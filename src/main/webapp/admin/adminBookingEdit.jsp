<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Edit Booking"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Edit Booking</h1>

<c:if test="${not empty param.err}">
  <div class="alert alert-danger">Error: ${param.err}</div>
</c:if>

<c:if test="${not empty booking}">
  <form method="post" action="${pageContext.request.contextPath}/admin/booking?action=edit" class="form">
  <input type="hidden" name="bookingId" value="${booking.bookingId}">
  
  <div class="form-group">
  <label>Customer: <strong>${booking.userName}</strong></label>
  </div>
  
  <div class="form-group">
  <label for="service_id">Service</label>
  <select id="service_id" name="service_id" required>
  <c:forEach var="service" items="${services}">
    <option value="${service.serviceId}" ${service.serviceId == booking.serviceId ? 'selected' : ''}>${service.serviceName}</option>
  </c:forEach>
  </select>
  </div>
  
  <div class="form-group">
  <label for="caregiver_id">Caregiver (Optional)</label>
  <select id="caregiver_id" name="caregiver_id">
  <option value="">None</option>
  <c:forEach var="caregiver" items="${caregivers}">
    <option value="${caregiver.caregiverId}" ${caregiver.caregiverId == booking.caregiverId ? 'selected' : ''}>
        ${caregiver.name} ${caregiver.available ? '(Available)' : '(Unavailable)'}
    </option>
  </c:forEach>
  </select>
  </div>
  
  <div class="form-group">
  <label for="booking_date">Booking Date</label>
  <input type="date" id="booking_date" name="booking_date" value="<fmt:formatDate value='${booking.bookingDate}' pattern='yyyy-MM-dd' timeZone='GMT+8'/>" required>
  </div>
  
  <div class="form-group">
  <label for="booking_time">Booking Time</label>
  <input type="time" id="booking_time" name="booking_time" value="<fmt:formatDate value='${booking.bookingTime}' pattern='HH:mm' timeZone='GMT+8'/>" required>
  </div>
  
  <div class="form-group">
  <label for="status">Status</label>
  <select id="status" name="status" required>
    <option value="Pending" ${booking.status == 'Pending' ? 'selected' : ''}>Pending</option>
    <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
    <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Completed</option>
    <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
  </select>
  </div>
  
  <div class="form-row">
      <div class="form-group">
      <label for="pickup_address">Pickup Address</label>
      <input type="text" id="pickup_address" name="pickup_address" value="${booking.pickupAddress}">
      </div>
      
      <div class="form-group">
      <label for="destination_address">Destination Address (Optional)</label>
      <input type="text" id="destination_address" name="destination_address" value="${booking.destinationAddress}">
      </div>
  </div>
  
  <div class="form-group">
  <label for="caregiver_status">Caregiver Status</label>
  <select id="caregiver_status" name="caregiver_status">
    <option value="Pending" ${booking.caregiverStatus == 'Pending' ? 'selected' : ''}>Pending</option>
    <option value="Accepted" ${booking.caregiverStatus == 'Accepted' ? 'selected' : ''}>Accepted</option>
    <option value="Rejected" ${booking.caregiverStatus == 'Rejected' ? 'selected' : ''}>Rejected</option>
  </select>
  </div>
  
  <div class="form-group">
  <label for="notes">Notes</label>
  <textarea id="notes" name="notes" rows="3">${booking.notes}</textarea>
  </div>
  
  <button type="submit" class="btn btn-primary">Update Booking</button>
  <a href="${pageContext.request.contextPath}/admin/booking" class="btn btn-secondary">Cancel</a>
  </form>
</c:if>

<c:if test="${empty booking}">
  <div class="alert alert-danger">Booking not found.</div>
  <a href="${pageContext.request.contextPath}/admin/booking" class="btn btn-secondary">Back to List</a>
</c:if>

</div>
</div>
<jsp:include page="../includes/footer.jsp"/>
