package controller.caregiver;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

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
 * CaregiverController - Handles caregiver operational logic
 */
@WebServlet({"/mvc/caregiver/dashboard", "/mvc/caregiver/jobs", "/mvc/caregiver/accept"})
public class CaregiverController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CaregiverDAO caregiverDAO;
    private dao.BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        caregiverDAO = DAOFactory.getCaregiverDAO();
        bookingDAO = DAOFactory.getBookingDAO();
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
        
        Caregiver currentCaregiver = getAuthenticatedCaregiver(request, response);
        if (currentCaregiver == null) return;

        String path = request.getServletPath();
        
        try {
            if (path.contains("accept")) {
                acceptJob(request, response, currentCaregiver);
            } else {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void showAvailableJobs(HttpServletRequest request, HttpServletResponse response, Caregiver caregiver) 
            throws SQLException, ServletException, IOException {
        
        List<Booking> availableBookings = bookingDAO.getUnassignedBookings();
        request.setAttribute("bookings", availableBookings);
        request.setAttribute("caregiver", caregiver);
        request.setAttribute("viewType", "available");
        request.getRequestDispatcher("/caregiver/dashboard.jsp").forward(request, response);
    }

    private void showMyJobs(HttpServletRequest request, HttpServletResponse response, Caregiver caregiver) 
            throws SQLException, ServletException, IOException {
        
        List<Booking> myBookings = bookingDAO.getBookingsByCaregiver(caregiver.getCaregiverId());
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
        boolean success = bookingDAO.assignCaregiver(bookingId, caregiver.getCaregiverId(), "Accepted");

        if (success) {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/jobs?action=my&success=accepted");
        } else {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?err=accept_failed");
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
