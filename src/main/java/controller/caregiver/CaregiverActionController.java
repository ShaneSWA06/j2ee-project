package controller.caregiver;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import service.BookingServiceAPI;
import service.CaregiverServiceAPI;
import model.Caregiver;

/**
 * CaregiverActionController handles job-related actions like Accept, Clock In, and Clock Out.
 */
@WebServlet({"/mvc/caregiver/accept", "/mvc/caregiver/clockin", "/mvc/caregiver/clockout"})
public class CaregiverActionController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingServiceAPI bookingAPI;
    private CaregiverServiceAPI caregiverAPI;

    @Override
    public void init() throws ServletException {
        bookingAPI = new BookingServiceAPI();
        caregiverAPI = new CaregiverServiceAPI();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isCaregiverLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        String path = request.getServletPath();
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?err=missing_id");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("sessUserId");
        Caregiver caregiver = caregiverAPI.getCaregiverByUserId(userId);

        if (caregiver == null) {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?err=no_profile");
            return;
        }

        boolean success = false;
        String successMsg = "";
        String errorMsg = "action_failed";

        if (path.endsWith("/accept")) {
            success = bookingAPI.assignCaregiver(bookingId, caregiver.getCaregiverId());
            successMsg = "job_accepted";
            errorMsg = "accept_failed";
        } else if (path.endsWith("/clockin")) {
            String location = request.getParameter("location");
            success = bookingAPI.clockIn(bookingId, location);
            successMsg = "clocked_in";
        } else if (path.endsWith("/clockout")) {
            String location = request.getParameter("location");
            success = bookingAPI.clockOut(bookingId, location);
            successMsg = "clocked_out";
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?action=my&success=" + successMsg);
        } else {
            response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?err=" + errorMsg);
        }
    }

    private boolean isCaregiverLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        Integer userId = (Integer) session.getAttribute("sessUserId");
        String role = (String) session.getAttribute("sessUserRole");
        return userId != null && "CAREGIVER".equals(role);
    }
}
