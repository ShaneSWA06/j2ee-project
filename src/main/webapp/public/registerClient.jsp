<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<jsp:include page="../includes/header.jsp"
  ><jsp:param name="title" value="Register"
/></jsp:include>
<jsp:include page="../includes/navbar.jsp" />
<div class="form-container">
  <h1>Create Your Account</h1>
  <p class="form-subtitle">Sign up to get started.</p>
  
  <% String error = (String) session.getAttribute("error"); String success =
  (String) session.getAttribute("success"); if (error != null) { %>
  <div class="alert alert-error"><%= error %></div>
  <% session.removeAttribute("error"); } if (success != null) { %>
  <div class="alert alert-success"><%= success %></div>
  <% session.removeAttribute("success"); } %>
  
  <form
    method="post"
    action="${pageContext.request.contextPath}/RegisterServlet"
    class="form"
  >
    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" placeholder="Choose a username" required />
    </div>
    
    <div class="form-group">
      <label for="name">Full Name</label>
      <input type="text" id="name" name="name" placeholder="Enter your full name" required />
    </div>
    
    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" placeholder="Your email address" required />
    </div>
    
    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" placeholder="Create a password" required />
    </div>
    
    <div class="form-group">
      <label for="phone">Phone</label>
      <input type="tel" id="phone" name="phone" placeholder="+1 (   ) -  __ ____" required />
    </div>
    
    <div class="form-group">
      <label for="relationship">Relationship</label>
      <select id="relationship" name="relationship" required>
        <option value="" selected disabled>Select your relationship</option>
        <option value="self">Self</option>
        <option value="spouse">Spouse</option>
        <option value="child">Child</option>
        <option value="parent">Parent</option>
        <option value="sibling">Sibling</option>
        <option value="friend">Friend</option>
        <option value="other">Other</option>
      </select>
    </div>
    
    <div class="form-group">
      <label for="address">Address</label>
      <input type="text" id="address" name="address" placeholder="Your full address" required />
    </div>
    
    <div class="form-group">
      <label for="careNotes">Care Notes</label>
      <textarea id="careNotes" name="care_notes" placeholder="Additional care notes"></textarea>
    </div>
    
    <button type="submit" class="btn btn-primary">Sign Up</button>
    
    <p class="form-footer">
      Already have an account?
      <a href="${pageContext.request.contextPath}/auth/login.jsp">Log In</a>
    </p>
  </form>
</div>
<jsp:include page="../includes/footer.jsp" />
