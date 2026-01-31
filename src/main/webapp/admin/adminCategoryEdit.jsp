<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Edit Category"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Edit Category</h1>

<c:if test="${not empty param.err}">
  <div class="alert alert-danger">Error: ${param.err}</div>
</c:if>

<c:if test="${not empty category}">
  <form method="post" action="${pageContext.request.contextPath}/admin/category?action=edit" class="form">
  <input type="hidden" name="categoryId" value="${category.categoryId}">
  <div class="form-group">
  <label for="name">Category Name</label>
  <input type="text" id="name" name="category_name" value="${category.categoryName}" required>
  </div>
  <div class="form-group">
  <label for="description">Description</label>
  <textarea id="description" name="description" rows="4" required>${category.description}</textarea>
  </div>
  <button type="submit" class="btn btn-primary">Update Category</button>
  <a href="${pageContext.request.contextPath}/admin/category" class="btn btn-secondary">Cancel</a>
  </form>
</c:if>

<c:if test="${empty category}">
  <div class="alert alert-danger">Category not found.</div>
  <a href="${pageContext.request.contextPath}/admin/category" class="btn btn-secondary">Back to List</a>
</c:if>

</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
