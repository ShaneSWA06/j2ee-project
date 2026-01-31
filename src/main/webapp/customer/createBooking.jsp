<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Create Booking"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Create New Booking</h1>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<form method="post" action="${pageContext.request.contextPath}/customer/booking?action=create" class="form">
<div class="form-group"><label for="service_id">Service *</label><select id="service_id" name="service_id" required><option value="">Select Service</option><c:forEach var="service" items="${services}"><option value="${service.serviceId}" ${service.serviceId == param.serviceId ? 'selected' : ''}>${service.serviceName} - $${service.basePrice}</option></c:forEach></select></div>
<div class="form-group"><label for="booking_date">Date *</label><input type="date" id="booking_date" name="booking_date" required></div>
<div class="form-group"><label for="booking_time">Time *</label><input type="time" id="booking_time" name="booking_time" required></div>
<div class="form-group"><label for="caregiver_id">Caregiver (Optional)</label><select id="caregiver_id" name="caregiver_id"><option value="">No Preference</option><c:forEach var="caregiver" items="${caregivers}"><option value="${caregiver.caregiverId}">${caregiver.name} - ${caregiver.specialization}</option></c:forEach></select></div>
<div class="form-group"><label for="notes">Notes</label><textarea id="notes" name="notes" rows="3"></textarea></div>
<button type="submit" class="btn btn-primary">Create Booking</button>
<a href="${pageContext.request.contextPath}/customer/booking" class="btn btn-secondary">Cancel</a>
</form>
</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
