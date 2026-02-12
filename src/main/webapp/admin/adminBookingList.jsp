<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Appointments"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Appointments</h1>
  
  <!-- Filters removed per user request -->
  
  <c:if test="${not empty param.success}">
    <div class="alert alert-success">
      <c:choose>
        <c:when test="${param.success == 'updated'}">Appointment updated successfully!</c:when>
        <c:when test="${param.success == 'deleted'}">Appointment removed successfully!</c:when>
      </c:choose>
    </div>
  </c:if>
  
  <c:if test="${not empty param.err}">
    <div class="alert alert-danger">Unable to complete the action. Please try again.</div>
  </c:if>
  
  <table>
    <thead>
      <tr>
        <th>Booking #</th>
        <th>Customer</th>
        <th>Service</th>
        <th>Caregiver</th>
        <th>Date</th>
        <th>Status</th>
        <th>Actions</th>
      </tr>
    </thead>
    
    <c:choose>
      <c:when test="${not empty bookings}">
        <c:forEach var="booking" items="${bookings}">
          <tr>
            <td><span class="badge" style="background: var(--surface); color: var(--foreground-muted); border: 1px solid var(--border-default);">${booking.bookingId}</span></td>
            <td style="font-weight: 500;">${booking.userName}</td>
            <td><span class="badge" style="background: var(--accent-glow); color: var(--accent-bright); border: 1px solid var(--border-accent);">${booking.serviceName}</span></td>
            <td>
              <c:choose>
                <c:when test="${not empty booking.caregiverName}">
                  <div style="display: flex; align-items: center; gap: 8px;">
                    <i class="fas fa-user-md" style="color: var(--accent-bright);"></i>
                    <span>${booking.caregiverName}</span>
                  </div>
                </c:when>
                <c:otherwise>
                  <span style="color: var(--foreground-muted); font-style: italic;">Pending Assignment</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <div style="font-weight: 600;">
                <fmt:formatDate value="${booking.bookingDate}" pattern="MMM dd, yyyy" timeZone="GMT+8"/>
              </div>
            </td>
            <td>
              <c:choose>
                <c:when test="${booking.status == 'Confirmed'}">
                  <span class="badge" style="background: rgba(34, 197, 94, 0.1); color: #22c55e; border: 1px solid rgba(34, 197, 94, 0.2);">Confirmed</span>
                </c:when>
                <c:when test="${booking.status == 'Completed'}">
                  <span class="badge" style="background: var(--surface); color: var(--foreground-muted); border: 1px solid var(--border-default);">Completed</span>
                </c:when>
                <c:when test="${booking.status == 'Cancelled'}">
                  <span class="badge" style="background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.2);">Cancelled</span>
                </c:when>
                <c:otherwise>
                  <span class="badge" style="background: rgba(234, 179, 8, 0.1); color: #eab308; border: 1px solid rgba(234, 179, 8, 0.2);">${booking.status}</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <div style="display: flex; gap: 8px;">
                <a class="btn btn-sm btn-secondary" href="${pageContext.request.contextPath}/admin/booking?action=edit&bookingId=${booking.bookingId}">
                  <i class="fas fa-edit"></i> Edit
                </a>
                <a class="btn btn-sm btn-outline" href="${pageContext.request.contextPath}/admin/booking?action=delete&bookingId=${booking.bookingId}" style="color: #ef4444; border-color: rgba(239, 68, 68, 0.2);">
                  <i class="fas fa-trash"></i> Delete
                </a>
              </div>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="7" style="text-align:center; padding:3rem; color: var(--foreground-muted);">
            <div style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.2;">📅</div>
            <p>No appointments found.</p>
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
