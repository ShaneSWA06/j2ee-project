<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Company, model.Caregiver, model.Service, java.util.List" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Company Profile"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<%
    Company company = (Company) request.getAttribute("company");
    List<Caregiver> caregivers = (List<Caregiver>) request.getAttribute("caregivers");
    List<Service> services = (List<Service>) request.getAttribute("services");
%>

<div class="container" style="margin-top: 3rem;">
    <!-- Company Header -->
    <div class="card" style="padding: 3rem; margin-bottom: 3rem; background: linear-gradient(135deg, var(--surface), rgba(94, 106, 210, 0.1)); border-color: var(--border-accent);">
        <div style="display: flex; gap: 2rem; align-items: center; flex-wrap: wrap;">
            <% if (company.getLogoUrl() != null) { %>
                <img src="<%= company.getLogoUrl() %>" alt="<%= company.getName() %>" style="width: 120px; height: 120px; border-radius: var(--radius-xl); object-fit: cover; border: 1px solid var(--border-default);">
            <% } else { %>
                <div style="width: 120px; height: 120px; border-radius: var(--radius-xl); background: var(--accent); display: flex; align-items: center; justify-content: center; font-size: 3rem; color: white;">
                    <%= company.getName().substring(0, 1) %>
                </div>
            <% } %>
            
            <div style="flex: 1; min-width: 300px;">
                <h1 style="margin-bottom: 0.5rem; font-size: 2.5rem;"><%= company.getName() %></h1>
                <p style="font-size: 1.125rem; color: var(--foreground-muted); margin-bottom: 1.5rem;"><%= company.getDescription() %></p>
                
                <div style="display: flex; gap: 2rem; flex-wrap: wrap;">
                    <div style="display: flex; align-items: center; gap: 0.5rem; color: var(--foreground-subtle);">
                        <span>📍</span> <%= company.getAddress() %>
                    </div>
                    <div style="display: flex; align-items: center; gap: 0.5rem; color: var(--foreground-subtle);">
                        <span>📞</span> <%= company.getPhone() %>
                    </div>
                    <div style="display: flex; align-items: center; gap: 0.5rem; color: var(--foreground-subtle);">
                        <span>⭐</span> <%= String.format("%.1f", company.getRating()) %> / 5.0 Rating
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Services Section -->
    <div class="section-title">
        <h2>Available Services</h2>
        <p>Professional care services provided by <%= company.getName() %></p>
    </div>
    
    <div class="grid grid-cols-3" style="gap: 1.5rem; margin-bottom: 5rem;">
        <% if (services != null && !services.isEmpty()) { 
            for (Service service : services) { %>
            <div class="card feature-card">
                <h3><%= service.getServiceName() %></h3>
                <p><%= service.getDescription() %></p>
                <div style="margin-top: 1.5rem; display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-weight: 700; color: var(--accent); font-size: 1.25rem;">$<%= String.format("%.2f", service.getBasePrice()) %></span>
                    <span style="color: var(--foreground-muted); font-size: 0.875rem;"><%= service.getDurationMinutes() %> min</span>
                </div>
                <a href="<%= request.getContextPath() %>/customer/addToCartForm.jsp?serviceId=<%= service.getServiceId() %>" class="btn btn-primary" style="width: 100%; margin-top: 1.5rem;">Book Service</a>
            </div>
        <% } } else { %>
            <p style="grid-column: span 3; text-align: center; color: var(--foreground-muted);">No services available at this time.</p>
        <% } %>
    </div>

    <!-- Caregivers Section -->
    <div class="section-title">
        <h2>Our Expert Caregivers</h2>
        <p>Dedicated professionals from <%= company.getName() %> ready to assist you</p>
    </div>

    <div class="grid grid-cols-2" style="gap: 2rem; margin-bottom: 5rem;">
        <% if (caregivers != null && !caregivers.isEmpty()) { 
            for (Caregiver caregiver : caregivers) { %>
            <div class="card" style="padding: 1.5rem; display: flex; gap: 1.5rem; align-items: flex-start;">
                <img src="<%= caregiver.getProfileImage() != null ? caregiver.getProfileImage() : "https://ui-avatars.com/api/?name=" + caregiver.getName() %>" 
                     alt="<%= caregiver.getName() %>" 
                     style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
                
                <div style="flex: 1;">
                    <h3 style="margin: 0;"><%= caregiver.getName() %></h3>
                    <p style="color: var(--accent); font-weight: 600; font-size: 0.875rem; margin-bottom: 0.5rem;"><%= caregiver.getSpecialties() %></p>
                    <p style="font-size: 0.875rem; margin-bottom: 1rem; line-height: 1.4;"><%= caregiver.getBio() != null ? caregiver.getBio() : "" %></p>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-size: 0.875rem; color: var(--foreground-subtle);">⭐ <%= caregiver.getRating() %> Rating</span>
                        <a href="<%= request.getContextPath() %>/customer/addToCartForm.jsp?caregiverId=<%= caregiver.getCaregiverId() %>" class="btn btn-secondary btn-sm">Select Caregiver</a>
                    </div>
                </div>
            </div>
        <% } } else { %>
            <p style="grid-column: span 2; text-align: center; color: var(--foreground-muted);">No caregivers available at this time.</p>
        <% } %>
    </div>
</div>

<style>
    .grid-cols-2 { grid-template-columns: repeat(2, 1fr); }
    @media (max-width: 768px) {
        .grid-cols-2, .grid-cols-3 { grid-template-columns: 1fr; }
    }
</style>

<jsp:include page="../includes/footer.jsp"/>
