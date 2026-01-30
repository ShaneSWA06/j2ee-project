<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Service" %>
<%
  if (request.getAttribute("mvcLoaded") == null) {
    request.getRequestDispatcher("/mvc/public/serviceDetails").forward(request, response);
    return;
  }

  Integer cid = (Integer) request.getAttribute("categoryId");
  String categoryName = (String) request.getAttribute("categoryName");
  String error = (String) request.getAttribute("error");

  @SuppressWarnings("unchecked")
  List<Service> services = (List<Service>) request.getAttribute("services");
%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Service Details"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <% if (categoryName != null) { %>
    <h1>Services - <%= categoryName %></h1>
  <% } else { %>
    <h1>All Services</h1>
  <% } %>

  <!-- Live Search Bar -->
  <div style="margin-bottom: 20px; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
      <div style="flex: 1; min-width: 250px;">
        <input type="text" id="searchInput" placeholder="Search services by name, description, or category..."
               style="width: 100%; padding: 12px; border: 2px solid #ddd; border-radius: 6px; font-size: 16px; transition: border-color 0.3s;"
               onkeyup="performSearch()"
               onfocus="this.style.borderColor='#1f4a7c'"
               onblur="this.style.borderColor='#ddd'">
      </div>
      <button onclick="clearSearch()" class="btn btn-secondary" style="white-space: nowrap;">
        Clear Search
      </button>
    </div>
    <div id="searchStatus" style="margin-top: 8px; font-size: 14px; color: #666;"></div>
  </div>

  <div style="margin-bottom: 16px;">
    <% if (cid != null) { %>
      <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp" class="btn btn-secondary">← View All Services</a>
    <% } %>
    <a href="<%= request.getContextPath() %>/public/serviceCategories.jsp" class="btn btn-secondary">View by Category</a>
  </div>

  <div id="servicesGrid" class="grid" style="margin-top: 12px;">
    <% if (error != null) { %>
      <div class="card" style="grid-column: 1 / -1; border-color: rgba(180, 35, 24, 0.35); background: rgba(180, 35, 24, 0.06);">
        <p style="margin: 0; color: #7a271a; font-weight: 700;">Error loading services</p>
        <p style="margin: 8px 0 0 0; color: #7a271a;"><%= error %></p>
      </div>
    <% } else if (services == null || services.isEmpty()) { %>
      <div class="card" style="grid-column: 1 / -1; border-color: rgba(181, 71, 8, 0.35); background: rgba(181, 71, 8, 0.06);">
        <p style="margin: 0; font-weight: 700; color: #7a2e0e;">No services available</p>
        <% if (categoryName != null) { %>
          <p style="margin: 8px 0 0 0; color: #7a2e0e;">There are currently no services available in the "<%= categoryName %>" category.</p>
          <p style="margin: 12px 0 0 0;">
            <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp" class="btn btn-primary">View All Services</a>
            <a href="<%= request.getContextPath() %>/public/serviceCategories.jsp" class="btn btn-secondary" style="margin-left: 8px;">Browse Other Categories</a>
          </p>
        <% } else { %>
          <p style="margin: 8px 0 0 0; color: #7a2e0e;">There are currently no services available. Please check back later.</p>
        <% } %>
      </div>
    <% } else { %>
      <% for (Service s : services) { %>
        <div class="card">
          <h3><%= s.getServiceName() %></h3>
          <p><strong>Category:</strong> <%= s.getCategoryName() %></p>
          <p><%= s.getDescription() %></p>
          <p>From $<%= String.format("%.2f", s.getBasePrice()) %> / <%= s.getDurationMinutes() %> minutes</p>
          <p>
            <% if (session.getAttribute("sessUserId") != null) { %>
              <a href="<%= request.getContextPath() %>/customer/booking?action=create&serviceId=<%= s.getServiceId() %>" class="btn btn-primary">Book Now</a>
              <a href="<%= request.getContextPath() %>/customer/addToCartForm.jsp?serviceId=<%= s.getServiceId() %>" class="btn btn-secondary" style="margin-left: 8px;">Add to Cart</a>
            <% } else { %>
              <a href="<%= request.getContextPath() %>/auth/login.jsp" class="btn btn-primary">Login to Book</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/customer/viewFeedback.jsp?serviceId=<%= s.getServiceId() %>" class="btn btn-secondary" style="margin-left: 8px;">View Feedback</a>
          </p>
        </div>
      <% } %>
    <% } %>
  </div>
</div>

<!-- AJAX Live Search JavaScript -->
<script>
let searchTimeout = null;
const contextPath = '<%= request.getContextPath() %>';
const currentCategoryId = '<%= cid != null ? cid : "" %>';
const isLoggedIn = <%= session.getAttribute("sessUserId") != null %>;

// Perform search with debouncing (wait 300ms after user stops typing)
function performSearch() {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(function() {
    const query = document.getElementById('searchInput').value.trim();
    executeSearch(query);
  }, 300);
}

// Execute the AJAX search
function executeSearch(query) {
  const statusDiv = document.getElementById('searchStatus');
  const gridDiv = document.getElementById('servicesGrid');

  // Show loading status
  statusDiv.innerHTML = '<span style="color: #1f4a7c;">🔍 Searching...</span>';

  // Build URL with query parameters
  let url = contextPath + '/mvc/api/searchServices?q=' + encodeURIComponent(query);
  if (currentCategoryId) url += '&categoryId=' + currentCategoryId;

  // Perform AJAX request using Fetch API
  fetch(url)
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      // Check for error in response
      if (data.error) {
        throw new Error(data.error);
      }

      // Update search status
      if (query === '') {
        statusDiv.innerHTML = '';
      } else {
        statusDiv.innerHTML = '<span style="color: #28a745;">✓ Found ' + data.length + ' service(s)</span>';
      }

      // Render the results
      renderServices(data);
    })
    .catch(error => {
      statusDiv.innerHTML = '<span style="color: #dc3545;">⚠ Error: ' + escapeHtml(error.message) + '</span>';
      gridDiv.innerHTML = '<div class="card" style="grid-column: 1 / -1; background: #f8d7da; border-color: #f5c6cb; color: #721c24;"><p><strong>Error loading services:</strong> ' + escapeHtml(error.message) + '</p></div>';
    });
}

