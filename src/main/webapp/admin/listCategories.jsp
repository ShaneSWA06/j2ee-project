<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=unauthorised"); return; } %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Manage Categories"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Service Categories</h1>
  <p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/adminCategoryCreate.jsp">Add Category</a></p>
  <table style="width:100%; border-collapse:collapse">
    <tr><th>ID</th><th>Name</th><th>Description</th><th>Actions</th></tr>
    <%
      try (Connection conn = DBUtil.getConnection();
           PreparedStatement ps = conn.prepareStatement("SELECT category_id, category_name, description FROM service_category ORDER BY category_id DESC");
           ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
    %>
      <tr style="border-top:1px solid #eee">
        <td><%= rs.getInt("category_id") %></td>
        <td><%= rs.getString("category_name") %></td>
        <td><%= rs.getString("description") %></td>
        <td>
          <a class="btn" href="${pageContext.request.contextPath}/admin/adminCategoryEdit.jsp?categoryId=<%=rs.getInt("category_id")%>">Edit</a>
          <a class="btn" href="${pageContext.request.contextPath}/admin/deleteCategory.jsp?categoryId=<%=rs.getInt("category_id")%>">Delete</a>
        </td>
      </tr>
    <%
        }
      } catch (Exception e) { %>
      <tr><td colspan="4">Error: <%= e.getMessage() %></td></tr>
    <% } %>
  </table>
  <p style="margin-top:12px"><a class="btn" href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">Back to Dashboard</a></p>
  </div>
<jsp:include page="../includes/footer.jsp"/>