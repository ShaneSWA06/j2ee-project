package dao;

import java.sql.SQLException;
import java.util.List;

import model.Feedback;

/**
 * FeedbackDAO - Data Access Object interface for Feedback operations
 */
public interface FeedbackDAO {

    /**
     * Get feedback by ID
     */
    Feedback getFeedbackById(int feedbackId) throws SQLException;

    /**
     * Get all feedback (admin view)
     */
    List<Feedback> getAllFeedback() throws SQLException;

    /**
     * Get feedback by specific user
     */
    List<Feedback> getFeedbackByUser(int userId) throws SQLException;

    /**
     * Get feedback for specific caregiver
     */
    List<Feedback> getFeedbackByCaregiver(int caregiverId) throws SQLException;

    /**
     * Create new feedback
     * @return the created feedback with generated ID
     */
    Feedback createFeedback(Feedback feedback) throws SQLException;

    /**
     * Update existing feedback
     */
    boolean updateFeedback(Feedback feedback) throws SQLException;

    /**
     * Delete feedback by ID
     */
    boolean deleteFeedback(int feedbackId) throws SQLException;

    /**
     * Add caregiver reply to feedback
     */
    boolean addCaregiverReply(int feedbackId, String caregiverReply) throws SQLException;
}
