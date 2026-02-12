<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Admin Command Center"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container admin-dashboard">
  <div class="dashboard-header animate-in">
    <div class="header-content">
        <span class="badge">Management Dashboard</span>
        <h1>Admin Dashboard</h1>
        <p class="page-subtitle">Manage services, monitor appointments, and view system analytics.</p>
    </div>
  </div>

  <div class="stats-overview animate-in" style="animation-delay: 100ms;">
      <div class="card stat-card intel" onclick="window.open('https://assignmenttwo-fljm.onrender.com/user-ws/analytics.html', '_blank')">
          <div class="stat-glow"></div>
          <div class="stat-icon"><i class="fas fa-chart-line"></i></div>
          <div class="stat-content">
              <h3>Business Analytics</h3>
              <p>View bookings and revenue insights.</p>
          </div>
          <div class="stat-action">View Reports <i class="fas fa-external-link-alt"></i></div>
      </div>
  </div>

  <div class="admin-grid animate-in" style="animation-delay: 200ms;">
    <!-- Core Management -->
    <div class="card management-card">
        <div class="card-icon"><i class="fas fa-layer-group"></i></div>
        <h3>Services & Categories</h3>
        <p>Manage service offerings and categories.</p>
        <div class="card-actions">
            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/category">Categories</a>
            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/admin/service">Services</a>
        </div>
    </div>

    <div class="card management-card">
        <div class="card-icon"><i class="fas fa-user-md"></i></div>
        <h3>Caregivers</h3>
        <p>Manage caregiver profiles, availability, and assignments.</p>
        <div class="card-actions">
            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/admin/caregiver">View Caregivers</a>
        </div>
    </div>

    <div class="card management-card highlight">
        <div class="card-glow"></div>
        <div class="card-icon"><i class="fas fa-calendar-check"></i></div>
        <h3>Appointments</h3>
        <p>View and manage service appointments and assignments.</p>
        <div class="card-actions">
            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/admin/booking">View Appointments</a>
        </div>
    </div>

    <div class="card management-card">
        <div class="card-icon"><i class="fas fa-credit-card"></i></div>
        <h3>Payments</h3>
        <p>View payment transactions and history.</p>
        <div class="card-actions">
            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/payments">View Payments</a>
        </div>
    </div>

    <div class="card management-card">
        <div class="card-icon"><i class="fas fa-users-cog"></i></div>
        <h3>Customer Management</h3>
        <p>View and manage customer profiles and accounts.</p>
        <div class="card-actions">
            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/client">View Customers</a>
        </div>
    </div>

    <div class="card management-card">
        <div class="card-icon"><i class="fas fa-star"></i></div>
        <h3>Customer Reviews</h3>
        <p>View and respond to customer feedback and ratings.</p>
        <div class="card-actions">
            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/feedback">View Reviews</a>
        </div>
    </div>

    <div class="card management-card">
        <div class="card-icon"><i class="fas fa-chart-pie"></i></div>
        <h3>Reports</h3>
        <p>View and export system reports and analytics.</p>
        <div class="card-actions">
            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/reports">View Reports</a>
        </div>
    </div>
  </div>
</div>

<style>
  .admin-dashboard {
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

  .page-header {
      margin-bottom: 3rem;
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

  .page-subtitle {
     color: var(--foreground-muted);
     font-size: 1.1rem;
     max-width: 600px;
  }

  /* Intel Card */
  .stats-overview {
      margin-bottom: 2.5rem;
  }

  .stat-card.intel {
      display: flex;
      align-items: center;
      gap: 2rem;
      padding: 2.5rem;
      background: linear-gradient(90deg, rgba(14, 144, 233, 0.15), rgba(0,0,0,0));
      border: 1px solid rgba(14, 144, 233, 0.4);
      cursor: pointer;
      overflow: hidden;
      position: relative;
  }

  .stat-card.intel:hover {
      background: linear-gradient(90deg, rgba(14, 144, 233, 0.25), rgba(0,0,0,0));
      border-color: rgba(14, 144, 233, 0.6);
  }

  .stat-glow {
    position: absolute;
    top: -50px;
    right: -50px;
    width: 200px;
    height: 200px;
    background: rgba(14, 144, 233, 0.15);
    filter: blur(80px);
    border-radius: 50%;
  }

  .stat-icon {
      font-size: 2.5rem;
      color: #0e90e9;
      background: rgba(14, 144, 233, 0.1);
      padding: 1.5rem;
      border-radius: var(--radius-xl);
  }

  .stat-content {
      flex-grow: 1;
  }

  .stat-content h3 {
      font-size: 1.5rem;
      color: #0e90e9;
      margin: 0;
  }

  .stat-content p {
      margin: 0.5rem 0 0;
      color: var(--foreground-muted);
  }

  .stat-action {
      font-weight: 700;
      color: #0e90e9;
      display: flex;
      align-items: center;
      gap: 0.75rem;
      text-transform: uppercase;
      font-size: 0.8rem;
      letter-spacing: 0.1em;
  }

  /* Grid */
  .admin-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
      gap: 1.5rem;
  }

  .management-card {
      padding: 2.5rem;
      display: flex;
      flex-direction: column;
      position: relative;
      overflow: hidden;
  }

  .management-card.highlight {
      border-color: var(--border-accent);
      background: linear-gradient(135deg, rgba(94, 106, 210, 0.1), transparent);
  }

  .card-glow {
    position: absolute;
    top: -30px;
    right: -30px;
    width: 100px;
    height: 100px;
    background: var(--accent-glow);
    filter: blur(50px);
    border-radius: 50%;
  }

  .card-icon {
      font-size: 1.75rem;
      color: var(--accent);
      margin-bottom: 1.5rem;
  }

  .management-card h3 {
      font-size: 1.25rem;
      margin-bottom: 0.75rem;
  }

  .management-card p {
      font-size: 0.95rem;
      color: var(--foreground-muted);
      margin-bottom: 2rem;
      flex-grow: 1;
  }

  .card-actions {
      display: flex;
      gap: 1rem;
      align-items: center;
  }

  @media (max-width: 600px) {
      .stat-card.intel {
          flex-direction: column;
          text-align: center;
          gap: 1rem;
      }
      .stat-action {
          margin-top: 1rem;
      }
  }
</style>

<jsp:include page="../includes/footer.jsp"/>