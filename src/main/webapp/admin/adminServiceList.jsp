<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Manage Services"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
  <h1>Services</h1>
  
  <c:if test="${not empty param.success}">
    <div class="alert alert-success">
      <c:choose>
        <c:when test="${param.success == 'created'}">Service created successfully!</c:when>
        <c:when test="${param.success == 'updated'}">Service updated successfully!</c:when>
        <c:when test="${param.success == 'deleted'}">Service deleted successfully!</c:when>
      </c:choose>
    </div>
  </c:if>
  
  <c:if test="${not empty param.err}">
    <div class="alert alert-danger">Unable to complete the action. Please try again.</div>
  </c:if>
  
  <p style="margin-bottom: 2rem;">
    <a href="${pageContext.request.contextPath}/admin/service?action=create" class="btn btn-primary">
      <i class="fas fa-plus"></i> Add New Service
    </a>
  </p>
  
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Service</th>
        <th>Category</th>
        <th>Pricing</th>
        <th>Efficiency</th>
        <th>Status</th>
        <th>Actions</th>
      </tr>
    </thead>
    
    <c:choose>
      <c:when test="${not empty services}">
        <c:forEach var="service" items="${services}">
          <tr>
            <td><span class="badge" style="background: var(--surface); color: var(--foreground-muted); border: 1px solid var(--border-default);">${service.serviceId}</span></td>
            <td>
              <div style="display: flex; align-items: center; gap: 12px;">
                <c:if test="${not empty service.imageUrl}">
                  <img src="${pageContext.request.contextPath}/${service.imageUrl}" style="width: 40px; height: 40px; border-radius: 8px; object-fit: cover; border: 1px solid var(--border-default);">
                </c:if>
                <div style="font-weight: 600; color: var(--foreground);">${service.serviceName}</div>
              </div>
            </td>
            <td><span class="badge" style="background: var(--accent-glow); color: var(--accent-bright); border: 1px solid var(--border-accent);">${service.categoryName}</span></td>
            <td style="font-weight: 500;"><fmt:formatNumber value="${service.basePrice}" pattern="$#,##0.00"/></td>
            <td style="color: var(--foreground-muted); font-size: 0.9rem;"><i class="far fa-clock" style="margin-right: 4px;"></i> ${service.durationMinutes} min</td>
            <td>
              <c:choose>
                <c:when test="${service.active}">
                  <span style="color: #22c55e; display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 0.85rem;">
                    <span style="width: 6px; height: 6px; border-radius: 50%; background: #22c55e; box-shadow: 0 0 8px #22c55e;"></span>
                    Active
                  </span>
                </c:when>
                <c:otherwise>
                  <span style="color: var(--foreground-muted); display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 0.85rem;">
                    <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--foreground-muted);"></span>
                    Inactive
                  </span>
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <div style="display: flex; gap: 8px;">
                <a class="btn btn-sm btn-secondary" href="${pageContext.request.contextPath}/admin/service?action=edit&serviceId=${service.serviceId}">
                  <i class="fas fa-edit"></i> Edit
                </a>
                <a class="btn btn-sm btn-outline" href="${pageContext.request.contextPath}/admin/service?action=delete&serviceId=${service.serviceId}" style="color: #ef4444; border-color: rgba(239, 68, 68, 0.2);">
                  <i class="fas fa-trash"></i> Delete
                </a>
              </div>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="7" style="text-align:center; padding:3rem; color: var(--foreground-muted);">
            <div style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.2;">🏥</div>
            <p>No services found. Click "Add New Service" to build your catalog.</p>
          </td>
        </tr>
      </c:otherwise>
    </c:choose>
  </table>
  
  <p style="margin-top:20px">
    <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>
  </p>
</div>
<jsp:include page="../includes/footer.jsp"/>
