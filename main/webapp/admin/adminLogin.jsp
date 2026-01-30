<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Get error parameter
String errorMsg = request.getParameter("err");
%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Admin Login"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Admin Login</h1>

  <% if (errorMsg != null) { %>
    <div style="background: #f8d7da; border: 2px solid #f5c6cb; color: #721c24; margin-bottom: 20px; padding: 15px; border-radius: 8px;">
      <p style="margin: 0; font-size: 16px;"><strong>⚠ Error:</strong>
      <% if ("missing".equals(errorMsg)) { %>
        Please enter both username and password.
      <% } else if ("invalid".equals(errorMsg)) { %>
        Invalid username or password. Please try again.
      <% } else { %>
        <%= errorMsg %>
      <% } %>
      </p>
    </div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/LoginServlet">
    <div class="card"><label>Username</label><input type="text" name="username" required style="width:100%"/></div>
    <div class="card"><label>Password</label><input type="password" name="password" required style="width:100%"/></div>
    <p style="margin-top:12px"><button class="btn btn-primary" type="submit">Login</button></p>
  </form>
</div>
<jsp:include page="../includes/footer.jsp"/>
