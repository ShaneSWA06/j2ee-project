<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=notLoggedIn"); return; } %>
<%@ page import="java.util.*" %>
<%@ page import="model.CartItem" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Customer Portal"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container customer-dashboard">
  <div class="dashboard-header animate-in">
    <div class="welcome-text">
        <span class="greet">Good day,</span>
        <h1>Welcome Home, <%= String.valueOf(session.getAttribute("sessUserName")) %></h1>
        <p class="subtitle">Access your health services, track bookings, and manage your personalized care profile.</p>
    </div>
  </div>

  <%
    @SuppressWarnings("unchecked")
    ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("shoppingCart");
    int cartCount = (cart != null) ? cart.size() : 0;
    if (cartCount > 0) {
  %>
    <div class="alert-banner animate-in" style="animation-delay: 100ms;">
        <div class="banner-content">
            <div class="banner-icon">
                <i class="fas fa-shopping-cart"></i>
                <span class="badge-count"><%= cartCount %></span>
            </div>
            <div class="banner-text">
                <strong>Items in your cart</strong>
                <p>You have pending bookings waiting for checkout.</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/customer/viewCart.jsp" class="btn btn-primary btn-sm">Complete Checkout</a>
    </div>
  <% } %>

  <div class="action-grid animate-in" style="animation-delay: 200ms;">
    <!-- Primary Actions -->
    <div class="card action-card primary">
        <div class="card-glow"></div>
        <i class="fas fa-plus-circle icon"></i>
        <h3>New Booking</h3>
        <p>Explore our healthcare categories and find the right service for your needs.</p>
        <div class="card-links">
            <a href="${pageContext.request.contextPath}/public/serviceCategories.jsp" class="btn btn-primary btn-sm">Browse Categories</a>
            <a href="${pageContext.request.contextPath}/public/serviceDetails.jsp" class="link-secondary">All Services</a>
        </div>
    </div>

    <div class="card action-card">
        <i class="fas fa-calendar-alt icon"></i>
        <h3>My Schedule</h3>
        <p>View upcoming appointments, past visits, and manage your booking status.</p>
        <div class="card-links">
            <a href="${pageContext.request.contextPath}/customer/booking?action=list" class="btn btn-secondary btn-sm">View Bookings</a>
        </div>
    </div>

    <div class="card action-card">
        <i class="fas fa-user-nurse icon"></i>
        <h3>Our Professionals</h3>
        <p>Meet our certified caregivers and medical escorts ready to assist you.</p>
        <div class="card-links">
            <a href="${pageContext.request.contextPath}/public/caregivers.jsp" class="btn btn-secondary btn-sm">Meet Caregivers</a>
        </div>
    </div>

    <div class="card action-card">
        <i class="fas fa-comment-medical icon"></i>
        <h3>Feedback & Support</h3>
        <p>Your satisfaction is our priority. Share your experience or view your feedback.</p>
        <div class="card-links">
            <a href="${pageContext.request.contextPath}/customer/submitFeedback.jsp" class="btn btn-secondary btn-sm">Give Feedback</a>
            <a href="${pageContext.request.contextPath}/customer/myFeedback.jsp" class="link-secondary">My History</a>
        </div>
    </div>
  </div>

  <div class="quick-links animate-in" style="animation-delay: 300ms;">
      <h3>Quick Access</h3>
      <div class="link-row">
          <a href="${pageContext.request.contextPath}/customer/settings.jsp" class="quick-link-item">
              <i class="fas fa-cog"></i> Account Settings
          </a>
          <a href="${pageContext.request.contextPath}/customer/viewCart.jsp" class="quick-link-item">
              <i class="fas fa-shopping-basket"></i> Shopping Basket
          </a>
          <a href="#" class="quick-link-item">
              <i class="fas fa-question-circle"></i> Help Center
          </a>
      </div>
  </div>
</div>

