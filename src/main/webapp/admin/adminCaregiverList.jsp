<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Manage Caregivers"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Caregivers</h1>
  
  <c:if test="${not empty param.success}">
    <div class="alert alert-success">
      <c:choose>
        <c:when test="${param.success == 'created'}">Caregiver created successfully!</c:when>
        <c:when test="${param.success == 'updated'}">Caregiver updated successfully!</c:when>
        <c:when test="${param.success == 'deleted'}">Caregiver deleted successfully!</c:when>
      </c:choose>
    </div>
  </c:if>
  
  <c:if test="${not empty param.err}">
    <div class="alert alert-danger">Error: ${param.err}</div>
  </c:if>
  
  <p><a href="${pageContext.request.contextPath}/admin/caregiver?action=create" class="btn btn-primary">Add New Caregiver</a></p>
  
  <table style="width:100%; border-collapse:collapse; margin-top:20px;">
    <tr>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">ID</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Name</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Specialization</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Phone</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Email</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Available</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Actions</th>
    </tr>
    
    <c:choose>
      <c:when test="${not empty caregivers}">
        <c:forEach var="caregiver" items="${caregivers}">
          <tr style="border-top:1px solid #eee">
            <td style="vertical-align: middle; padding: 12px;">${caregiver.caregiverId}</td>
            <td style="vertical-align: middle; padding: 12px;">${caregiver.name}</td>
            <td style="vertical-align: middle; padding: 12px;">${caregiver.specialization}</td>
            <td style="vertical-align: middle; padding: 12px;">${caregiver.phone}</td>
            <td style="vertical-align: middle; padding: 12px;">${caregiver.email}</td>
            <td style="vertical-align: middle; padding: 12px;">${caregiver.available ? '✓ Yes' : '✗ No'}</td>
            <td style="vertical-align: middle; padding: 12px; white-space: nowrap;">
              <a class="btn" href="${pageContext.request.contextPath}/admin/caregiver?action=bookings&caregiverId=${caregiver.caregiverId}" style="margin-right: 8px;">View Bookings</a>
              <a class="btn" href="${pageContext.request.contextPath}/admin/caregiver?action=edit&caregiverId=${caregiver.caregiverId}" style="margin-right: 8px;">Edit</a>
              <a class="btn" href="${pageContext.request.contextPath}/admin/caregiver?action=delete&caregiverId=${caregiver.caregiverId}">Delete</a>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="7" style="text-align:center; padding:20px; color:#888;">No caregivers found.</td>
        </tr>
      </c:otherwise>
    </c:choose>
  </table>
  
  <p style="margin-top:20px">
    <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>
  </p>
</div>
<jsp:include page="../includes/footer.jsp"/>
