<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Company, model.Caregiver, model.Service, java.util.List" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Company Profile"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<%
    Company company = (Company) request.getAttribute("company");
    List<Caregiver> caregivers = (List<Caregiver>) request.getAttribute("caregivers");
    List<Service> services = (List<Service>) request.getAttribute("services");
%>

<div class="container company-profile">
    <div class="card company-hero">
        <div class="company-hero-content">
            <% if (company.getLogoUrl() != null) { %>
                <img src="<%= company.getLogoUrl() %>" alt="<%= company.getName() %>" class="company-logo">
            <% } else { %>
                <div class="company-logo company-logo-fallback">
                    <%= company.getName().substring(0, 1) %>
                </div>
            <% } %>
            
            <div class="company-hero-details">
                <h1 class="company-name"><%= company.getName() %></h1>
                <p class="company-description"><%= company.getDescription() %></p>
                
                <div class="company-meta">
                    <div class="meta-item">
                        <span>📍</span> <%= company.getAddress() %>
                    </div>
                    <div class="meta-item">
                        <span>📞</span> <%= company.getPhone() %>
                    </div>
                    <div class="meta-item">
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
    
    <div class="grid grid-cols-3 services-grid">
        <% if (services != null && !services.isEmpty()) { 
            for (Service service : services) { %>
            <div class="card feature-card service-card">
                <h3 class="service-title"><%= service.getServiceName() %></h3>
                <p class="service-description"><%= service.getDescription() %></p>
                <div class="service-meta">
                    <span class="service-price">$<%= String.format("%.2f", service.getBasePrice()) %></span>
                    <span class="service-duration"><%= service.getDurationMinutes() %> min</span>
                </div>
                <a href="<%= request.getContextPath() %>/customer/addToCartForm.jsp?serviceId=<%= service.getServiceId() %>" class="btn btn-primary service-cta">Book Service</a>
            </div>
        <% } } else { %>
            <p class="empty-state full-span">No services available at this time.</p>
        <% } %>
    </div>

    <!-- Caregivers Section -->
    <div class="section-title">
        <h2>Our Expert Caregivers</h2>
        <p>Dedicated professionals from <%= company.getName() %> ready to assist you</p>
    </div>

    <div class="grid grid-cols-2 caregiver-grid">
        <% if (caregivers != null && !caregivers.isEmpty()) { 
            for (Caregiver caregiver : caregivers) { %>
            <div class="card caregiver-card">
                <img src="<%= caregiver.getProfileImage() != null ? caregiver.getProfileImage() : "https://ui-avatars.com/api/?name=" + caregiver.getName() %>" 
                     alt="<%= caregiver.getName() %>" 
                     class="caregiver-avatar">
                
                <div class="caregiver-details">
                    <h3 class="caregiver-name"><%= caregiver.getName() %></h3>
                    <p class="caregiver-specialty"><%= caregiver.getSpecialties() %></p>
                    <p class="caregiver-bio"><%= caregiver.getBio() != null ? caregiver.getBio() : "" %></p>
                    
                    <div class="caregiver-footer">
                        <span class="rating-pill">⭐ <%= caregiver.getRating() %> Rating</span>
                        <a href="<%= request.getContextPath() %>/customer/addToCartForm.jsp?caregiverId=<%= caregiver.getCaregiverId() %>" class="btn btn-secondary btn-sm">Select Caregiver</a>
                    </div>
                </div>
            </div>
        <% } } else { %>
            <p class="empty-state full-span">No caregivers available at this time.</p>
        <% } %>
    </div>
</div>

<style>
    .company-profile {
        margin-top: 3rem;
    }

    .company-hero {
        padding: 3rem;
        margin-bottom: 3rem;
        background: linear-gradient(135deg, rgba(94, 106, 210, 0.16), rgba(255, 255, 255, 0.04));
        border-color: var(--border-accent);
    }

    .company-hero-content {
        display: flex;
        gap: 2rem;
        align-items: center;
        flex-wrap: wrap;
    }

    .company-logo {
        width: 120px;
        height: 120px;
        border-radius: var(--radius-xl);
        object-fit: cover;
        border: 1px solid var(--border-default);
    }

    .company-logo-fallback {
        background: var(--accent);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 3rem;
        color: white;
    }

    .company-hero-details {
        flex: 1;
        min-width: 280px;
    }

    .company-name {
        margin-bottom: 0.5rem;
        font-size: clamp(2rem, 4vw, 2.75rem);
    }

    .company-description {
        font-size: 1.0625rem;
        color: var(--foreground-muted);
        margin-bottom: 1.5rem;
    }

    .company-meta {
        display: flex;
        gap: 1.5rem;
        flex-wrap: wrap;
    }

    .meta-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: var(--foreground-subtle);
        font-size: 0.95rem;
    }

    .services-grid {
        gap: 1.5rem;
        margin-bottom: 5rem;
    }

    .service-card {
        padding: 2rem;
    }

    .service-title {
        margin-bottom: 0.75rem;
    }

    .service-description {
        color: var(--foreground-muted);
    }

    .service-meta {
        margin-top: 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .service-price {
        font-weight: 700;
        color: var(--accent);
        font-size: 1.25rem;
    }

    .service-duration {
        color: var(--foreground-muted);
        font-size: 0.875rem;
    }

    .service-cta {
        width: 100%;
        margin-top: 1.5rem;
    }

    .caregiver-grid {
        gap: 2rem;
        margin-bottom: 5rem;
    }

    .caregiver-card {
        padding: 1.5rem;
        display: flex;
        gap: 1.5rem;
        align-items: flex-start;
    }

    .caregiver-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 1px solid var(--border-default);
    }

    .caregiver-details {
        flex: 1;
    }

    .caregiver-name {
        margin: 0;
    }

    .caregiver-specialty {
        color: var(--accent);
        font-weight: 600;
        font-size: 0.875rem;
        margin-bottom: 0.5rem;
    }

    .caregiver-bio {
        font-size: 0.875rem;
        margin-bottom: 1rem;
        line-height: 1.4;
        color: var(--foreground-muted);
    }

    .caregiver-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 1rem;
    }

    .rating-pill {
        font-size: 0.875rem;
        color: var(--foreground-subtle);
        background: rgba(255, 255, 255, 0.06);
        padding: 0.25rem 0.75rem;
        border-radius: 999px;
        border: 1px solid var(--border-default);
    }

    .empty-state {
        text-align: center;
        color: var(--foreground-muted);
    }

    .full-span {
        grid-column: 1 / -1;
    }

    @media (max-width: 768px) {
        .company-hero {
            padding: 2rem;
        }

        .caregiver-card {
            flex-direction: column;
            align-items: flex-start;
        }
    }
</style>

<jsp:include page="../includes/footer.jsp"/>
