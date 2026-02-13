package controller.caregiver;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Booking;
import model.Caregiver;
import service.BookingServiceAPI;
import service.CaregiverServiceAPI;

/**
 * CaregiverDashboardController handles the main caregiver portal view.
 * Maps to /mvc/caregiver/dashboard
 */
@WebServlet("/mvc/caregiver/dashboard")
public class CaregiverDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CaregiverServiceAPI caregiverAPI;
    private BookingServiceAPI bookingAPI;

    @Override
    public void init() throws ServletException {
        caregiverAPI = new CaregiverServiceAPI();
        bookingAPI = new BookingServiceAPI();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCaregiverLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("sessUserId");

        // Fetch Caregiver Profile
        Caregiver caregiver = caregiverAPI.getCaregiverByUserId(userId);
        if (caregiver == null) {
            // If they are a CAREGIVER user but have no profile record
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=no_profile");
            return;
        }
        request.setAttribute("caregiver", caregiver);

        // Determine View Type (Available Jobs vs My Schedule)
        String action = request.getParameter("action");
        if (action == null || action.isEmpty() || "list".equals(action)) {
            action = "available"; // Default to Available Jobs
        }
        request.setAttribute("viewType", action);

        List<Booking> bookings;
        if ("my".equals(action)) {
            // Fetch assigned bookings for this caregiver
            bookings = bookingAPI.getBookingsByCaregiver(caregiver.getCaregiverId());
        } else {
            // Fetch unassigned bookings (Available Jobs)
            bookings = bookingAPI.getUnassignedBookings();
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/caregiver/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private boolean isCaregiverLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        Integer userId = (Integer) session.getAttribute("sessUserId");
        String role = (String) session.getAttribute("sessUserRole");
        
        return userId != null && "CAREGIVER".equals(role);
    }
}
