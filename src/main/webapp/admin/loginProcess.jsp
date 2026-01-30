<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");
if (username==null || password==null || username.trim().isEmpty() || password.trim().isEmpty()) {
  response.sendRedirect(request.getContextPath()+"/admin/adminLogin.jsp?err=missing");
  return;
}
try (Connection conn = DBUtil.getConnection();
     PreparedStatement ps = conn.prepareStatement("SELECT user_id, role, name FROM app_user WHERE username=? AND password=? AND role='ADMIN'")) {
  ps.setString(1, username);
  ps.setString(2, password);
  try (ResultSet rs = ps.executeQuery()) {
    if (rs.next()) {
      session.setAttribute("sessUserId", rs.getInt("user_id"));
      session.setAttribute("sessUserRole", rs.getString("role"));
      session.setAttribute("sessUserName", rs.getString("name"));
      response.sendRedirect(request.getContextPath()+"/admin/adminDashboard.jsp");
    } else {
      response.sendRedirect(request.getContextPath()+"/admin/adminLogin.jsp?err=invalid");
    }
  }
} catch (Exception e) {
  response.sendRedirect(request.getContextPath()+"/admin/adminLogin.jsp?err="+java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
}
%>