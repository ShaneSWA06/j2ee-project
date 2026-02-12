<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Customers"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<h1>Customers</h1>
<c:if test="${not empty param.success}"><div class="alert alert-success"><c:choose><c:when test="${param.success == 'updated'}">Customer updated successfully!</c:when><c:when test="${param.success == 'deleted'}">Customer removed successfully!</c:when></c:choose></div></c:if>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Unable to complete the action. Please try again.</div></c:if>
<table style="width:100%; border-collapse:collapse; margin-top:20px;">
<tr><th style="text-align: left; padding: 12px; background: var(--background-alt);">Customer ID</th><th style="text-align: left; padding: 12px; background: var(--background-alt);">Username</th><th style="text-align: left; padding: 12px; background: var(--background-alt);">Name</th><th style="text-align: left; padding: 12px; background: var(--background-alt);">Email</th><th style="text-align: left; padding: 12px; background: var(--background-alt);">Actions</th></tr>
<c:choose>
<c:when test="${not empty clients}">
<c:forEach var="client" items="${clients}">
<tr style="border-top:1px solid #eee">
<td style="padding: 12px;">${client.userId}</td>
<td style="padding: 12px;">${client.username}</td>
<td style="padding: 12px;">${client.name}</td>
<td style="padding: 12px;">${client.email}</td>
<td style="padding: 12px;"><a class="btn" href="${pageContext.request.contextPath}/admin/client?action=edit&userId=${client.userId}">Edit</a> <a class="btn" href="${pageContext.request.contextPath}/admin/client?action=delete&userId=${client.userId}">Delete</a></td>
</tr>
</c:forEach>
</c:when>
<c:otherwise><tr><td colspan="5" style="text-align:center; padding:20px;">No clients found.</td></tr></c:otherwise>
</c:choose>
</table>
<p style="margin-top:20px"><a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Back</a></p>
</div>
<jsp:include page="../includes/footer.jsp"/>
