<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=unauthorised"); return; } %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Manage Services"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Services</h1>
  <p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/addService.jsp">Add Service</a></p>
  <table style="width:100%; border-collapse:collapse">
    <tr><th>ID</th><th>Name</th><th>Category</th><th>Price</th><th>Status</th><th>Actions</th></tr>
    <%
      int rowNumber = 0;
      try (Connection conn = DBUtil.getConnection();
           PreparedStatement ps = conn.prepareStatement("SELECT s.service_id, s.service_name, s.base_price, s.is_active, c.category_name FROM service s LEFT JOIN service_category c ON s.category_id=c.category_id ORDER BY s.service_id ASC");
           ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          rowNumber++;
    %>
      <tr style="border-top:1px solid #eee">
        <td><%= rowNumber %></td>
        <td><%= rs.getString("service_name") %></td>
        <td><%= rs.getString("category_name") %></td>
        <td>$<%= rs.getBigDecimal("base_price") %></td>
        <td><%= rs.getBoolean("is_active") ? "Active" : "Inactive" %></td>
        <td>
          <a class="btn" href="${pageContext.request.contextPath}/admin/editService.jsp?serviceId=<%=rs.getInt("service_id")%>">Edit</a>
          <a class="btn" href="${pageContext.request.contextPath}/admin/deleteService.jsp?serviceId=<%=rs.getInt("service_id")%>">Delete</a>
        </td>
      </tr>
    <%
        }
      } catch (Exception e) { %>
      <tr><td colspan="6">Error: <%= e.getMessage() %></td></tr>
    <% } %>
  </table>
</div>
<jsp:include page="../includes/footer.jsp"/>