<style>
  .customer-dashboard {
      margin-top: 4rem;
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

  /* Header */
  .dashboard-header {
      margin-bottom: 3rem;
  }

  .greet {
      color: var(--accent-bright);
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      font-size: 0.8rem;
      display: block;
      margin-bottom: 0.5rem;
  }

  .subtitle {
      color: var(--foreground-muted);
      font-size: 1.1rem;
      max-width: 600px;
  }

  /* Alert Banner */
  .alert-banner {
      background: linear-gradient(90deg, var(--accent-glow), rgba(255,255,255,0.03));
      border: 1px solid var(--border-accent);
      border-radius: var(--radius-xl);
      padding: 1.5rem 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 2.5rem;
      backdrop-filter: blur(8px);
  }

  .banner-content {
      display: flex;
      align-items: center;
      gap: 1.5rem;
  }

  .banner-icon {
      position: relative;
      font-size: 1.5rem;
      color: var(--accent-bright);
  }

  .badge-count {
      position: absolute;
      top: -10px;
      right: -10px;
      background: var(--accent);
      color: white;
      font-size: 0.7rem;
      width: 1.2rem;
      height: 1.2rem;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      border: 2px solid var(--background-base);
  }

  .banner-text strong {
      display: block;
      font-size: 1.1rem;
  }

  .banner-text p {
      margin: 0;
      font-size: 0.9rem;
      color: var(--foreground-muted);
  }

  /* Action Grid */
  .action-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 1.5rem;
      margin-bottom: 4rem;
  }

  .action-card {
      padding: 2.5rem;
      display: flex;
      flex-direction: column;
      height: 100%;
      position: relative;
      overflow: hidden;
  }

  .action-card.primary {
      grid-column: span 1;
      border-color: var(--border-accent);
      background: linear-gradient(135deg, rgba(94, 106, 210, 0.1), rgba(0,0,0,0));
  }

  .action-card .icon {
      font-size: 2rem;
      color: var(--accent);
      margin-bottom: 1.5rem;
  }

  .action-card h3 {
      font-size: 1.25rem;
      margin-bottom: 0.75rem;
  }

  .action-card p {
      font-size: 0.95rem;
      color: var(--foreground-muted);
      margin-bottom: 2rem;
      flex-grow: 1;
  }

  .card-glow {
    position: absolute;
    top: -40px;
    right: -40px;
    width: 120px;
    height: 120px;
    background: var(--accent-glow);
    filter: blur(50px);
    border-radius: 50%;
    z-index: 0;
  }

  .card-links {
      display: flex;
      align-items: center;
      gap: 1.25rem;
  }

  .link-secondary {
      font-size: 0.9rem;
      font-weight: 600;
      color: var(--foreground-muted);
      transition: color 0.2s;
  }

  .link-secondary:hover {
      color: var(--accent-bright);
  }

  /* Quick Links */
  .quick-links h3 {
      font-size: 1.1rem;
      margin-bottom: 1.5rem;
      color: var(--foreground-muted);
      text-transform: uppercase;
      letter-spacing: 0.1em;
  }

  .link-row {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
  }

  .quick-link-item {
      background: var(--surface);
      border: 1px solid var(--border-default);
      padding: 0.75rem 1.25rem;
      border-radius: var(--radius-lg);
      font-size: 0.9rem;
      font-weight: 500;
      color: var(--foreground);
      display: flex;
      align-items: center;
      gap: 0.75rem;
      transition: all 0.2s;
  }

  .quick-link-item:hover {
      background: var(--accent-glow);
      border-color: var(--accent-bright);
      color: var(--accent-bright);
      transform: translateY(-2px);
  }

  .quick-link-item i {
      opacity: 0.7;
  }

  @media (max-width: 600px) {
      .alert-banner {
          flex-direction: column;
          gap: 1.5rem;
          text-align: center;
      }
      .banner-content {
          flex-direction: column;
          gap: 0.5rem;
      }
  }
</style>

<jsp:include page="../includes/footer.jsp"/>
