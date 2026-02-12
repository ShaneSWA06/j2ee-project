<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=notLoggedIn"); return; } %>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Review Cart"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container view-cart">
  <div class="page-header animate-in">
    <div class="header-content">
        <span class="badge">Checkout Flow</span>
        <h1>Shopping Basket</h1>
        <p class="page-subtitle">Review your selected services and schedule before finalizing your booking.</p>
    </div>
  </div>

  <%
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    if ("added".equals(success)) { %>
      <div class="alert alert-success animate-in">
        <i class="fas fa-check-circle"></i> Service successfully added to your basket.
      </div>
  <% } else if ("removed".equals(success)) { %>
      <div class="alert alert-success animate-in">
        <i class="fas fa-trash-alt"></i> Item removed from your basket.
      </div>
  <% } else if (error != null) { %>
      <div class="alert alert-error animate-in">
        <i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> <%= error %>
        <% if (request.getParameter("msg") != null) { %>
            <div class="small"><%= request.getParameter("msg") %></div>
        <% } %>
      </div>
  <% } %>

  <%
    java.util.ArrayList<model.CartItem> cart = (java.util.ArrayList<model.CartItem>) session.getAttribute("shoppingCart");

    if (cart == null || cart.isEmpty()) {
  %>
    <div class="card empty-cart-card animate-in">
      <div class="empty-icon"><i class="fas fa-shopping-basket"></i></div>
      <h2>Your basket is empty</h2>
      <p>It looks like you haven't added any services yet. Start exploring our healthcare options.</p>
      <div class="empty-actions">
        <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp" class="btn btn-primary">Browse Services</a>
        <a href="<%= request.getContextPath() %>/customer/customerHome.jsp" class="btn btn-secondary">Back to Workspace</a>
      </div>
    </div>
  <%
    } else {
      double subtotal = 0;
      for (CartItem item : cart) {
        subtotal += item.getBasePrice();
      }
      double gst = subtotal * 0.09;
      double total = subtotal + gst;
  %>
    <div class="cart-layout">
        <div class="cart-items-section">
            <div class="section-title">
                <i class="fas fa-list-ul"></i>
                Basket Items (<%= cart.size() %>)
            </div>
            
            <% for (CartItem item : cart) { %>
                <div class="card cart-item animate-in">
                    <div class="item-header">
                        <div class="item-title-group">
                            <span class="item-category"><%= item.getCategoryName() %></span>
                            <h3><%= item.getServiceName() %></h3>
                        </div>
                        <div class="item-price-tag">
                            $<%= String.format("%.2f", item.getBasePrice()) %>
                        </div>
                    </div>
                    
                    <div class="item-details-grid">
                        <div class="detail-item">
                            <i class="fas fa-calendar-check"></i>
                            <div>
                                <label>Booking Date</label>
                                <span><%= item.getBookingDate() %></span>
                            </div>
                        </div>
                        <div class="detail-item">
                            <i class="fas fa-clock"></i>
                            <div>
                                <label>Scheduled Time</label>
                                <span><%= item.getBookingTime() %></span>
                            </div>
                        </div>
                        <div class="detail-item">
                            <i class="fas fa-user-nurse"></i>
                            <div>
                                <label>Caregiver</label>
                                <span><%= item.getCaregiverName() != null ? item.getCaregiverName() : "Auto-Match" %></span>
                            </div>
                        </div>
                        <div class="detail-item">
                            <i class="fas fa-hourglass-half"></i>
                            <div>
                                <label>Duration</label>
                                <span><%= item.getDurationMinutes() %> Mins</span>
                            </div>
                        </div>
                    </div>

                    <% if (item.getNotes() != null && !item.getNotes().trim().isEmpty()) { %>
                        <div class="item-notes">
                            <i class="fas fa-sticky-note"></i>
                            <span><%= item.getNotes() %></span>
                        </div>
                    <% } %>

                    <div class="item-footer">
                        <a href="<%= request.getContextPath() %>/customer/removeFromCart.jsp?itemId=<%= item.getCartItemId() %>"
                           class="btn-remove"
                           onclick="return confirm('Do you want to remove this service from your basket?');">
                          <i class="fas fa-trash"></i> Remove
                        </a>
                    </div>
                </div>
            <% } %>
        </div>

        <div class="cart-summary-section">
            <div class="card summary-card animate-in" style="animation-delay: 200ms;">
                <div class="summary-glow"></div>
                <h3>Order Summary</h3>
                <div class="summary-rows">
                    <div class="summary-line">
                        <span>Items Subtotal</span>
                        <span>$<%= String.format("%.2f", subtotal) %></span>
                    </div>
                    <div class="summary-line">
                        <span>GST (9%)</span>
                        <span>$<%= String.format("%.2f", gst) %></span>
                    </div>
                    <div class="divider"></div>
                    <div class="summary-total">
                        <span>Grand Total</span>
                        <span>$<%= String.format("%.2f", total) %></span>
                    </div>
                </div>
                
                <div class="summary-footer">
                    <p><i class="fas fa-info-circle"></i> Payments are processed securely via Stripe. Check your details before proceeding.</p>
                </div>

                <div class="summary-actions">
                    <a href="<%= request.getContextPath() %>/CheckoutServlet"
                       class="btn btn-primary btn-checkout"
                       onclick="if(this.classList.contains('disabled')) return false; this.classList.add('disabled'); this.innerText='Securing Session...';">
                      <i class="fas fa-lock"></i> Proceed to Checkout
                    </a>
                    <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp" class="btn btn-secondary">
                      <i class="fas fa-plus"></i> Add More Services
                    </a>
                </div>
            </div>
            
            <a href="<%= request.getContextPath() %>/customer/customerHome.jsp" class="back-link">
                <i class="fas fa-chevron-left"></i> Return to Dashboard
            </a>
        </div>
    </div>
  <% } %>
