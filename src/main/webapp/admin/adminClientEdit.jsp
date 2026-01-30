<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Edit Client"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Edit Client</h1>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<c:if test="${not empty client}">
<form method="post" action="${pageContext.request.contextPath}/admin/client?action=edit" class="form">
<input type="hidden" name="userId" value="${client.userId}">
<div class="form-group"><label for="username">Username</label><input type="text" id="username" name="username" value="${client.username}" required></div>
<div class="form-group"><label for="email">Email</label><input type="email" id="email" name="email" value="${client.email}"></div>
<div class="form-group"><label for="name">Name</label><input type="text" id="name" name="name" value="${client.name}"></div>
<button type="submit" class="btn btn-primary">Update</button>
<a href="${pageContext.request.contextPath}/admin/client" class="btn btn-secondary">Cancel</a>
</form>
</c:if>
<c:if test="${empty client}"><div class="alert alert-danger">Not found.</div><a href="${pageContext.request.contextPath}/admin/client" class="btn">Back</a></c:if>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
