<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=unauthorised"); return; } %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Edit Service"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Edit Service</h1>
  <%
    int sid = Integer.parseInt(request.getParameter("serviceId"));
    String name = null, desc = null; java.math.BigDecimal price = null; Integer duration = null; Boolean active = null; Integer catId = null;
    try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT service_name, description, base_price, duration_minutes, is_active, category_id FROM service WHERE service_id=?")) {
      ps.setInt(1, sid);
      try (ResultSet rs = ps.executeQuery()) { if (rs.next()) { name = rs.getString(1); desc = rs.getString(2); price = rs.getBigDecimal(3); duration = rs.getInt(4); active = rs.getBoolean(5); catId = rs.getInt(6);} }
    }
  %>
  <form method="post" action="${pageContext.request.contextPath}/admin/editServiceProcess.jsp">
    <input type="hidden" name="service_id" value="<%= sid %>"/>
    <div class="card"><label>Name</label><input type="text" name="service_name" value="<%= name %>" required style="width:100%"/></div>
    <div class="card"><label>Category</label>
      <select name="category_id" required style="width:100%">
      <%
        try (Connection conn = DBUtil.getConnection(); Statement s = conn.createStatement(); ResultSet r = s.executeQuery("SELECT category_id, category_name FROM service_category ORDER BY category_name")) {
          while (r.next()) {
      %>
        <option value="<%= r.getInt("category_id") %>" <%= r.getInt("category_id")==catId?"selected":"" %>><%= r.getString("category_name") %></option>
      <%
          }
        } catch(Exception e) {}
      %>
      </select>
    </div>
    <div class="card"><label>Description</label><textarea name="description" rows="3" style="width:100%"><%= desc %></textarea></div>
    <div class="card"><label>Base Price</label><input type="number" step="0.01" name="base_price" value="<%= price %>" required style="width:100%"/></div>
    <div class="card"><label>Duration (minutes)</label><input type="number" name="duration_minutes" value="<%= duration %>" required style="width:100%"/></div>
    <div class="card"><label>Status</label>
      <select name="is_active" style="width:100%"><option value="true" <%= active?"selected":"" %>>Active</option><option value="false" <%= !active?"selected":"" %>>Inactive</option></select>
    </div>
    <p style="margin-top:12px"><button class="btn btn-primary" type="submit">Update</button></p>
  </form>
</div>
<jsp:include page="../includes/footer.jsp"/>