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
<div class="container">
  <h1>Service Categories</h1>

  <div style="margin-bottom: 16px;">
    <a href="<%= request.getContextPath() %>/public/serviceDetails.jsp" class="btn btn-secondary">View All Services</a>
  </div>

  <!-- Special Medical Escort Service -->
  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 2rem;">
      <div class="card" style="border-left: 4px solid var(--coral); margin: 0;">
          <div style="display: flex; justify-content: space-between; align-items: center; height: 100%;">
              <div>
                  <h3 style="margin-top: 0;">🚑 Medical Escort</h3>
                  <p style="margin-bottom: 0; font-size: 0.875rem;">Professional accompaniment for medical appointments.</p>
              </div>
              <a href="${pageContext.request.contextPath}/customer/medical-escort" class="btn btn-primary" style="flex-shrink: 0;">Book Now</a>
          </div>
      </div>

      <div class="card" style="border-left: 4px solid var(--accent); margin: 0; background: linear-gradient(135deg, var(--surface), rgba(94, 106, 210, 0.05));">
          <div style="display: flex; justify-content: space-between; align-items: center; height: 100%;">
              <div>
                  <h3 style="margin-top: 0; color: var(--accent);">🤝 SilverCare Partners</h3>
                  <p style="margin-bottom: 0; font-size: 0.875rem;">Premium services provided by our trusted agency partners.</p>
              </div>
              <a href="${pageContext.request.contextPath}/customer/company?id=1" class="btn btn-secondary" style="flex-shrink: 0;">Visit Partner</a>
          </div>
      </div>
  </div>

  <div class="grid" style="margin-top: 12px;">
    <% if (error != null) { %>
      <div class="card" style="grid-column: 1 / -1; border-color: rgba(180, 35, 24, 0.35); background: rgba(180, 35, 24, 0.06);">
        <p style="margin: 0; color: #7a271a; font-weight: 700;">Error loading categories</p>
        <p style="margin: 8px 0 0 0; color: #7a271a;"><%= error %></p>
      </div>
    <% } else if (categories == null || categories.isEmpty()) { %>
      <div class="card" style="grid-column: 1 / -1; border-color: rgba(181, 71, 8, 0.35); background: rgba(181, 71, 8, 0.06);">
        <p style="margin: 0; font-weight: 700; color: #7a2e0e;">No categories available</p>
        <p style="margin: 8px 0 0 0; color: #7a2e0e;">There are currently no service categories available. Please check back later.</p>
      </div>
    <% } else { %>
      <% for (Category c : categories) { %>
        <div class="card">
          <h3><%= c.getCategoryName() %></h3>
          <p><%= c.getDescription() %></p>
          <p><a class="btn btn-primary" href="${pageContext.request.contextPath}/public/serviceDetails.jsp?categoryId=<%= c.getCategoryId() %>">View Services</a></p>
        </div>
      <% } %>
    <% } %>
  </div>
</div>
<jsp:include page="../includes/footer.jsp"/>
