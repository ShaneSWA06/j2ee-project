package servlet;

import java.io.IOException;

import com.stripe.model.PaymentIntent;

import service.BookingServiceAPI;
import dao.DAOFactory;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.StripeService;

/**
 * PaymentSuccessServlet handles the callback from Stripe after a successful transaction.
 * <p>
 * What it does:
 * - Verifies the `payment_intent` ID returned by Stripe against the Stripe API.
 * - Confirms the payment status is actually "succeeded" (prevents URL tampering).
 * - Updates the local database: marks the Payment as "Paid".
 * - Updates the Microservice: marks related Bookings as "Confirmed" and "Paid".
 * - Clears the shopping cart and redirects to the "My Bookings" page.
 * <p>
 * Design Intent:
 * - Security (Server-Side Verification): We never trust the client-side redirect alone.
 *   Even if a user manually types `/PaymentSuccessServlet?payment_intent=xyz`, this servlet
 *   calls `stripeService.retrievePaymentIntent(id)` to verify the status directly with Stripe.
 * - Metadata Linking: We retrieve the list of `Booking IDs` stored in the Stripe PaymentIntent metadata.
 *   This ensures we update exactly the right bookings without relying on fragile session state that might expire.
 */
@WebServlet("/PaymentSuccessServlet")
public class PaymentSuccessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;
    private BookingServiceAPI bookingAPI;
    private StripeService stripeService;

    @Override
    public void init() throws ServletException {
        paymentDAO = DAOFactory.getPaymentDAO();
        bookingAPI = new BookingServiceAPI();
        stripeService = new StripeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paymentIntentId = request.getParameter("payment_intent");
        System.out.println("DEBUG - PaymentSuccessServlet reached with payment_intent: " + paymentIntentId);

        if (paymentIntentId == null) {
            response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=invalid_payment");
            return;
        }

        try {
            // Verify with Stripe
            PaymentIntent intent = stripeService.retrievePaymentIntent(paymentIntentId);

            if ("succeeded".equals(intent.getStatus())) {
                System.out.println("DEBUG - Stripe Payment Succeeded for ID: " + paymentIntentId);
                
                // Design Intent: Idempotency & State Synchronization
                // 1. Update Local Payment Record
                boolean updated = paymentDAO.updatePaymentStatus(paymentIntentId, "Paid");
                System.out.println("DEBUG - Local payment table update status: " + updated);

                // 2. Update Microservice Bookings
                // We use the metadata attached during Checkout to find which bookings to confirm.
                String bookingIdsStr = intent.getMetadata().get("Bookings"); // e.g., "[1, 2, 3]"
                System.out.println("DEBUG - Booking IDs from Stripe Metadata: " + bookingIdsStr);

                if (bookingIdsStr != null) {
                    bookingIdsStr = bookingIdsStr.replace("[", "").replace("]", "");
                    if (!bookingIdsStr.isEmpty()) {
                        String[] ids = bookingIdsStr.split(",\\s*");
                        for (String id : ids) {
                            try {
                                int bookingId = Integer.parseInt(id);
                                System.out.println("DEBUG - Attempting to update status for Booking ID: " + bookingId);
                                boolean s1 = bookingAPI.updateBookingStatus(bookingId, "Confirmed");
                                boolean s2 = bookingAPI.updatePaymentStatus(bookingId, "Paid");
                                System.out.println("DEBUG - Booking updates for " + bookingId + ": status=" + s1 + ", payment=" + s2);
                            } catch (NumberFormatException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }

                // Clear cart
                request.getSession().removeAttribute("shoppingCart");
                
                // Clear payment session attributes
                request.getSession().removeAttribute("payment_clientSecret");
                request.getSession().removeAttribute("payment_amount");
                request.getSession().removeAttribute("payment_subtotal");
                request.getSession().removeAttribute("payment_gst");
                request.getSession().removeAttribute("payment_stripePublicKey");

                // Redirect to bookings
                response.sendRedirect(request.getContextPath() + "/customer/booking?success=payment_complete");

            } else {
                 response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=payment_not_succeeded&status=" + intent.getStatus());
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=" + e.getMessage());
        }
    }
}
