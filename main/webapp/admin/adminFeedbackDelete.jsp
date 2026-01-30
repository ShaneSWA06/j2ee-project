<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Delete Feedback"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Delete Feedback</h1>
<c:if test="${not empty feedback}">
<div class="alert alert-danger"><p><strong>Warning:</strong> This cannot be undone.</p></div>
<p>Delete feedback from: <strong>${feedback.userName}</strong>?</p>
<form method="post" action="${pageContext.request.contextPath}/admin/feedback?action=delete">
<input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
<button type="submit" class="btn btn-danger">Delete</button>
<a href="${pageContext.request.contextPath}/admin/feedback" class="btn btn-secondary">Cancel</a>
</form>
</c:if>
<c:if test="${empty feedback}"><div class="alert alert-danger">Not found.</div><a href="${pageContext.request.contextPath}/admin/feedback" class="btn">Back</a></c:if>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
