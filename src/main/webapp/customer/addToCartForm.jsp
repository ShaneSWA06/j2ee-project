<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% if (session.getAttribute("sessUserId") == null) { response.sendRedirect(request.getContextPath()+"/auth/login.jsp?err=notLoggedIn"); return; } %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Add to Cart"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Add Service to Cart</h1>

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
      response.sendRedirect(request.getContextPath() + "/public/serviceDetails.jsp?err=service_not_found");
      return;
    }
  %>

  <div class="card" style="margin-bottom: 16px; background: #f0f7ff;">
    <h3><%= serviceName %></h3>
    <p><strong>Category:</strong> <%= categoryName %></p>
    <p><%= description %></p>
    <p><strong>Price:</strong> $<%= String.format("%.2f", basePrice) %></p>
    <p><strong>Duration:</strong> <%= durationMinutes %> minutes</p>
  </div>

  <form method="post" action="<%= request.getContextPath() %>/AddToCartServlet">
    <input type="hidden" name="serviceId" value="<%= selectedServiceId %>"/>

    <div class="card">
      <label><strong>Booking Date</strong></label>
      <input type="date" name="bookingDate" required
             min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
             style="width:100%; padding: 8px; font-size: 16px; margin-top: 8px;"/>
    </div>

    <div class="card">
      <label><strong>Booking Time</strong></label>
      <input type="time" name="bookingTime" required
             style="width:100%; padding: 8px; font-size: 16px; margin-top: 8px;"/>
    </div>

    <div class="card">
      <label><strong>Preferred Caregiver (Optional)</strong></label>
      <select name="caregiverId" style="width:100%; padding: 8px; font-size: 16px; margin-top: 8px;">
        <option value="">No Preference</option>
        <%
          try (Connection connCg = DBUtil.getConnection();
               PreparedStatement psCg = connCg.prepareStatement(
                 "SELECT caregiver_id, name, specialties, experience_years FROM caregiver WHERE is_active=TRUE ORDER BY name")) {
            try (ResultSet rsCg = psCg.executeQuery()) {
              while (rsCg.next()) {
                int cgId = rsCg.getInt("caregiver_id");
                String cgName = rsCg.getString("name");
                String cgSpecialties = rsCg.getString("specialties");
                Integer cgExp = rsCg.getObject("experience_years", Integer.class);
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
      <small style="color: #666; display: block; margin-top: 4px;">
        <% if (selectedCaregiverId > 0) { %>
          Caregiver pre-selected. You can change if needed.
        <% } else { %>
          Select a specific caregiver or leave as "No Preference"
        <% } %>
      </small>
    </div>

    <div class="card">
      <label><strong>Additional Notes (Optional)</strong></label>
      <textarea name="notes" rows="4"
                placeholder="Any special requests or information we should know..."
                style="width:100%; padding: 8px; font-size: 16px; margin-top: 8px;"></textarea>
    </div>

    <p style="margin-top:12px">
      <button class="btn btn-primary" type="submit">Add to Cart</button>
      <a class="btn btn-secondary" href="<%= request.getContextPath() %>/public/serviceDetails.jsp">Cancel</a>
    </p>
  </form>
</div>
<jsp:include page="../includes/footer.jsp"/>
