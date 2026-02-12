<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="My Feedback"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<style>
.feedback-container {
    max-width: 1200px;
    margin: 2rem auto;
    padding: 0 2rem;
}

.feedback-header {
    margin-bottom: 2rem;
}

.feedback-header h1 {
    font-size: 2rem;
    font-weight: 700;
    color: var(--foreground);
    margin-bottom: 0.5rem;
}

.feedback-header p {
    color: var(--foreground-muted);
    font-size: 1.1rem;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}

.stat-card {
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 1.5rem;
    text-align: center;
}

.stat-value {
    font-size: 2.5rem;
    font-weight: 700;
    color: var(--accent);
    margin-bottom: 0.5rem;
}

.stat-label {
    color: var(--foreground-muted);
    font-size: 0.9rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.feedback-list {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.feedback-card {
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 1.5rem;
    transition: all 0.3s;
}

.feedback-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    border-color: rgba(255, 255, 255, 0.1);
}

.feedback-card-header {
    display: flex;
    justify-content: space-between;
    align-items: start;
    margin-bottom: 1rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.feedback-info {
    flex: 1;
}

.feedback-from {
    font-size: 0.875rem;
    color: var(--foreground-muted);
    margin-bottom: 0.5rem;
}

.feedback-date {
    font-size: 0.875rem;
    color: var(--foreground-muted);
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.rating-display {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.stars {
    color: #fbbf24;
    font-size: 1.5rem;
    letter-spacing: 0.1rem;
}

.rating-number {
    font-size: 1.25rem;
    font-weight: 600;
    color: var(--foreground);
}

.feedback-comment {
    color: var(--foreground);
    line-height: 1.6;
    font-size: 1rem;
}

.empty-state {
    text-align: center;
    padding: 4rem 2rem;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 12px;
}

.empty-state-icon {
    font-size: 4rem;
    margin-bottom: 1rem;
    opacity: 0.5;
}

.empty-state h3 {
    color: var(--foreground);
    font-size: 1.5rem;
    margin-bottom: 0.5rem;
}

.empty-state p {
    color: var(--foreground-muted);
    font-size: 1rem;
}

.back-button {
    display: inline-block;
    margin-top: 2rem;
    padding: 0.75rem 2rem;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    color: var(--foreground);
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s;
}

.back-button:hover {
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.2);
}

.alert {
    padding: 1rem 1.25rem;
    margin-bottom: 1.5rem;
    border-radius: 8px;
    font-weight: 500;
}

.alert-success {
    background: rgba(40, 167, 69, 0.1);
    border: 1px solid rgba(40, 167, 69, 0.3);
    color: #28a745;
}

.alert-danger {
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid rgba(239, 68, 68, 0.3);
    color: #ef4444;
}

.caregiver-reply-section {
    margin-top: 1.5rem;
    padding-top: 1.5rem;
    border-top: 1px solid rgba(255, 255, 255, 0.05);
}

.your-reply {
    background: rgba(59, 130, 246, 0.1);
    border-left: 4px solid var(--accent);
    padding: 1rem;
    border-radius: 8px;
    margin-bottom: 1rem;
}

.your-reply-header {
    font-size: 0.875rem;
    color: var(--foreground-muted);
    margin-bottom: 0.5rem;
    font-weight: 600;
}

.your-reply-text {
    color: var(--foreground);
    line-height: 1.6;
}

.reply-form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.reply-textarea {
    width: 100%;
    padding: 0.75rem;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.15);
    border-radius: 8px;
    color: var(--foreground);
    font-family: inherit;
    resize: vertical;
    min-height: 100px;
    line-height: 1.6;
}

.reply-textarea:focus {
    outline: none;
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.reply-button {
    background: linear-gradient(135deg, var(--accent, #3b82f6) 0%, #2563eb 100%);
    color: white;
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 8px;
    font-size: 0.9375rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
    align-self: flex-start;
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

.reply-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(59, 130, 246, 0.4);
}

.reply-button:active {
    transform: translateY(0);
}
</style>

<div class="feedback-container">
    <div class="feedback-header">
        <h1>📊 My Performance Feedback</h1>
        <p>Review feedback and ratings from administrators</p>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">
            <c:choose>
                <c:when test="${param.success == 'reply_added'}">✅ Your reply has been submitted successfully!</c:when>
                <c:otherwise>Success!</c:otherwise>
            </c:choose>
        </div>
    </c:if>
    
    <c:if test="${not empty param.err}">
        <div class="alert alert-danger">
            <c:choose>
                <c:when test="${param.err == 'missing_fields'}">❌ Please provide a reply message.</c:when>
                <c:when test="${param.err == 'reply_failed'}">❌ Failed to submit reply. Please try again.</c:when>
                <c:when test="${param.err == 'invalid_id'}">❌ Invalid feedback ID.</c:when>
                <c:otherwise>❌ An error occurred. Please try again.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:set var="totalFeedback" value="${feedbackList.size()}" />
    <c:set var="totalRating" value="0" />
    <c:forEach var="feedback" items="${feedbackList}">
        <c:set var="totalRating" value="${totalRating + feedback.rating}" />
    </c:forEach>
    <c:set var="avgRating" value="${totalFeedback > 0 ? totalRating / totalFeedback : 0}" />

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value">${totalFeedback}</div>
            <div class="stat-label">Total Feedback</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <fmt:formatNumber value="${avgRating}" maxFractionDigits="1" />
            </div>
            <div class="stat-label">Average Rating</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <c:set var="excellentCount" value="0" />
                <c:forEach var="feedback" items="${feedbackList}">
                    <c:if test="${feedback.rating >= 4}">
                        <c:set var="excellentCount" value="${excellentCount + 1}" />
                    </c:if>
                </c:forEach>
                ${excellentCount}
            </div>
            <div class="stat-label">4+ Stars</div>
        </div>
    </div>

    <div class="feedback-list">
        <c:choose>
            <c:when test="${not empty feedbackList}">
                <c:forEach var="feedback" items="${feedbackList}">
                    <div class="feedback-card">
                        <div class="feedback-card-header">
                            <div class="feedback-info">
                                <div class="feedback-from">
                                    👤 From: ${feedback.userName != null ? feedback.userName : 'Admin'}
                                </div>
                                <div class="feedback-date">
                                    📅 <fmt:formatDate value="${feedback.createdAt}" pattern="MMM dd, yyyy 'at' hh:mm a" />
                                </div>
                            </div>
                            <div class="rating-display">
                                <div class="stars">
                                    <c:forEach var="i" begin="1" end="${feedback.rating}">★</c:forEach>
                                    <c:forEach var="i" begin="${feedback.rating + 1}" end="5">☆</c:forEach>
                                </div>
                                <span class="rating-number">${feedback.rating}/5</span>
                            </div>
                        </div>
                        <div class="feedback-comment">
                            ${feedback.comment}
                        </div>
                        
                        <!-- Caregiver Reply Section -->
                        <div class="caregiver-reply-section">
                            <c:choose>
                                <c:when test="${not empty feedback.caregiverReply}">
                                    <div class="your-reply">
                                        <div class="your-reply-header">
                                            💬 Your Reply <c:if test="${not empty feedback.caregiverReplyAt}">- <fmt:formatDate value="${feedback.caregiverReplyAt}" pattern="MMM dd, yyyy"/></c:if>
                                        </div>
                                        <div class="your-reply-text">
                                            ${feedback.caregiverReply}
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" action="${pageContext.request.contextPath}/caregiver/feedback" class="reply-form">
                                        <input type="hidden" name="action" value="reply">
                                        <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
                                        <textarea name="reply" class="reply-textarea" placeholder="Write your response to this feedback..." required></textarea>
                                        <button type="submit" class="reply-button">📤 Submit Reply</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">💬</div>
                    <h3>No Feedback Yet</h3>
                    <p>You haven't received any feedback from administrators yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <a href="${pageContext.request.contextPath}/caregiver/dashboard" class="back-button">
        ← Back to Dashboard
    </a>
</div>

<jsp:include page="../includes/footer.jsp"/>
