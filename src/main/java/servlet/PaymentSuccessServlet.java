package servlet;

import java.io.IOException;

import com.stripe.model.PaymentIntent;

import dao.BookingDAO;
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
    private BookingDAO bookingDAO;
    private StripeService stripeService;

    @Override
    public void init() throws ServletException {
        paymentDAO = DAOFactory.getPaymentDAO();
        bookingDAO = DAOFactory.getBookingDAO();
        stripeService = new StripeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paymentIntentId = request.getParameter("payment_intent");

        if (paymentIntentId == null) {
            response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=invalid_payment");
            return;
        }

        try {
            // Verify with Stripe
            PaymentIntent intent = stripeService.retrievePaymentIntent(paymentIntentId);

            if ("succeeded".equals(intent.getStatus())) {
                // Update Payment Status
                paymentDAO.updatePaymentStatus(paymentIntentId, "Paid");

                // Update Bookings Status using Metadata
                String bookingIdsStr = intent.getMetadata().get("Bookings"); // e.g., "[1, 2, 3]"

                if (bookingIdsStr != null) {
                    bookingIdsStr = bookingIdsStr.replace("[", "").replace("]", "");
                    if (!bookingIdsStr.isEmpty()) {
                        String[] ids = bookingIdsStr.split(",\\s*");
                        for (String id : ids) {
                            try {
                                int bookingId = Integer.parseInt(id);
                                bookingDAO.updateBookingStatus(bookingId, "Confirmed");
                                bookingDAO.updatePaymentStatus(bookingId, "Paid");
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
