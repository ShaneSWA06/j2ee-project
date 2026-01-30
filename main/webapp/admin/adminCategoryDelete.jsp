<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Delete Category"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Delete Category</h1>

<c:if test="${not empty category}">
  <div class="alert alert-danger">
  <p><strong>Warning:</strong> This action cannot be undone. All services under this category will also be affected.</p>
  </div>
  
  <p>Are you sure you want to delete category: <strong>${category.categoryName}</strong>?</p>
  
  <form method="post" action="${pageContext.request.contextPath}/admin/category?action=delete" class="form">
  <input type="hidden" name="categoryId" value="${category.categoryId}">
  <button type="submit" class="btn btn-danger">Delete Category</button>
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
