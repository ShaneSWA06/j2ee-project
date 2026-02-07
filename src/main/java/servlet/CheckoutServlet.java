package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;

import dao.DAOFactory;
import dao.PaymentDAO;
import db.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.Payment;
import service.StripeService;

/**
 * CheckoutServlet processes the shopping cart checkout
 * Initiates Stripe payment flow
 */
@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;
    private StripeService stripeService;

    @Override
    public void init() throws ServletException {
        paymentDAO = DAOFactory.getPaymentDAO();
        stripeService = new StripeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheckout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheckout(request, response);
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("sessUserId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=notLoggedIn");
            return;
        }

        @SuppressWarnings("unchecked")
        ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("shoppingCart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=cart_empty");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        List<Integer> bookingIds = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String insertSQL = "INSERT INTO booking (user_id, service_id, caregiver_id, booking_date, " +
                              "booking_time, status, notes, total_price, created_at, updated_at) " +
                              "VALUES (?, ?, ?, ?, ?, 'Pending', ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

            ps = conn.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);
            service.BookingServiceAPI bookingAPI = new service.BookingServiceAPI();

            double totalAmount = 0;

            for (CartItem item : cart) {
                ps.setInt(1, userId);
                ps.setInt(2, item.getServiceId());

                if (item.getCaregiverId() != null) {
                    ps.setInt(3, item.getCaregiverId());
                } else {
                    ps.setNull(3, java.sql.Types.INTEGER);
                }

                ps.setDate(4, java.sql.Date.valueOf(item.getBookingDate()));
                ps.setTime(5, java.sql.Time.valueOf(item.getBookingTime() + ":00"));
                ps.setString(6, item.getNotes());
                ps.setDouble(7, item.getBasePrice());

                ps.executeUpdate();

                int localBookingId = -1;
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        localBookingId = rs.getInt(1);
                        bookingIds.add(localBookingId);
                    }
                }

                // Also call external API as requested
                model.Booking apiBooking = new model.Booking();
                apiBooking.setUserId(userId);
                apiBooking.setServiceId(item.getServiceId());
                apiBooking.setCaregiverId(item.getCaregiverId());
                apiBooking.setBookingDate(java.sql.Date.valueOf(item.getBookingDate()));
                apiBooking.setBookingTime(java.sql.Time.valueOf(item.getBookingTime() + ":00"));
                apiBooking.setNotes(item.getNotes());
                apiBooking.setTotalPrice(item.getBasePrice());
                apiBooking.setStatus("PENDING");
                
                bookingAPI.createBooking(apiBooking);

                totalAmount += item.getBasePrice();
            }

            // Commit bookings first
            conn.commit();

            // Calculate Total with GST (9%)
            double gstRate = 0.09;
            double gstAmount = totalAmount * gstRate;
            double grandTotal = totalAmount + gstAmount;
            long amountCents = Math.round(grandTotal * 100);

            // Load Stripe Keys from properties (Reload on every request to ensure consistency)
            String stripePublicKey = null;
            String stripeSecretKey = null;
            try {
                java.util.Properties props = new java.util.Properties();
                java.io.InputStream input = getClass().getClassLoader().getResourceAsStream("stripe.properties");
                if (input == null) {
                    input = Thread.currentThread().getContextClassLoader().getResourceAsStream("stripe.properties");
                }

                if (input != null) {
                    try (java.io.InputStream is = input) {
                        props.load(is);
                        stripePublicKey = props.getProperty("stripe.publishable.key");
                        stripeSecretKey = props.getProperty("stripe.secret.key");
                        
                        if (stripePublicKey != null) {
                            stripePublicKey = stripePublicKey.trim().replaceAll("[^a-zA-Z0-9_]", "");
                        }
                        if (stripeSecretKey != null) {
                            stripeSecretKey = stripeSecretKey.trim().replaceAll("[^a-zA-Z0-9_]", "");
                        }
                        
                        System.out.println("DEBUG: Loaded Stripe Keys from properties");
                        System.out.println("DEBUG: Public Key: " + (stripePublicKey != null ? stripePublicKey.substring(0, 10) + "..." + stripePublicKey.substring(stripePublicKey.length()-5) : "null"));
                        System.out.println("DEBUG: Public Key Length: " + (stripePublicKey != null ? stripePublicKey.length() : 0));
                    }
                } else {
                    System.err.println("CheckoutServlet: stripe.properties not found in classpath");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            // Update global Stripe Secret Key if found
            if (stripeSecretKey != null && !stripeSecretKey.isEmpty()) {
                Stripe.apiKey = stripeSecretKey;
            }

            // Create Stripe PaymentIntent
            try {
                String bookingIdsStr = bookingIds.toString();
                if (bookingIdsStr.length() > 500) {
					bookingIdsStr = bookingIdsStr.substring(0, 497) + "...";
				}

                PaymentIntent intent = stripeService.createPaymentIntent(amountCents, "sgd", bookingIdsStr);

                // Create local Payment record
                Payment payment = new Payment();
                if (!bookingIds.isEmpty()) {
                    payment.setBookingId(bookingIds.get(0)); // Link to first booking
                }
                payment.setAmount(grandTotal);
                payment.setCurrency("SGD");
                payment.setPaymentMethod("stripe");
                payment.setTransactionId(intent.getId());
                payment.setStatus("Pending");

                paymentDAO.createPayment(payment);

                // Set attributes for Payment Page
                request.setAttribute("clientSecret", intent.getClientSecret());
                request.setAttribute("amount", grandTotal);
            request.setAttribute("subtotal", totalAmount);
            request.setAttribute("gst", gstAmount);

            if (stripePublicKey == null || stripePublicKey.trim().isEmpty()) {
                stripePublicKey = "pk_test_PLACEHOLDER_ERROR";
                System.err.println("CheckoutServlet: Failed to load stripe.publishable.key");
            }

            request.setAttribute("stripePublicKey", stripePublicKey);

            // Forward to payment page
                request.getRequestDispatcher("/customer/payment.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                String errorMsg = "Payment initialization failed";
                try {
                    if (e.getMessage() != null) {
                        errorMsg = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
                    }
                } catch (Exception ignore) {}
                response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=payment_init_failed&msg=" + errorMsg);
            }

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            String errorMsg = "Database error";
            try {
                if (e.getMessage() != null) {
                    errorMsg = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
                }
            } catch (Exception ignore) {}
            response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=" + errorMsg);
        } finally {
            if (ps != null) {
				try { ps.close(); } catch (SQLException ignore) {}
			}
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignore) {}
            }
        }
    }
}
