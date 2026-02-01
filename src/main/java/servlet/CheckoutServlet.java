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
                              "booking_time, status, notes, created_at, payment_status) " +
                              "VALUES (?, ?, ?, ?, ?, 'Pending', ?, CURRENT_TIMESTAMP, 'Unpaid')";

            ps = conn.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);

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

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        bookingIds.add(rs.getInt(1));
                    }
                }

                totalAmount += item.getBasePrice();
            }

            // Commit bookings first
            conn.commit();

            // Calculate Total with GST (9%)
            double gstRate = 0.09;
            double gstAmount = totalAmount * gstRate;
            double grandTotal = totalAmount + gstAmount;
            long amountCents = Math.round(grandTotal * 100);

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

            // Load Stripe Public Key from properties
            String stripePublicKey = "pk_test_PLACEHOLDER";
            try {
                java.util.Properties props = new java.util.Properties();
                try (java.io.InputStream input = getClass().getClassLoader().getResourceAsStream("stripe.properties")) {
                    if (input != null) {
                        props.load(input);
                        stripePublicKey = props.getProperty("stripe.publishable.key");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
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
