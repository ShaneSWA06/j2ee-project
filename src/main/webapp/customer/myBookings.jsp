<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="My Bookings"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
<h1>My Bookings</h1>
<c:if test="${not empty param.success}"><div class="alert alert-success">Booking ${param.success}!</div></c:if>
<c:if test="${not empty param.err}"><div class="alert alert-danger">Error: ${param.err}</div></c:if>
<p><a href="${pageContext.request.contextPath}/customer/booking?action=create" class="btn btn-primary">Create New Booking</a></p>
<c:choose>
<c:when test="${not empty bookings}">
<c:forEach var="booking" items="${bookings}">
<div class="card" style="margin-bottom: 20px;">
<h3>${booking.serviceName}</h3>
<p><strong>Date:</strong> <fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd"/></p>
<p><strong>Time:</strong> <fmt:formatDate value="${booking.bookingTime}" pattern="HH:mm"/></p>
<p><strong>Status:</strong> <span style="color: ${booking.status == 'Confirmed' ? 'green' : booking.status == 'Cancelled' ? 'red' : 'orange'}">${booking.status}</span></p>
<c:if test="${not empty booking.caregiverName}"><p><strong>Caregiver:</strong> ${booking.caregiverName}</p></c:if>
<c:if test="${not empty booking.notes}"><p><strong>Notes:</strong> ${booking.notes}</p></c:if>
</div>
</c:forEach>
</c:when>
<c:otherwise><p>No bookings yet. <a href="${pageContext.request.contextPath}/customer/booking?action=create">Create one now!</a></p></c:otherwise>
</c:choose>
</div>
<jsp:include page="../includes/footer.jsp"/>
