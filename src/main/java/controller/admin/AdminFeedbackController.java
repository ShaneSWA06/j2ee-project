package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import service.CaregiverServiceAPI;
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
    private CaregiverServiceAPI caregiverAPI;

    @Override
    public void init() throws ServletException {
        feedbackDAO = DAOFactory.getFeedbackDAO();
        caregiverAPI = new CaregiverServiceAPI();
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
                case "create":
                    showCreateForm(request, response);
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
                case "create":
                    createFeedback(request, response);
                    break;
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

        List<Feedback> allFeedback = feedbackDAO.getAllFeedback();
        
        // Split lists by user role
        List<Feedback> customerFeedback = new java.util.ArrayList<>();
        List<Feedback> caregiverFeedback = new java.util.ArrayList<>();
        
        for (Feedback f : allFeedback) {
            if ("CUSTOMER".equals(f.getUserRole())) {
                customerFeedback.add(f);
            } else {
                // Includes CAREGIVER, ADMIN, and other roles
                caregiverFeedback.add(f);
            }
        }
        
        request.setAttribute("customerFeedback", customerFeedback);
        request.setAttribute("caregiverFeedback", caregiverFeedback);
        request.setAttribute("feedbackList", allFeedback); // Keep original for compatibility
        
        String type = request.getParameter("type");
        if (type == null) type = "customer";
        request.setAttribute("viewType", type);
        
        request.getRequestDispatcher("/admin/adminFeedbackList.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Caregiver> caregivers = caregiverAPI.getAllCaregivers();
        request.setAttribute("caregivers", caregivers);
        request.getRequestDispatcher("/admin/adminFeedbackCreate.jsp").forward(request, response);
    }

    private void createFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        HttpSession session = request.getSession();
        Integer adminUserId = (Integer) session.getAttribute("sessUserId");

        String caregiverIdStr = request.getParameter("caregiver_id");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (caregiverIdStr == null || ratingStr == null || comment == null || comment.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?action=create&err=missing_fields");
            return;
        }

        Feedback feedback = new Feedback();
        feedback.setUserId(adminUserId); // Admin is the one giving feedback
        feedback.setCaregiverId(Integer.parseInt(caregiverIdStr));
        feedback.setRating(Integer.parseInt(ratingStr));
        feedback.setComment(comment.trim());

        Feedback created = feedbackDAO.createFeedback(feedback);

        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/feedback?action=create&err=create_failed");
        }
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

        List<Caregiver> caregivers = caregiverAPI.getAllCaregivers();
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
        String adminReply = request.getParameter("admin_reply");

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
        feedback.setAdminReply(adminReply != null ? adminReply.trim() : "");

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
