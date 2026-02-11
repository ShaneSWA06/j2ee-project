<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Manage Bookings"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Bookings</h1>
  
  <div style="margin-bottom: 20px;">
    <a href="${pageContext.request.contextPath}/admin/booking" class="btn ${viewType == 'all' || empty viewType ? 'btn-primary' : 'btn-secondary'}" style="margin-right: 10px;">All Bookings</a>
    <a href="${pageContext.request.contextPath}/admin/booking?view=unassigned" class="btn ${viewType == 'unassigned' ? 'btn-primary' : 'btn-secondary'}">Unassigned Bookings</a>
  </div>

  <c:if test="${not empty param.success}">
    <div class="alert alert-success">
      <c:choose>
        <c:when test="${param.success == 'updated'}">Booking updated successfully!</c:when>
        <c:when test="${param.success == 'deleted'}">Booking deleted successfully!</c:when>
      </c:choose>
    </div>
  </c:if>
  
  <c:if test="${not empty param.err}">
    <div class="alert alert-danger">Error: ${param.err}</div>
  </c:if>
  
  <table style="width:100%; border-collapse:collapse; margin-top:20px;">
    <tr>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">ID</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Customer</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Service</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Caregiver</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Date</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Time</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Status</th>
      <th style="text-align: left; padding: 12px; background: var(--background-alt);">Actions</th>
    </tr>
    
    <c:choose>
      <c:when test="${not empty bookings}">
        <c:forEach var="booking" items="${bookings}">
          <tr style="border-top:1px solid #eee">
            <td style="vertical-align: middle; padding: 12px;">${booking.bookingId}</td>
            <td style="vertical-align: middle; padding: 12px;">${booking.userName}</td>
            <td style="vertical-align: middle; padding: 12px;">${booking.serviceName}</td>
            <td style="vertical-align: middle; padding: 12px;">${not empty booking.caregiverName ? booking.caregiverName : 'Not assigned'}</td>
            <td style="vertical-align: middle; padding: 12px;"><fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd" timeZone="GMT+8"/></td>
            <td style="vertical-align: middle; padding: 12px;"><fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm" timeZone="GMT+8"/></td>
            <td style="vertical-align: middle; padding: 12px;">${booking.status}</td>
            <td style="vertical-align: middle; padding: 12px; white-space: nowrap;">
              <a class="btn" href="${pageContext.request.contextPath}/admin/booking?action=edit&bookingId=${booking.bookingId}" style="margin-right: 8px;">Edit</a>
              <a class="btn" href="${pageContext.request.contextPath}/admin/booking?action=delete&bookingId=${booking.bookingId}">Delete</a>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="8" style="text-align:center; padding:20px; color:#888;">No bookings found.</td>
        </tr>
      </c:otherwise>
    </c:choose>
  </table>
  
  <p style="margin-top:20px">
    <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>
  </p>
</div>
<jsp:include page="../includes/footer.jsp"/>
