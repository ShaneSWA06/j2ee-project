<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Company" %>
<%@ page import="model.Service" %>
<%@ page import="model.Caregiver" %>
<%@ page import="model.Booking" %>
<%@ page import="model.User" %>

<%
    Company company = (Company) request.getAttribute("company");
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<Caregiver> caregivers = (List<Caregiver>) request.getAttribute("caregivers");
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    
    int caregiverCount = (Integer) request.getAttribute("caregiverCount");
    int serviceCount = (Integer) request.getAttribute("serviceCount");
    int bookingCount = (Integer) request.getAttribute("bookingCount");
%>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Agency Dashboard - SilverCare"/>
</jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<main class="container py-5">
    <!-- Dashboard Header -->
    <div class="d-flex justify-content-between align-items-center mb-5">
        <div>
            <h1 class="display-5 fw-bold text-gradient mb-2">Agency Dashboard</h1>
            <p class="text-muted"><%= company.getName() %> | Management Portal</p>
        </div>
        <div class="d-flex gap-3">
            <button class="btn btn-glass" onclick="window.location.reload()">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
            <a href="<%= request.getContextPath() %>/company/settings" class="btn btn-glass">
                <i class="fas fa-cog"></i> Settings
            </a>
        </div>
    </div>

    <!-- Stats Overview -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card stat-card h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="stat-icon bg-primary-soft">
                            <i class="fas fa-user-nurse text-primary"></i>
                        </div>
                        <span class="badge bg-success-soft text-success">+2 this month</span>
                    </div>
                    <h3 class="fw-bold mb-1"><%= caregiverCount %></h3>
                    <p class="text-muted mb-0">Total Caregivers</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="stat-icon bg-info-soft">
                            <i class="fas fa-concierge-bell text-info"></i>
                        </div>
                        <span class="badge bg-info-soft text-info">Active</span>
                    </div>
                    <h3 class="fw-bold mb-1"><%= serviceCount %></h3>
                    <p class="text-muted mb-0">Services Offered</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="stat-icon bg-warning-soft">
                            <i class="fas fa-calendar-check text-warning"></i>
                        </div>
                        <span class="badge bg-warning-soft text-warning">Pending Review</span>
                    </div>
                    <h3 class="fw-bold mb-1"><%= bookingCount %></h3>
                    <p class="text-muted mb-0">Lifetime Bookings</p>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Recent Bookings Table -->
        <div class="col-lg-8">
            <div class="card h-100">
                <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center pt-4 px-4">
                    <h5 class="fw-bold mb-0">Recent Bookings</h5>
                    <a href="<%= request.getContextPath() %>/company/bookings" class="text-primary text-decoration-none small">View All</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4">Client</th>
                                    <th>Service</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th class="pe-4 text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentBookings != null && !recentBookings.isEmpty()) { 
                                    for (Booking b : recentBookings) { %>
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <div class="avatar-sm me-3 bg-light rounded-circle d-flex align-items-center justify-content-center">
                                                    <i class="fas fa-user text-muted"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 small fw-bold"><%= b.getUserName() %></h6>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="small"><%= b.getServiceName() %></span></td>
                                        <td><span class="small text-muted"><%= b.getBookingDate() %></span></td>
                                        <td>
                                            <% 
                                                String statusClass = "bg-secondary";
                                                if ("Confirmed".equals(b.getStatus())) statusClass = "bg-success";
                                                if ("Pending".equals(b.getStatus())) statusClass = "bg-warning";
                                                if ("Cancelled".equals(b.getStatus())) statusClass = "bg-danger";
                                            %>
                                            <span class="badge <%= statusClass %>-soft text-<%= statusClass.replace("bg-", "") %> rounded-pill small">
                                                <%= b.getStatus() %>
                                            </span>
                                        </td>
                                        <td class="pe-4 text-end">
                                            <a href="<%= request.getContextPath() %>/company/booking-details?id=<%= b.getBookingId() %>" class="btn btn-sm btn-light">
                                                Details
                                            </a>
                                        </td>
                                    </tr>
                                <% } } else { %>
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="fas fa-inbox display-4 mb-3 d-block opacity-25"></i>
                                            No recent bookings found.
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Management -->
        <div class="col-lg-4">
            <div class="card mb-4 mt-1">
                <div class="card-body">
                    <h5 class="fw-bold mb-4">Management</h5>
                    <div class="d-grid gap-3">
                        <a href="<%= request.getContextPath() %>/company/caregivers" class="btn btn-outline-primary text-start d-flex justify-content-between align-items-center py-3 px-4">
                            <span><i class="fas fa-user-nurse me-2"></i> Caregivers</span>
                            <span class="badge bg-primary rounded-pill"><%= caregiverCount %></span>
                        </a>
                        <a href="<%= request.getContextPath() %>/company/services" class="btn btn-outline-info text-start d-flex justify-content-between align-items-center py-3 px-4">
                            <span><i class="fas fa-concierge-bell me-2"></i> Services</span>
                            <span class="badge bg-info rounded-pill"><%= serviceCount %></span>
                        </a>
                        <a href="<%= request.getContextPath() %>/company/verify-reviews" class="btn btn-outline-secondary text-start d-flex justify-content-between align-items-center py-3 px-4">
                            <span><i class="fas fa-star me-2"></i> Reviews</span>
                            <i class="fas fa-chevron-right small opacity-50"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Agency Profile Preview -->
            <div class="card bg-primary text-white overflow-hidden shadow-lg border-0">
                <div class="card-body p-4 position-relative">
                    <div class="position-absolute top-0 end-0 p-3 opacity-10" style="font-size: 5rem;">
                        <i class="fas fa-building"></i>
                    </div>
                    <h6 class="text-white-50 text-uppercase small fw-bold mb-3">Agency Profile</h6>
                    <h4 class="fw-bold mb-2"><%= company.getName() %></h4>
                    <p class="small text-white-50 mb-4"><%= company.getAddress() %></p>
                    <div class="d-flex align-items-center mb-4">
                        <div class="me-3">
                            <span class="display-6 fw-bold"><%= String.format("%.1f", company.getRating()) %></span>
                        </div>
                        <div>
                            <div class="text-warning small mb-1">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                            <span class="text-white-50 small">Average Agency Rating</span>
                        </div>
                    </div>
                    <a href="<%= request.getContextPath() %>/customer/company?id=<%= company.getCompanyId() %>" target="_blank" class="btn btn-light btn-sm w-100 fw-bold py-2">
                        View Public Profile <i class="fas fa-external-link-alt ms-1 small"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<style>
    :root {
        --primary-soft: rgba(var(--accent-rgb), 0.1);
        --info-soft: rgba(13, 202, 240, 0.1);
        --warning-soft: rgba(255, 193, 7, 0.1);
        --success-soft: rgba(25, 135, 84, 0.1);
        --danger-soft: rgba(220, 53, 69, 0.1);
        --secondary-soft: rgba(108, 117, 125, 0.1);
    }
    
    .text-gradient {
        background: linear-gradient(135deg, var(--accent), #7d89f0);
        -webkit-background-clip: text;
        background-clip: text;
        -webkit-text-fill-color: transparent;
    }
    
    .stat-card {
        border: none;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        background: var(--surface);
    }
    
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-lg);
    }
    
    .stat-icon {
        width: 48px;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 12px;
        font-size: 1.5rem;
    }
    
    .btn-glass {
        background: rgba(var(--accent-rgb), 0.05);
        border: 1px solid rgba(var(--accent-rgb), 0.1);
        backdrop-filter: blur(10px);
        color: var(--foreground);
    }
    
    .btn-glass:hover {
        background: rgba(var(--accent-rgb), 0.1);
    }
    
    .avatar-sm {
        width: 32px;
        height: 32px;
    }
    
    .bg-primary-soft { background: var(--primary-soft); }
    .bg-info-soft { background: var(--info-soft); }
    .bg-warning-soft { background: var(--warning-soft); }
    .bg-success-soft { background: var(--success-soft); }
    .bg-danger-soft { background: var(--danger-soft); }
    .bg-secondary-soft { background: var(--secondary-soft); }
</style>

<jsp:include page="../includes/footer.jsp"/>
