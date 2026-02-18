<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Category" %>
<%
  if (request.getAttribute("mvcLoaded") == null) {
    request.getRequestDispatcher("/mvc/public/serviceCategories").forward(request, response);
    return;
  }

  @SuppressWarnings("unchecked")
  List<Category> categories = (List<Category>) request.getAttribute("categories");
  String error = (String) request.getAttribute("error");
%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Service Categories"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container service-categories">
  <div class="page-header">
    <h1>Service Categories</h1>
    <p class="page-subtitle">Browse all service types and jump into booking in seconds.</p>
  </div>

  <div class="action-row">
    <a href="<%= request.getContextPath() %>/mvc/public/serviceDetails" class="btn btn-secondary">View All Services</a>
  </div>

  <div class="feature-grid">
    <div class="card feature-card feature-escort">
      <div class="feature-body">
        <div>
          <h3>✨ Medical Escort</h3>
          <p>Professional accompaniment for medical appointments.</p>
        </div>
        <a href="${pageContext.request.contextPath}/customer/medical-escort" class="btn btn-primary">Book Now</a>
      </div>
    </div>
  </div>

  <div class="grid category-grid">
    <% if (error != null) { %>
      <div class="card alert-card alert-error">
        <p class="alert-title">Error loading categories</p>
        <p class="alert-text"><%= error %></p>
      </div>
    <% } else if (categories == null || categories.isEmpty()) { %>
      <div class="card alert-card alert-warning">
        <p class="alert-title">No categories available</p>
        <p class="alert-text">There are currently no service categories available. Please check back later.</p>
      </div>
    <% } else { %>
      <% for (Category c : categories) { %>
        <div class="card category-card">
          <div class="category-body">
            <h3><%= c.getCategoryName() %></h3>
            <p><%= c.getDescription() %></p>
          </div>
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/mvc/public/serviceDetails?categoryId=<%= c.getCategoryId() %>">View Services</a>
        </div>
      <% } %>
    <% } %>
  </div>
</div>
<style>
  .service-categories {
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

  .action-row {
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
    margin-bottom: 1.5rem;
  }

  .feature-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
  }

  .feature-card {
    border: 1px solid rgba(148, 163, 184, 0.2);
    background: linear-gradient(145deg, rgba(18, 20, 30, 0.98), rgba(9, 10, 18, 0.95));
    transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
  }

  .feature-card:hover {
    transform: translateY(-4px);
    border-color: rgba(129, 140, 248, 0.5);
    box-shadow: 0 20px 35px rgba(15, 23, 42, 0.35);
  }

  .feature-escort {
    border-left: 4px solid var(--coral);
  }

  .feature-partner {
    border-left: 4px solid var(--accent);
    background: linear-gradient(145deg, rgba(18, 20, 30, 0.98), rgba(46, 49, 86, 0.9));
  }

  .feature-partner h3 {
    color: #a5b4fc;
  }

  .feature-body {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 1.5rem;
  }

  .feature-body h3 {
    margin-top: 0;
  }

  .feature-body p {
    margin-bottom: 0;
    font-size: 0.9rem;
    color: var(--foreground-muted);
  }

  .category-grid {
    margin-top: 1rem;
    gap: 1.5rem;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  }

  .category-card {
    display: flex;
    flex-direction: column;
    gap: 1.25rem;
    border: 1px solid rgba(148, 163, 184, 0.2);
    background: linear-gradient(145deg, rgba(18, 20, 30, 0.98), rgba(9, 10, 18, 0.95));
    padding: 1.5rem;
  }

  .category-body h3 {
    margin-top: 0;
    font-size: 1.15rem;
  }

  .category-body p {
    color: var(--foreground-muted);
    margin-bottom: 0;
  }

  .alert-card {
    grid-column: 1 / -1;
    border: 1px solid rgba(148, 163, 184, 0.2);
    background: rgba(15, 16, 25, 0.95);
    padding: 1.5rem;
  }

  .alert-title {
    margin: 0;
    font-weight: 700;
  }

  .alert-text {
    margin-top: 0.5rem;
    color: var(--foreground-muted);
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
    .page-header {
      padding: 1.5rem;
    }

    .feature-body {
      flex-direction: column;
      align-items: flex-start;
    }
  }
</style>
<jsp:include page="../includes/footer.jsp"/>
