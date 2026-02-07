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
<div class="container service-details">
  <div class="page-header">
    <% if (categoryName != null) { %>
      <h1>Services - <%= categoryName %></h1>
    <% } else { %>
      <h1>All Services</h1>
    <% } %>
    <p class="page-subtitle">Find the right support service and book in minutes.</p>
  </div>

  <div class="search-panel">
    <div class="search-row">
      <div class="search-field">
        <input type="text" id="searchInput" placeholder="Search services by name, description, or category..."
               class="search-input"
               onkeyup="performSearch()">
      </div>
      <button onclick="clearSearch()" class="btn btn-secondary search-clear">
        Clear Search
      </button>
    </div>
    <div id="searchStatus" class="search-status"></div>
  </div>

  <div class="action-row">
    <% if (cid != null) { %>
      <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp" class="btn btn-secondary">← View All Services</a>
    <% } %>
    <a href="<%= request.getContextPath() %>/public/serviceCategories.jsp" class="btn btn-secondary">View by Category</a>
  </div>

  <div id="servicesGrid" class="grid service-grid">
    <% if (error != null) { %>
      <div class="card alert-card alert-error">
        <p class="alert-title">Error loading services</p>
        <p class="alert-text"><%= error %></p>
      </div>
    <% } else if (services == null || services.isEmpty()) { %>
      <div class="card alert-card alert-warning">
        <p class="alert-title">No services available</p>
        <% if (categoryName != null) { %>
          <p class="alert-text">There are currently no services available in the "<%= categoryName %>" category.</p>
          <div class="alert-actions">
            <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp" class="btn btn-primary">View All Services</a>
            <a href="<%= request.getContextPath() %>/public/serviceCategories.jsp" class="btn btn-secondary">Browse Other Categories</a>
          </div>
        <% } else { %>
          <p class="alert-text">There are currently no services available. Please check back later.</p>
        <% } %>
      </div>
    <% } else { %>
      <% for (Service s : services) { %>
        <div class="card service-card">
          <div class="service-card-header">
            <h3><%= s.getServiceName() %></h3>
            <span class="service-category"><%= s.getCategoryName() %></span>
          </div>
          <p class="service-description"><%= s.getDescription() %></p>
          <div class="service-meta">
            <span class="service-price">From $<%= String.format("%.2f", s.getBasePrice()) %></span>
            <span class="service-duration"><%= s.getDurationMinutes() %> minutes</span>
          </div>
          <div class="service-actions">
            <% if (session.getAttribute("sessUserId") != null) { %>
              <a href="<%= request.getContextPath() %>/customer/addToCartForm.jsp?serviceId=<%= s.getServiceId() %>" class="btn btn-primary">Book Now</a>
              <a href="<%= request.getContextPath() %>/customer/addToCartForm.jsp?serviceId=<%= s.getServiceId() %>" class="btn btn-secondary">Add to Cart</a>
            <% } else { %>
              <a href="<%= request.getContextPath() %>/auth/login.jsp" class="btn btn-primary">Login to Book</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/customer/viewFeedback.jsp?serviceId=<%= s.getServiceId() %>" class="btn btn-secondary">View Feedback</a>
          </div>
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
  statusDiv.innerHTML = '<span class="status-info">🔍 Searching...</span>';

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
        statusDiv.innerHTML = '<span class="status-success">✓ Found ' + data.length + ' service(s)</span>';
      }

      // Render the results
      renderServices(data);
    })
    .catch(error => {
      statusDiv.innerHTML = '<span class="status-error">⚠ Error: ' + escapeHtml(error.message) + '</span>';
      gridDiv.innerHTML = '<div class="card alert-card alert-error"><p class="alert-title">Error loading services:</p><p class="alert-text">' + escapeHtml(error.message) + '</p></div>';
    });
}

