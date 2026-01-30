<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
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
    <%
      int totalCustomers = 0, totalBookings = 0, totalCaregivers = 0, totalServices = 0;
      int pendingBookings = 0, confirmedBookings = 0, completedBookings = 0;
      double avgRating = 0.0;

      try (Connection conn = DBUtil.getConnection()) {
        // Total customers
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM app_user WHERE role='CUSTOMER'");
             ResultSet rs = ps.executeQuery()) {
          if (rs.next()) totalCustomers = rs.getInt(1);
        }

        // Total bookings
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM booking");
             ResultSet rs = ps.executeQuery()) {
          if (rs.next()) totalBookings = rs.getInt(1);
        }

        // Bookings by status
        try (PreparedStatement ps = conn.prepareStatement("SELECT status, COUNT(*) FROM booking GROUP BY status")) {
          try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
              String status = rs.getString("status");
              int count = rs.getInt(2);
              if ("Pending".equals(status)) pendingBookings = count;
              else if ("Confirmed".equals(status)) confirmedBookings = count;
              else if ("Completed".equals(status)) completedBookings = count;
            }
          }
        }

        // Total caregivers
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM caregiver WHERE is_active=TRUE");
             ResultSet rs = ps.executeQuery()) {
          if (rs.next()) totalCaregivers = rs.getInt(1);
        }

        // Total services
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM service WHERE is_active=TRUE");
             ResultSet rs = ps.executeQuery()) {
          if (rs.next()) totalServices = rs.getInt(1);
        }

        // Average rating
        try (PreparedStatement ps = conn.prepareStatement("SELECT AVG(star_rating) FROM feedback");
             ResultSet rs = ps.executeQuery()) {
          if (rs.next()) avgRating = rs.getDouble(1);
        }
      } catch (Exception e) { }
    %>

    <div class="card" style="text-align: center;">
      <h2 style="color: #1f4a7c; margin: 0; font-size: 36px;"><%= totalCustomers %></h2>
      <p style="margin: 8px 0 0 0; color: #666;">Total Customers</p>
    </div>

    <div class="card" style="text-align: center;">
      <h2 style="color: #1f4a7c; margin: 0; font-size: 36px;"><%= totalBookings %></h2>
      <p style="margin: 8px 0 0 0; color: #666;">Total Bookings</p>
    </div>

    <div class="card" style="text-align: center;">
      <h2 style="color: #1f4a7c; margin: 0; font-size: 36px;"><%= totalCaregivers %></h2>
      <p style="margin: 8px 0 0 0; color: #666;">Active Caregivers</p>
    </div>

    <div class="card" style="text-align: center;">
      <h2 style="color: #1f4a7c; margin: 0; font-size: 36px;"><%= totalServices %></h2>
      <p style="margin: 8px 0 0 0; color: #666;">Active Services</p>
    </div>

    <div class="card" style="text-align: center;">
      <h2 style="color: #ff9800; margin: 0; font-size: 36px;"><%= String.format("%.1f", avgRating) %> ★</h2>
      <p style="margin: 8px 0 0 0; color: #666;">Average Rating</p>
    </div>
  </div>

  <!-- Booking Status Overview -->
  <h2 style="margin-top: 32px;">Booking Status</h2>
  <div class="grid" style="margin-top: 16px; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">
    <div class="card" style="border-left: 4px solid #ff9800;">
      <h3 style="color: #ff9800; margin: 0;"><%= pendingBookings %></h3>
      <p style="margin: 4px 0 0 0;">Pending</p>
    </div>

    <div class="card" style="border-left: 4px solid #4caf50;">
      <h3 style="color: #4caf50; margin: 0;"><%= confirmedBookings %></h3>
      <p style="margin: 4px 0 0 0;">Confirmed</p>
    </div>

    <div class="card" style="border-left: 4px solid #2196f3;">
      <h3 style="color: #2196f3; margin: 0;"><%= completedBookings %></h3>
      <p style="margin: 4px 0 0 0;">Completed</p>
    </div>
  </div>

  <!-- Upcoming Schedule -->
  <h2 style="margin-top: 32px;">Upcoming Care Schedule</h2>
  <div style="margin-top: 16px;">
    <%
      String scheduleSql = "SELECT b.booking_id, b.booking_date, b.booking_time, b.status, " +
                           "s.service_name, s.duration_minutes, " +
                           "c.name AS customer_name, c.phone AS customer_phone, " +
                           "cg.name AS caregiver_name " +
                           "FROM booking b " +
                           "JOIN service s ON b.service_id = s.service_id " +
                           "JOIN app_user c ON b.user_id = c.user_id " +
                           "LEFT JOIN caregiver cg ON b.caregiver_id = cg.caregiver_id " +
                           "WHERE b.booking_date >= CURRENT_DATE AND b.status IN ('Pending', 'Confirmed') " +
                           "ORDER BY b.booking_date, b.booking_time " +
                           "LIMIT 10";

      try (Connection conn = DBUtil.getConnection();
           PreparedStatement ps = conn.prepareStatement(scheduleSql);
           ResultSet rs = ps.executeQuery()) {

        boolean hasUpcoming = false;
        while (rs.next()) {
          hasUpcoming = true;
          String status = rs.getString("status");
          String statusColor = "Pending".equals(status) ? "#ff9800" : "#4caf50";
    %>
      <div class="card" style="margin-bottom: 12px;">
        <div style="display: flex; justify-content: space-between; align-items: start;">
          <div style="flex: 1;">
            <h3 style="margin: 0 0 8px 0;"><%= rs.getString("service_name") %></h3>
            <p style="margin: 4px 0;"><strong>Date:</strong> <%= rs.getDate("booking_date") %> at <%= rs.getTime("booking_time") %></p>
            <p style="margin: 4px 0;"><strong>Duration:</strong> <%= rs.getInt("duration_minutes") %> minutes</p>
            <p style="margin: 4px 0;"><strong>Customer:</strong> <%= rs.getString("customer_name") %>
              <% if (rs.getString("customer_phone") != null) { %>
                (<%= rs.getString("customer_phone") %>)
              <% } %>
            </p>
            <% String caregiverName = rs.getString("caregiver_name");
               if (caregiverName != null) { %>
              <p style="margin: 4px 0;"><strong>Caregiver:</strong> <%= caregiverName %></p>
            <% } else { %>
              <p style="margin: 4px 0; color: #f44336;"><strong>Caregiver:</strong> Not assigned</p>
            <% } %>
          </div>
          <span style="background: <%= statusColor %>; color: white; padding: 6px 12px; border-radius: 4px; font-weight: bold; white-space: nowrap;">
            <%= status %>
          </span>
        </div>
      </div>
    <%
        }

        if (!hasUpcoming) { %>
          <div class="card" style="text-align: center; padding: 40px; color: #666;">
            <p>No upcoming bookings scheduled.</p>
          </div>
    <%  }
      } catch (Exception e) { %>
        <div class="card" style="background: #f8d7da; border-color: #f5c6cb; color: #721c24;">
          <p><strong>Error loading schedule:</strong> <%= e.getMessage() %></p>
        </div>
    <% } %>
  </div>

  <!-- Most Popular Services -->
  <h2 style="margin-top: 32px;">Most Popular Services</h2>
  <div style="margin-top: 16px;">
    <%
      String popularSql = "SELECT s.service_name, COUNT(b.booking_id) as booking_count " +
                          "FROM service s " +
                          "LEFT JOIN booking b ON s.service_id = b.service_id " +
                          "WHERE s.is_active = TRUE " +
                          "GROUP BY s.service_id, s.service_name " +
                          "ORDER BY booking_count DESC " +
                          "LIMIT 5";

      try (Connection conn = DBUtil.getConnection();
           PreparedStatement ps = conn.prepareStatement(popularSql);
           ResultSet rs = ps.executeQuery()) {

        boolean hasServices = false;
        while (rs.next()) {
          hasServices = true;
          int bookingCount = rs.getInt("booking_count");
    %>
      <div class="card" style="margin-bottom: 8px;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <h4 style="margin: 0;"><%= rs.getString("service_name") %></h4>
          <span style="background: #1f4a7c; color: white; padding: 4px 12px; border-radius: 12px; font-weight: bold;">
            <%= bookingCount %> bookings
          </span>
        </div>
      </div>
    <%
        }

        if (!hasServices) { %>
          <div class="card" style="text-align: center; padding: 20px; color: #666;">
            <p>No service data available.</p>
          </div>
    <%  }
      } catch (Exception e) { %>
        <div class="card" style="background: #f8d7da; border-color: #f5c6cb; color: #721c24;">
          <p><strong>Error loading services:</strong> <%= e.getMessage() %></p>
        </div>
    <% } %>
  </div>
</div>
<jsp:include page="../includes/footer.jsp"/>
