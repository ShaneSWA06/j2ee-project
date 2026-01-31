<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Edit Feedback"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Edit Feedback</h1>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<c:if test="${not empty feedback}">
<form method="post" action="${pageContext.request.contextPath}/admin/feedback?action=edit" class="form">
<input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
<div class="form-group"><label>Customer: <strong>${feedback.userName}</strong></label></div>
<div class="form-group"><label for="rating">Rating (1-5)</label><input type="number" id="rating" name="rating" min="1" max="5" value="${feedback.rating}" required></div>
<div class="form-group"><label for="caregiver_id">Caregiver (Optional)</label><select id="caregiver_id" name="caregiver_id"><option value="">None</option><c:forEach var="caregiver" items="${caregivers}"><option value="${caregiver.caregiverId}" ${caregiver.caregiverId == feedback.caregiverId ? 'selected' : ''}>${caregiver.name}</option></c:forEach></select></div>
<div class="form-group"><label for="comment">Comment</label><textarea id="comment" name="comment" rows="4">${feedback.comment}</textarea></div>
<button type="submit" class="btn btn-primary">Update</button>
<a href="${pageContext.request.contextPath}/admin/feedback" class="btn btn-secondary">Cancel</a>
</form>
</c:if>
<c:if test="${empty feedback}"><div class="alert alert-danger">Not found.</div><a href="${pageContext.request.contextPath}/admin/feedback" class="btn">Back</a></c:if>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
