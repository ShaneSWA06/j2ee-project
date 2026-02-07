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

<main class="container dashboard">
    <div class="dashboard-header">
        <div>
            <h1 class="dashboard-title text-gradient">Agency Dashboard</h1>
            <p class="dashboard-subtitle"><%= company.getName() %> | Management Portal</p>
        </div>
        <div class="dashboard-actions">
            <button class="btn btn-secondary btn-sm" onclick="window.location.reload()">
                <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                    <polyline points="23 4 23 10 17 10"></polyline>
                    <polyline points="1 20 1 14 7 14"></polyline>
                    <path d="M3.51 9a9 9 0 0 1 14.13-3.36L23 10"></path>
                    <path d="M20.49 15a9 9 0 0 1-14.13 3.36L1 14"></path>
                </svg>
                Refresh
            </button>
            <a href="<%= request.getContextPath() %>/company/settings" class="btn btn-outline btn-sm">
                <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                    <circle cx="12" cy="12" r="3"></circle>
                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9c0 .64.37 1.23 1 1.51.31.14.65.22 1 .22H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                </svg>
                Settings
            </a>
        </div>
    </div>

    <div class="grid grid-cols-3 dashboard-stats">
        <div class="card stat-card">
            <div class="stat-top">
                <div class="stat-icon stat-icon-primary">
                    <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </div>
                <span class="stat-pill stat-pill-success">+2 this month</span>
            </div>
            <div class="stat-value"><%= caregiverCount %></div>
            <div class="stat-label">Total Caregivers</div>
        </div>
        <div class="card stat-card">
            <div class="stat-top">
                <div class="stat-icon stat-icon-info">
                    <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                </div>
                <span class="stat-pill stat-pill-info">Active</span>
            </div>
            <div class="stat-value"><%= serviceCount %></div>
            <div class="stat-label">Services Offered</div>
        </div>
        <div class="card stat-card">
            <div class="stat-top">
                <div class="stat-icon stat-icon-warning">
                    <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                </div>
                <span class="stat-pill stat-pill-warning">Pending Review</span>
            </div>
            <div class="stat-value"><%= bookingCount %></div>
            <div class="stat-label">Lifetime Bookings</div>
        </div>
    </div>

    <div class="dashboard-columns">
        <div class="card">
            <div class="card-head">
                <h5>Recent Bookings</h5>
                <a href="<%= request.getContextPath() %>/company/bookings" class="card-link">View All</a>
            </div>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Client</th>
                            <th>Service</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th class="text-right">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentBookings != null && !recentBookings.isEmpty()) { 
                            for (Booking b : recentBookings) { %>
                            <tr>
                                <td>
                                    <div class="table-user">
                                        <div class="avatar-sm">
                                            <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                        </div>
                                        <div class="table-user-name"><%= b.getUserName() %></div>
                                    </div>
                                </td>
                                <td><span class="text-small"><%= b.getServiceName() %></span></td>
                                <td><span class="text-small text-muted"><%= b.getBookingDate() %></span></td>
                                <td>
                                    <% 
                                        String statusClass = "status-neutral";
                                        if ("Confirmed".equals(b.getStatus())) statusClass = "status-success";
                                        if ("Pending".equals(b.getStatus())) statusClass = "status-warning";
                                        if ("Cancelled".equals(b.getStatus())) statusClass = "status-danger";
                                    %>
                                    <span class="status-pill <%= statusClass %>">
                                        <%= b.getStatus() %>
                                    </span>
                                </td>
                                <td class="text-right">
                                    <a href="<%= request.getContextPath() %>/company/booking-details?id=<%= b.getBookingId() %>" class="btn btn-sm btn-outline">
                                        Details
                                    </a>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="5" class="empty-state">
                                    <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M22 12h-6l-2 3h-4l-2-3H2"></path>
                                        <path d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"></path>
                                    </svg>
                                    <span>No recent bookings found.</span>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="dashboard-side">
            <div class="card">
                <h5>Management</h5>
                <div class="action-list">
                    <a href="<%= request.getContextPath() %>/company/caregivers" class="btn btn-outline action-link">
                        <span class="action-text">
                            <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            Caregivers
                        </span>
                        <span class="count-pill"><%= caregiverCount %></span>
                    </a>
                    <a href="<%= request.getContextPath() %>/company/services" class="btn btn-outline action-link">
                        <span class="action-text">
                            <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                            </svg>
                            Services
                        </span>
                        <span class="count-pill"><%= serviceCount %></span>
                    </a>
                    <a href="<%= request.getContextPath() %>/company/verify-reviews" class="btn btn-outline action-link">
                        <span class="action-text">
                            <svg class="icon icon-fill" viewBox="0 0 24 24" aria-hidden="true">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                            Reviews
                        </span>
                        <svg class="icon icon-stroke action-chevron" viewBox="0 0 24 24" aria-hidden="true">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </a>
                </div>
            </div>

            <div class="card profile-card">
                <div class="profile-icon">
                    <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                        <rect x="4" y="3" width="16" height="18" rx="2" ry="2"></rect>
                        <line x1="8" y1="7" x2="8" y2="9"></line>
                        <line x1="12" y1="7" x2="12" y2="9"></line>
                        <line x1="16" y1="7" x2="16" y2="9"></line>
                        <line x1="8" y1="12" x2="8" y2="14"></line>
                        <line x1="12" y1="12" x2="12" y2="14"></line>
                        <line x1="16" y1="12" x2="16" y2="14"></line>
                        <line x1="10" y1="21" x2="14" y2="21"></line>
                    </svg>
                </div>
                <div class="profile-kicker">Agency Profile</div>
                <div class="profile-name"><%= company.getName() %></div>
                <div class="profile-address"><%= company.getAddress() %></div>
                <div class="profile-rating">
                    <div class="profile-score"><%= String.format("%.1f", company.getRating()) %></div>
                    <div>
                        <div class="profile-stars">
                            <svg class="icon icon-fill" viewBox="0 0 24 24" aria-hidden="true">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                            <svg class="icon icon-fill" viewBox="0 0 24 24" aria-hidden="true">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                            <svg class="icon icon-fill" viewBox="0 0 24 24" aria-hidden="true">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                            <svg class="icon icon-fill" viewBox="0 0 24 24" aria-hidden="true">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                            <svg class="icon icon-fill" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 2v15.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                            </svg>
                        </div>
                        <div class="profile-label">Average Agency Rating</div>
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/customer/company?id=<%= company.getCompanyId() %>" target="_blank" class="btn btn-secondary btn-sm profile-link">
                    View Public Profile
                    <svg class="icon icon-stroke" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M14 3h7v7"></path>
                        <path d="M10 14L21 3"></path>
                        <path d="M5 7v12a2 2 0 0 0 2 2h12"></path>
                    </svg>
                </a>
            </div>
        </div>
    </div>
</main>

<style>
    .dashboard {
        padding: 3rem 0 4rem;
    }

    .dashboard-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 1.5rem;
        margin-bottom: 2.5rem;
        flex-wrap: wrap;
    }

    .dashboard-title {
        margin: 0;
        font-size: clamp(2.25rem, 4vw, 3.25rem);
    }

    .dashboard-subtitle {
        margin: 0.35rem 0 0;
        color: var(--foreground-muted);
    }

    .dashboard-actions {
        display: flex;
        gap: 0.75rem;
        flex-wrap: wrap;
    }

    .dashboard-stats {
        margin-bottom: 2.5rem;
    }

    .stat-card {
        padding: 1.5rem;
    }

    .stat-top {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 1rem;
        margin-bottom: 1rem;
    }

    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: var(--radius-lg);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
    }

    .icon {
        width: 1em;
        height: 1em;
        display: inline-block;
        vertical-align: -0.125em;
    }

    .icon-fill {
        fill: currentColor;
    }

    .icon-stroke {
        fill: none;
        stroke: currentColor;
        stroke-width: 1.8;
        stroke-linecap: round;
        stroke-linejoin: round;
    }

    .stat-icon-primary {
        background: rgba(94, 106, 210, 0.2);
        color: var(--accent);
    }

    .stat-icon-info {
        background: rgba(13, 202, 240, 0.2);
        color: #6be3ff;
    }

    .stat-icon-warning {
        background: rgba(245, 158, 11, 0.2);
        color: #facc15;
    }

    .stat-pill {
        padding: 0.25rem 0.75rem;
        border-radius: 999px;
        font-size: 0.75rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .stat-pill-success {
        background: rgba(25, 135, 84, 0.2);
        color: #7fe6b0;
    }

    .stat-pill-info {
        background: rgba(13, 202, 240, 0.18);
        color: #7dd3fc;
    }

    .stat-pill-warning {
        background: rgba(245, 158, 11, 0.2);
        color: #fde68a;
    }

    .stat-value {
        font-size: 2rem;
        font-weight: 600;
    }

    .stat-label {
        color: var(--foreground-muted);
        font-size: 0.95rem;
    }

    .dashboard-columns {
        display: grid;
        grid-template-columns: minmax(0, 2fr) minmax(0, 1fr);
        gap: 1.5rem;
        align-items: start;
    }

    .card-head {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1rem;
        margin-bottom: 1rem;
    }

    .card-link {
        color: var(--accent);
        font-size: 0.875rem;
    }

    .card-link:hover {
        color: var(--foreground);
    }

    .table-wrap {
        overflow-x: auto;
    }

    .table-user {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .avatar-sm {
        width: 32px;
        height: 32px;
        border-radius: 999px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: var(--surface);
        color: var(--foreground-muted);
        flex-shrink: 0;
    }

    .avatar-sm .icon {
        width: 1rem;
        height: 1rem;
    }

    .text-small {
        font-size: 0.875rem;
    }

    .text-muted {
        color: var(--foreground-muted);
    }

    .text-right {
        text-align: right;
    }

    .status-pill {
        display: inline-flex;
        align-items: center;
        padding: 0.25rem 0.75rem;
        border-radius: 999px;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .status-success {
        background: rgba(25, 135, 84, 0.2);
        color: #7fe6b0;
    }

    .status-warning {
        background: rgba(245, 158, 11, 0.2);
        color: #fde68a;
    }

    .status-danger {
        background: rgba(220, 53, 69, 0.2);
        color: #fca5a5;
    }

    .status-neutral {
        background: rgba(148, 163, 184, 0.2);
        color: #cbd5f5;
    }

    .empty-state {
        text-align: center;
        padding: 2.5rem 1rem;
        color: var(--foreground-muted);
    }

    .empty-state .icon {
        font-size: 2rem;
        display: block;
        margin-bottom: 0.75rem;
        opacity: 0.5;
    }

    .dashboard-side {
        display: grid;
        gap: 1.5rem;
    }

    .action-list {
        display: grid;
        gap: 0.75rem;
        margin-top: 1rem;
    }

    .action-link {
        width: 100%;
        justify-content: space-between;
        text-align: left;
        padding: 0.75rem 1rem;
    }

    .action-text {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }

    .action-chevron {
        opacity: 0.6;
    }

    .count-pill {
        background: var(--accent);
        color: var(--foreground);
        border-radius: 999px;
        padding: 0.125rem 0.5rem;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .profile-card {
        background: linear-gradient(135deg, rgba(94, 106, 210, 0.22), rgba(94, 106, 210, 0.08));
        border: 1px solid rgba(94, 106, 210, 0.3);
        position: relative;
        overflow: hidden;
    }

    .profile-icon {
        position: absolute;
        top: 1rem;
        right: 1rem;
        font-size: 4rem;
        opacity: 0.08;
        color: var(--foreground);
        pointer-events: none;
    }

    .profile-icon .icon {
        width: 4rem;
        height: 4rem;
    }

    .profile-kicker {
        font-size: 0.75rem;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: var(--foreground-subtle);
        margin-bottom: 0.5rem;
    }

    .profile-name {
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 0.25rem;
    }

    .profile-address {
        color: var(--foreground-subtle);
        font-size: 0.875rem;
        margin-bottom: 1.25rem;
    }

    .profile-rating {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 1.25rem;
    }

    .profile-score {
        font-size: 2rem;
        font-weight: 600;
    }

    .profile-stars {
        color: #f5c451;
        font-size: 0.875rem;
        margin-bottom: 0.25rem;
    }

    .profile-label {
        color: var(--foreground-subtle);
        font-size: 0.75rem;
    }

    .profile-link {
        width: 100%;
    }

    @media (max-width: 1024px) {
        .dashboard-columns {
            grid-template-columns: 1fr;
        }
    }
</style>

<jsp:include page="../includes/footer.jsp"/>
