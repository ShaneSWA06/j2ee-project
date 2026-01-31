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
      Error: ${param.err}
    </div>
  </c:if>
  
  <p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/category?action=create">Add New Category</a></p>
  
  <table style="width:100%; border-collapse:collapse; margin-top:20px;">
    <tr>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">ID</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Name</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Description</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Actions</th>
    </tr>
    
    <c:choose>
      <c:when test="${not empty categories}">
        <c:forEach var="category" items="${categories}">
          <tr style="border-top:1px solid #eee">
            <td style="vertical-align: middle; padding: 12px;">${category.categoryId}</td>
            <td style="vertical-align: middle; padding: 12px;">${category.categoryName}</td>
            <td style="vertical-align: middle; padding: 12px;">${category.description}</td>
            <td style="vertical-align: middle; padding: 12px; white-space: nowrap;">
              <a class="btn" href="${pageContext.request.contextPath}/admin/category?action=edit&categoryId=${category.categoryId}" style="margin-right: 8px;">Edit</a>
              <a class="btn" href="${pageContext.request.contextPath}/admin/category?action=delete&categoryId=${category.categoryId}">Delete</a>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="4" style="text-align:center; padding:20px; color:#888;">
            No categories found. Click "Add New Category" to create one.
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
