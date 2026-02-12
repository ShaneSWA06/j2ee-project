<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Send Feedback to Caregiver"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<style>
.feedback-container {
    max-width: 800px;
    margin: 2rem auto;
    padding: 0 2rem;
}

.feedback-card {
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 2rem;
}

.feedback-header {
    margin-bottom: 2rem;
}

.feedback-header h1 {
    font-size: 1.75rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
    color: var(--foreground);
}

.feedback-header p {
    color: var(--foreground-muted);
    margin: 0;
}

.form-group {
    margin-bottom: 1.5rem;
}

.form-label {
    display: block;
    font-weight: 600;
    margin-bottom: 0.5rem;
    color: var(--foreground);
}

.form-label .required {
    color: #ef4444;
    margin-left: 4px;
}

.form-input, .form-select, .form-textarea {
    width: 100%;
    padding: 0.75rem 1rem;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    color: var(--foreground);
    font-family: inherit;
    font-size: 0.9375rem;
    transition: all 0.3s ease;
}

.form-input:focus, .form-select:focus, .form-textarea:focus {
    outline: none;
    border-color: var(--accent);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-select {
    cursor: pointer;
}

.form-textarea {
    resize: vertical;
    min-height: 150px;
    line-height: 1.6;
}

.rating-group {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.rating-option {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.rating-option input[type="radio"] {
    width: 18px;
    height: 18px;
    cursor: pointer;
    accent-color: var(--accent);
}

.rating-option label {
    cursor: pointer;
    color: var(--foreground);
    font-size: 1.25rem;
}

.star-display {
    color: #fbbf24;
    margin-left: 0.25rem;
}

.form-actions {
    display: flex;
    gap: 1rem;
    margin-top: 2rem;
    padding-top: 2rem;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.btn-submit {
    background: linear-gradient(135deg, #28a745 0%, #20863a 100%);
    color: white;
    padding: 0.75rem 2rem;
    border: none;
    border-radius: 8px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
    box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(40, 167, 69, 0.4);
}

.btn-cancel {
    background: transparent;
    color: var(--foreground);
    padding: 0.75rem 2rem;
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    font-size: 1rem;
    font-weight: 500;
    text-decoration: none;
    cursor: pointer;
    transition: all 0.3s;
    display: inline-block;
}

.btn-cancel:hover {
    background: rgba(255, 255, 255, 0.05);
    border-color: rgba(255, 255, 255, 0.3);
}

.alert {
    padding: 1rem 1.25rem;
    margin-bottom: 1.5rem;
    border-radius: 8px;
    font-weight: 500;
}

.alert-danger {
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid rgba(239, 68, 68, 0.3);
    color: #ef4444;
}

.info-box {
    background: rgba(59, 130, 246, 0.1);
    border-left: 4px solid var(--accent);
    padding: 1rem;
    border-radius: 8px;
    margin-bottom: 1.5rem;
}

.info-box p {
    margin: 0;
    color: var(--foreground);
    line-height: 1.6;
}
</style>

<div class="feedback-container">
    <div class="feedback-card">
        <div class="feedback-header">
            <h1>✍️ Send Feedback to Caregiver</h1>
            <p>Provide performance feedback and ratings for caregiver evaluation</p>
        </div>

        <c:if test="${not empty param.err}">
            <div class="alert alert-danger">
                <c:choose>
                    <c:when test="${param.err == 'missing_fields'}">
                        Please fill in all required fields.
                    </c:when>
                    <c:when test="${param.err == 'create_failed'}">
                        Failed to send feedback. Please try again.
                    </c:when>
                    <c:otherwise>
                        An error occurred. Please try again.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="info-box">
            <p>📝 Use this form to send performance feedback to caregivers. This feedback will help them improve their service quality and track their performance over time.</p>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/feedback">
            <input type="hidden" name="action" value="create">

            <div class="form-group">
                <label class="form-label">
                    Select Caregiver<span class="required">*</span>
                </label>
                <select name="caregiver_id" class="form-select" required>
                    <option value="">-- Choose a caregiver --</option>
                    <c:forEach var="caregiver" items="${caregivers}">
                        <option value="${caregiver.caregiverId}">
                            ${caregiver.name} - ${caregiver.specialization}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">
                    Rating<span class="required">*</span>
                </label>
                <div class="rating-group">
                    <c:forEach var="i" begin="1" end="5">
                        <div class="rating-option">
                            <input type="radio" id="rating${i}" name="rating" value="${i}" 
                                   ${i == 5 ? 'checked' : ''} required>
                            <label for="rating${i}">
                                ${i}
                                <span class="star-display">
                                    <c:forEach var="j" begin="1" end="${i}">★</c:forEach>
                                </span>
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">
                    Feedback Comments<span class="required">*</span>
                </label>
                <textarea name="comment" class="form-textarea" required 
                          placeholder="Provide detailed feedback about the caregiver's performance, professionalism, and areas for improvement..."></textarea>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-submit">
                    📤 Send Feedback
                </button>
                <a href="${pageContext.request.contextPath}/admin/feedback" class="btn-cancel">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