// Render services to the grid
function renderServices(services) {
  const gridDiv = document.getElementById('servicesGrid');

  if (services.length === 0) {
    gridDiv.innerHTML = '<div style="background: #fff3cd; border: 2px solid #ffc107; color: #856404; padding: 20px; border-radius: 8px; grid-column: 1 / -1;">' +
      '<p style="margin: 0; font-size: 16px;"><strong>ℹ No Services Found</strong></p>' +
      '<p style="margin: 8px 0 0 0;">No services match your search criteria. Try different keywords.</p>' +
      '</div>';
    return;
  }

  let html = '';
  services.forEach(function(service) {
    const bookButton = isLoggedIn
      ? '<a href="' + contextPath + '/customer/createBooking.jsp?serviceId=' + service.serviceId + '" class="btn btn-primary">Book Now</a>'
      : '<a href="' + contextPath + '/auth/login.jsp" class="btn btn-primary">Login to Book</a>';

    const cartButton = isLoggedIn
      ? '<a href="' + contextPath + '/customer/addToCartForm.jsp?serviceId=' + service.serviceId + '" class="btn btn-secondary" style="margin-left: 8px;">Add to Cart</a>'
      : '';

    html += '<div class="card">' +
      '<h3>' + escapeHtml(service.serviceName) + '</h3>' +
      '<p><strong>Category:</strong> ' + escapeHtml(service.categoryName) + '</p>' +
      '<p>' + escapeHtml(service.description) + '</p>' +
      '<p>From $' + service.basePrice + ' / ' + service.durationMinutes + ' minutes</p>' +
      '<p>' + bookButton + cartButton +
      '<a href="' + contextPath + '/customer/viewFeedback.jsp?serviceId=' + service.serviceId + '" class="btn btn-secondary" style="margin-left: 8px;">View Feedback</a>' +
      '</p>' +
      '</div>';
  });

  gridDiv.innerHTML = html;
}

// Clear search and reload original results
function clearSearch() {
  document.getElementById('searchInput').value = '';
  document.getElementById('searchStatus').innerHTML = '';

  // Reload the page to show original results
  if (currentCategoryId) {
    window.location.href = contextPath + '/public/serviceDetails.jsp?categoryId=' + currentCategoryId;
  } else {
    window.location.href = contextPath + '/public/serviceDetails.jsp';
  }
}

// Helper function to escape HTML to prevent XSS
function escapeHtml(text) {
  if (!text) return '';
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
</script>

<jsp:include page="../includes/footer.jsp"/>
