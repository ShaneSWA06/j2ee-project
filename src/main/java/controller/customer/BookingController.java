package controller.customer;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;

import dao.DAOFactory;
import dao.PaymentDAO;
import model.Payment;
import service.BookingServiceAPI;
import service.ServiceAPI;
import service.CaregiverServiceAPI;
import service.StripeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Service;

/**
 * BookingController - Handles customer booking operations
 * <p>
 * Purpose:
 * - Manages the booking lifecycle for customers (Create, List).
 * - Interfaces with BookingServiceAPI to persist booking data.
 * <p>
 * Scope:
 * - Handles both viewing past bookings and initiating new ones.
 * - Enforces customer login requirements.
 */
@WebServlet("/customer/booking")
public class BookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingServiceAPI bookingAPI;
    private ServiceAPI serviceAPI;
    private CaregiverServiceAPI caregiverAPI;
    private PaymentDAO paymentDAO;
    private StripeService stripeService;

    @Override
    public void init() throws ServletException {
        bookingAPI = new BookingServiceAPI();
        serviceAPI = new ServiceAPI();
        caregiverAPI = new CaregiverServiceAPI();
        paymentDAO = DAOFactory.getPaymentDAO();
        stripeService = new StripeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomerLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=notLoggedIn");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
			action = "list";
		}

        try {
            switch (action) {
                case "list":
                    listMyBookings(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                default:
                    listMyBookings(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomerLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=notLoggedIn");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
			action = "create";
		}

        try {
            switch (action) {
                case "create":
                    createBooking(request, response);
                    break;
                case "cancel":
                    cancelBooking(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/customer/booking");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listMyBookings(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("sessUserId");

        List<Booking> bookings = bookingAPI.getBookingsByUser(userId);
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/customer/myBookings.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String serviceIdParam = request.getParameter("serviceId");

        if (serviceIdParam != null && !serviceIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/addToCartForm.jsp?serviceId=" + serviceIdParam);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/public/serviceDetails.jsp");
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("sessUserId");

        String serviceIdStr = request.getParameter("service_id");
        String bookingDateStr = request.getParameter("booking_date");
        String bookingTimeStr = request.getParameter("booking_time");
        String caregiverIdStr = request.getParameter("caregiver_id");
        String notes = request.getParameter("notes");

        // Validation
        if (serviceIdStr == null || bookingDateStr == null || bookingTimeStr == null) {
            response.sendRedirect(request.getContextPath() + "/public/serviceDetails.jsp?err=missing_fields");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            Date bookingDate = Date.valueOf(bookingDateStr);
            Date today = new Date(System.currentTimeMillis());

            // Validate date is not in the past
            if (bookingDate.before(today)) {
                response.sendRedirect(request.getContextPath() +
                    "/customer/addToCartForm.jsp?serviceId=" + serviceId +
                    "&err=" + java.net.URLEncoder.encode("Booking date cannot be in the past", "UTF-8"));
                return;
            }

            // Validate service exists and is active
            Service service = serviceAPI.getServiceById(serviceId);
            if (service == null || !service.isActive()) {
                response.sendRedirect(request.getContextPath() +
                    "/public/serviceDetails.jsp?err=" +
                    java.net.URLEncoder.encode("Service is not available", "UTF-8"));
                return;
            }

            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setServiceId(serviceId);

            if (caregiverIdStr != null && !caregiverIdStr.trim().isEmpty()) {
                booking.setCaregiverId(Integer.parseInt(caregiverIdStr));
            }

            booking.setBookingDate(bookingDate);
            booking.setBookingTime(Time.valueOf(bookingTimeStr + ":00"));
            booking.setStatus("Pending");
            booking.setNotes(notes != null ? notes.trim() : "");

            Booking created = bookingAPI.createBooking(booking);

            if (created != null) {
                response.sendRedirect(request.getContextPath() + "/customer/booking?success=created");
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/customer/addToCartForm.jsp?serviceId=" + serviceId + "&err=create_failed");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                "/public/serviceDetails.jsp?err=" +
                java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private boolean isCustomerLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
			return false;
		}
        Integer userId = (Integer) session.getAttribute("sessUserId");
        return userId != null;
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("sessUserId");

        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/booking?err=missing_id");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);

            // Verify the booking belongs to this user before cancelling
            model.Booking booking = bookingAPI.getBookingById(bookingId);
            if (booking == null || booking.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/customer/booking?err=unauthorised");
                return;
            }

            // Only allow cancellation of Pending or Confirmed bookings
            String status = booking.getStatus();
            if (!"Pending".equals(status) && !"Confirmed".equals(status)) {
                response.sendRedirect(request.getContextPath() + "/customer/booking?err=cannot_cancel");
                return;
            }

            // --- Stripe Refund ---
            // Look up the payment record for this booking
            Payment payment = paymentDAO.getPaymentByBookingId(bookingId);
            if (payment != null && "Paid".equals(payment.getStatus())) {
                try {
                    // Issue full refund via Stripe
                    com.stripe.model.Refund refund = stripeService.refundPayment(payment.getTransactionId());
                    System.out.println("Stripe refund issued: " + refund.getId() + " for booking " + bookingId);

                    // Update local payment record to 'Refunded'
                    paymentDAO.updatePaymentStatus(payment.getTransactionId(), "Refunded");

                    // Update booking payment status
                    bookingAPI.updatePaymentStatus(bookingId, "Refunded");
                } catch (Exception stripeEx) {
                    System.err.println("Stripe refund failed for booking " + bookingId + ": " + stripeEx.getMessage());
                    // Still cancel the booking even if refund fails — admin can handle manually
                }
            }

            // Cancel the booking
            boolean success = bookingAPI.updateBookingStatus(bookingId, "Cancelled");
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/booking?success=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/booking?err=cancel_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/booking?err=cancel_error");
        }
    }
}
