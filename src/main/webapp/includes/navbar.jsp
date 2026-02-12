<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.CartItem" %>
<nav class="navbar">
  <div class="nav-container">
    <div class="nav-left">
      <a href="${pageContext.request.contextPath}/index.jsp" class="nav-logo">SILVER CAREGIVERS</a>
    </div>
    <div class="nav-center">
      <ul class="nav-menu">
        <li><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <% 
          String userRole = (String) session.getAttribute("sessUserRole");
          // Only show Service Categories for customers (MEMBER) or non-logged-in users
          if (!"ADMIN".equals(userRole) && !"CAREGIVER".equals(userRole)) { 
        %>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/public/serviceCategories.jsp">Service Categories</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/customer/viewFeedback.jsp">Feedback</a></li>
        <% } %>
      </ul>
    </div>
    <div class="nav-right">
      <ul class="nav-menu">
        <% 
          if ("ADMIN".equals(userRole)) { 
        %>
          <!-- Admin Navigation -->
          <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin Panel</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/feedback">Feedback</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/settings">Settings</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
        <% } else if ("CAREGIVER".equals(userRole)) { %>
          <!-- Caregiver Navigation -->
          <li><a class="nav-link" href="${pageContext.request.contextPath}/mvc/caregiver/dashboard">Caregiver Portal</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/caregiver/feedback">My Feedback</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/settings">Settings</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
        <% } else if ("COMPANY_ADMIN".equals(userRole)) { %>
          <!-- Agency Navigation -->
          <li><a class="nav-link" href="${pageContext.request.contextPath}/company/dashboard">Agency Panel</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/settings">Settings</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
        <% } else if (session.getAttribute("sessUserId") != null) {
             // Customer/Member Navigation
             @SuppressWarnings("unchecked")
             ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("shoppingCart");
             int cartCount = (cart != null) ? cart.size() : 0;
        %>
          <li>
            <a class="nav-link nav-link--with-badge" href="${pageContext.request.contextPath}/customer/viewCart.jsp">
              Cart
              <% if (cartCount > 0) { %>
                <span class="nav-badge">
                  <%= cartCount %>
                </span>
              <% } %>
            </a>
          </li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/customer/customerHome.jsp">Account</a></li>
          <li><a class="nav-link" href="${pageContext.request.contextPath}/settings">Settings</a></li>
          <li>
            <a class="nav-link" href="${pageContext.request.contextPath}/logout"
               <% if (cartCount > 0) { %>
                 onclick="return confirmLogout(<%= cartCount %>);"
               <% } %>
            >Logout</a>
          </li>

          <% if (cartCount > 0) { %>
          <script>
          function confirmLogout(itemCount) {
            return confirm(
              'Warning: You have ' + itemCount + ' item(s) in your shopping cart!\n\n' +
              'If you logout now, your cart will be lost.\n\n' +
              'Do you want to:\n' +
              '- Click "Cancel" to stay logged in and checkout\n' +
              '- Click "OK" to logout and lose your cart items'
            );
          }
          </script>
          <% } %>

        <% } else { %>
          <li><a class="nav-btn nav-btn-signin" href="${pageContext.request.contextPath}/auth/login.jsp">Sign In</a></li>
          <li><a class="nav-btn nav-btn-signup" href="${pageContext.request.contextPath}/public/registerClient.jsp">Sign Up</a></li>
        <% } %>
      </ul>
    </div>
  </div>
  </nav>
