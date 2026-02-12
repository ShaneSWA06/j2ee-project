<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Manage Categories"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Service Categories</h1>
  
  <c:if test="${not empty param.success}">
    <div class="alert alert-success">
      <c:choose>
        <c:when test="${param.success == 'created'}">Category created successfully!</c:when>
        <c:when test="${param.success == 'updated'}">Category updated successfully!</c:when>
        <c:when test="${param.success == 'deleted'}">Category deleted successfully!</c:when>
      </c:choose>
    </div>
  </c:if>
  
  <c:if test="${not empty param.err}">
    <div class="alert alert-danger">
      Unable to complete the action. Please try again or contact support.
    </div>
  </c:if>
  
  <p style="margin-bottom: 2rem;">
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/category?action=create">
      <i class="fas fa-plus"></i> Add New Category
    </a>
  </p>
  
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Description</th>
        <th>Actions</th>
      </tr>
    </thead>
    
    <c:choose>
      <c:when test="${not empty categories}">
        <c:forEach var="category" items="${categories}">
          <tr>
            <td><span class="badge" style="background: var(--surface); color: var(--foreground-muted); border: 1px solid var(--border-default);">${category.categoryId}</span></td>
            <td style="font-weight: 600; color: var(--foreground);">${category.categoryName}</td>
            <td style="color: var(--foreground-muted); max-width: 400px;">${category.description}</td>
            <td>
              <div style="display: flex; gap: 8px;">
                <a class="btn btn-sm btn-secondary" href="${pageContext.request.contextPath}/admin/category?action=edit&categoryId=${category.categoryId}">
                  <i class="fas fa-edit"></i> Edit
                </a>
                <a class="btn btn-sm btn-outline" href="${pageContext.request.contextPath}/admin/category?action=delete&categoryId=${category.categoryId}" style="color: #ef4444; border-color: rgba(239, 68, 68, 0.2);">
                  <i class="fas fa-trash"></i> Delete
                </a>
              </div>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="4" style="text-align:center; padding:3rem; color: var(--foreground-muted);">
            <div style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.2;">📂</div>
            <p>No categories found. Get started by creating your first service category.</p>
          </td>
        </tr>
      </c:otherwise>
    </c:choose>
  </table>
  
  <p style="margin-top:20px">
    <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>
  </p>
</div>
<jsp:include page="../includes/footer.jsp"/>
