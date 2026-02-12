<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Caregiver Performance Review"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Review Details & Performance Evaluation</h1>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Unable to save changes. Please try again.</div></c:if>
<c:if test="${not empty feedback}">
<form method="post" action="${pageContext.request.contextPath}/admin/feedback?action=edit" class="form">
<input type="hidden" name="feedbackId" value="${feedback.feedbackId}">

<div class="form-row">
    <div class="form-group">
        <label>Submitted By</label>
        <div style="padding: 0.75rem 1rem; background: var(--surface); border: 1px solid var(--border-default); border-radius: var(--radius-lg); color: var(--foreground); font-weight: 600;">
            ${feedback.userName}
        </div>
    </div>
    <div class="form-group">
        <label for="rating">Rating (1-5)</label>
        <input type="number" id="rating" name="rating" min="1" max="5" value="${feedback.rating}" required>
    </div>
</div>

<div class="form-group">
    <label for="caregiver_id">Caregiver (Optional)</label>
    <select id="caregiver_id" name="caregiver_id">
        <option value="">None</option>
        <c:forEach var="caregiver" items="${caregivers}">
            <option value="${caregiver.caregiverId}" ${caregiver.caregiverId == feedback.caregiverId ? 'selected' : ''}>${caregiver.name}</option>
        </c:forEach>
    </select>
</div>

<div class="form-group">
    <label for="comment">Performance Observation / Review</label>
    <textarea id="comment" name="comment" rows="4" readonly style="background: rgba(255,255,255,0.03); color: var(--foreground-muted); cursor: default; border-style: dashed; opacity: 0.8;">${feedback.comment}</textarea>
</div>

<c:if test="${not empty feedback.caregiverReply}">
<div class="form-group" style="background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(59, 130, 246, 0.05) 100%); border: 1px solid rgba(59, 130, 246, 0.2); padding: 20px; border-radius: var(--radius-xl); margin: 24px 0; position: relative; overflow: hidden;">
    <div style="position: absolute; top:0; left:0; width: 4px; height: 100%; background: #3b82f6;"></div>
    <label style="color: #60a5fa; font-weight: 700; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.05em;">
        <span>💬</span> Caregiver's Response
    </label>
    <div style="color: var(--foreground); line-height: 1.6; white-space: pre-wrap; font-size: 1.05rem;">${feedback.caregiverReply}</div>
    <c:if test="${not empty feedback.caregiverReplyAt}">
        <div style="margin-top: 12px; font-size: 0.8rem; color: var(--foreground-muted); display: flex; align-items: center; gap: 6px; opacity: 0.8;">
            <span style="opacity: 0.6;">📅</span> 
            Responded on: <fmt:formatDate value="${feedback.caregiverReplyAt}" pattern="MMM dd, yyyy 'at' hh:mm a"/>
        </div>
    </c:if>
</div>
</c:if>

<div class="form-group">
    <label for="admin_reply">Official Response / Notes</label>
    <textarea id="admin_reply" name="admin_reply" rows="4" placeholder="Type your notes or response here..." style="border-color: var(--border-accent); box-shadow: 0 0 15px rgba(94, 106, 210, 0.1);">${feedback.adminReply}</textarea>
</div>

<div style="display: flex; gap: 12px; margin-top: 2rem;">
    <button type="submit" class="btn btn-primary" style="flex: 2;">Save Changes</button>
    <a href="${pageContext.request.contextPath}/admin/feedback" class="btn btn-secondary" style="flex: 1;">Cancel</a>
</div>
</form>
</c:if>
<c:if test="${empty feedback}"><div class="alert alert-danger">Review not found.</div><a href="${pageContext.request.contextPath}/admin/feedback" class="btn">Back to Reviews</a></c:if>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
