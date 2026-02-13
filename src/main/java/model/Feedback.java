package model;

import java.io.Serializable;

/**
 * Feedback - User Review & Rating Entity
 * <p>
 * Purpose:
 * - Captures customer satisfaction data for completed bookings.
 * - Maps to the `feedback` table.
 * - Supports a threaded conversation model (Admin and Caregiver replies).
 * <p>
 * Relationships:
 * - Linked to `app_user` (Customer).
 * - Linked to `caregivers` (Subject of review).
 * - Includes transient fields (userName, caregiverName) for efficient display without extra queries.
 */
public class Feedback implements Serializable {
    private static final long serialVersionUID = 1L;

    private int feedbackId;
    private int userId;
    private int rating; // 1-5 stars
    private Integer caregiverId; // Nullable
    private String comment;
    private java.sql.Timestamp createdAt;
    private String adminReply;
    private java.sql.Timestamp adminReplyAt;
    private String caregiverReply;
    private java.sql.Timestamp caregiverReplyAt;

    // For joined queries - display names
    private String userName;
    private String userRole; // "CUSTOMER" or "CAREGIVER"
    private String caregiverName;

    // Constructors
    public Feedback() {
    }

    public Feedback(int feedbackId, int userId, int rating, String comment) {
        this.feedbackId = feedbackId;
        this.userId = userId;
        this.rating = rating;
        this.comment = comment;
    }

    // Getters and Setters
    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public Integer getCaregiverId() {
        return caregiverId;
    }

    public void setCaregiverId(Integer caregiverId) {
        this.caregiverId = caregiverId;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserName() {
        return userName;
    }
    
    public String getUserRole() {
        return userRole;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getCaregiverName() {
        return caregiverName;
    }

    public void setCaregiverName(String caregiverName) {
        this.caregiverName = caregiverName;
    }

    public String getAdminReply() {
        return adminReply;
    }

    public void setAdminReply(String adminReply) {
        this.adminReply = adminReply;
    }

    public java.sql.Timestamp getAdminReplyAt() {
        return adminReplyAt;
    }

    public void setAdminReplyAt(java.sql.Timestamp adminReplyAt) {
        this.adminReplyAt = adminReplyAt;
    }

    public String getCaregiverReply() {
        return caregiverReply;
    }

    public void setCaregiverReply(String caregiverReply) {
        this.caregiverReply = caregiverReply;
    }

    public java.sql.Timestamp getCaregiverReplyAt() {
        return caregiverReplyAt;
    }

    public void setCaregiverReplyAt(java.sql.Timestamp caregiverReplyAt) {
        this.caregiverReplyAt = caregiverReplyAt;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "feedbackId=" + feedbackId +
                ", userId=" + userId +
                ", rating=" + rating +
                ", caregiverId=" + caregiverId +
                ", comment='" + comment + '\'' +
                ", adminReply='" + adminReply + '\'' +
                '}';
    }
}
