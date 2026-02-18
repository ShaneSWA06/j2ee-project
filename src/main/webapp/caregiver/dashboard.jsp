<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Caregiver" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Caregiver Portal | CareConnect"/>
</jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<!-- Add Tailwind for layout utilities, configured to respect existing theme if possible -->
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          background: 'var(--background-base)',
          foreground: 'var(--foreground)',
          card: 'var(--background-elevated)',
          accent: 'var(--accent)',
        }
      }
    }
  }
</script>

<style>
    /* Override Tailwind reset issues if any */
    body {
        background-color: var(--background-base);
        color: var(--foreground);
    }
    .glass-card {
        background: rgba(10, 10, 15, 0.6);
        backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.08);
    }
    .status-badge {
        font-size: 0.7rem;
        padding: 0.1rem 0.5rem;
        border-radius: 9999px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.025em;
    }
    .status-pending { background: rgba(234, 179, 8, 0.2); color: #facc15; border: 1px solid rgba(234, 179, 8, 0.3); }
    .status-in-progress { background: rgba(59, 130, 246, 0.2); color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.3); }
    .status-completed { background: rgba(34, 197, 94, 0.2); color: #4ade80; border: 1px solid rgba(34, 197, 94, 0.3); }
</style>

<script>
function handleClockAction(formId) {
    console.log("Clock action triggered for form:", formId);
    const form = document.getElementById(formId);
    if (!form || form.dataset.submitted === 'true') return;

    const button = form.querySelector('button');
    if (button) {
        button.disabled = true;
        button.innerHTML = `<svg class="animate-spin h-5 w-5 mr-2" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> Please wait...`;
    }

    function submitForm() {
        if (form.dataset.submitted === 'true') return; // guard against double-submit
        form.dataset.submitted = 'true';
        form.submit();
    }

    if (navigator.geolocation) {
        // Safety timeout: submit without location if geolocation takes too long
        const geoTimeout = setTimeout(() => {
            console.warn("Geolocation timeout — submitting without location");
            submitForm();
        }, 5000);

        navigator.geolocation.getCurrentPosition(
            (position) => {
                clearTimeout(geoTimeout);
                const loc = position.coords.latitude + "," + position.coords.longitude;
                const locInput = document.getElementById(formId + "_location");
                if (locInput) locInput.value = loc;
                console.log("Location captured:", loc);
                submitForm();
            },
            (error) => {
                clearTimeout(geoTimeout);
                console.warn("Geolocation error:", error.message);
                submitForm(); // Submit without location if denied/failed
            },
            { timeout: 4000, enableHighAccuracy: true }
        );
    } else {
        console.warn("Geolocation not supported");
        submitForm();
    }
}
</script>

<div class="min-h-screen py-10 px-4 sm:px-6 lg:px-8">
    <div class="max-w-7xl mx-auto">
        
        <!-- Welcome Section -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-white mb-2">Caregiver Portal</h1>
            <p class="text-gray-400">Manage your schedule and find new care opportunities.</p>
        </div>

        <% 
            String error = request.getParameter("err");
            String success = request.getParameter("success");
            if (error != null) {
        %>
            <div class="mb-4 bg-red-900/30 border border-red-500/50 text-red-200 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline">
                    <% if("missing_id".equals(error)) { %> Error: Booking ID is missing.
                    <% } else if("accept_failed".equals(error)) { %> Error: Failed to accept job. It may have been taken.
                    <% } else { %> <%= error %> <% } %>
                </span>
            </div>
        <% } %>

        <% if ("accepted".equals(success)) { %>
            <div class="mb-4 bg-green-900/30 border border-green-500/50 text-green-200 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline">Job accepted successfully! It has been added to your schedule.</span>
            </div>
        <% } %>

        <% if ("clocked_in".equals(success) || "clockin_success".equals(success)) { %>
            <div class="mb-4 bg-blue-900/30 border border-blue-500/50 text-blue-200 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline">✓ Session started! Your clock-in time and location have been recorded.</span>
            </div>
        <% } %>

        <% if ("clocked_out".equals(success) || "clockout_success".equals(success)) { %>
            <div class="mb-4 bg-green-900/30 border border-green-500/50 text-green-200 px-4 py-3 rounded relative" role="alert">
                <span class="block sm:inline">✓ Session ended! Your clock-out time has been recorded and the job is marked as completed.</span>
            </div>
        <% } %>

        <!-- Navigation Tabs -->
        <% 
            String viewType = (String) request.getAttribute("viewType");
            if (viewType == null) viewType = "available";
        %>
        <div class="border-b border-gray-700 mb-8">
            <nav class="-mb-px flex space-x-8" aria-label="Tabs">
                <a href="${pageContext.request.contextPath}/mvc/caregiver/dashboard?action=list" 
                   class="<%= "available".equals(viewType) ? "border-indigo-500 text-indigo-400" : "border-transparent text-gray-400 hover:text-gray-300 hover:border-gray-300" %> whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200">
                   Available Jobs
                </a>
                <a href="${pageContext.request.contextPath}/mvc/caregiver/dashboard?action=my" 
                   class="<%= "my".equals(viewType) ? "border-indigo-500 text-indigo-400" : "border-transparent text-gray-400 hover:text-gray-300 hover:border-gray-300" %> whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200">
                   My Schedule
                </a>
            </nav>
        </div>

        <!-- Job Listings -->
        <%
            List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
            
            if (bookings == null || bookings.isEmpty()) {
        %>
            <div class="text-center py-12 glass-card rounded-lg">
                <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                <h3 class="mt-2 text-sm font-medium text-gray-200">No bookings found</h3>
                <p class="mt-1 text-sm text-gray-400">
                    <% if ("available".equals(viewType)) { %>
                        There are currently no open jobs available. Check back later!
                    <% } else { %>
                        You haven't accepted any jobs yet. Check the "Available Jobs" tab.
                    <% } %>
                </p>
            </div>
        <% } else { %>
            <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
                <% for (Booking booking : bookings) { %>
                    <div class="glass-card rounded-xl p-6 shadow-lg transition-all duration-200 hover:shadow-indigo-500/10 hover:-translate-y-1 relative group">
                        <!-- Card Header -->
                        <div class="flex justify-between items-start mb-4">
                            <div>
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-900/50 text-indigo-200 border border-indigo-500/20">
                                    <%= booking.getServiceName() != null ? booking.getServiceName() : "Medical Service" %>
                                </span>
                                <h3 class="text-white text-lg font-semibold mt-2">
                                    <%= booking.getUserName() != null ? booking.getUserName() : ("Client #" + booking.getUserId()) %>
                                </h3>
                            </div>
                            <div class="text-right flex flex-col items-end">
                                <p class="text-indigo-400 font-bold text-lg mb-1">$<%= String.format("%.2f", booking.getTotalPrice() != null ? booking.getTotalPrice() : 0.0) %></p>
                                <%
                                    String status = booking.getStatus() != null ? booking.getStatus() : "Pending";
                                    String statusClass = "status-pending";
                                    if ("Confirmed".equalsIgnoreCase(status)) statusClass = "status-in-progress";
                                    if ("In-Progress".equalsIgnoreCase(status)) statusClass = "status-in-progress";
                                    if ("Completed".equalsIgnoreCase(status)) statusClass = "status-completed";
                                    if ("Cancelled".equalsIgnoreCase(status)) statusClass = "status-pending";
                                %>
                                <span class="status-badge <%= statusClass %>">
                                    <%= status %>
                                </span>
                            </div>
                        </div>

                        <!-- Card Body -->
                        <div class="space-y-3 mb-6">
                            <div class="flex items-center text-gray-300 text-sm">
                                <svg class="h-5 w-5 text-gray-500 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                                <span><%= booking.getBookingDate() %> at <%= booking.getBookingTime() %></span>
                            </div>
                            <div class="flex items-start text-gray-300 text-sm">
                                <svg class="h-5 w-5 text-gray-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                </svg>
                                <span class="truncate">
                                    <%= booking.getPickupAddress() != null && !booking.getPickupAddress().isEmpty() ? booking.getPickupAddress() : "No location provided" %>
                                    <% if (booking.getDestinationAddress() != null && !booking.getDestinationAddress().isEmpty()) { %>
                                        → <%= booking.getDestinationAddress() %>
                                    <% } %>
                                </span>
                            </div>
                            
                            <% if (booking.getClockInTime() != null) { %>
                                <div class="flex items-center text-xs text-blue-400">
                                    <svg class="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    Started: <fmt:formatDate value="${booking.clockInTime}" pattern="HH:mm (dd MMM)"/>
                                </div>
                            <% } %>

                            <% if (booking.getClockOutTime() != null) { %>
                                <div class="flex items-center text-xs text-green-400">
                                    <svg class="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    Ended: <fmt:formatDate value="${booking.clockOutTime}" pattern="HH:mm (dd MMM)"/>
                                </div>
                            <% } %>

                            <% if (booking.getNotes() != null && !booking.getNotes().isEmpty()) { %>
                                <div class="mt-2 text-xs text-gray-500 bg-black/20 p-2 rounded">
                                    Note: <%= booking.getNotes() %>
                                </div>
                            <% } %>
                        </div>

                        <!-- Card Footer -->
                        <div>
                            <% if ("available".equals(viewType)) { %>
                                <form action="${pageContext.request.contextPath}/mvc/caregiver/accept" method="post">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="w-full flex justify-center items-center px-4 py-2 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200">
                                        Accept Job
                                    </button>
                                </form>
                            <% } else { %>
                                <div class="space-y-2">
                                    <% 
                                        String bStatus = booking.getStatus() != null ? booking.getStatus() : "Pending";
                                        if ("Confirmed".equalsIgnoreCase(bStatus) || "Pending".equalsIgnoreCase(bStatus)) { 
                                    %>
                                        <form id="clockin_<%= booking.getBookingId() %>" action="${pageContext.request.contextPath}/mvc/caregiver/clockin" method="post">
                                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                            <input type="hidden" name="location" id="clockin_<%= booking.getBookingId() %>_location">
                                            <button type="button" onclick="handleClockAction('clockin_<%= booking.getBookingId() %>')" class="w-full flex justify-center items-center px-4 py-3 border border-transparent rounded-lg shadow-sm text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-all duration-200 transform hover:scale-[1.02]">
                                                <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                </svg>
                                                Start Session (Clock In)
                                            </button>
                                        </form>
                                    <% } else if ("In-Progress".equalsIgnoreCase(bStatus)) { %>
                                        <form id="clockout_<%= booking.getBookingId() %>" action="${pageContext.request.contextPath}/mvc/caregiver/clockout" method="post">
                                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                            <input type="hidden" name="location" id="clockout_<%= booking.getBookingId() %>_location">
                                            <button type="button" onclick="handleClockAction('clockout_<%= booking.getBookingId() %>')" class="w-full flex justify-center items-center px-4 py-3 border border-transparent rounded-lg shadow-sm text-sm font-bold text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-all duration-200 transform hover:scale-[1.02]">
                                                <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                </svg>
                                                End Session (Clock Out)
                                            </button>
                                        </form>
                                    <% } else if ("Completed".equalsIgnoreCase(bStatus)) { %>
                                        <div class="w-full flex justify-center items-center px-4 py-3 border border-gray-700 rounded-lg shadow-sm text-sm font-medium text-green-400 bg-green-900/20 cursor-default">
                                            <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                            </svg>
                                            Job Completed
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
        
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
