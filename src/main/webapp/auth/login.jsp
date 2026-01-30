<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Get error and message parameters
String errorMsg = request.getParameter("err");
String successMsg = request.getParameter("msg");

// Get remembered identifier from cookie
String rememberedId = "";
jakarta.servlet.http.Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (jakarta.servlet.http.Cookie cookie : cookies) {
        if ("remember_id".equals(cookie.getName())) {
            rememberedId = cookie.getValue();
            break;
        }
    }
}
%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Login"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Login</h1>

  <% if (errorMsg != null) { %>
    <div style="background: #f8d7da; border: 2px solid #f5c6cb; color: #721c24; margin-bottom: 20px; padding: 15px; border-radius: 8px;">
      <p style="margin: 0; font-size: 16px;"><strong>⚠ Error:</strong>
      <% if ("missing".equals(errorMsg)) { %>
        Please enter both email/username and password.
      <% } else if ("invalid".equals(errorMsg)) { %>
        Invalid username/email or password. Please try again.
      <% } else if ("notloggedin".equals(errorMsg)) { %>
        You must be logged in to access that page.
      <% } else { %>
        <%= errorMsg %>
      <% } %>
      </p>
    </div>
  <% } %>

  <% if (successMsg != null) { %>
    <div style="background: #d4edda; border: 2px solid #c3e6cb; color: #155724; margin-bottom: 20px; padding: 15px; border-radius: 8px;">
      <p style="margin: 0; font-size: 16px;"><strong>✓ Success:</strong>
      <% if ("registered".equals(successMsg)) { %>
        Registration successful! Please login with your credentials.
      <% } else if ("password_reset_success".equals(successMsg)) { %>
        Password reset successful! You can now login with your new password.
      <% } else { %>
        <%= successMsg %>
      <% } %>
      </p>
    </div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/LoginServlet">
    <div class="grid">
      <div class="card">
        <label>Email or Username</label>
        <input type="text" name="username" value="<%= rememberedId %>" required style="width:100%"/>
      </div>
      <div class="card">
        <label>Password</label>
        <input type="password" name="password" required style="width:100%"/>
      </div>
    </div>
    <p style="margin-top:12px">
      <button class="btn btn-primary" type="submit">Login</button>
    </p>
  </form>

  <p style="text-align: center; margin-top: 16px;">
    <a href="${pageContext.request.contextPath}/auth/forgotPassword.jsp" style="color: #1f4a7c; text-decoration: underline;">
      Forgot Password?
    </a>
  </p>
</div>
<jsp:include page="../includes/footer.jsp"/>
