<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="My Feedback"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<h1>My Feedback</h1>
<c:if test="${not empty param.success}"><div class="alert alert-success">Feedback ${param.success}!</div></c:if>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<p><a href="${pageContext.request.contextPath}/customer/feedback?action=submit" class="btn btn-primary">Submit New Feedback</a></p>
<c:choose>
<c:when test="${not empty feedbackList}">
<c:forEach var="feedback" items="${feedbackList}">
<div class="card" style="margin-bottom: 20px;">
<p><strong>Rating:</strong> ${feedback.rating}/5 ⭐</p>
<c:if test="${not empty feedback.caregiverName}"><p><strong>Caregiver:</strong> ${feedback.caregiverName}</p></c:if>
<c:if test="${not empty feedback.comment}"><p><strong>Comment:</strong> "${feedback.comment}"</p></c:if>
<p style="font-size: 12px; color: #999;">Submitted: ${feedback.createdAt}</p>
<c:if test="${not empty feedback.adminReply}">
<div style="margin-top: 15px; padding: 15px; background-color: #f0f8ff; border-left: 4px solid #4a90e2; border-radius: 4px;">
<p style="margin: 0 0 8px 0; font-weight: bold; color: #4a90e2;">💬 Admin Reply:</p>
<p style="margin: 0; color: #333;">${feedback.adminReply}</p>
<c:if test="${not empty feedback.adminReplyAt}">
<p style="margin-top: 8px; font-size: 11px; color: #999;">Replied: ${feedback.adminReplyAt}</p>
</c:if>
</div>
</c:if>
</div>
</c:forEach>
</c:when>
<c:otherwise><p>No feedback yet.</p></c:otherwise>
</c:choose>
</div>
<jsp:include page="../includes/footer.jsp"/>
