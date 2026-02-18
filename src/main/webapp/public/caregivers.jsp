<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Caregiver" %>
<%
  if (request.getAttribute("mvcLoaded") == null) {
    request.getRequestDispatcher("/mvc/public/caregivers").forward(request, response);
    return;
  }

  @SuppressWarnings("unchecked")
  List<Caregiver> caregivers = (List<Caregiver>) request.getAttribute("caregivers");
  String error = (String) request.getAttribute("error");
%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Our Caregivers"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Meet Our Caregivers</h1>
  <p>Our experienced and compassionate caregivers are here to provide the best care for your loved ones.</p>

  <!-- Live Search Bar -->
  <div class="card" style="margin: 20px 0; padding: 20px;">
    <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
      <div style="flex: 1; min-width: 250px;">
        <input type="text" id="searchInput" placeholder="Search caregivers by name, qualifications, or specialties..."
               style="width: 100%; padding: 12px; background: rgba(0,0,0,0.2); border: 1px solid var(--border-default); border-radius: 6px; color: var(--foreground); font-size: 16px; transition: all 0.3s;"
               onkeyup="performSearch()"
               onfocus="this.style.borderColor='var(--accent)'; this.style.boxShadow='0 0 0 1px var(--accent)'"
               onblur="this.style.borderColor='var(--border-default)'; this.style.boxShadow='none'">
      </div>
      <button onclick="clearSearch()" class="btn btn-secondary" style="white-space: nowrap;">
        Clear Search
      </button>
    </div>
    <div id="searchStatus" style="margin-top: 8px; font-size: 14px; color: var(--foreground-muted);"></div>
  </div>

  <div id="caregiversGrid" class="grid" style="margin-top: 20px;">
    <% if (error != null) { %>
      <div class="card" style="grid-column: 1 / -1; border: 1px solid rgba(220, 53, 69, 0.3); background: rgba(220, 53, 69, 0.1);">
        <p style="margin: 0; color: #ff6b6b; font-weight: 700;">Error loading caregivers</p>
        <p style="margin: 8px 0 0 0; color: #ff6b6b;"><%= error %></p>
      </div>
    <% } else if (caregivers == null || caregivers.isEmpty()) { %>
      <div class="card" style="grid-column: 1 / -1; text-align: center; padding: 40px; background: rgba(255, 193, 7, 0.1); border: 1px solid rgba(255, 193, 7, 0.3);">
        <h3 style="color: #ffc107;">No Caregivers Available</h3>
        <p style="color: rgba(255, 255, 255, 0.7);">We are currently updating our caregiver roster. Please check back soon!</p>
        <p style="margin-top: 16px;">
          <a href="<%= request.getContextPath() %>/mvc/public/serviceDetails" class="btn btn-primary">View Our Services</a>
        </p>
      </div>
    <% } else { %>
      <% for (Caregiver c : caregivers) { %>
        <div class="card">
          <div style="text-align: center; margin-bottom: 16px;">
            <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, var(--accent) 0%, var(--accent-bright) 100%); display: flex; align-items: center; justify-content: center; margin: 0 auto; color: white; font-size: 32px; font-weight: bold;">
              <%= c.getName() == null || c.getName().isEmpty() ? "?" : c.getName().substring(0, 1).toUpperCase() %>
            </div>
          </div>

          <h3 style="text-align: center; margin: 8px 0;"><%= c.getName() %></h3>

          <% if (c.getExperienceYears() != null && c.getExperienceYears() > 0) { %>
            <p style="text-align: center; color: var(--accent); font-weight: bold; margin: 8px 0;">
              <%= c.getExperienceYears() %> <%= c.getExperienceYears() == 1 ? "year" : "years" %> of experience
            </p>
          <% } %>

          <hr style="margin: 12px 0; border: none; border-top: 1px solid var(--border-default);">

          <% if (c.getQualifications() != null && !c.getQualifications().trim().isEmpty()) { %>
            <div style="margin: 12px 0;">
              <p style="font-weight: bold; color: var(--accent); margin-bottom: 8px;">Qualifications:</p>
              <ul style="margin: 0; padding-left: 20px; color: var(--muted-foreground);">
                <% for (String qual : c.getQualifications().split(",")) { %>
                  <li style="margin-bottom: 4px;"><%= qual.trim() %></li>
                <% } %>
              </ul>
            </div>
          <% } %>

          <% if (c.getSpecialties() != null && !c.getSpecialties().trim().isEmpty()) { %>
            <div style="margin: 12px 0;">
              <p style="font-weight: bold; color: var(--accent); margin-bottom: 8px;">Specialties:</p>
              <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                <% for (String specialty : c.getSpecialties().split(",")) { %>
                  <span style="background: rgba(94, 106, 210, 0.1); color: var(--accent-bright); padding: 4px 10px; border-radius: 12px; font-size: 13px; border: 1px solid var(--accent);">
                    <%= specialty.trim() %>
                  </span>
                <% } %>
              </div>
            </div>
          <% } %>

          <% if (c.getBio() != null && !c.getBio().trim().isEmpty()) { %>
            <div style="margin: 16px 0; padding: 12px; background: var(--surface); border-left: 3px solid var(--accent); border-radius: 4px;">
              <p style="font-style: italic; color: var(--muted-foreground); margin: 0; line-height: 1.6;">
                "<%= c.getBio() %>"
              </p>
            </div>
          <% } %>
        </div>
      <% } %>
    <% } %>
  </div>

  <div style="margin-top: 24px; text-align: center;">
    <a href="<%= request.getContextPath() %>/mvc/public/serviceCategories" class="btn btn-secondary">View Service Categories</a>
    <a href="<%= request.getContextPath() %>/mvc/public/serviceDetails" class="btn btn-secondary">View All Services</a>
  </div>
