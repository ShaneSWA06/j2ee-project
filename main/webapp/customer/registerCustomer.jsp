<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String errorMsg = request.getParameter("err");
%>
<jsp:include page="../includes/header.jsp">
  <jsp:param name="title" value="Sign Up - SilverCare"/>
</jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container" style="max-width: 600px; padding: 3rem 1.5rem;">

  <div style="text-align: center; margin-bottom: 2.5rem;">
    <h1 style="color: var(--coral); margin-bottom: 0.5rem;">Create Your Account</h1>
    <p style="color: var(--text-soft);">Join SilverCare and start your care journey</p>
  </div>

  <% if (errorMsg != null) { %>
    <div class="alert alert-error">
      <% if ("missing".equals(errorMsg)) { %>
        Please fill in all required fields.
      <% } else if ("exists".equals(errorMsg)) { %>
        This username or email is already taken.
      <% } else { %>
        <%= errorMsg %>
      <% } %>
    </div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/RegisterServlet" class="form">
    <div class="form-row">
      <div class="form-group">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="johndoe" required>
      </div>
      <div class="form-group">
        <label for="name">Full Name</label>
        <input type="text" id="name" name="name" placeholder="John Doe" required>
      </div>
    </div>

    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" placeholder="john@example.com" required>
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" placeholder="Create a password" required>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label for="phone">Phone</label>
        <input type="tel" id="phone" name="phone" placeholder="+1 234 567 890">
      </div>
      <div class="form-group">
        <label for="relationship">Relationship</label>
        <select id="relationship" name="relationship">
          <option value="" selected disabled>Select</option>
          <option value="self">Self</option>
          <option value="spouse">Spouse</option>
          <option value="child">Child</option>
          <option value="parent">Parent</option>
          <option value="sibling">Sibling</option>
          <option value="friend">Friend</option>
          <option value="other">Other</option>
        </select>
      </div>
    </div>

    <div class="form-group">
      <label for="address">Address</label>
      <input type="text" id="address" name="address" placeholder="123 Main St, City">
    </div>

    <div class="form-group">
      <label for="care_notes">Care Notes (Optional)</label>
      <textarea id="care_notes" name="care_notes" placeholder="Any special requirements..." rows="3"></textarea>
    </div>

    <button type="submit" class="btn btn-primary btn-lg">Create Account</button>

    <p style="text-align: center; margin-top: 1.5rem; color: var(--text-soft);">
      Already have an account? <a href="${pageContext.request.contextPath}/customer/login.jsp">Sign in</a>
    </p>
  </form>
</div>

<jsp:include page="../includes/footer.jsp"/>
