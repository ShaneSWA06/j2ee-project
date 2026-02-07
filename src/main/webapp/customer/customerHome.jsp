<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=notLoggedIn"); return; } %>
<%@ page import="java.util.*" %>
<%@ page import="model.CartItem" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Customer Home"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Welcome, <%= String.valueOf(session.getAttribute("sessUserName")) %></h1>

  <%
    @SuppressWarnings("unchecked")
    ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("shoppingCart");
    int cartCount = (cart != null) ? cart.size() : 0;
    if (cartCount > 0) {
  %>
    <div class="card" style="background: #e6f2ff; border: 2px solid #1f4a7c; margin-bottom: 20px;">
      <p style="margin: 0; font-size: 16px;">
        <strong>You have <%= cartCount %> item(s) in your shopping cart!</strong>
      </p>
      <p style="margin: 8px 0 0 0;">
        <a href="${pageContext.request.contextPath}/customer/viewCart.jsp" class="btn btn-primary">View Cart & Checkout</a>
      </p>
    </div>
  <% } %>

  <p>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/public/serviceCategories.jsp">View Service Categories</a>
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/public/serviceDetails.jsp">View All Services</a>
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/public/caregivers.jsp">Meet Our Caregivers</a>
  </p>
  <p style="margin-top:12px">
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/customer/viewCart.jsp">View Shopping Cart<% if (cartCount > 0) { %> (<%= cartCount %>)<% } %></a>
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/customer/booking?action=list">My Bookings</a>
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/public/serviceDetails.jsp">Create New Booking</a>
  </p>
  <p style="margin-top:12px">
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/customer/myFeedback.jsp">My Feedback</a>
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/customer/submitFeedback.jsp">Submit Feedback</a>
  </p>
  </div>
<jsp:include page="../includes/footer.jsp"/>
