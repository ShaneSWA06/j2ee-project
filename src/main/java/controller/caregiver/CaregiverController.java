package controller.caregiver;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import service.BookingServiceAPI;
import dao.CaregiverDAO;
import dao.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Caregiver;

/**
 * CaregiverController - Handles caregiver operational logic via Spring Boot API
 */
@WebServlet("/mvc/caregiver/*")
public class CaregiverController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CaregiverDAO caregiverDAO;
    private BookingServiceAPI bookingAPI;

    @Override
    public void init() throws ServletException {
        caregiverDAO = DAOFactory.getCaregiverDAO();
        bookingAPI = new BookingServiceAPI();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Caregiver currentCaregiver = getAuthenticatedCaregiver(request, response);
        if (currentCaregiver == null) return;

        String path = request.getServletPath();
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if (path.contains("dashboard") || path.contains("jobs")) {
                if ("my".equals(action)) {
                    showMyJobs(request, response, currentCaregiver);
                } else {
                    showAvailableJobs(request, response, currentCaregiver);
                }
            } else {
                showAvailableJobs(request, response, currentCaregiver);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error in Caregiver Controller", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uri = request.getRequestURI();
        System.out.println("DEBUG - CaregiverController.doPost URI: " + uri);

        Caregiver currentCaregiver = getAuthenticatedCaregiver(request, response);
        if (currentCaregiver == null) {
            System.out.println("DEBUG - Caregiver authentication failed or profile not found.");
            return;
        }

        try {
            if (uri.contains("accept")) {
                acceptJob(request, response, currentCaregiver);
            } else if (uri.contains("clockin")) {
                clockIn(request, response, currentCaregiver);
            } else if (uri.contains("clockout")) {
                clockOut(request, response, currentCaregiver);
            } else {
                System.out.println("DEBUG - No specific action found in URI, redirecting to dashboard.");
                response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?action=my");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void showAvailableJobs(HttpServletRequest request, HttpServletResponse response, Caregiver caregiver) 
            throws SQLException, ServletException, IOException {
        
        List<Booking> availableBookings = bookingAPI.getUnassignedBookings();
        request.setAttribute("bookings", availableBookings);
        request.setAttribute("caregiver", caregiver);
        request.setAttribute("viewType", "available");
        request.getRequestDispatcher("/caregiver/dashboard.jsp").forward(request, response);
    }

    private void showMyJobs(HttpServletRequest request, HttpServletResponse response, Caregiver caregiver) 
            throws SQLException, ServletException, IOException {
        
        List<Booking> myBookings = bookingAPI.getBookingsByCaregiver(caregiver.getCaregiverId());
        request.setAttribute("bookings", myBookings);
        request.setAttribute("caregiver", caregiver);
        request.setAttribute("viewType", "my");
        request.getRequestDispatcher("/caregiver/dashboard.jsp").forward(request, response);
    }

    private void acceptJob(HttpServletRequest request, HttpServletResponse response, Caregiver caregiver) 
            throws SQLException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?err=missing_id");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        boolean success = bookingAPI.assignCaregiver(bookingId, caregiver.getCaregiverId());

        if (success) {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/jobs?action=my&success=accepted");
        } else {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?err=accept_failed");
        }
    }

    private void clockIn(HttpServletRequest request, HttpServletResponse response, Caregiver caregiver) 
            throws SQLException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        String location = request.getParameter("location"); // Received from browser GPS
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/jobs?action=my&err=missing_id");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        System.out.println("DEBUG - Processing Clock-In for ID: " + bookingId + ", Location: " + location);
        boolean success = bookingAPI.clockIn(bookingId, location != null ? location : "Unknown");
        System.out.println("DEBUG - Clock-In Result: " + success);

        if (success) {
            System.out.println("DEBUG - Redirecting to dashboard with success=clocked_in");
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?action=my&success=clocked_in");
        } else {
            System.out.println("DEBUG - Redirecting to dashboard with err=clockin_failed");
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?action=my&err=clockin_failed");
        }
    }

    private void clockOut(HttpServletRequest request, HttpServletResponse response, Caregiver caregiver) 
            throws SQLException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        String location = request.getParameter("location"); 
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/jobs?action=my&err=missing_id");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        System.out.println("DEBUG - Processing Clock-Out for ID: " + bookingId + ", Location: " + location);
        boolean success = bookingAPI.clockOut(bookingId, location != null ? location : "Unknown");
        System.out.println("DEBUG - Clock-Out Result: " + success);

        if (success) {
            System.out.println("DEBUG - Redirecting to dashboard with success=clocked_out");
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?action=my&success=clocked_out");
        } else {
            System.out.println("DEBUG - Redirecting to dashboard with err=clockout_failed");
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?action=my&err=clockout_failed");
        }
    }

    private Caregiver getAuthenticatedCaregiver(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("sessUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=session_expired");
            return null;
        }

        String role = (String) session.getAttribute("sessUserRole");
        if (!"CAREGIVER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return null;
        }

        String email = (String) session.getAttribute("sessUserEmail");
        if (email == null) {
            // Should not happen if logged in correctly
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=invalid_session");
            return null;
        }

        try {
            Caregiver caregiver = caregiverDAO.getCaregiverByEmail(email);
            if (caregiver == null) {
                // User exists but Caregiver profile not found for this email
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=profile_not_found");
                return null;
            }
            return caregiver;
        } catch (SQLException e) {
            throw new ServletException("Database error retrieving caregiver profile", e);
        }
    }
}
