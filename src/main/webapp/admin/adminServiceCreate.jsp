<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Create Service"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Create New Service</h1>

<c:if test="${not empty param.err}">
  <div class="alert alert-danger">Error: ${param.err}</div>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/admin/service?action=create" class="form">
<div class="form-group">
<label for="category_id">Category</label>
<select id="category_id" name="category_id" required>
<option value="">Select Category</option>
<c:forEach var="category" items="${categories}">
  <option value="${category.categoryId}">${category.categoryName}</option>
</c:forEach>
</select>
</div>
<div class="form-group">
<label for="service_name">Service Name</label>
<input type="text" id="service_name" name="service_name" required>
</div>
<div class="form-group">
<label for="description">Description</label>
<textarea id="description" name="description" rows="4" required></textarea>
</div>
<div class="form-group">
<label for="base_price">Base Price ($)</label>
<input type="number" id="base_price" name="base_price" step="0.01" min="0" required>
</div>
<div class="form-group">
<label for="duration_minutes">Duration (minutes)</label>
<input type="number" id="duration_minutes" name="duration_minutes" min="1" required>
</div>
<div class="form-group">
<label>
  <input type="checkbox" name="is_active" value="true" checked> Active
</label>
</div>
<button type="submit" class="btn btn-primary">Create Service</button>
<a href="${pageContext.request.contextPath}/admin/service" class="btn btn-secondary">Cancel</a>
</form>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
