<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=unauthorised"); return; } %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Edit Category"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Edit Category</h1>
  <%
    int cid = Integer.parseInt(request.getParameter("categoryId"));
    String name = null, desc = null;
    try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement("SELECT category_name, description FROM service_category WHERE category_id=?")) {
      ps.setInt(1, cid);
      try (ResultSet rs = ps.executeQuery()) { if (rs.next()) { name = rs.getString(1); desc = rs.getString(2);} }
    }
  %>
  <form method="post" action="${pageContext.request.contextPath}/admin/editCategoryProcess.jsp">
    <input type="hidden" name="category_id" value="<%= cid %>"/>
    <div class="card"><label>Name</label><input type="text" name="category_name" value="<%= name %>" required style="width:100%"/></div>
    <div class="card"><label>Description</label><textarea name="description" rows="3" style="width:100%"><%= desc %></textarea></div>
    <p style="margin-top:12px"><button class="btn btn-primary" type="submit">Update</button></p>
  </form>
  <p><a class="btn" href="${pageContext.request.contextPath}/admin/adminCategoryList.jsp">Back</a></p>
</div>
<jsp:include page="../includes/footer.jsp"/>