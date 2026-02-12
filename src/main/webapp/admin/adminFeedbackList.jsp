<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Caregiver Feedback"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<h1>Caregiver Performance & Feedback</h1>

<div style="margin-bottom: 20px;">
    <a class="btn" href="${pageContext.request.contextPath}/admin/feedback?action=create" 
       style="background: linear-gradient(135deg, #28a745 0%, #20863a 100%); color: white; padding: 12px 24px; text-decoration: none; border-radius: 8px; display: inline-block; font-weight: 600;">
        ✏️ Send Feedback to Caregiver
    </a>
</div>

<c:if test="${not empty param.success}"><div class="alert alert-success"><c:choose><c:when test="${param.success == 'created'}">Feedback sent successfully!</c:when><c:when test="${param.success == 'updated'}">Review updated successfully!</c:when><c:when test="${param.success == 'deleted'}">Review removed successfully!</c:when></c:choose></div></c:if>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Unable to complete the action. Please try again.</div></c:if>
<table>
<thead>
    <tr>
        <th>Review #</th>
        <th>Submitted By</th>
        <th>Rating</th>
        <th>Caregiver</th>
        <th>Comment</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
</thead>
<c:choose>
<c:when test="${not empty feedbackList}">
<c:forEach var="feedback" items="${feedbackList}">
<tr>
<td>${feedback.feedbackId}</td>
<td>${feedback.userName}</td>
<td>${feedback.rating}/5</td>
<td>${not empty feedback.caregiverName ? feedback.caregiverName : 'N/A'}</td>
<td>${feedback.comment}</td>
<td>
<c:choose>
<c:when test="${not empty feedback.adminReply}">
<span style="color: #28a745; font-weight: bold;">✓ Replied</span>
</c:when>
<c:when test="${empty feedback.caregiverReply}">
<span style="color: #dc3545;">Pending Response</span>
</c:when>
</c:choose>
<c:if test="${not empty feedback.caregiverReply}">
<c:if test="${not empty feedback.adminReply}"><br/></c:if>
<span style="color: #3b82f6; font-weight: bold; font-size: 0.85rem;">💬 Caregiver Responded</span>
</c:if>
</td>
<td><a class="btn btn-sm" href="${pageContext.request.contextPath}/admin/feedback?action=edit&feedbackId=${feedback.feedbackId}">Edit</a> <a class="btn btn-sm btn-secondary" href="${pageContext.request.contextPath}/admin/feedback?action=delete&feedbackId=${feedback.feedbackId}">Delete</a></td>
</tr>
</c:forEach>
</c:when>
<c:otherwise><tr><td colspan="7" style="text-align:center; padding:20px;">No caregiver reviews yet.</td></tr></c:otherwise>
</c:choose>
</table>
<p style="margin-top:20px"><a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Back</a></p>
</div>
<jsp:include page="../includes/footer.jsp"/>
