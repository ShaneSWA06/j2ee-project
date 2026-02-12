package controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.Comparator;
import java.util.List;

import service.BookingServiceAPI;
import dao.CaregiverDAO;
import dao.DAOFactory;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Caregiver;
import model.Service;

/**
 * AdminBookingController - Handles booking management for admins
 * <p>
 * What it does:
 * - Lists bookings with filtering options (e.g., "unassigned" vs "all").
 * - Provides forms for editing booking details (assigning caregivers, changing status).
 * - Handles the deletion of bookings.
 * - Interacts with `BookingServiceAPI` to fetch and update data.
 * <p>
 * Architecture: Hybrid MVC Controller
 * - Acts as the "Controller" in MVC, receiving requests and selecting the correct "View" (JSP).
 * - Integration: Uses `BookingServiceAPI` to fetch data, demonstrating how a legacy Servlet 
 *   can consume data from a modern Microservice backend transparently.
 */
@WebServlet("/admin/booking")
public class AdminBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingServiceAPI bookingAPI;
    private ServiceDAO serviceDAO;
    private CaregiverDAO caregiverDAO;

    @Override
    public void init() throws ServletException {
        bookingAPI = new BookingServiceAPI();
        serviceDAO = DAOFactory.getServiceDAO();
        caregiverDAO = DAOFactory.getCaregiverDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
			action = "list";
		}

        try {
            switch (action) {
                case "list":
                    listBookings(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    showDeleteConfirmation(request, response);
                    break;
                default:
                    listBookings(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
			action = "list";
		}

        try {
            switch (action) {
                case "edit":
                    updateBooking(request, response);
                    break;
                case "delete":
                    deleteBooking(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/booking");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String view = request.getParameter("view");
        List<Booking> bookings;

        if ("unassigned".equals(view)) {
            bookings = bookingAPI.getUnassignedBookings();
            request.setAttribute("viewType", "unassigned");
        } else {
            bookings = bookingAPI.getAllBookings();
            request.setAttribute("viewType", "all");
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/admin/adminBookingList.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/booking?err=missing_id");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdParam);
        Booking booking = bookingAPI.getBookingById(bookingId);

        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/admin/booking?err=not_found");
            return;
        }

        List<Service> services = serviceDAO.getAllServices();
        List<Caregiver> caregivers = caregiverDAO.getAllCaregivers();
        
        // Sort caregivers: Available first, then by name
        caregivers.sort(Comparator.comparing(Caregiver::isAvailable).reversed()
                .thenComparing(Caregiver::getName));

        request.setAttribute("booking", booking);
        request.setAttribute("services", services);
        request.setAttribute("caregivers", caregivers);
        request.getRequestDispatcher("/admin/adminBookingEdit.jsp").forward(request, response);
    }

    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/booking?err=missing_id");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdParam);
        Booking booking = bookingAPI.getBookingById(bookingId);

        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/admin/booking?err=not_found");
            return;
        }

        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/admin/adminBookingDelete.jsp").forward(request, response);
    }

    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String bookingIdStr = request.getParameter("bookingId");
        String serviceIdStr = request.getParameter("service_id");
        String caregiverIdStr = request.getParameter("caregiver_id");
        String bookingDateStr = request.getParameter("booking_date");
        String bookingTimeStr = request.getParameter("booking_time");
        String status = request.getParameter("status");
        String caregiverStatus = request.getParameter("caregiver_status");
        String notes = request.getParameter("notes");

        if (bookingIdStr == null || serviceIdStr == null || bookingDateStr == null || bookingTimeStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/booking?err=missing_fields");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        Booking booking = new Booking();
        booking.setBookingId(bookingId);
        booking.setServiceId(Integer.parseInt(serviceIdStr));

        if (caregiverIdStr != null && !caregiverIdStr.trim().isEmpty()) {
            booking.setCaregiverId(Integer.parseInt(caregiverIdStr));
        }

        booking.setBookingDate(Date.valueOf(bookingDateStr));
        booking.setBookingTime(Time.valueOf(bookingTimeStr + ":00"));
        booking.setStatus(status != null ? status : "Pending");
        booking.setCaregiverStatus(caregiverStatus != null ? caregiverStatus : "Pending");
        booking.setNotes(notes);

        boolean updated = bookingAPI.updateBooking(bookingId, booking);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/booking?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/booking?action=edit&bookingId=" + bookingId + "&err=update_failed");
        }
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String bookingIdStr = request.getParameter("bookingId");

        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/booking?err=missing_id");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        boolean deleted = bookingAPI.deleteBooking(bookingId);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/booking?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/booking?err=delete_failed");
        }
    }

    private boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
			return false;
		}
        Integer userId = (Integer) session.getAttribute("sessUserId");
        String role = (String) session.getAttribute("sessUserRole");
        return userId != null && "ADMIN".equals(role);
    }
}
