<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Delete Service"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Delete Service</h1>

<c:if test="${not empty service}">
  <div class="alert alert-danger">
  <p><strong>Warning:</strong> This action cannot be undone.</p>
  </div>
  
  <p>Are you sure you want to delete service: <strong>${service.serviceName}</strong>?</p>
  
  <form method="post" action="${pageContext.request.contextPath}/admin/service?action=delete" class="form">
  <input type="hidden" name="serviceId" value="${service.serviceId}">
  <button type="submit" class="btn btn-danger">Delete Service</button>
  <a href="${pageContext.request.contextPath}/admin/service" class="btn btn-secondary">Cancel</a>
  </form>
</c:if>

<c:if test="${empty service}">
  <div class="alert alert-danger">Service not found.</div>
  <a href="${pageContext.request.contextPath}/admin/service" class="btn btn-secondary">Back to List</a>
</c:if>

</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
