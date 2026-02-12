<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Customer Feedback - SilverCare"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Customer Feedback</h1>
  <p>See what our customers are saying about our caregivers and services.</p>
  
  <% if (session.getAttribute("sessUserId") != null) { %>
    <p style="margin-bottom: 20px;">
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/customer/feedback?action=submit">Submit Feedback</a>
    </p>
  <% } %>

  <div class="grid" style="margin-top: 20px;">
    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
      conn = DBUtil.getConnection();
      String sql = "SELECT f.feedback_id, f.rating, f.comment, f.created_at, " +
                   "c.name AS customer_name, cg.name AS caregiver_name " +
                   "FROM feedback f " +
                   "JOIN app_user c ON f.user_id = c.user_id " +
                   "LEFT JOIN caregiver cg ON f.caregiver_id = cg.caregiver_id " +
                   "WHERE c.role IN ('CUSTOMER', 'MEMBER') " +
                   "ORDER BY f.feedback_id ASC";
      pstmt = conn.prepareStatement(sql);
      rs = pstmt.executeQuery();
      
      boolean hasResults = false;
      while (rs.next()) {
        hasResults = true;
        int rating = rs.getInt("rating");
        String comment = rs.getString("comment");
        String customerName = rs.getString("customer_name");
        String caregiverName = rs.getString("caregiver_name");
        Timestamp createdAt = rs.getTimestamp("created_at");
        
        // Generate star display
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
          if (i <= rating) {
            stars.append("★");
          } else {
            stars.append("☆");
          }
        }
    %>
        <div class="card">
          <div style="color: #f39c12; font-size: 20px; margin-bottom: 8px;">
            <%= stars.toString() %>
          </div>
          <p><strong>Customer:</strong> <%= customerName %></p>
          <% if (caregiverName != null) { %>
            <p><strong>Caregiver:</strong> <%= caregiverName %></p>
          <% } %>
          <% if (comment != null && !comment.trim().isEmpty()) { %>
            <p style="margin-top: 12px; font-style: italic;">"<%= comment %>"</p>
          <% } %>
          <p style="margin-top: 12px; color: #888; font-size: 14px;">
            <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(createdAt) %>
          </p>
        </div>
    <%
      }
      if (!hasResults) {
    %>
        <div class="card">
          <p>No feedback submitted yet. Be the first to share your experience!</p>
        </div>
    <%
      }
    } catch (Exception e) {
      out.print("<div class='card'><p style='color: red;'>Error loading feedback: " + e.getMessage() + "</p></div>");
    } finally {
      try { if (rs != null) rs.close(); } catch(Exception ignore){}
      try { if (pstmt != null) pstmt.close(); } catch(Exception ignore){}
      try { if (conn != null) conn.close(); } catch(Exception ignore){}
    }
    %>
  </div>
</div>
<jsp:include page="../includes/footer.jsp"/>
