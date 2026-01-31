<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Create Category"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Create New Category</h1>

<c:if test="${not empty param.err}">
  <div class="alert alert-danger">Error: ${param.err}</div>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/admin/category?action=create" class="form">
<div class="form-group">
<label for="name">Category Name</label>
<input type="text" id="name" name="category_name" required>
</div>
<div class="form-group">
<label for="description">Description</label>
<textarea id="description" name="description" rows="4" required></textarea>
</div>
<button type="submit" class="btn btn-primary">Create Category</button>
<a href="${pageContext.request.contextPath}/admin/category" class="btn btn-secondary">Cancel</a>
</form>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