// Render services to the grid
function renderServices(services) {
  const gridDiv = document.getElementById('servicesGrid');

  if (services.length === 0) {
    gridDiv.innerHTML = '<div class="card alert-card alert-warning">' +
      '<p class="alert-title">ℹ No Services Found</p>' +
      '<p class="alert-text">No services match your search criteria. Try different keywords.</p>' +
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

    html += '<div class="card service-card">' +
      '<div class="service-card-header">' +
      '<h3>' + escapeHtml(service.serviceName) + '</h3>' +
      '<span class="service-category">' + escapeHtml(service.categoryName) + '</span>' +
      '</div>' +
      '<p class="service-description">' + escapeHtml(service.description) + '</p>' +
      '<div class="service-meta">' +
      '<span class="service-price">From $' + service.basePrice + '</span>' +
      '<span class="service-duration">' + service.durationMinutes + ' minutes</span>' +
      '</div>' +
      '<div class="service-actions">' + bookButton + cartButton +
      '<a href="' + contextPath + '/customer/viewFeedback.jsp?serviceId=' + service.serviceId + '" class="btn btn-secondary">View Feedback</a>' +
      '</div>' +
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
<style>
  .service-details {
    margin-top: 2.5rem;
    margin-bottom: 5rem;
  }

  .page-header {
    margin-bottom: 2rem;
    padding: 2rem 2.5rem;
    border-radius: var(--radius-2xl);
    border: 1px solid rgba(99, 102, 241, 0.2);
    background: radial-gradient(circle at top left, rgba(99, 102, 241, 0.18), rgba(15, 16, 25, 0.95));
    box-shadow: var(--shadow-lg);
  }

  .page-header h1 {
    font-size: clamp(2rem, 3vw, 2.75rem);
    letter-spacing: -0.02em;
  }

  .page-subtitle {
    color: var(--foreground-muted);
    margin-top: 0.5rem;
    max-width: 640px;
    font-size: 1rem;
  }

  .search-panel {
    background: linear-gradient(135deg, rgba(20, 22, 33, 0.95), rgba(15, 16, 25, 0.85));
    padding: 1.5rem;
    border-radius: var(--radius-2xl);
    border: 1px solid rgba(148, 163, 184, 0.2);
    box-shadow: var(--shadow-md);
    margin-bottom: 1.5rem;
  }

  .search-row {
    display: flex;
    gap: 1rem;
    align-items: center;
    flex-wrap: wrap;
  }

  .search-field {
    flex: 1;
    min-width: 240px;
  }

  .search-input {
    width: 100%;
    padding: 0.75rem 1rem;
    border-radius: var(--radius-lg);
    border: 1px solid rgba(148, 163, 184, 0.3);
    background: rgba(10, 11, 18, 0.9);
    color: var(--foreground);
    font-size: 1rem;
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
  }

  .search-input:focus {
    outline: none;
    border-color: var(--border-accent);
    box-shadow: 0 0 0 2px rgba(94, 106, 210, 0.35);
  }

  .search-input::placeholder {
    color: var(--foreground-muted);
  }

  .search-clear {
    white-space: nowrap;
  }

  .search-status {
    margin-top: 0.75rem;
    font-size: 0.875rem;
    color: var(--foreground-muted);
  }

  .status-info {
    color: #7ab6ff;
  }

  .status-success {
    color: #7fe6b0;
  }

  .status-error {
    color: #fca5a5;
  }

  .action-row {
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
    margin-bottom: 1.5rem;
  }

  .service-grid {
    margin-top: 1rem;
    gap: 1.5rem;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  }

  .service-card {
    padding: 1.75rem;
    border: 1px solid rgba(148, 163, 184, 0.2);
    background: linear-gradient(145deg, rgba(18, 20, 30, 0.98), rgba(9, 10, 18, 0.95));
    transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
  }

  .service-card:hover {
    transform: translateY(-4px);
    border-color: rgba(129, 140, 248, 0.5);
    box-shadow: 0 20px 35px rgba(15, 23, 42, 0.35);
  }

  .service-card-header {
    display: flex;
    justify-content: space-between;
    gap: 1rem;
    align-items: flex-start;
    flex-wrap: wrap;
  }

  .service-card-header h3 {
    font-size: 1.2rem;
    letter-spacing: -0.01em;
  }

  .service-category {
    font-size: 0.875rem;
    color: #c7d2fe;
    background: rgba(79, 70, 229, 0.18);
    border: 1px solid rgba(129, 140, 248, 0.4);
    padding: 0.25rem 0.75rem;
    border-radius: 999px;
  }

  .service-description {
    color: var(--foreground-muted);
    margin-top: 0.75rem;
  }

  .service-meta {
    margin-top: 1.25rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 1rem;
    color: var(--foreground-subtle);
    font-size: 0.95rem;
  }

  .service-price {
    font-size: 1.125rem;
    font-weight: 600;
    color: #a5b4fc;
  }

  .service-actions {
    margin-top: 1.5rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .alert-card {
    grid-column: 1 / -1;
    padding: 1.75rem;
    border: 1px solid rgba(148, 163, 184, 0.2);
    background: rgba(15, 16, 25, 0.95);
  }

  .alert-title {
    margin: 0;
    font-weight: 700;
  }

  .alert-text {
    margin-top: 0.5rem;
    color: var(--foreground-muted);
  }

  .alert-actions {
    margin-top: 1rem;
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
  }

  .alert-error {
    border-color: rgba(248, 113, 113, 0.4);
    background: rgba(248, 113, 113, 0.08);
  }

  .alert-error .alert-title,
  .alert-error .alert-text {
    color: #fca5a5;
  }

  .alert-warning {
    border-color: rgba(251, 191, 36, 0.4);
    background: rgba(251, 191, 36, 0.08);
  }

  .alert-warning .alert-title {
    color: #fde68a;
  }

  @media (max-width: 768px) {
    .search-panel {
      padding: 1.25rem;
    }

    .page-header {
      padding: 1.5rem;
    }

    .service-card {
      padding: 1.5rem;
    }
  }
</style>

<jsp:include page="../includes/footer.jsp"/>
