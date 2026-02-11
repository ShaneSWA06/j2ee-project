<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Manage Services"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Services</h1>
  
  <c:if test="${not empty param.success}">
    <div class="alert alert-success">
      <c:choose>
        <c:when test="${param.success == 'created'}">Service created successfully!</c:when>
        <c:when test="${param.success == 'updated'}">Service updated successfully!</c:when>
        <c:when test="${param.success == 'deleted'}">Service deleted successfully!</c:when>
      </c:choose>
    </div>
  </c:if>
  
  <c:if test="${not empty param.err}">
    <div class="alert alert-danger">Error: ${param.err}</div>
  </c:if>
  
  <p><a href="${pageContext.request.contextPath}/admin/service?action=create" class="btn btn-primary">Add New Service</a></p>
  
  <table style="width:100%; border-collapse:collapse; margin-top:20px;">
    <tr>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">ID</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Name</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Category</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Price</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Duration</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Active</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Actions</th>
    </tr>
    
    <c:choose>
      <c:when test="${not empty services}">
        <c:forEach var="service" items="${services}">
          <tr style="border-top:1px solid #eee">
            <td style="vertical-align: middle; padding: 12px;">${service.serviceId}</td>
            <td style="vertical-align: middle; padding: 12px;">${service.serviceName}</td>
            <td style="vertical-align: middle; padding: 12px;">${service.categoryName}</td>
            <td style="vertical-align: middle; padding: 12px;"><fmt:formatNumber value="${service.basePrice}" pattern="$#,##0.00"/></td>
            <td style="vertical-align: middle; padding: 12px;">${service.durationMinutes} min</td>
            <td style="vertical-align: middle; padding: 12px;">
              <c:choose>
                <c:when test="${service.active}">✓ Active</c:when>
                <c:otherwise>✗ Inactive</c:otherwise>
              </c:choose>
            </td>
            <td style="vertical-align: middle; padding: 12px; white-space: nowrap;">
              <a class="btn" href="${pageContext.request.contextPath}/admin/service?action=edit&serviceId=${service.serviceId}" style="margin-right: 8px;">Edit</a>
              <a class="btn" href="${pageContext.request.contextPath}/admin/service?action=delete&serviceId=${service.serviceId}">Delete</a>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="7" style="text-align:center; padding:20px; color:#888;">
            No services found. Click "Add New Service" to create one.
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
