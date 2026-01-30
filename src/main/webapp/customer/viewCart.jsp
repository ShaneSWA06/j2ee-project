<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=notLoggedIn"); return; } %>
<%@ page import="java.util.*" %>
<%@ page import="model.CartItem" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Shopping Cart"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Shopping Cart</h1>

  <%
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    if ("added".equals(success)) { %>
      <div class="card" style="background: #d4edda; border-color: #c3e6cb; color: #155724; margin-bottom: 16px;">
        <p style="margin: 0;"><strong>✓ Service added to cart!</strong></p>
      </div>
  <% } else if ("removed".equals(success)) { %>
      <div class="card" style="background: #d4edda; border-color: #c3e6cb; color: #155724; margin-bottom: 16px;">
        <p style="margin: 0;"><strong>✓ Item removed from cart</strong></p>
      </div>
  <% } else if (error != null) { %>
      <div class="card" style="background: #f8d7da; border-color: #f5c6cb; color: #721c24; margin-bottom: 16px;">
        <p style="margin: 0;"><strong>⚠ Error:</strong> <%= error %></p>
      </div>
  <% } %>

  <%
    @SuppressWarnings("unchecked")
    ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("shoppingCart");

    if (cart == null || cart.isEmpty()) {
  %>
    <div class="card" style="text-align: center; padding: 40px;">
      <h2>Your cart is empty</h2>
      <p style="color: #666; margin: 16px 0;">Add some services to your cart to get started!</p>
      <p style="margin-top: 24px;">
        <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp" class="btn btn-primary">Browse Services</a>
        <a href="<%= request.getContextPath() %>/customer/customerHome.jsp" class="btn btn-secondary">Back to Home</a>
      </p>
    </div>
  <%
    } else {
      double totalPrice = 0;
      for (CartItem item : cart) {
        totalPrice += item.getBasePrice();
      }
  %>
    <div style="margin-bottom: 16px;">
      <p style="font-size: 18px; color: #666;">
        You have <strong><%= cart.size() %></strong> item(s) in your cart
      </p>
    </div>

    <div class="grid" style="margin-bottom: 20px;">
      <%
        for (CartItem item : cart) {
      %>
        <div class="card">
          <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 12px;">
            <h3 style="margin: 0; flex: 1;"><%= item.getServiceName() %></h3>
            <span style="font-size: 20px; font-weight: bold; color: #1f4a7c; margin-left: 12px;">
              $<%= String.format("%.2f", item.getBasePrice()) %>
            </span>
          </div>

          <p style="color: #666; margin: 8px 0;">
            <strong>Category:</strong> <%= item.getCategoryName() %>
          </p>

          <p style="color: #666; margin: 8px 0;">
            <strong>Duration:</strong> <%= item.getDurationMinutes() %> minutes
          </p>

          <hr style="margin: 12px 0; border: none; border-top: 1px solid #eee;">

          <p style="margin: 8px 0;">
            <strong>📅 Date:</strong> <%= item.getBookingDate() %>
          </p>

          <p style="margin: 8px 0;">
            <strong>🕐 Time:</strong> <%= item.getBookingTime() %>
          </p>

          <% if (item.getCaregiverName() != null) { %>
            <p style="margin: 8px 0;">
              <strong>👤 Caregiver:</strong> <%= item.getCaregiverName() %>
            </p>
          <% } else { %>
            <p style="margin: 8px 0; color: #999;">
              <strong>👤 Caregiver:</strong> No preference
            </p>
          <% } %>

          <% if (item.getNotes() != null && !item.getNotes().trim().isEmpty()) { %>
            <p style="margin: 8px 0;">
              <strong>📝 Notes:</strong> <%= item.getNotes() %>
            </p>
          <% } %>

          <div style="margin-top: 16px; text-align: center;">
            <a href="<%= request.getContextPath() %>/customer/removeFromCart.jsp?itemId=<%= item.getCartItemId() %>"
               class="btn btn-secondary"
               onclick="return confirm('Remove this item from cart?');">
              Remove from Cart
            </a>
          </div>
        </div>
      <%
        }
      %>
    </div>

    <!-- Cart Summary -->
    <div class="card" style="background: #f0f7ff; border: 2px solid #1f4a7c; padding: 24px;">
      <h2 style="margin: 0 0 16px 0;">Cart Summary</h2>
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
        <span style="font-size: 18px;">Subtotal (<%= cart.size() %> items):</span>
        <span style="font-size: 24px; font-weight: bold; color: #1f4a7c;">
          $<%= String.format("%.2f", totalPrice) %>
        </span>
      </div>
      <p style="color: #666; font-size: 14px; margin: 12px 0;">
        * Final prices may vary based on actual service duration and additional requirements
      </p>

      <div style="margin-top: 24px; display: flex; gap: 12px; flex-wrap: wrap;">
        <a href="<%= request.getContextPath() %>/CheckoutServlet"
           class="btn btn-primary"
           style="flex: 1; min-width: 200px; text-align: center;">
          Proceed to Checkout
        </a>
        <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp"
           class="btn btn-secondary"
           style="flex: 1; min-width: 200px; text-align: center;">
          Continue Shopping
        </a>
      </div>
    </div>
  <%
    }
  %>
</div>
<jsp:include page="../includes/footer.jsp"/>
