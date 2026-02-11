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
                // Update Payment Status
                boolean updated = paymentDAO.updatePaymentStatus(paymentIntentId, "Paid");
                System.out.println("DEBUG - Local payment table update status: " + updated);

                // Update Bookings Status using Metadata
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
