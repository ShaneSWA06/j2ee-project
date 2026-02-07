<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Caregiver Bookings"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Bookings for ${caregiver.name}</h1>
  
  <p>
      <strong>Caregiver ID:</strong> ${caregiver.caregiverId}<br>
      <strong>Email:</strong> ${caregiver.email}<br>
      <strong>Phone:</strong> ${caregiver.phone}
  </p>

  <table style="width:100%; border-collapse:collapse; margin-top:20px;">
    <tr>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">ID</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Customer</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Service</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Date</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Time</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Booking Status</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Caregiver Status</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Actions</th>
    </tr>
    
    <c:choose>
      <c:when test="${not empty bookings}">
        <c:forEach var="booking" items="${bookings}">
          <tr style="border-top:1px solid #eee">
            <td style="vertical-align: middle; padding: 12px;">${booking.bookingId}</td>
            <td style="vertical-align: middle; padding: 12px;">${booking.userName}</td>
            <td style="vertical-align: middle; padding: 12px;">${booking.serviceName}</td>
            <td style="vertical-align: middle; padding: 12px;"><fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd"/></td>
            <td style="vertical-align: middle; padding: 12px;"><fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/></td>
            <td style="vertical-align: middle; padding: 12px;">
                <span class="status-badge ${booking.status.toLowerCase()}">${booking.status}</span>
            </td>
            <td style="vertical-align: middle; padding: 12px;">
                <c:choose>
                    <c:when test="${not empty booking.caregiverStatus}">
                        <span class="status-badge ${booking.caregiverStatus.toLowerCase()}">${booking.caregiverStatus}</span>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #999;">-</span>
                    </c:otherwise>
                </c:choose>
            </td>
            <td style="vertical-align: middle; padding: 12px; white-space: nowrap;">
              <a class="btn" href="${pageContext.request.contextPath}/admin/booking?action=edit&bookingId=${booking.bookingId}" style="margin-right: 8px;">Edit</a>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="8" style="text-align:center; padding:20px; color:#888;">No bookings found for this caregiver.</td>
        </tr>
      </c:otherwise>
    </c:choose>
  </table>
  
  <p style="margin-top:20px">
    <a class="btn" href="${pageContext.request.contextPath}/admin/caregiver">Back to Caregivers List</a>
  </p>
</div>

<style>
.status-badge {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 0.9em;
    font-weight: bold;
}
.status-badge.pending { background-color: #ffeeba; color: #856404; }
.status-badge.confirmed, .status-badge.accepted { background-color: #d4edda; color: #155724; }
.status-badge.completed { background-color: #cce5ff; color: #004085; }
.status-badge.cancelled, .status-badge.rejected { background-color: #f8d7da; color: #721c24; }
</style>

<jsp:include page="../includes/footer.jsp"/>