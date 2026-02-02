<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../../includes/header.jsp"><jsp:param name="title" value="Book Medical Escort"/></jsp:include>
<jsp:include page="../../includes/navbar.jsp"/>

<div class="container" style="padding-top: 2rem; padding-bottom: 4rem;">
    <div class="form-container">
        <h1>Book Service</h1>
        <p class="form-subtitle">Please select your preferred date and time.</p>
        
        <form action="${pageContext.request.contextPath}/customer/medical-escort" method="get">
            <input type="hidden" name="action" value="confirm">
            <input type="hidden" name="id" value="${param.id}">
            <input type="hidden" name="name" value="${param.name}">
            <input type="hidden" name="price" value="${param.price}">
            
            <div class="card" style="margin-bottom: 1.5rem; background: var(--bg-soft);">
                <h3>Selected: ${param.name}</h3>
                <p>Base Fee: $${param.price} / session</p>
            </div>

            <div class="form-group">
                <label>Appointment Date</label>
                <input type="date" name="date" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
            </div>

            <div class="form-group">
                <label>Pickup Time</label>
                <input type="time" name="time" required>
            </div>

            <div class="form-group">
                <label>Pickup Address</label>
                <textarea name="address" required placeholder="Enter pickup location..."></textarea>
            </div>
            
            <div class="form-group">
                <label>Destination (Hospital/Clinic)</label>
                <input type="text" name="destination" required placeholder="e.g. general Hospital">
            </div>

            <div class="form-footer">
                <button type="submit" class="btn btn-primary" style="width: 100%;">Proceed to Confirmation</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../../includes/footer.jsp"/>
