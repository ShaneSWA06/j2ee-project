<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=unauthorised"); return; } %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Add Category"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Add Category</h1>
  <form method="post" action="${pageContext.request.contextPath}/admin/addCategoryProcess.jsp">
    <div class="card"><label>Name</label><input type="text" name="category_name" required style="width:100%"/></div>
    <div class="card"><label>Description</label><textarea name="description" rows="3" style="width:100%"></textarea></div>
    <p style="margin-top:12px"><button class="btn btn-primary" type="submit">Create</button></p>
  </form>
  <p><a class="btn" href="${pageContext.request.contextPath}/admin/adminCategoryList.jsp">Back</a></p>
</div>
<jsp:include page="../includes/footer.jsp"/>