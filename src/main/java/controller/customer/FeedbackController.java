package controller.customer;

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
 * FeedbackController - Handles customer feedback operations
 */
@WebServlet("/customer/feedback")
public class FeedbackController extends HttpServlet {
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
                    listMyFeedback(request, response);
                    break;
                case "submit":
                    showSubmitForm(request, response);
                    break;
                default:
                    listMyFeedback(request, response);
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
			action = "submit";
		}

        try {
            switch (action) {
                case "submit":
                    submitFeedback(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/customer/feedback");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listMyFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("sessUserId");

        List<Feedback> feedbackList = feedbackDAO.getFeedbackByUser(userId);
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("/customer/myFeedback.jsp").forward(request, response);
    }

    private void showSubmitForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Caregiver> caregivers = caregiverDAO.getAllCaregivers();
        request.setAttribute("caregivers", caregivers);
        request.getRequestDispatcher("/customer/submitFeedback.jsp").forward(request, response);
    }

    private void submitFeedback(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("sessUserId");

        String ratingStr = request.getParameter("rating");
        String caregiverIdStr = request.getParameter("caregiver_id");
        String comment = request.getParameter("comment");

        // Validation
        if (ratingStr == null || ratingStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/feedback?action=submit&err=missing_rating");
            return;
        }

        int rating = Integer.parseInt(ratingStr);

        // Validate rating is between 1-5
        if (rating < 1 || rating > 5) {
            response.sendRedirect(request.getContextPath() +
                "/customer/feedback?action=submit&err=" +
                java.net.URLEncoder.encode("Rating must be between 1 and 5", "UTF-8"));
            return;
        }

        Feedback feedback = new Feedback();
        feedback.setUserId(userId);
        feedback.setRating(rating);

        if (caregiverIdStr != null && !caregiverIdStr.trim().isEmpty()) {
            feedback.setCaregiverId(Integer.parseInt(caregiverIdStr));
        }

        feedback.setComment(comment != null ? comment.trim() : "");

        Feedback created = feedbackDAO.createFeedback(feedback);

        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/customer/feedback?success=submitted");
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/feedback?action=submit&err=submit_failed");
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
