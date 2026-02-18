<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Booking History"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container my-bookings">
  <div class="page-header animate-in">
    <div class="header-content">
        <span class="badge">Appointment History</span>
        <h1>My Appointments</h1>
        <p class="page-subtitle">View your upcoming and past appointments.</p>
    </div>
  </div>

  <c:if test="${not empty param.success}">
    <div class="alert alert-success animate-in">
        <i class="fas fa-check-circle"></i> Success: Booking ${param.success}!
    </div>
  </c:if>
  <c:if test="${not empty param.err}">
    <div class="alert alert-error animate-in">
        <i class="fas fa-exclamation-triangle"></i> Sorry, we couldn't complete that action. Please try again or contact support.
    </div>
  </c:if>

  <div class="booking-controls animate-in" style="animation-delay: 100ms;">
    <a href="${pageContext.request.contextPath}/mvc/public/serviceDetails" class="btn btn-primary">
        <i class="fas fa-plus"></i> New Appointment
    </a>
  </div>

  <div class="booking-list">
    <c:choose>
        <c:when test="${not empty bookings}">
            <c:forEach var="booking" items="${bookings}" varStatus="status">
                <div class="card booking-card animate-in" style="animation-delay: ${200 + (status.index * 50)}ms;">
                    <div class="booking-header">
                        <div class="service-identity">
                            <span class="service-name">${booking.serviceName}</span>
                            <span class="booking-id">Booking #${booking.bookingId}</span>
                        </div>
                        <div class="status-indicator">
                            <span class="status-badge ${booking.status.toLowerCase()}">
                                ${booking.status}
                            </span>
                        </div>
                    </div>

                    <div class="booking-body">
                        <div class="booking-meta-grid">
                            <div class="meta-item">
                                <i class="fas fa-calendar"></i>
                                <div>
                                    <label>Date</label>
                                    <span><fmt:formatDate value="${booking.bookingDate}" pattern="EEE, dd MMM yyyy" timeZone="GMT+8"/></span>
                                </div>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-clock"></i>
                                <div>
                                    <label>Time</label>
                                    <span><fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm" timeZone="GMT+8"/></span>
                                </div>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-credit-card"></i>
                                <div>
                                    <label>Payment</label>
                                    <span class="${booking.paymentStatus == 'Paid' ? 'paid-text' : 'unpaid-text'}">
                                        ${not empty booking.paymentStatus ? booking.paymentStatus : 'Unpaid'}
                                    </span>
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty booking.caregiverName}">
                            <div class="caregiver-info card-solid">
                                <i class="fas fa-user-nurse"></i>
                                <div class="cg-details">
                                    <div class="cg-name">${booking.caregiverName}</div>
                                    <div class="cg-status">
                                        <i class="fas fa-circle 
                                            ${booking.caregiverStatus == 'Accepted' ? 'online' :
                                              booking.caregiverStatus == 'In-Progress' ? 'inprogress' :
                                              booking.caregiverStatus == 'Completed' ? 'done' : 'away'}"></i>
                                        Assignment Status: <strong>${booking.caregiverStatus}</strong>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty booking.notes}">
                            <div class="booking-notes">
                                <i class="fas fa-sticky-note"></i>
                                <p>${booking.notes}</p>
                            </div>
                        </c:if>
                    </div>

                    <div class="booking-actions">
                        <a href="${pageContext.request.contextPath}/customer/viewFeedback.jsp?serviceId=${booking.serviceId}" class="link-action">
                            <i class="fas fa-star text-amber-400"></i> View Service Feedback
                        </a>
                        <c:if test="${booking.status == 'Pending' || booking.status == 'Confirmed'}">
                            <form method="post"
                                  action="${pageContext.request.contextPath}/customer/booking?action=cancel"
                                  onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                <button type="submit" class="btn btn-ghost btn-sm" style="color: #ff4d4d;">
                                    <i class="fas fa-times-circle"></i> Cancel Request
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="card empty-state-card animate-in">
                <i class="fas fa-calendar-times empty-icon"></i>
                <h2>No bookings found</h2>
                <p>You haven't scheduled any services yet. Our professionals are ready to assist you.</p>
                <a href="${pageContext.request.contextPath}/mvc/public/serviceDetails" class="btn btn-primary">Schedule First Service</a>
            </div>
        </c:otherwise>
    </c:choose>
  </div>
</div>

