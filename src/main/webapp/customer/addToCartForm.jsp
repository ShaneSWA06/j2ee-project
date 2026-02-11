<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=notLoggedIn"); return; } %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Add to Cart"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container add-to-cart">
  <div class="page-header animate-in">
    <div class="header-content">
      <span class="badge">Booking Pipeline</span>
      <h1>Schedule Service</h1>
      <p class="page-subtitle">Configure your booking details and confirm your selection.</p>
    </div>
  </div>

  <%
    String serviceIdParam = request.getParameter("serviceId");
    String caregiverIdParam = request.getParameter("caregiverId");

    if (serviceIdParam == null) {
      response.sendRedirect(request.getContextPath() + "/public/serviceDetails.jsp");
      return;
    }

    int selectedServiceId = Integer.parseInt(serviceIdParam);
    int selectedCaregiverId = 0;
    if (caregiverIdParam != null && !caregiverIdParam.trim().isEmpty()) {
      selectedCaregiverId = Integer.parseInt(caregiverIdParam);
    }
    String companyIdParam = request.getParameter("companyId");

    String serviceName = null;
    String description = null;
    double basePrice = 0;
    int durationMinutes = 0;
    String categoryName = null;

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(
            "SELECT s.service_name, s.description, s.base_price, s.duration_minutes, c.category_name " +
            "FROM service s LEFT JOIN service_category c ON s.category_id = c.category_id " +
            "WHERE s.service_id=? AND s.is_active=TRUE")) {
      ps.setInt(1, selectedServiceId);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          serviceName = rs.getString("service_name");
          description = rs.getString("description");
          basePrice = rs.getDouble("base_price");
          durationMinutes = rs.getInt("duration_minutes");
          categoryName = rs.getString("category_name");
        }
      }
    }

    if (serviceName == null) {
      try (Connection conn = DBUtil.getConnection();
           PreparedStatement ps = conn.prepareStatement(
             "SELECT service_name, description, base_price, duration_minutes " +
             "FROM medical_escort_service WHERE service_id=? AND is_active=TRUE")) {
        ps.setInt(1, selectedServiceId);
        try (ResultSet rs = ps.executeQuery()) {
          if (rs.next()) {
            serviceName = rs.getString("service_name");
            description = rs.getString("description");
            basePrice = rs.getDouble("base_price");
            durationMinutes = rs.getInt("duration_minutes");
            categoryName = "Medical Escort";
          }
        }
      }
    }

    if (serviceName == null) {
      response.sendRedirect(request.getContextPath() + "/public/serviceDetails.jsp?err=service_not_found");
      return;
    }
  %>

  <div class="booking-grid">
    <!-- Left Column: Service Information -->
    <div class="summary-column animate-in" style="animation-delay: 100ms;">
      <div class="card service-info-card">
        <div class="card-glow"></div>
        <div class="service-chip"><i class="fas fa-sparkles"></i> Selected Service</div>
        <h3><%= serviceName %></h3>
        <p class="summary-category"><%= categoryName %></p>
        
        <div class="divider"></div>
        
        <p class="summary-description"><%= description %></p>
        
        <div class="meta-row">
            <div class="meta-item">
                <i class="fas fa-clock"></i>
                <span><%= durationMinutes %> Minutes</span>
            </div>
            <div class="meta-item">
                <i class="fas fa-shield-halved"></i>
                <span>Verified Provider</span>
            </div>
        </div>

        <div class="pricing-card">
            <h4>Price Quotation</h4>
            <% 
               double gstRate = 0.09;
               double gstAmount = basePrice * gstRate;
               double totalPrice = basePrice + gstAmount;
            %>
            <div class="pricing-row">
                <span>Base Rate</span>
                <span>$<%= String.format("%.2f", basePrice) %></span>
            </div>
            <div class="pricing-row">
                <span>GST (9%)</span>
                <span>$<%= String.format("%.2f", gstAmount) %></span>
            </div>
            <div class="pricing-total">
                <span>Estimated Total</span>
                <span>$<%= String.format("%.2f", totalPrice) %></span>
            </div>
            <p class="pricing-note">Final price may vary based on specific requirements.</p>
        </div>
      </div>
    </div>

    <!-- Right Column: Booking Form -->
    <div class="form-column animate-in" style="animation-delay: 200ms;">
      <form method="post" action="<%= request.getContextPath() %>/AddToCartServlet" class="main-form">
        <input type="hidden" name="serviceId" value="<%= selectedServiceId %>"/>
        <input type="hidden" name="companyId" value="<%= companyIdParam != null ? companyIdParam : "" %>"/>

        <div class="card form-section-card">
          <div class="section-title">
            <i class="fas fa-calendar-day"></i>
            Schedule and Preferences
          </div>
          
          <div class="input-row">
            <div class="form-group">
                <label>Date</label>
                <div class="input-wrapper">
                    <i class="fas fa-calendar"></i>
                    <input type="date" name="bookingDate" required
                           min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"/>
                </div>
            </div>
            <div class="form-group">
                <label>Time</label>
                <div class="input-wrapper">
                    <i class="fas fa-clock"></i>
                    <input type="time" name="bookingTime" required/>
                </div>
            </div>
          </div>

          <div class="form-group">
              <label>Match Caregiver (Optional)</label>
              <div class="input-wrapper">
                  <i class="fas fa-user-nurse"></i>
                  <select name="caregiverId">
                    <option value="">Auto-match best available</option>
                    <%
                      try (Connection connCg = DBUtil.getConnection();
                           PreparedStatement psCg = connCg.prepareStatement(
                             "SELECT caregiver_id, name, specialties, experience FROM caregiver WHERE available=TRUE ORDER BY name")) {
                        try (ResultSet rsCg = psCg.executeQuery()) {
                          while (rsCg.next()) {
                            int cgId = rsCg.getInt("caregiver_id");
                            String cgName = rsCg.getString("name");
                            String cgSpecialties = rsCg.getString("specialties");
                            Integer cgExp = rsCg.getObject("experience", Integer.class);
                            String displayText = cgName;
                            if (cgExp != null && cgExp > 0) {
                              displayText += " (" + cgExp + "y exp)";
                            }
                            if (cgSpecialties != null && !cgSpecialties.trim().isEmpty()) {
                              displayText += " - " + cgSpecialties;
                            }
                            boolean isSelected = (selectedCaregiverId > 0 && cgId == selectedCaregiverId);
                    %>
                      <option value="<%= cgId %>" <%= isSelected ? "selected" : "" %>><%= displayText %></option>
                    <%
                          }
                        }
                      } catch (Exception ignore) {}
                    %>
                  </select>
              </div>
              <span class="hint"><i class="fas fa-info-circle"></i> Leaving this blank will assign our top-rated available professional.</span>
          </div>
        </div>

        <div class="card form-section-card" style="margin-top: 1.5rem;">
          <div class="section-title">
            <i class="fas fa-location-dot"></i>
            Location & Logistics
          </div>

          <div class="form-group">
              <label>Pickup Address</label>
              <div class="input-wrapper">
                  <i class="fas fa-map-marker-alt"></i>
                  <input type="text" name="pickupAddress" placeholder="e.g. 123 Silver Street, #04-12"/>
              </div>
          </div>

          <div class="form-group">
              <label>Destination Address (Optional)</label>
              <div class="input-wrapper">
                  <i class="fas fa-flag-checkered"></i>
                  <input type="text" name="destinationAddress" placeholder="e.g. Mount Elizabeth Hospital"/>
              </div>
          </div>

          <div class="form-group" style="margin-bottom: 0;">
              <label>Health Notes / Requests</label>
              <div class="input-wrapper align-top">
                  <i class="fas fa-notes-medical"></i>
                  <textarea name="notes" rows="3" placeholder="Tell us about special requirements, medication needs, or access instructions..."></textarea>
              </div>
          </div>
        </div>

        <div class="form-actions animate-in" style="animation-delay: 300ms;">
          <button class="btn btn-primary btn-booking" type="submit">
            <i class="fas fa-cart-plus"></i> Confirm and Add to Cart
          </button>
          <a class="btn btn-secondary" href="<%= request.getContextPath() %>/public/serviceDetails.jsp?serviceId=<%= selectedServiceId %>">
            <i class="fas fa-arrow-left"></i> Back to Details
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<style>
  :root {
    --form-bg: rgba(10, 10, 12, 0.7);
    --input-bg: rgba(255, 255, 255, 0.03);
    --input-border: rgba(255, 255, 255, 0.08);
  }

  .add-to-cart {
    margin: 3rem auto 5rem;
  }

  /* Animations */
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
  }

  /* Grid Layout */
  .booking-grid {
    display: grid;
    grid-template-columns: 1fr 1.3fr;
    gap: 2rem;
    align-items: start;
  }

  @media (max-width: 992px) {
    .booking-grid {
      grid-template-columns: 1fr;
    }
    .summary-column {
        order: 2;
    }
    .form-column {
        order: 1;
    }
  }

  /* Service Card */
  .service-info-card {
    position: relative;
    overflow: hidden;
    padding: 2.5rem;
  }

  .card-glow {
    position: absolute;
    top: -50px;
    right: -50px;
    width: 150px;
    height: 150px;
    background: var(--accent-glow);
    filter: blur(60px);
    border-radius: 50%;
    z-index: 0;
  }

  .service-chip {
    font-size: 0.8rem;
    color: var(--accent-bright);
    margin-bottom: 1rem;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .summary-category {
    font-size: 0.9rem;
    color: var(--foreground-muted);
    background: rgba(255,255,255,0.05);
    padding: 0.2rem 0.6rem;
    border-radius: 4px;
    display: inline-block;
  }

  .divider {
    height: 1px;
    background: linear-gradient(to right, var(--border-default), transparent);
    margin: 1.5rem 0;
  }

  .summary-description {
    line-height: 1.7;
    margin-bottom: 2rem;
  }

  .meta-row {
      display: flex;
      gap: 1.5rem;
      margin-bottom: 2rem;
  }

  .meta-item {
      display: flex;
      align-items: center;
      gap: 0.6rem;
      color: var(--foreground-muted);
      font-size: 0.9rem;
  }

  .meta-item i {
      color: var(--accent);
  }

  /* Pricing Card */
  .pricing-card {
    background: rgba(0, 0, 0, 0.3);
    border-radius: var(--radius-xl);
    padding: 1.5rem;
    border: 1px solid var(--border-default);
  }

  .pricing-card h4 {
    font-size: 1rem;
    margin-bottom: 1rem;
    color: var(--foreground);
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .pricing-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 0.75rem;
    color: var(--foreground-muted);
    font-size: 0.95rem;
  }

  .pricing-total {
    display: flex;
    justify-content: space-between;
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 1px dashed var(--border-default);
    color: var(--accent-bright);
    font-weight: 700;
    font-size: 1.25rem;
  }

  .pricing-note {
    font-size: 0.75rem;
    color: var(--foreground-subtle);
    margin-top: 1rem;
    text-align: center;
  }

  /* Form Styling */
  .form-section-card {
    padding: 2rem;
  }

  .section-title {
    font-size: 1.1rem;
    font-weight: 600;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    color: var(--foreground);
  }

  .section-title i {
    color: var(--accent);
    font-size: 1rem;
  }

  .input-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-bottom: 1.5rem;
  }

  .form-group {
    margin-bottom: 1.5rem;
  }

  .form-group label {
    display: block;
    font-size: 0.85rem;
    font-weight: 600;
    color: var(--foreground-muted);
    margin-bottom: 0.6rem;
    text-transform: uppercase;
    letter-spacing: 0.02em;
  }

  .input-wrapper {
    position: relative;
    display: flex;
    align-items: center;
  }

  .input-wrapper i {
    position: absolute;
    left: 1rem;
    color: var(--foreground-subtle);
    font-size: 0.9rem;
    pointer-events: none;
    transition: color 0.2s;
  }

  .input-wrapper input,
  .input-wrapper select,
  .input-wrapper textarea {
    padding-left: 2.8rem;
    background: var(--input-bg);
    border: 1px solid var(--input-border);
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  }

  .input-wrapper.align-top {
      align-items: flex-start;
  }

  .input-wrapper.align-top i {
      top: 1rem;
  }

  .input-wrapper input:focus,
  .input-wrapper select:focus,
  .input-wrapper textarea:focus {
    background: var(--background-elevated);
    border-color: var(--accent);
    box-shadow: 0 0 0 4px var(--accent-glow);
  }

  .input-wrapper input:focus + i,
  .input-wrapper select:focus + i,
  .input-wrapper textarea:focus + i {
    color: var(--accent-bright);
  }

  .hint {
    display: block;
    font-size: 0.75rem;
    color: var(--foreground-subtle);
    margin-top: 0.5rem;
    padding-left: 0.5rem;
  }

  /* Actions */
  .form-actions {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    margin-top: 2rem;
  }

  .btn-booking {
    width: 100%;
    padding: 1.1rem;
    font-size: 1.1rem;
    letter-spacing: 0.01em;
  }

  .btn-secondary {
      width: 100%;
      background: transparent;
      border: 1px solid var(--border-default);
  }

  .btn-secondary:hover {
      background: var(--surface);
  }
</style>

<jsp:include page="../includes/footer.jsp"/>
