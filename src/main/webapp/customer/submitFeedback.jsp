<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Submit Feedback"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Submit Feedback</h1>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<form method="post" action="${pageContext.request.contextPath}/customer/feedback?action=submit" class="form">
<div class="form-group"><label for="rating">Rating *</label><select id="rating" name="rating" required><option value="">Select Rating</option><option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option><option value="4">⭐⭐⭐⭐ (4 - Good)</option><option value="3">⭐⭐⭐ (3 - Average)</option><option value="2">⭐⭐ (2 - Fair)</option><option value="1">⭐ (1 - Poor)</option></select></div>
<div class="form-group"><label for="caregiver_id">Caregiver (Optional)</label><select id="caregiver_id" name="caregiver_id"><option value="">General Feedback</option><c:forEach var="caregiver" items="${caregivers}"><option value="${caregiver.caregiverId}">${caregiver.name}</option></c:forEach></select></div>
<div class="form-group"><label for="comment">Comment *</label><textarea id="comment" name="comment" rows="4" required></textarea></div>
<button type="submit" class="btn btn-primary">Submit Feedback</button>
<a href="${pageContext.request.contextPath}/customer/feedback" class="btn btn-secondary">Cancel</a>
</form>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
