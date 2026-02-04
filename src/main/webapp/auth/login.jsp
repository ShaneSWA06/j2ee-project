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
<div class="form-container">
  <h1>Login</h1>
  <p class="form-subtitle">Welcome back! Please login to your account.</p>

  <% if (errorMsg != null) { %>
    <div class="alert alert-error">
      <strong>⚠ Error:</strong>
      <% if ("missing".equals(errorMsg)) { %>
        Please enter both email/username and password.
      <% } else if ("invalid".equals(errorMsg)) { %>
        Invalid username/email or password. Please try again.
      <% } else if ("not_verified".equals(errorMsg)) { %>
        Your email address is not verified. Please check your inbox for the verification link.
      <% } else if ("notloggedin".equals(errorMsg)) { %>
        You must be logged in to access that page.
      <% } else { %>
        <%= errorMsg %>
      <% } %>
    </div>
  <% } %>

  <% if (successMsg != null) { %>
    <div class="alert alert-success">
      <strong>✓ Success:</strong>
      <% if ("registered".equals(successMsg)) { %>
        Registration successful! Please login with your credentials.
      <% } else if ("verify_email".equals(successMsg)) { %>
        Registration successful! Please check your email to verify your account.
      <% } else if ("verified".equals(successMsg)) { %>
        Email verified successfully! You can now login.
      <% } else if ("password_reset_success".equals(successMsg)) { %>
        Password reset successful! You can now login with your new password.
      <% } else { %>
        <%= successMsg %>
      <% } %>
    </div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/LoginServlet" class="form">
    <div class="form-group">
      <label for="username">Email or Username</label>
      <input type="text" id="username" name="username" value="<%= rememberedId %>" required placeholder="Enter your email or username"/>
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required placeholder="Enter your password"/>
    </div>

    <button class="btn btn-primary" type="submit">Login</button>
 
    <div class="form-footer">
      <p>
        <a href="${pageContext.request.contextPath}/auth/forgotPassword.jsp">Forgot Password?</a>
      </p>
      <p style="margin-top: 0.5rem;">
        Don't have an account? <a href="${pageContext.request.contextPath}/public/registerClient.jsp">Sign up</a>
      </p>
    </div>
  </form>
</div>
<jsp:include page="../includes/footer.jsp"/>
