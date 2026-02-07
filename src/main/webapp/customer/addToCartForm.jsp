<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=notLoggedIn"); return; } %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Add to Cart"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container add-to-cart">
  <div class="page-header">
    <h1>Add Service to Cart</h1>
    <p class="page-subtitle">Confirm the service details and schedule your booking.</p>
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

  <div class="card service-summary">
    <div class="service-summary-header">
      <div>
        <h3><%= serviceName %></h3>
        <p class="summary-category">Category: <%= categoryName %></p>
      </div>
      <div class="summary-meta">
        <span class="summary-price">$<%= String.format("%.2f", basePrice) %></span>
        <span class="summary-duration"><%= durationMinutes %> minutes</span>
      </div>
    </div>
    <p class="summary-description"><%= description %></p>
  </div>

  <form method="post" action="<%= request.getContextPath() %>/AddToCartServlet" class="form-grid">
    <input type="hidden" name="serviceId" value="<%= selectedServiceId %>"/>
    <input type="hidden" name="companyId" value="<%= companyIdParam != null ? companyIdParam : "" %>"/>

    <div class="card form-card">
      <label class="form-label">Booking Date</label>
      <input type="date" name="bookingDate" required
             min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
             class="form-control"/>
    </div>

    <div class="card form-card">
      <label class="form-label">Booking Time</label>
      <input type="time" name="bookingTime" required
             class="form-control"/>
    </div>

    <div class="card form-card">
      <label class="form-label">Preferred Caregiver (Optional)</label>
      <select name="caregiverId" class="form-control">
        <option value="">No Preference</option>
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
                  displayText += " (" + cgExp + " years exp)";
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
      <small class="form-hint">
        <% if (selectedCaregiverId > 0) { %>
          Caregiver pre-selected. You can change if needed.
        <% } else { %>
          Select a specific caregiver or leave as "No Preference"
        <% } %>
      </small>
    </div>

    <div class="card form-card">
      <label class="form-label">Additional Notes (Optional)</label>
      <textarea name="notes" rows="4"
                placeholder="Any special requests or information we should know..."
                class="form-control"></textarea>
    </div>

    <div class="form-actions">
      <button class="btn btn-primary" type="submit">Add to Cart</button>
      <a class="btn btn-secondary" href="<%= request.getContextPath() %>/public/serviceDetails.jsp">Cancel</a>
    </div>
  </form>
</div>
<style>
  .add-to-cart {
    margin-top: 3rem;
    margin-bottom: 4rem;
  }

  .page-header {
    margin-bottom: 2rem;
  }

  .page-subtitle {
    color: var(--foreground-muted);
    margin-top: 0.5rem;
  }

  .service-summary {
    padding: 2rem;
    margin-bottom: 1.5rem;
    background: linear-gradient(135deg, rgba(94, 106, 210, 0.14), rgba(255, 255, 255, 0.03));
    border-color: var(--border-accent);
  }

  .service-summary-header {
    display: flex;
    justify-content: space-between;
    gap: 1.5rem;
    flex-wrap: wrap;
    align-items: flex-start;
  }

  .summary-category {
    color: var(--foreground-muted);
    margin-top: 0.5rem;
  }

  .summary-meta {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    align-items: flex-end;
  }

  .summary-price {
    font-size: 1.5rem;
    font-weight: 600;
    color: var(--accent);
  }

  .summary-duration {
    color: var(--foreground-muted);
    font-size: 0.875rem;
  }

  .summary-description {
    margin-top: 1.25rem;
    color: var(--foreground-muted);
  }

  .form-grid {
    display: grid;
    gap: 1.5rem;
  }

  .form-card {
    padding: 1.5rem;
  }

  .form-label {
    font-weight: 600;
    color: var(--foreground);
  }

  .form-control {
    width: 100%;
    margin-top: 0.75rem;
    padding: 0.75rem 1rem;
    font-size: 1rem;
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-default);
    background: rgba(5, 5, 6, 0.7);
    color: var(--foreground);
    outline: none;
  }

  .form-control:focus {
    border-color: var(--border-accent);
    box-shadow: 0 0 0 1px rgba(94, 106, 210, 0.4);
  }

  .form-control::placeholder {
    color: var(--foreground-muted);
  }

  .form-hint {
    display: block;
    margin-top: 0.5rem;
    color: var(--foreground-muted);
  }

  .form-actions {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    margin-top: 0.5rem;
  }

  @media (max-width: 768px) {
    .service-summary {
      padding: 1.5rem;
    }

    .summary-meta {
      align-items: flex-start;
    }
  }
</style>
<jsp:include page="../includes/footer.jsp"/>
