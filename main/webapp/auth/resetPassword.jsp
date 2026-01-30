<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Check if user came from forgot password page
String resetEmail = (String) session.getAttribute("resetEmail");
if (resetEmail == null) {
    response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
    return;
}
%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Reset Password"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Reset Password</h1>

  <%
    String success = request.getParameter("success");
    String error = request.getParameter("err");

    if ("code_sent".equals(success)) {
  %>
    <div style="background: #d4edda; border: 2px solid #c3e6cb; color: #155724; margin-bottom: 20px; padding: 15px; border-radius: 8px;">
      <p style="margin: 0; font-size: 16px;"><strong>✓ Verification Code Sent!</strong></p>
      <p style="margin: 8px 0 0 0;">
        A 6-digit verification code has been sent to <strong><%= resetEmail %></strong>.
      </p>
      <p style="margin: 8px 0 0 0; font-size: 14px; color: #0c5460;">
        <strong>Demo Note:</strong> Check your Eclipse Console to see the code!
      </p>
    </div>
  <% } %>

  <% if (error != null) { %>
    <div style="background: #f8d7da; border: 2px solid #f5c6cb; color: #721c24; margin-bottom: 20px; padding: 15px; border-radius: 8px;">
      <p style="margin: 0; font-size: 16px;"><strong>⚠ Error:</strong>
      <% if ("missing".equals(error)) { %>
        Please fill in all fields.
      <% } else if ("invalid_code".equals(error)) { %>
        Invalid or expired verification code. Please try again.
      <% } else if ("password_mismatch".equals(error)) { %>
        Passwords do not match. Please try again.
      <% } else { %>
        <%= error %>
      <% } %>
      </p>
    </div>
  <% } %>

  <div class="card">
    <form method="post" action="${pageContext.request.contextPath}/ResetPasswordServlet">
      <div style="margin-bottom: 16px;">
        <label><strong>Verification Code</strong></label>
        <input type="text" name="code" required
               style="width:100%; padding: 10px; margin-top: 8px; font-size: 16px;"
               placeholder="Enter 6-digit code"
               pattern="[0-9]{6}"
               maxlength="6"/>
        <small style="color: #666; display: block; margin-top: 4px;">
          Enter the 6-digit code from the console
        </small>
      </div>

      <div style="margin-bottom: 16px;">
        <label><strong>New Password</strong></label>
        <input type="password" name="newPassword" required
               style="width:100%; padding: 10px; margin-top: 8px; font-size: 16px;"
               placeholder="Enter new password"
               minlength="6"/>
      </div>

      <div style="margin-bottom: 16px;">
        <label><strong>Confirm New Password</strong></label>
        <input type="password" name="confirmPassword" required
               style="width:100%; padding: 10px; margin-top: 8px; font-size: 16px;"
               placeholder="Re-enter new password"
               minlength="6"/>
      </div>

      <div style="margin-top: 20px;">
        <button class="btn btn-primary" type="submit">Reset Password</button>
        <a href="${pageContext.request.contextPath}/auth/login.jsp"
           class="btn btn-secondary" style="margin-left: 8px;">
          Cancel
        </a>
      </div>
    </form>
  </div>

  <div style="background: #fff3cd; border: 2px solid #ffc107; color: #856404; padding: 15px; border-radius: 8px; margin-top: 20px;">
    <p style="margin: 0; font-size: 14px;">
      <strong>Tip:</strong> The verification code is displayed in your Eclipse Console window.
      Look for "PASSWORD RESET REQUEST" in the console output.
    </p>
  </div>
</div>
<jsp:include page="../includes/footer.jsp"/>
