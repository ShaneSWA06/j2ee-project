package controller.caregiver;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.CaregiverDAO;
import dao.DAOFactory;
import dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Caregiver;
import model.Feedback;

/**
 * CaregiverFeedbackController - Handles caregiver viewing their feedback
 */
@WebServlet("/caregiver/feedback")
public class CaregiverFeedbackController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeedbackDAO feedbackDAO;
    private CaregiverDAO caregiverDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = DAOFactory.getFeedbackDAO();
        caregiverDAO = DAOFactory.getCaregiverDAO();
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

        try {
            // Get caregiver profile by user ID
            Caregiver caregiver = caregiverDAO.getCaregiverByUserId(userId);
            
            if (caregiver == null) {
                response.sendRedirect(request.getContextPath() + "/mvc/caregiver/dashboard?err=no_caregiver_profile");
                return;
            }

            List<Feedback> feedbackList = feedbackDAO.getFeedbackByCaregiver(caregiver.getCaregiverId());
            request.setAttribute("feedbackList", feedbackList);
            request.getRequestDispatcher("/caregiver/caregiverFeedbackList.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCaregiverLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        String action = request.getParameter("action");
        
        if ("reply".equals(action)) {
            addReply(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/caregiver/feedback");
        }
    }

    private void addReply(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String feedbackIdStr = request.getParameter("feedbackId");
        String replyText = request.getParameter("reply");

        if (feedbackIdStr == null || replyText == null || replyText.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/caregiver/feedback?err=missing_fields");
            return;
        }

        try {
            int feedbackId = Integer.parseInt(feedbackIdStr);
            boolean success = feedbackDAO.addCaregiverReply(feedbackId, replyText.trim());

            if (success) {
                response.sendRedirect(request.getContextPath() + "/caregiver/feedback?success=reply_added");
            } else {
                response.sendRedirect(request.getContextPath() + "/caregiver/feedback?err=reply_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/caregiver/feedback?err=invalid_id");
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private boolean isCaregiverLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        Integer userId = (Integer) session.getAttribute("sessUserId");
        String role = (String) session.getAttribute("sessUserRole");
        return userId != null && "CAREGIVER".equals(role);
    }
}
