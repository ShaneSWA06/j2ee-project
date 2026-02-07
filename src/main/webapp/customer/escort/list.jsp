<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../../includes/header.jsp"><jsp:param name="title" value="Medical Escort Services"/></jsp:include>
<jsp:include page="../../includes/navbar.jsp"/>

<div class="container hero">
    <h1>Medical <span>Escort</span> Services</h1>
    <p>Professional accompaniment for your medical appointments.</p>
</div>

<div class="container" style="padding-bottom: 4rem;">
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <div class="grid grid-cols-3">
        <c:forEach var="escort" items="${escorts}">
            <div class="card">
                <div class="service-icon">🚑</div>
                <h3>${escort.serviceName}</h3>
                <p>${escort.description}</p>
                <h4 class="text-coral">$<fmt:formatNumber value="${escort.basePrice}" maxFractionDigits="2"/></h4>
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/customer/addToCartForm.jsp?serviceId=${escort.serviceId}" class="btn btn-primary" style="width: 100%;">Book Now</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../../includes/footer.jsp"/>
