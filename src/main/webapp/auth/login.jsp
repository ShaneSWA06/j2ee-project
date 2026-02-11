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
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Login to SilverCare"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="auth-container">
  <div class="auth-card animate-in">
    <div class="auth-glow"></div>
    <div class="auth-header">
        <div class="auth-icon-box">
            <i class="fas fa-shield-halved"></i>
        </div>
        <h1>Welcome Back</h1>
        <p class="auth-subtitle">Secure access to your SilverCare health portal.</p>
    </div>

    <% if (errorMsg != null) { %>
      <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i>
        <span>
          <% if ("missing".equals(errorMsg)) { %>
            Please enter both email/username and password.
          <% } else if ("invalid".equals(errorMsg)) { %>
            Invalid username/email or password.
          <% } else if ("not_verified".equals(errorMsg)) { %>
            Your email is not verified. Check your inbox.
          <% } else if ("notloggedin".equals(errorMsg)) { %>
            Session expired. Please login again.
          <% } else { %>
            <%= errorMsg %>
          <% } %>
        </span>
      </div>
    <% } %>

    <% if (successMsg != null) { %>
      <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        <span>
          <% if ("registered".equals(successMsg)) { %>
            Registration successful! Please login.
          <% } else if ("verify_email".equals(successMsg)) { %>
            Check your email to verify your account.
          <% } else if ("verified".equals(successMsg)) { %>
            Email verified! You can now login.
          <% } else { %>
            <%= successMsg %>
          <% } %>
        </span>
      </div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/LoginServlet" class="auth-form">
      <div class="form-group">
        <label for="username">Email or Username</label>
        <div class="input-wrapper">
            <i class="fas fa-envelope"></i>
            <input type="text" id="username" name="username" value="<%= rememberedId %>" required placeholder="name@example.com"/>
        </div>
      </div>
      
      <div class="form-group">
        <div class="label-row">
            <label for="password">Password</label>
            <a href="${pageContext.request.contextPath}/auth/forgotPassword.jsp" class="forgot-link">Forgot?</a>
        </div>
        <div class="input-wrapper">
            <i class="fas fa-lock"></i>
            <input type="password" id="password" name="password" required placeholder="••••••••"/>
        </div>
      </div>

      <button class="btn btn-primary btn-auth" type="submit">
          Sign In
          <i class="fas fa-arrow-right"></i>
      </button>
  
      <div class="auth-footer">
          <span>Don't have an account?</span>
          <a href="${pageContext.request.contextPath}/public/registerClient.jsp">Create for free</a>
      </div>
    </form>
  </div>
</div>

<style>
  .auth-container {
      min-height: calc(100vh - 120px);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
  }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .animate-in {
    opacity: 0;
    animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }

  .auth-card {
      width: 100%;
      max-width: 440px;
      padding: 3rem;
      background: rgba(10, 10, 12, 0.7);
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-default);
      border-radius: var(--radius-2xl);
      box-shadow: var(--shadow-xl);
      position: relative;
      overflow: hidden;
  }

  .auth-glow {
    position: absolute;
    top: -60px;
    right: -60px;
    width: 200px;
    height: 200px;
    background: var(--accent-glow);
    filter: blur(80px);
    border-radius: 50%;
    z-index: 0;
  }

  .auth-header {
      text-align: center;
      margin-bottom: 2.5rem;
      position: relative;
      z-index: 1;
  }

  .auth-icon-box {
      width: 64px;
      height: 64px;
      background: var(--accent);
      border-radius: var(--radius-xl);
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 1.5rem;
      box-shadow: 0 0 30px var(--accent-glow);
  }

  .auth-icon-box i {
      font-size: 1.75rem;
      color: white;
  }

  .auth-header h1 {
      font-size: 1.75rem;
      margin-bottom: 0.5rem;
  }

  .auth-subtitle {
     color: var(--foreground-muted);
     font-size: 0.95rem;
  }

  .auth-form {
      position: relative;
      z-index: 1;
  }

  .form-group {
      margin-bottom: 1.5rem;
  }

  .label-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 0.5rem;
  }

  .forgot-link {
      font-size: 0.8rem;
      font-weight: 600;
  }

  .input-wrapper {
      position: relative;
      display: flex;
      align-items: center;
  }

  .input-wrapper i {
      position: absolute;
      left: 1rem;
      color: var(--foreground-subtle);
      font-size: 0.9rem;
  }

  .input-wrapper input {
      padding-left: 2.8rem;
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid var(--border-default);
  }

  .input-wrapper input:focus {
      background: rgba(255, 255, 255, 0.05);
      border-color: var(--accent);
      box-shadow: 0 0 0 4px var(--accent-glow);
  }

  .btn-auth {
      width: 100%;
      padding: 1rem;
      font-size: 1rem;
      margin-top: 1rem;
      display: flex;
      gap: 0.75rem;
  }

  .auth-footer {
      margin-top: 2rem;
      text-align: center;
      font-size: 0.9rem;
      color: var(--foreground-muted);
      display: flex;
      gap: 0.5rem;
      justify-content: center;
  }

  .auth-footer a {
      font-weight: 600;
      color: var(--accent-bright);
  }
</style>

<jsp:include page="../includes/footer.jsp"/>
