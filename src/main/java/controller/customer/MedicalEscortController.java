package controller.customer;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Properties;

import service.StripeService;
import com.stripe.model.PaymentIntent;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Service;
import service.MedicalEscortServiceAPI;

@WebServlet("/customer/medical-escort")
public class MedicalEscortController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MedicalEscortServiceAPI escortService;
    private StripeService stripeService;

    @Override
    public void init() throws ServletException {
        escortService = new MedicalEscortServiceAPI();
        stripeService = new StripeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listEscorts(request, response);
                break;
            case "book":
                showBookingForm(request, response);
                break;
            case "confirm":
                showConfirmation(request, response);
                break;
            case "payment":
                processPayment(request, response);
                break;
            default:
                listEscorts(request, response);
        }
    }

    private void listEscorts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Service> escorts = escortService.getMedicalEscorts();
        request.setAttribute("escorts", escorts);
        request.getRequestDispatcher("/customer/escort/list.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String serviceId = request.getParameter("id");
        request.setAttribute("selectedServiceId", serviceId);
        request.getRequestDispatcher("/customer/escort/book.jsp").forward(request, response);
    }
    
    private void showConfirmation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/customer/escort/confirm.jsp").forward(request, response);
    }
    
    private void processPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("sessUserId");

        // Basic validation/User check
        if (userId == null) {
             response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=notLoggedIn");
             return;
        }

        // 1. Calculate Amounts
        String priceStr = request.getParameter("price");
        double basePrice = 0.0;
        try {
            basePrice = Double.parseDouble(priceStr);
        } catch (Exception e) {
            basePrice = 50.00; // Fallback
        }

        double gstRate = 0.09;
        double gstAmount = basePrice * gstRate;
        double grandTotal = basePrice + gstAmount;

        // 2. Prepare Payment Attributes for JSP
        request.setAttribute("subtotal", basePrice);
        request.setAttribute("gst", gstAmount);
        request.setAttribute("amount", grandTotal);

        // 3. Load Stripe Keys and Create Intent
        try {
            // Load Public Key
            String stripePublicKey = null;
            try (InputStream input = getClass().getClassLoader().getResourceAsStream("stripe.properties")) {
                if (input != null) {
                    Properties props = new Properties();
                    props.load(input);
                    stripePublicKey = props.getProperty("stripe.publishable.key");
                }
            }
            if (stripePublicKey != null) stripePublicKey = stripePublicKey.trim();
            request.setAttribute("stripePublicKey", stripePublicKey);

            // Create Intent
            long amountCents = Math.round(grandTotal * 100);
            PaymentIntent intent = stripeService.createPaymentIntent(amountCents, "sgd", "Medical Escort Booking");
            request.setAttribute("clientSecret", intent.getClientSecret());

            // 4. Forward to EXISTING Payment Page
            request.getRequestDispatcher("/customer/payment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // If Stripe fails (e.g. no keys), forward to our mock payment page as fallback
            // OR handle error. simpler to just forward with error.
             request.setAttribute("error", "Payment Init Failed: " + e.getMessage());
             // Fallback to the MOCK payment page I created earlier if real one fails
             request.getRequestDispatcher("/customer/escort/payment.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