</div>

<!-- AJAX Live Search JavaScript -->
<script>
let searchTimeout = null;
const contextPath = '<%= request.getContextPath() %>';
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
  const gridDiv = document.getElementById('caregiversGrid');

  // Show loading status
  statusDiv.innerHTML = '<span style="color: var(--accent);">🔍 Searching...</span>';

  // Build URL with query parameter
  const url = contextPath + '/mvc/api/searchCaregivers?q=' + encodeURIComponent(query);

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
        statusDiv.innerHTML = '<span style="color: #28a745;">✓ Found ' + data.length + ' caregiver(s)</span>';
      }

      // Render the results
      renderCaregivers(data);
    })
    .catch(error => {
      statusDiv.innerHTML = '<span style="color: #ff6b6b;">⚠ Error: ' + escapeHtml(error.message) + '</span>';
      gridDiv.innerHTML = '<div class="card" style="background: rgba(220, 53, 69, 0.1); border: 1px solid rgba(220, 53, 69, 0.3); color: #ff6b6b; grid-column: 1 / -1;"><p><strong>Error loading caregivers:</strong> ' + escapeHtml(error.message) + '</p></div>';
    });
}

// Render caregivers to the grid
function renderCaregivers(caregivers) {
  const gridDiv = document.getElementById('caregiversGrid');

  if (caregivers.length === 0) {
    gridDiv.innerHTML = '<div class="card" style="grid-column: 1 / -1; text-align: center; padding: 40px; background: rgba(255, 193, 7, 0.1); border: 1px solid rgba(255, 193, 7, 0.3); color: #ffc107;">' +
      '<h3>No Caregivers Found</h3>' +
      '<p style="color: rgba(255, 255, 255, 0.7);">No caregivers match your search criteria. Try different keywords.</p>' +
      '</div>';
    return;
  }

  let html = '';
  caregivers.forEach(function(caregiver) {
    const initial = caregiver.name ? caregiver.name.substring(0, 1).toUpperCase() : '?';
    const experienceYears = caregiver.experienceYears;
    let experienceText = '';
    if (experienceYears && experienceYears > 0) {
      const yearWord = experienceYears === 1 ? 'year' : 'years';
      experienceText = '<p style="text-align: center; color: var(--accent); font-weight: bold; margin: 8px 0;">' +
        experienceYears + ' ' + yearWord + ' of experience</p>';
    }

    // Parse qualifications
    let qualificationsHtml = '';
    if (caregiver.qualifications && caregiver.qualifications.trim() !== '') {
      const qualsList = caregiver.qualifications.split(',').map(function(q) { return q.trim(); }).filter(function(q) { return q; });
      if (qualsList.length > 0) {
        qualificationsHtml = '<div style="margin: 12px 0;">' +
          '<p style="font-weight: bold; color: var(--accent); margin-bottom: 8px;">Qualifications:</p>' +
          '<ul style="margin: 0; padding-left: 20px; color: var(--muted-foreground);">';
        qualsList.forEach(function(q) {
          qualificationsHtml += '<li style="margin-bottom: 4px;">' + escapeHtml(q) + '</li>';
        });
        qualificationsHtml += '</ul></div>';
      }
    }

    // Parse specialties
    let specialtiesHtml = '';
    if (caregiver.specialties && caregiver.specialties.trim() !== '') {
      const specialtiesList = caregiver.specialties.split(',').map(function(s) { return s.trim(); }).filter(function(s) { return s; });
      if (specialtiesList.length > 0) {
        specialtiesHtml = '<div style="margin: 12px 0;">' +
          '<p style="font-weight: bold; color: var(--accent); margin-bottom: 8px;">Specialties:</p>' +
          '<div style="display: flex; flex-wrap: wrap; gap: 6px;">';
        specialtiesList.forEach(function(s) {
          specialtiesHtml += '<span style="background: rgba(94, 106, 210, 0.1); color: var(--accent-bright); padding: 4px 10px; border-radius: 12px; font-size: 13px; border: 1px solid var(--accent);">' +
            escapeHtml(s) + '</span>';
        });
        specialtiesHtml += '</div></div>';
      }
    }

    // Bio quote
    let bioHtml = '';
    if (caregiver.bio && caregiver.bio.trim() !== '') {
      bioHtml = '<div style="margin: 16px 0; padding: 12px; background: var(--surface); border-left: 3px solid var(--accent); border-radius: 4px;">' +
        '<p style="font-style: italic; color: var(--muted-foreground); margin: 0; line-height: 1.6;">"' + escapeHtml(caregiver.bio) + '"</p></div>';
    }

    // Contact info
    let contactHtml = '';
    if (caregiver.email) {
      contactHtml = '<p style="text-align: center; margin-top: 16px; font-size: 14px; color: var(--muted-foreground);">' +
        '<strong>Contact:</strong> ' + escapeHtml(caregiver.email) + '</p>';
    }

    html += '<div class="card">' +
      '<div style="text-align: center; margin-bottom: 16px;">' +
      '<div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, var(--accent) 0%, var(--accent-bright) 100%); display: flex; align-items: center; justify-content: center; margin: 0 auto; color: white; font-size: 32px; font-weight: bold;">' +
      initial + '</div></div>' +
      '<h3 style="text-align: center; margin: 8px 0;">' + escapeHtml(caregiver.name) + '</h3>' +
      experienceText +
      '<hr style="margin: 12px 0; border: none; border-top: 1px solid var(--border-default);">' +
      qualificationsHtml +
      specialtiesHtml +
      bioHtml +
      contactHtml +
      '</div>';
  });

  gridDiv.innerHTML = html;
}

// Clear search and reload original results
function clearSearch() {
  document.getElementById('searchInput').value = '';
  document.getElementById('searchStatus').innerHTML = '';
  window.location.href = contextPath + '/mvc/public/caregivers';
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