</div>

<style>
  .view-cart {
      margin-top: 3rem;
      margin-bottom: 6rem;
  }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .animate-in {
    opacity: 0;
    animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }

  .badge {
    background: var(--accent-glow);
    color: var(--accent-bright);
    padding: 0.25rem 0.75rem;
    border-radius: var(--radius-full);
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    border: 1px solid var(--border-accent);
    margin-bottom: 1rem;
    display: inline-block;
  }

  .page-header {
      margin-bottom: 3rem;
      text-align: center;
  }

  .page-subtitle {
      color: var(--foreground-muted);
      font-size: 1.1rem;
  }

  /* Success/Error Alerts */
  .alert {
      margin-bottom: 2rem;
      display: flex;
      align-items: center;
      gap: 0.75rem;
  }

  /* Empty Cart */
  .empty-cart-card {
      text-align: center;
      padding: 5rem 2rem;
  }

  .empty-icon {
      font-size: 4rem;
      color: var(--accent);
      margin-bottom: 2rem;
      opacity: 0.5;
  }

  .empty-actions {
      margin-top: 2.5rem;
      display: flex;
      gap: 1rem;
      justify-content: center;
  }

  /* Cart Layout */
  .cart-layout {
      display: grid;
      grid-template-columns: 1fr 340px;
      gap: 2.5rem;
      align-items: start;
  }

  @media (max-width: 992px) {
      .cart-layout {
          grid-template-columns: 1fr;
      }
  }

  .section-title {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 1.5rem;
      color: var(--foreground-muted);
      display: flex;
      align-items: center;
      gap: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
  }

  /* Cart Items */
  .cart-item {
      padding: 2rem;
      margin-bottom: 1.5rem;
  }

  .item-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 1.5rem;
  }

  .item-category {
      font-size: 0.75rem;
      font-weight: 700;
      color: var(--accent-bright);
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 0.25rem;
      display: block;
  }

  .item-title-group h3 {
      font-size: 1.4rem;
      margin: 0;
  }

  .item-price-tag {
      font-size: 1.25rem;
      font-weight: 700;
      color: var(--foreground);
      background: var(--surface);
      padding: 0.5rem 1rem;
      border-radius: var(--radius-lg);
      border: 1px solid var(--border-default);
  }

  .item-details-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 1.5rem;
      margin: 1.5rem 0;
      padding-top: 1.5rem;
      border-top: 1px solid var(--border-default);
  }

  .detail-item {
      display: flex;
      gap: 1rem;
      align-items: center;
  }

  .detail-item i {
      color: var(--accent);
      font-size: 1.1rem;
      opacity: 0.8;
  }

  .detail-item label {
      display: block;
      font-size: 0.7rem;
      color: var(--foreground-muted);
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin: 0;
  }

  .detail-item span {
      font-size: 0.95rem;
      font-weight: 500;
  }

  .item-notes {
      background: rgba(255,255,255,0.03);
      padding: 1rem;
      border-radius: var(--radius-md);
      font-size: 0.9rem;
      color: var(--foreground-muted);
      display: flex;
      gap: 0.75rem;
      margin-top: 1rem;
  }

  .item-notes i {
      margin-top: 0.2rem;
  }

  .item-footer {
      margin-top: 2rem;
      display: flex;
      justify-content: flex-end;
  }

  .btn-remove {
      color: #ff4d4d;
      font-size: 0.85rem;
      font-weight: 600;
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      transition: opacity 0.2s;
      padding: 0.5rem;
  }

  .btn-remove:hover {
      opacity: 0.7;
      text-decoration: underline;
  }

  /* Summary Card */
  .summary-card {
      padding: 2rem;
      position: sticky;
      top: 100px;
      overflow: hidden;
  }

  .summary-glow {
      position: absolute;
      top: -30px;
      left: -30px;
      width: 100px;
      height: 100px;
      background: var(--accent-glow);
      filter: blur(40px);
      border-radius: 50%;
  }

  .summary-card h3 {
      font-size: 1.25rem;
      margin-bottom: 2rem;
  }

  .summary-line {
      display: flex;
      justify-content: space-between;
      margin-bottom: 1rem;
      color: var(--foreground-muted);
      font-size: 0.95rem;
  }

  .summary-total {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 1.4rem;
      font-weight: 700;
      color: var(--accent-bright);
      margin: 1.5rem 0;
  }

  .divider {
      height: 1px;
      background: var(--border-default);
      margin: 1.5rem 0;
  }

  .summary-footer {
      font-size: 0.75rem;
      color: var(--foreground-muted);
      margin: 2rem 0;
      line-height: 1.5;
  }

  .summary-actions {
      display: flex;
      flex-direction: column;
      gap: 1rem;
  }

  .btn-checkout {
      width: 100%;
      padding: 1rem;
      font-size: 1.1rem;
  }

  .back-link {
      display: block;
      margin-top: 1.5rem;
      text-align: center;
      font-size: 0.9rem;
      color: var(--foreground-muted);
      text-decoration: none;
      transition: color 0.2s;
  }

  .back-link:hover {
      color: var(--accent);
  }
</style>

<jsp:include page="../includes/footer.jsp"/>