<style>
  .my-bookings {
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
      text-align: center;
  }

  .page-subtitle {
     color: var(--foreground-muted);
     font-size: 1.1rem;
     max-width: 600px;
     margin: 0.5rem auto 0;
  }

  .booking-controls {
      margin-bottom: 2rem;
      display: flex;
      justify-content: flex-end;
  }

  .booking-list {
      max-width: 800px;
      margin: 0 auto;
  }

  /* Booking Card */
  .booking-card {
      padding: 0;
      margin-bottom: 1.5rem;
      overflow: hidden;
  }

  .booking-header {
      padding: 1.5rem 2rem;
      background: rgba(255, 255, 255, 0.03);
      border-bottom: 1px solid var(--border-default);
      display: flex;
      justify-content: space-between;
      align-items: center;
  }

  .service-identity {
      display: flex;
      flex-direction: column;
  }

  .service-name {
      font-size: 1.2rem;
      font-weight: 600;
      color: var(--foreground);
  }

  .booking-id {
      font-size: 0.75rem;
      font-family: var(--font-mono);
      color: var(--foreground-muted);
      letter-spacing: 0.05em;
  }

  .status-badge {
      padding: 0.25rem 0.75rem;
      border-radius: var(--radius-full);
      font-size: 0.7rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      border: 1px solid currentColor;
  }

  .status-badge.confirmed { color: #4ade80; background: rgba(74, 222, 128, 0.1); }
  .status-badge.pending { color: #fbbf24; background: rgba(251, 191, 36, 0.1); }
  .status-badge.cancelled { color: #f87171; background: rgba(248, 113, 113, 0.1); }
  .status-badge.completed { color: #60a5fa; background: rgba(96, 165, 250, 0.1); }

  .booking-body {
      padding: 2rem;
  }

  .booking-meta-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
      gap: 1.5rem;
      margin-bottom: 2rem;
  }

  .meta-item {
      display: flex;
      align-items: center;
      gap: 1rem;
  }

  .meta-item i {
      color: var(--accent);
      font-size: 1.1rem;
      opacity: 0.7;
  }

  .meta-item label {
      display: block;
      font-size: 0.7rem;
      color: var(--foreground-muted);
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 0.15rem;
  }

  .meta-item span {
      font-size: 0.95rem;
      font-weight: 500;
  }

  .paid-text { color: #4ade80; }
  .unpaid-text { color: #fbbf24; }

  /* Caregiver Section */
  .caregiver-info {
      padding: 1.25rem;
      display: flex;
      gap: 1.25rem;
      align-items: center;
      border-radius: var(--radius-lg);
      margin-bottom: 1.5rem;
  }

  .caregiver-info > i {
      font-size: 1.5rem;
      color: var(--accent-bright);
      background: var(--accent-glow);
      padding: 1rem;
      border-radius: var(--radius-md);
  }

  .cg-name {
      font-weight: 600;
      font-size: 1rem;
      margin-bottom: 0.25rem;
  }

  .cg-status {
      font-size: 0.8rem;
      color: var(--foreground-muted);
      display: flex;
      align-items: center;
      gap: 0.5rem;
  }

  .cg-status i {
      font-size: 0.5rem;
  }

  .online { color: #4ade80; }
  .away { color: #fbbf24; }
  .inprogress { color: #60a5fa; }
  .done { color: #a78bfa; }

  .booking-notes {
      padding: 1rem;
      background: rgba(255, 255, 255, 0.02);
      border-radius: var(--radius-md);
      font-size: 0.9rem;
      color: var(--foreground-muted);
      display: flex;
      gap: 1rem;
  }

  .booking-notes i {
      margin-top: 0.2rem;
      opacity: 0.5;
  }

  .booking-actions {
      padding: 1rem 2rem;
      background: rgba(0, 0, 0, 0.2);
      display: flex;
      justify-content: space-between;
      align-items: center;
  }

  .link-action {
      font-size: 0.85rem;
      font-weight: 600;
      color: var(--foreground-muted);
      transition: color 0.2s;
      text-decoration: none;
  }

  .link-action:hover {
      color: var(--accent-bright);
  }

  /* Empty State */
  .empty-state-card {
      text-align: center;
      padding: 5rem 2rem;
  }

  .empty-icon {
      font-size: 4rem;
      color: var(--accent);
      margin-bottom: 2rem;
      opacity: 0.4;
  }
</style>

<jsp:include page="../includes/footer.jsp"/>
