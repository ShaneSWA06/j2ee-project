<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Forgot Password"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Forgot Password</h1>
  <p style="color: #666; margin-bottom: 20px;">
    Enter your email address and we'll send you a verification code to reset your password.
  </p>

  <%
    String error = request.getParameter("err");
    String success = request.getParameter("success");

    if (error != null) {
  %>
    <div style="background: #f8d7da; border: 2px solid #f5c6cb; color: #721c24; margin-bottom: 20px; padding: 15px; border-radius: 8px;">
      <p style="margin: 0; font-size: 16px;"><strong>⚠ Error:</strong>
      <% if ("missing".equals(error)) { %>
        Please enter your email address.
      <% } else if ("notfound".equals(error)) { %>
        No account found with this email address.
      <% } else { %>
        <%= error %>
      <% } %>
      </p>
    </div>
  <% } %>

  <div class="card">
    <form method="post" action="${pageContext.request.contextPath}/ForgotPasswordServlet">
      <label><strong>Email Address</strong></label>
      <input type="email" name="email" required
             style="width:100%; padding: 10px; margin-top: 8px; font-size: 16px;"
             placeholder="Enter your registered email"/>

      <div style="margin-top: 20px;">
        <button class="btn btn-primary" type="submit">Send Verification Code</button>
        <a href="${pageContext.request.contextPath}/auth/login.jsp"
           class="btn btn-secondary" style="margin-left: 8px;">
          Back to Login
        </a>
      </div>
    </form>
  </div>

</div>
<jsp:include page="../includes/footer.jsp"/>
