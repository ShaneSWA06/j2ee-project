package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import dao.FeedbackDAO;
import db.DBUtil;
import model.Feedback;

/**
 * FeedbackDAOImpl - JDBC Implementation of FeedbackDAO
 * <p>
 * Purpose:
 * - Implements the database operations for Feedback using raw JDBC.
 * - Manages connections via DBUtil.
 * - Handles result set mapping to Feedback objects.
 */
public class FeedbackDAOImpl implements FeedbackDAO {

    @Override
    public Feedback getFeedbackById(int feedbackId) throws SQLException {
        String sql = "SELECT f.feedback_id, f.user_id, f.rating, f.caregiver_id, f.comment, f.created_at, " +
                     "f.admin_reply, f.admin_reply_at, f.caregiver_reply, f.caregiver_reply_at, " +
                     "u.name as user_name, u.role as user_role, c.name as caregiver_name " +
                     "FROM feedback f " +
                     "LEFT JOIN app_user u ON f.user_id = u.user_id " +
                     "LEFT JOIN caregiver c ON f.caregiver_id = c.caregiver_id " +
                     "WHERE f.feedback_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractFeedbackFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Feedback> getAllFeedback() throws SQLException {
        String sql = "SELECT f.feedback_id, f.user_id, f.rating, f.caregiver_id, f.comment, f.created_at, " +
                     "f.admin_reply, f.admin_reply_at, f.caregiver_reply, f.caregiver_reply_at, " +
                     "u.name as user_name, u.role as user_role, c.name as caregiver_name " +
                     "FROM feedback f " +
                     "LEFT JOIN app_user u ON f.user_id = u.user_id " +
                     "LEFT JOIN caregiver c ON f.caregiver_id = c.caregiver_id " +
                     "ORDER BY f.created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Feedback> feedbackList = new ArrayList<>();
            while (rs.next()) {
                feedbackList.add(extractFeedbackFromResultSet(rs));
            }
            return feedbackList;
        }
    }

    @Override
    public List<Feedback> getFeedbackByUser(int userId) throws SQLException {
        String sql = "SELECT f.feedback_id, f.user_id, f.rating, f.caregiver_id, f.comment, f.created_at, " +
                     "f.admin_reply, f.admin_reply_at, f.caregiver_reply, f.caregiver_reply_at, " +
                     "u.name as user_name, u.role as user_role, c.name as caregiver_name " +
                     "FROM feedback f " +
                     "LEFT JOIN app_user u ON f.user_id = u.user_id " +
                     "LEFT JOIN caregiver c ON f.caregiver_id = c.caregiver_id " +
                     "WHERE f.user_id = ? " +
                     "ORDER BY f.created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Feedback> feedbackList = new ArrayList<>();
                while (rs.next()) {
                    feedbackList.add(extractFeedbackFromResultSet(rs));
                }
                return feedbackList;
            }
        }
    }

    @Override
    public List<Feedback> getFeedbackByCaregiver(int caregiverId) throws SQLException {
        String sql = "SELECT f.feedback_id, f.user_id, f.rating, f.caregiver_id, f.comment, f.created_at, " +
                     "f.admin_reply, f.admin_reply_at, f.caregiver_reply, f.caregiver_reply_at, " +
                     "u.name as user_name, u.role as user_role, c.name as caregiver_name " +
                     "FROM feedback f " +
                     "LEFT JOIN app_user u ON f.user_id = u.user_id " +
                     "LEFT JOIN caregiver c ON f.caregiver_id = c.caregiver_id " +
                     "WHERE f.caregiver_id = ? " +
                     "ORDER BY f.created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Feedback> feedbackList = new ArrayList<>();
                while (rs.next()) {
                    feedbackList.add(extractFeedbackFromResultSet(rs));
                }
                return feedbackList;
            }
        }
    }

    @Override
    public Feedback createFeedback(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO feedback (user_id, rating, caregiver_id, comment) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, feedback.getUserId());
            ps.setInt(2, feedback.getRating());

            if (feedback.getCaregiverId() != null) {
                ps.setInt(3, feedback.getCaregiverId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setString(4, feedback.getComment());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        feedback.setFeedbackId(rs.getInt(1));
                        return feedback;
                    }
                }
            }
        }
        return null;
    }

    @Override
    public boolean updateFeedback(Feedback feedback) throws SQLException {
        String sql = "UPDATE feedback SET rating = ?, caregiver_id = ?, comment = ?, admin_reply = ?, admin_reply_at = ? WHERE feedback_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedback.getRating());

            if (feedback.getCaregiverId() != null) {
                ps.setInt(2, feedback.getCaregiverId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setString(3, feedback.getComment());
            
            if (feedback.getAdminReply() != null && !feedback.getAdminReply().trim().isEmpty()) {
                ps.setString(4, feedback.getAdminReply());
                if (feedback.getAdminReplyAt() == null) {
                    ps.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis()));
                } else {
                    ps.setTimestamp(5, feedback.getAdminReplyAt());
                }
            } else {
                ps.setNull(4, Types.VARCHAR);
                ps.setNull(5, Types.TIMESTAMP);
            }
            
            ps.setInt(6, feedback.getFeedbackId());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteFeedback(int feedbackId) throws SQLException {
        String sql = "DELETE FROM feedback WHERE feedback_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean addCaregiverReply(int feedbackId, String caregiverReply) throws SQLException {
        String sql = "UPDATE feedback SET caregiver_reply = ?, caregiver_reply_at = CURRENT_TIMESTAMP WHERE feedback_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, caregiverReply);
            ps.setInt(2, feedbackId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Helper method to extract Feedback object from ResultSet
     */
    private Feedback extractFeedbackFromResultSet(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setRating(rs.getInt("rating"));

        int caregiverId = rs.getInt("caregiver_id");
        if (!rs.wasNull()) {
            feedback.setCaregiverId(caregiverId);
        }

        feedback.setComment(rs.getString("comment"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        feedback.setAdminReply(rs.getString("admin_reply"));
        feedback.setAdminReplyAt(rs.getTimestamp("admin_reply_at"));
        
        // Try to get caregiver reply fields (may not exist in all queries)
        try {
            feedback.setCaregiverReply(rs.getString("caregiver_reply"));
            feedback.setCaregiverReplyAt(rs.getTimestamp("caregiver_reply_at"));
        } catch (SQLException e) {
            // Columns not in result set, ignore
        }
        
        feedback.setUserName(rs.getString("user_name"));
        feedback.setUserRole(rs.getString("user_role"));
        feedback.setCaregiverName(rs.getString("caregiver_name"));

        return feedback;
    }
}
