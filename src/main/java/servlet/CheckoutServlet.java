package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;

import dao.DAOFactory;
import dao.PaymentDAO;
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

        List<Integer> bookingIds = new ArrayList<>();

        try {
            service.BookingServiceAPI bookingAPI = new service.BookingServiceAPI();

            double totalAmount = 0;

            for (CartItem item : cart) {
                // Call external API ONLY (Removes duplicate database insert)
                model.Booking apiBooking = new model.Booking();
                apiBooking.setUserId(userId);
                apiBooking.setServiceId(item.getServiceId());
                apiBooking.setCaregiverId(item.getCaregiverId());
                apiBooking.setBookingDate(java.sql.Date.valueOf(item.getBookingDate()));
                apiBooking.setBookingTime(java.sql.Time.valueOf(item.getBookingTime() + ":00"));
                apiBooking.setNotes(item.getNotes());
                apiBooking.setPickupAddress(item.getPickupAddress());
                apiBooking.setDestinationAddress(item.getDestinationAddress());
                apiBooking.setTotalPrice(item.getBasePrice());
                apiBooking.setPaymentStatus("Unpaid");
                apiBooking.setStatus("Pending");
                
                model.Booking created = bookingAPI.createBooking(apiBooking);
                
                if (created != null && created.getBookingId() > 0) {
                    bookingIds.add(created.getBookingId());
                    System.out.println("DEBUG - Created booking via API with ID: " + created.getBookingId());
                }

                totalAmount += item.getBasePrice();
            }

            if (bookingIds.isEmpty()) {
                System.err.println("CheckoutServlet: Failed to create any bookings via API");
                response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=booking_failed");
                return;
            }

            // Calculate Total with GST (9%)
            double gstRate = 0.09;
            double gstAmount = totalAmount * gstRate;
            double grandTotal = totalAmount + gstAmount;
            long amountCents = Math.round(grandTotal * 100);

            // 3. Load Stripe Keys from properties (Reload on every request to ensure consistency)
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

            // 4. Create Stripe PaymentIntent
            try {
                String bookingIdsStr = bookingIds.toString();
                if (bookingIdsStr.length() > 500) {
					bookingIdsStr = bookingIdsStr.substring(0, 497) + "...";
				}

                PaymentIntent intent = stripeService.createPaymentIntent(amountCents, "sgd", bookingIdsStr);

                // Create local Payment record (Linked to first booking ID from API)
                Payment payment = new Payment();
                if (!bookingIds.isEmpty()) {
                    payment.setBookingId(bookingIds.get(0)); 
                }
                payment.setAmount(grandTotal);
                payment.setTaxAmount(gstAmount);
                payment.setCurrency("SGD");
                payment.setPaymentMethod("stripe");
                payment.setTransactionId(intent.getId());
                payment.setStatus("Pending");
                
                // Set CreatedAt to Singapore Time
                ZonedDateTime nowSGT = ZonedDateTime.now(ZoneId.of("Asia/Singapore"));
                payment.setCreatedAt(Timestamp.valueOf(nowSGT.toLocalDateTime()));

                paymentDAO.createPayment(payment);

                // Set attributes in Session for Payment Page (Post-Redirect-Get pattern)
                session.setAttribute("payment_clientSecret", intent.getClientSecret());
                session.setAttribute("payment_amount", grandTotal);
                session.setAttribute("payment_subtotal", totalAmount);
                session.setAttribute("payment_gst", gstAmount);

                if (stripePublicKey == null || stripePublicKey.trim().isEmpty()) {
                    stripePublicKey = "pk_test_PLACEHOLDER_ERROR";
                    System.err.println("CheckoutServlet: Failed to load stripe.publishable.key");
                }

                session.setAttribute("payment_stripePublicKey", stripePublicKey);

                // Redirect to payment page
                response.sendRedirect(request.getContextPath() + "/customer/payment.jsp");

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
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "System error";
            try {
                if (e.getMessage() != null) {
                    errorMsg = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
                }
            } catch (Exception ignore) {}
            response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=" + errorMsg);
        }
    }
}
