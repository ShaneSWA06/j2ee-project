<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<%
if (session.getAttribute("sessUserId") == null) {
  response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=unauthorised");
  return;
}

int bookingId = Integer.parseInt(request.getParameter("booking_id"));
String bookingDateStr = request.getParameter("booking_date");
String bookingTimeStr = request.getParameter("booking_time");
String caregiverIdStr = request.getParameter("caregiver_id");
String status = request.getParameter("status");
String notes = request.getParameter("notes");

Integer caregiverId = null;
if (caregiverIdStr != null && !caregiverIdStr.trim().isEmpty()) {
  try {
    caregiverId = Integer.parseInt(caregiverIdStr);
  } catch (NumberFormatException e) {
    // Leave as null
  }
}

// Validate status
if (!status.equals("Pending") && !status.equals("Confirmed") &&
    !status.equals("Completed") && !status.equals("Cancelled")) {
  response.sendRedirect(request.getContextPath()+"/admin/adminBookingEdit.jsp?bookingId="+bookingId+"&err=invalidstatus");
  return;
}

try (Connection conn = DBUtil.getConnection();
     PreparedStatement ps = conn.prepareStatement(
       "UPDATE booking SET booking_date=?, booking_time=?, caregiver_id=?, status=?, notes=? WHERE booking_id=?")) {
  ps.setDate(1, Date.valueOf(bookingDateStr));
  ps.setTime(2, Time.valueOf(bookingTimeStr + ":00"));
  if (caregiverId != null) {
    ps.setInt(3, caregiverId);
  } else {
    ps.setNull(3, java.sql.Types.INTEGER);
  }
  ps.setString(4, status);
  ps.setString(5, notes);
  ps.setInt(6, bookingId);

  int rowsUpdated = ps.executeUpdate();

  if (rowsUpdated > 0) {
    response.sendRedirect(request.getContextPath()+"/admin/adminBookingList.jsp?success=updated");
  } else {
    response.sendRedirect(request.getContextPath()+"/admin/adminBookingEdit.jsp?bookingId="+bookingId+"&err=updatefailed");
  }
} catch (Exception e) {
  response.sendRedirect(request.getContextPath()+"/admin/adminBookingEdit.jsp?bookingId="+bookingId+"&err="+java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
}
%>
