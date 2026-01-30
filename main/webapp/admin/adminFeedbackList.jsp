<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Manage Feedback"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<h1>Feedback</h1>
<c:if test="${not empty param.success}"><div class="alert alert-success"><c:choose><c:when test="${param.success == 'updated'}">Updated!</c:when><c:when test="${param.success == 'deleted'}">Deleted!</c:when></c:choose></div></c:if>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
<tr><th style="text-align: left; padding: 12px; background: #f5f5f5;">ID</th><th style="text-align: left; padding: 12px; background: #f5f5f5;">Customer</th><th style="text-align: left; padding: 12px; background: #f5f5f5;">Rating</th><th style="text-align: left; padding: 12px; background: #f5f5f5;">Caregiver</th><th style="text-align: left; padding: 12px; background: #f5f5f5;">Comment</th><th style="text-align: left; padding: 12px; background: #f5f5f5;">Actions</th></tr>
<c:choose>
<c:when test="${not empty feedbackList}">
<c:forEach var="feedback" items="${feedbackList}">
<tr style="border-top:1px solid #eee">
<td style="padding: 12px;">${feedback.feedbackId}</td>
<td style="padding: 12px;">${feedback.userName}</td>
<td style="padding: 12px;">${feedback.rating}/5</td>
<td style="padding: 12px;">${not empty feedback.caregiverName ? feedback.caregiverName : 'N/A'}</td>
<td style="padding: 12px;">${feedback.comment}</td>
<td style="padding: 12px;"><a class="btn" href="${pageContext.request.contextPath}/admin/feedback?action=edit&feedbackId=${feedback.feedbackId}">Edit</a> <a class="btn" href="${pageContext.request.contextPath}/admin/feedback?action=delete&feedbackId=${feedback.feedbackId}">Delete</a></td>
</tr>
</c:forEach>
</c:when>
<c:otherwise><tr><td colspan="6" style="text-align:center; padding:20px;">No feedback found.</td></tr></c:otherwise>
</c:choose>
</table>
<p style="margin-top:20px"><a class="btn" href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">Back</a></p>
</div>
<jsp:include page="../includes/footer.jsp"/>
