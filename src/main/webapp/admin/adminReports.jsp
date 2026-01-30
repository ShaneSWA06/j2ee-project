<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=unauthorised"); return; } %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Reports & Analytics"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Reports & Analytics</h1>

  <div style="margin-bottom: 20px;">
    <a href="<%= request.getContextPath() %>/admin/adminDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
  </div>

  <!-- Summary Statistics -->
  <h2>Summary Statistics</h2>
  <div class="grid" style="margin-top: 16px; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">

    <div class="card" style="text-align: center;">
      <h2 style="color: #1f4a7c; margin: 0; font-size: 36px;">${totalCustomers}</h2>
      <p style="margin: 8px 0 0 0; color: #666;">Total Customers</p>
    </div>

    <div class="card" style="text-align: center;">
      <h2 style="color: #1f4a7c; margin: 0; font-size: 36px;">${totalBookings}</h2>
      <p style="margin: 8px 0 0 0; color: #666;">Total Bookings</p>
    </div>

    <div class="card" style="text-align: center;">
      <h2 style="color: #1f4a7c; margin: 0; font-size: 36px;">${totalCaregivers}</h2>
      <p style="margin: 8px 0 0 0; color: #666;">Active Caregivers</p>
    </div>

    <div class="card" style="text-align: center;">
      <h2 style="color: #1f4a7c; margin: 0; font-size: 36px;">${totalServices}</h2>
      <p style="margin: 8px 0 0 0; color: #666;">Active Services</p>
    </div>

    <div class="card" style="text-align: center;">
      <h2 style="color: #ff9800; margin: 0; font-size: 36px;"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/> ★</h2>
      <p style="margin: 8px 0 0 0; color: #666;">Average Rating</p>
    </div>
  </div>

  <!-- Booking Status Overview -->
  <h2 style="margin-top: 32px;">Booking Status</h2>
  <div class="grid" style="margin-top: 16px; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">
    <div class="card" style="border-left: 4px solid #ff9800;">
      <h3 style="color: #ff9800; margin: 0;">${pendingBookings}</h3>
      <p style="margin: 4px 0 0 0;">Pending</p>
    </div>

    <div class="card" style="border-left: 4px solid #4caf50;">
      <h3 style="color: #4caf50; margin: 0;">${confirmedBookings}</h3>
      <p style="margin: 4px 0 0 0;">Confirmed</p>
    </div>

    <div class="card" style="border-left: 4px solid #2196f3;">
      <h3 style="color: #2196f3; margin: 0;">${completedBookings}</h3>
      <p style="margin: 4px 0 0 0;">Completed</p>
    </div>
  </div>

  <!-- Upcoming Schedule -->
  <h2 style="margin-top: 32px;">Upcoming Care Schedule</h2>
  <div style="margin-top: 16px;">
    <c:forEach var="item" items="${upcomingSchedule}">
      <div class="card" style="margin-bottom: 12px;">
        <div style="display: flex; justify-content: space-between; align-items: start;">
          <div style="flex: 1;">
            <h3 style="margin: 0 0 8px 0;">${item.service_name}</h3>
            <p style="margin: 4px 0;"><strong>Date:</strong> ${item.booking_date} at ${item.booking_time}</p>
            <p style="margin: 4px 0;"><strong>Duration:</strong> ${item.duration_minutes} minutes</p>
            <p style="margin: 4px 0;"><strong>Customer:</strong> ${item.customer_name}
              <c:if test="${not empty item.customer_phone}">
                (${item.customer_phone})
              </c:if>
            </p>
            <c:if test="${not empty item.caregiver_name}">
              <p style="margin: 4px 0;"><strong>Caregiver:</strong> ${item.caregiver_name}</p>
            </c:if>
            <c:if test="${empty item.caregiver_name}">
              <p style="margin: 4px 0; color: #f44336;"><strong>Caregiver:</strong> Not assigned</p>
            </c:if>
          </div>
          <span style="background: ${item.status == 'Pending' ? '#ff9800' : '#4caf50'}; color: white; padding: 6px 12px; border-radius: 4px; font-weight: bold; white-space: nowrap;">
            ${item.status}
          </span>
        </div>
      </div>
    </c:forEach>
    
    <c:if test="${empty upcomingSchedule}">
      <div class="card" style="text-align: center; padding: 40px; color: #666;">
        <p>No upcoming bookings scheduled.</p>
      </div>
    </c:if>
  </div>

  <!-- Most Popular Services -->
  <h2 style="margin-top: 32px;">Most Popular Services</h2>
  <div style="margin-top: 16px;">
    <c:forEach var="service" items="${popularServices}">
      <div class="card" style="margin-bottom: 8px;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <h4 style="margin: 0;">${service.service_name}</h4>
          <span style="background: #1f4a7c; color: white; padding: 4px 12px; border-radius: 12px; font-weight: bold;">
            ${service.booking_count} bookings
          </span>
        </div>
      </div>
    </c:forEach>

    <c:if test="${empty popularServices}">
      <div class="card" style="text-align: center; padding: 20px; color: #666;">
        <p>No service data available.</p>
      </div>
    </c:if>
  </div>
</div>
<jsp:include page="../includes/footer.jsp"/>
