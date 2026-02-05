<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../../includes/header.jsp"><jsp:param name="title" value="Confirm Booking"/></jsp:include>
<jsp:include page="../../includes/navbar.jsp"/>

<div class="container" style="padding-top: 2rem; padding-bottom: 4rem;">
    <div class="form-container">
        <h1>Confirm Details</h1>
        <p class="form-subtitle">Please review your booking details before payment.</p>
        
        <div class="card" style="margin-bottom: 2rem;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                <strong>Service:</strong>
                <span>${param.name}</span>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                <strong>Date:</strong>
                <span>${param.bookingDate}</span>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                <strong>Time:</strong>
                <span>${param.bookingTime}</span>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                <strong>Pickup:</strong>
                <span>${param.pickupAddress}</span>
            </div>
             <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                <strong>Destination:</strong>
                <span>${param.destinationAddress}</span>
            </div>
            <hr style="margin: 1rem 0; border: 0; border-top: 1px solid rgba(0,0,0,0.1);">
            <div style="display: flex; justify-content: space-between; font-size: 1.2rem; color: var(--coral);">
                <strong>Total Amount:</strong>
                <strong>$${param.price}</strong>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/customer/medical-escort" method="get">
            <input type="hidden" name="action" value="payment">
            <input type="hidden" name="serviceId" value="${param.serviceId}">
            <input type="hidden" name="name" value="${param.name}">
            <input type="hidden" name="price" value="${param.price}">
            <input type="hidden" name="bookingDate" value="${param.bookingDate}">
            <input type="hidden" name="bookingTime" value="${param.bookingTime}">
            <input type="hidden" name="pickupAddress" value="${param.pickupAddress}">
            <input type="hidden" name="destinationAddress" value="${param.destinationAddress}">
            
            <button type="submit" class="btn btn-primary" style="width: 100%;">Proceed to Payment</button>
            <div style="text-align: center; margin-top: 1rem;">
                <a href="javascript:history.back()" style="color: var(--text-soft);">Go Back</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../../includes/footer.jsp"/>
