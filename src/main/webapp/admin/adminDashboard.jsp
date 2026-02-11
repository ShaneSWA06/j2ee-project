<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Admin Dashboard"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Admin Dashboard</h1>
  <div class="grid" style="margin-top:12px;">
    <div class="card"><h3>Manage Service Categories</h3><p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/category">Manage</a></p></div>
    <div class="card"><h3>Manage Services</h3><p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/service">Manage</a></p></div>
    <div class="card"><h3>Manage Caregivers</h3><p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/caregiver">Manage</a></p></div>
    <div class="card"><h3>Manage Bookings</h3><p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/booking">Manage</a></p></div>
    <div class="card"><h3>Sales & Payments</h3><p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/payments">View</a></p></div>
    <div class="card"><h3>Manage Clients</h3><p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/client">Manage</a></p></div>
    <div class="card"><h3>Feedback</h3><p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/feedback">Manage</a></p></div>
    <div class="card"><h3>Reports & Analytics</h3><p><a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/reports">View</a></p></div>
    <div class="card" style="border: 2px solid #0e90e9; background: rgba(14, 144, 233, 0.05);">
        <h3 style="color: #0e90e9;">MedCare Corporate Analytics</h3>
        <p><a class="btn" style="background: #0e90e9; color: white;" href="https://assignmenttwo-fljm.onrender.com/user-ws/analytics.html" target="_blank">Launch Intelligence</a></p>
    </div>
  </div>
</div>
<jsp:include page="../includes/footer.jsp"/>