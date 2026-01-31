package controller.admin;

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
 * AdminFeedbackController - Handles feedback management for admins
 */
@WebServlet("/admin/feedback")
public class AdminFeedbackController extends HttpServlet {
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
                    listFeedback(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    showDeleteConfirmation(request, response);
                    break;
                default:
                    listFeedback(request, response);
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
                    updateFeedback(request, response);
                    break;
                case "delete":
                    deleteFeedback(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/feedback");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Feedback> feedbackList = feedbackDAO.getAllFeedback();
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("/admin/adminFeedbackList.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String feedbackIdParam = request.getParameter("feedbackId");
        if (feedbackIdParam == null || feedbackIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?err=missing_id");
            return;
        }

        int feedbackId = Integer.parseInt(feedbackIdParam);
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        if (feedback == null) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?err=not_found");
            return;
        }

        List<Caregiver> caregivers = caregiverDAO.getAllCaregivers();
        request.setAttribute("feedback", feedback);
        request.setAttribute("caregivers", caregivers);
        request.getRequestDispatcher("/admin/adminFeedbackEdit.jsp").forward(request, response);
    }

    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String feedbackIdParam = request.getParameter("feedbackId");
        if (feedbackIdParam == null || feedbackIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?err=missing_id");
            return;
        }

        int feedbackId = Integer.parseInt(feedbackIdParam);
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        if (feedback == null) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?err=not_found");
            return;
        }

        request.setAttribute("feedback", feedback);
        request.getRequestDispatcher("/admin/adminFeedbackDelete.jsp").forward(request, response);
    }

    private void updateFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String feedbackIdStr = request.getParameter("feedbackId");
        String ratingStr = request.getParameter("rating");
        String caregiverIdStr = request.getParameter("caregiver_id");
        String comment = request.getParameter("comment");

        if (feedbackIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?err=missing_fields");
            return;
        }

        int feedbackId = Integer.parseInt(feedbackIdStr);
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(feedbackId);
        feedback.setRating(Integer.parseInt(ratingStr));

        if (caregiverIdStr != null && !caregiverIdStr.trim().isEmpty()) {
            feedback.setCaregiverId(Integer.parseInt(caregiverIdStr));
        }

        feedback.setComment(comment != null ? comment.trim() : "");

        boolean updated = feedbackDAO.updateFeedback(feedback);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?action=edit&feedbackId=" + feedbackId + "&err=update_failed");
        }
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String feedbackIdStr = request.getParameter("feedbackId");

        if (feedbackIdStr == null || feedbackIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?err=missing_id");
            return;
        }

        int feedbackId = Integer.parseInt(feedbackIdStr);
        boolean deleted = feedbackDAO.deleteFeedback(feedbackId);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?err=delete_failed");
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
