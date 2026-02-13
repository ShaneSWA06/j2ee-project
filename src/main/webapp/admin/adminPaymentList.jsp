<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Financial Overview | SilverCare"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container py-12">
    <div class="mb-8">
        <h1 class="text-3xl font-bold tracking-tight">Financial Overview</h1>
        <p class="text-muted">Track and manage all processed payments across the platform.</p>
    </div>

    <div class="card card--glass overflow-hidden">
        <table style="width:100%; border-collapse:collapse;">
            <thead>
                <tr>
                    <th style="text-align: left; padding: 16px; background: rgba(255,255,255,0.05); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">ID</th>
                    <th style="text-align: left; padding: 16px; background: rgba(255,255,255,0.05); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">Amount</th>
                    <th style="text-align: left; padding: 16px; background: rgba(255,255,255,0.05); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">Status</th>
                    <th style="text-align: left; padding: 16px; background: rgba(255,255,255,0.05); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">Method</th>
                    <th style="text-align: left; padding: 16px; background: rgba(255,255,255,0.05); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">Transaction ID</th>
                    <th style="text-align: left; padding: 16px; background: rgba(255,255,255,0.05); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em;">Date</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty payments}">
                        <c:forEach var="payment" items="${payments}">
                            <tr style="border-top:1px solid rgba(255,255,255,0.1); transition: background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.02)'" onmouseout="this.style.background='transparent'">
                                <td style="padding: 16px; font-family: monospace; opacity: 0.7;">#${payment.paymentId}</td>
                                <td style="padding: 16px; font-weight: 600; color: var(--accent);">
                                    <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="$"/> ${payment.currency}
                                </td>
                                <td style="padding: 16px;">
                                    <c:set var="statusColor" value="${payment.status == 'COMPLETED' || payment.status == 'Paid' ? '#22c55e' : (payment.status == 'FAILED' ? '#ef4444' : '#f59e0b')}" />
                                    <span style="padding: 4px 10px; border-radius: 99px; background: ${statusColor}15; color: ${statusColor}; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; border: 1px solid ${statusColor}30;">
                                        ${payment.status}
                                    </span>
                                </td>
                                <td style="padding: 16px; font-size: 0.9rem;">${payment.paymentMethod}</td>
                                <td style="padding: 16px; font-family: monospace; font-size: 0.8rem; opacity: 0.6;">${payment.transactionId}</td>
                                <td style="padding: 16px; font-size: 0.9rem; opacity: 0.8;">
                                    <c:if test="${not empty payment.createdAt}">
                                        <fmt:formatDate value="${payment.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="text-align:center; padding: 48px; color: rgba(255,255,255,0.4);">
                                <div style="font-size: 2rem; margin-bottom: 12px;">💸</div>
                                <p>No payment records found in the system.</p>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
    
    <div class="mt-8">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-arrow-left mr-2"></i> Back to Command Center
        </a>
    </div>
</div>

<jsp:include page="../includes/footer.jsp"/>
