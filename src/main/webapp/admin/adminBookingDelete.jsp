<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Delete Booking"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<div class="form-container">
<h1>Delete Booking</h1>

<c:if test="${not empty booking}">
  <div class="alert alert-danger">
  <p><strong>Warning:</strong> This action cannot be undone.</p>
  </div>
  
  <p>Are you sure you want to delete this booking?</p>
  <p><strong>Customer:</strong> ${booking.userName}<br>
  <strong>Service:</strong> ${booking.serviceName}<br>
  <strong>Date:</strong> ${booking.bookingDate}</p>
  
  <form method="post" action="${pageContext.request.contextPath}/admin/booking?action=delete" class="form">
  <input type="hidden" name="bookingId" value="${booking.bookingId}">
  <button type="submit" class="btn btn-danger">Delete Booking</button>
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
