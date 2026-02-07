package controller.customer;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
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
    private service.BookingServiceAPI bookingService;
    private StripeService stripeService;

    @Override
    public void init() throws ServletException {
        escortService = new MedicalEscortServiceAPI();
        bookingService = new service.BookingServiceAPI();
        stripeService = new StripeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        // Enforce login for booking actions
        if (!action.equals("list")) {
            if (!isCustomerLoggedIn(request)) {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=login_required");
                return;
            }
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
            case "create":
                createBooking(request, response);
                break;
            default:
                listEscorts(request, response);
        }
    }

    private void listEscorts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Service> escorts = new ArrayList<>();
        try {
            escorts = escortService.getMedicalEscorts();
        } catch (Exception e) {
            request.setAttribute("error", "Unable to load medical escort services. Please try again later.");
        }
        request.setAttribute("escorts", escorts);
        request.getRequestDispatcher("/customer/escort/list.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String serviceId = request.getParameter("id");
        if (serviceId == null || serviceId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/medical-escort?action=list");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/customer/addToCartForm.jsp?serviceId=" + serviceId);
    }
    
    private void showConfirmation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/customer/escort/confirm.jsp").forward(request, response);
    }
    
    private void processPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
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
        
        // Pass through other form data to payment page
        // Store in SESSION because redirects lose request attributes
        HttpSession session = request.getSession();
        session.setAttribute("pending_serviceId", request.getParameter("serviceId"));
        session.setAttribute("pending_bookingDate", request.getParameter("bookingDate"));
        session.setAttribute("pending_bookingTime", request.getParameter("bookingTime"));
        session.setAttribute("pending_pickupAddress", request.getParameter("pickupAddress"));
        session.setAttribute("pending_destinationAddress", request.getParameter("destinationAddress"));
        session.setAttribute("pending_notes", request.getParameter("notes"));
        session.setAttribute("pending_caregiverId", request.getParameter("caregiverId")); // Add caregiver ID
        session.setAttribute("pending_amount", String.valueOf(grandTotal));


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
            request.setAttribute("error", "Payment Init Failed: " + e.getMessage());
            request.getRequestDispatcher("/customer/escort/payment.jsp").forward(request, response);
        }
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("sessUserId");

        model.Booking booking = new model.Booking();
        booking.setUserId(userId);
        
        try {
            // Try to get from Request first (if posted), else Session (if redirected)
            String serviceIdFn = (String) session.getAttribute("pending_serviceId");
            String dateFn = (String) session.getAttribute("pending_bookingDate");
            String timeFn = (String) session.getAttribute("pending_bookingTime");
            String pickupFn = (String) session.getAttribute("pending_pickupAddress");
            String destFn = (String) session.getAttribute("pending_destinationAddress");
            String notesFn = (String) session.getAttribute("pending_notes");
            String caregiverIdFn = (String) session.getAttribute("pending_caregiverId");
            String amountFn = (String) session.getAttribute("pending_amount");

            if (serviceIdFn != null && !serviceIdFn.trim().isEmpty()) {
                 booking.setServiceId(Integer.parseInt(serviceIdFn));
                 booking.setBookingDate(java.sql.Date.valueOf(dateFn));
                 
                 String timeStr = timeFn;
                 if (timeStr.length() == 5) timeStr += ":00";
                 booking.setBookingTime(java.sql.Time.valueOf(timeStr));
                 
                 booking.setPickupAddress(pickupFn);
                 booking.setDestinationAddress(destFn);
                 booking.setNotes(notesFn != null ? notesFn : "");
                 
                 // Set caregiver ID if provided
                 if (caregiverIdFn != null && !caregiverIdFn.trim().isEmpty()) {
                     booking.setCaregiverId(Integer.parseInt(caregiverIdFn));
                 }
                 
                 booking.setTotalPrice(Double.parseDouble(amountFn));
                 
                 // Clear session
                 session.removeAttribute("pending_serviceId");
                 session.removeAttribute("pending_bookingDate");
                 session.removeAttribute("pending_bookingTime");
                 session.removeAttribute("pending_pickupAddress");
                 session.removeAttribute("pending_destinationAddress");
                 session.removeAttribute("pending_notes");
                 session.removeAttribute("pending_caregiverId");
                 session.removeAttribute("pending_amount");
                 
            } else {
                // Fallback to request parameters if any manually sent
                 String serviceIdParam = request.getParameter("serviceId");
                 String dateParam = request.getParameter("bookingDate");
                 String timeParam = request.getParameter("bookingTime");
                 String amountParam = request.getParameter("amount");
                 
                 if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
                     throw new IllegalArgumentException("Service ID is required");
                 }
                 
                 booking.setServiceId(Integer.parseInt(serviceIdParam));
                 booking.setBookingDate(java.sql.Date.valueOf(dateParam));
                 
                 String timeStr = timeParam;
                 if (timeStr.length() == 5) timeStr += ":00";
                 booking.setBookingTime(java.sql.Time.valueOf(timeStr));
                 
                 booking.setPickupAddress(request.getParameter("pickupAddress"));
                 booking.setDestinationAddress(request.getParameter("destinationAddress"));
                 booking.setNotes(request.getParameter("notes"));
                 
                 // Set caregiver ID if provided
                 String caregiverIdParam = request.getParameter("caregiverId");
                 if (caregiverIdParam != null && !caregiverIdParam.trim().isEmpty()) {
                     booking.setCaregiverId(Integer.parseInt(caregiverIdParam));
                 }
                 
                 booking.setTotalPrice(Double.parseDouble(amountParam));
            }
            
            boolean success = bookingService.createBooking(booking);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/medical-escort?action=list&success=booked");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/medical-escort?action=book&err=failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/medical-escort?action=book&err=invalid_data");
        }
    }

    private boolean isCustomerLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        Integer userId = (Integer) session.getAttribute("sessUserId");
        String role = (String) session.getAttribute("sessUserRole");
        
        return userId != null && "CUSTOMER".equals(role);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
