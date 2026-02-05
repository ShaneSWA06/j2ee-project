<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../../includes/header.jsp"><jsp:param name="title" value="Book Medical Escort"/></jsp:include>
<jsp:include page="../../includes/navbar.jsp"/>

<div class="container" style="padding-top: 2rem; padding-bottom: 4rem;">
    <div class="form-container">
        <h1>Book Service</h1>
        <p class="form-subtitle">Please select your preferred date and time.</p>
        
        <form action="${pageContext.request.contextPath}/customer/medical-escort" method="get">
            <input type="hidden" name="action" value="confirm">
            <input type="hidden" name="serviceId" value="${param.id}">
            <input type="hidden" name="name" value="${param.name}">
            <input type="hidden" name="price" value="${param.price}">
            
            <div class="card" style="margin-bottom: 1.5rem; background: var(--bg-soft);">
                <h3>Selected: ${param.name}</h3>
                <p>Base Fee: $${param.price} / session</p>
            </div>

            <div class="form-group">
                <label>Appointment Date</label>
                <input type="date" name="bookingDate" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
            </div>

            <div class="form-group">
                <label>Pickup Time</label>
                <input type="time" name="bookingTime" required>
            </div>

            <div class="form-group">
                <label>Pickup Address</label>
                <textarea name="pickupAddress" required placeholder="Enter pickup location..."></textarea>
            </div>
            
            <div class="form-group">
                <label>Destination (Hospital/Clinic)</label>
                <input type="text" name="destinationAddress" required placeholder="e.g. general Hospital">
            </div>

            <div class="form-group">
                <label>Select Caregiver</label>
                <select name="caregiverId" class="form-control">
                    <option value="">-- Select a Caregiver (Optional) --</option>
                    <c:forEach var="caregiver" items="${caregivers}">
                        <option value="${caregiver.caregiverId}">
                            ${caregiver.name} - ${caregiver.specialties}
                        </option>
                    </c:forEach>
                </select>
                <small style="color: var(--text-muted); display: block; margin-top: 0.5rem;">
                    Choose a caregiver to assist you during your medical escort service
                </small>
            </div>

            <div class="form-footer">
                <button type="submit" class="btn btn-primary" style="width: 100%;">Proceed to Confirmation</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../../includes/footer.jsp"/>
