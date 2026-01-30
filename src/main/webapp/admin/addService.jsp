<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=unauthorised"); return; } %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Add Service"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Add Service</h1>
  <form method="post" action="${pageContext.request.contextPath}/admin/addServiceProcess.jsp">
    <div class="card"><label>Name</label><input type="text" name="service_name" required style="width:100%"/></div>
    <div class="card"><label>Category</label>
      <select name="category_id" required style="width:100%">
      <%
        try (Connection conn = DBUtil.getConnection(); Statement s = conn.createStatement(); ResultSet r = s.executeQuery("SELECT category_id, category_name FROM service_category ORDER BY category_name")) {
          while (r.next()) {
      %>
        <option value="<%= r.getInt("category_id") %>"><%= r.getString("category_name") %></option>
      <%
          }
        } catch(Exception e) {}
      %>
      </select>
    </div>
    <div class="card"><label>Description</label><textarea name="description" rows="3" style="width:100%"></textarea></div>
    <div class="card"><label>Base Price</label><input type="number" step="0.01" name="base_price" required style="width:100%"/></div>
    <div class="card"><label>Duration (minutes)</label><input type="number" name="duration_minutes" required style="width:100%"/></div>
    <div class="card"><label>Status</label>
      <select name="is_active" style="width:100%"><option value="true">Active</option><option value="false">Inactive</option></select>
    </div>
    <p style="margin-top:12px"><button class="btn btn-primary" type="submit">Create</button></p>
  </form>
</div>
<jsp:include page="../includes/footer.jsp"/>