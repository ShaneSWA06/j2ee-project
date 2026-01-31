<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Sales Management"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Sales Management (Payments)</h1>
  
  <table style="width:100%; border-collapse:collapse; margin-top:20px;">
    <tr>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">ID</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Amount</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Status</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Method</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Transaction ID</th>
      <th style="text-align: left; padding: 12px; background: #f5f5f5;">Date</th>
    </tr>
    
    <c:choose>
      <c:when test="${not empty payments}">
        <c:forEach var="payment" items="${payments}">
          <tr style="border-top:1px solid #eee">
            <td style="vertical-align: middle; padding: 12px;">${payment.paymentId}</td>
            <td style="vertical-align: middle; padding: 12px; font-weight: bold;">
                <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="$"/> ${payment.currency}
            </td>
            <td style="vertical-align: middle; padding: 12px;">
                <span style="
                    padding: 4px 8px; border-radius: 4px;
                    background: ${payment.status == 'Paid' ? '#d4edda' : '#fff3cd'};
                    color: ${payment.status == 'Paid' ? '#155724' : '#856404'};
                ">
                    ${payment.status}
                </span>
            </td>
            <td style="vertical-align: middle; padding: 12px;">${payment.paymentMethod}</td>
            <td style="vertical-align: middle; padding: 12px; font-family: monospace;">${payment.transactionId}</td>
            <td style="vertical-align: middle; padding: 12px;">
                <fmt:formatDate value="${payment.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="6" style="text-align:center; padding:20px; color:#888;">No payments found.</td>
        </tr>
      </c:otherwise>
    </c:choose>
  </table>
  
  <p style="margin-top:20px">
    <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>
  </p>
</div>
<jsp:include page="../includes/footer.jsp"/>
