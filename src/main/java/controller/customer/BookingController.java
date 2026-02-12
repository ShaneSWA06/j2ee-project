package controller.customer;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;

import service.BookingServiceAPI;
import service.ServiceAPI;
import service.CaregiverServiceAPI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Service;

/**
 * BookingController - Handles customer booking operations via Spring Boot API
 */
@WebServlet("/customer/booking")
public class BookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingServiceAPI bookingAPI;
    private ServiceAPI serviceAPI;
    private CaregiverServiceAPI caregiverAPI;

    @Override
    public void init() throws ServletException {
        bookingAPI = new BookingServiceAPI();
        serviceAPI = new ServiceAPI();
        caregiverAPI = new CaregiverServiceAPI();
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
}
