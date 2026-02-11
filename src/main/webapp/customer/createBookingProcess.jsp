<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<%
if (session.getAttribute("sessUserId") == null) {
  response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=notLoggedIn");
  return;
}

int userId = (Integer) session.getAttribute("sessUserId");
int serviceId = Integer.parseInt(request.getParameter("service_id"));
String bookingDateStr = request.getParameter("booking_date");
String bookingTimeStr = request.getParameter("booking_time");
String caregiverIdStr = request.getParameter("caregiver_id");
String notes = request.getParameter("notes");

Integer caregiverId = null;
if (caregiverIdStr != null && !caregiverIdStr.trim().isEmpty()) {
  try {
    caregiverId = Integer.parseInt(caregiverIdStr);
  } catch (NumberFormatException e) {
    // Leave as null
  }
}

try {
  // Validate the date is not in the past
  Date bookingDate = Date.valueOf(bookingDateStr);
  Date today = new Date(System.currentTimeMillis());

  if (bookingDate.before(today)) {
    response.sendRedirect(request.getContextPath()+"/customer/createBooking.jsp?serviceId="+serviceId+"&err="+java.net.URLEncoder.encode("Booking date cannot be in the past", "UTF-8"));
    return;
  }

  // Validate service exists and is active
  try (Connection conn = DBUtil.getConnection();
       PreparedStatement checkPs = conn.prepareStatement("SELECT service_id FROM service WHERE service_id=? AND is_active=TRUE")) {
    checkPs.setInt(1, serviceId);
    try (ResultSet rs = checkPs.executeQuery()) {
      if (!rs.next()) {
        response.sendRedirect(request.getContextPath()+"/customer/createBooking.jsp?err="+java.net.URLEncoder.encode("Service is not available", "UTF-8"));
        return;
      }
    }
  }

  // Insert the booking
  try (Connection conn = DBUtil.getConnection();
       PreparedStatement ps = conn.prepareStatement(
         "INSERT INTO booking (user_id, service_id, caregiver_id, booking_date, booking_time, status, notes) VALUES (?, ?, ?, ?, ?, 'Pending', ?)")) {
    ps.setInt(1, userId);
    ps.setInt(2, serviceId);
    if (caregiverId != null) {
      ps.setInt(3, caregiverId);
    } else {
      ps.setNull(3, java.sql.Types.INTEGER);
    }
    ps.setDate(4, bookingDate);
    ps.setTime(5, Time.valueOf(bookingTimeStr + ":00"));
    ps.setString(6, notes);

    int rowsInserted = ps.executeUpdate();

    if (rowsInserted > 0) {
      response.sendRedirect(request.getContextPath()+"/customer/booking?success=created");
    } else {
      response.sendRedirect(request.getContextPath()+"/customer/createBooking.jsp?serviceId="+serviceId+"&err="+java.net.URLEncoder.encode("Failed to create booking", "UTF-8"));
    }
  }
} catch (Exception e) {
  response.sendRedirect(request.getContextPath()+"/customer/createBooking.jsp?serviceId="+request.getParameter("service_id")+"&err="+java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
}
%>
