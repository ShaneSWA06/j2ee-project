<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Caregiver Feedback"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>
<div class="container">
    <div class="dashboard-header animate-in">
        <div class="header-content">
            <span class="badge">Feedback Management</span>
            <h1>Review & Performance</h1>
            <p class="page-subtitle">Manage customer reviews and caregiver feedback reports.</p>
        </div>
    </div>

    <div style="margin-bottom: 30px;" class="animate-in" style="animation-delay: 100ms;">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/feedback?action=create">
            <i class="fas fa-paper-plane" style="margin-right: 8px;"></i> Send Official Feedback to Caregiver
        </a>
    </div>

    <!-- Navigation Tabs -->
    <div class="border-b border-gray-700 mb-8 animate-in" style="animation-delay: 200ms; border-bottom: 1px solid rgba(255,255,255,0.1); margin-bottom: 2rem;">
        <nav style="display: flex; gap: 2rem;">
            <a href="${pageContext.request.contextPath}/admin/feedback?type=customer" 
               style="padding: 1rem 0; border-bottom: 2px solid ${viewType == 'customer' ? 'var(--accent)' : 'transparent'}; color: ${viewType == 'customer' ? 'var(--accent-bright)' : 'var(--foreground-muted)'}; text-decoration: none; font-weight: 600; font-size: 0.95rem; transition: all 0.2s;">
               Customer Reviews
            </a>
            <a href="${pageContext.request.contextPath}/admin/feedback?type=caregiver" 
               style="padding: 1rem 0; border-bottom: 2px solid ${viewType == 'caregiver' ? 'var(--accent)' : 'transparent'}; color: ${viewType == 'caregiver' ? 'var(--accent-bright)' : 'var(--foreground-muted)'}; text-decoration: none; font-weight: 600; font-size: 0.95rem; transition: all 0.2s;">
               Caregiver Feedback
            </a>
        </nav>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success animate-in" style="animation-delay: 300ms;">
            <c:choose>
                <c:when test="${param.success == 'created'}">Feedback sent successfully!</c:when>
                <c:when test="${param.success == 'updated'}">Review updated successfully!</c:when>
                <c:when test="${param.success == 'deleted'}">Review removed successfully!</c:when>
            </c:choose>
        </div>
    </c:if>
    <c:if test="${not empty param.err}">
        <div class="alert alert-danger animate-in" style="animation-delay: 300ms;">Unable to complete the action. Please try again.</div>
    </c:if>

    <div class="card animate-in" style="animation-delay: 400ms; padding: 0; overflow: hidden;">
        <table class="table" style="margin: 0;">
            <thead>
                <tr>
                    <th>#</th>
                    <th>${viewType == 'customer' ? 'Submitted By' : 'Caregiver'}</th>
                    <th>Rating</th>
                    <th>${viewType == 'customer' ? 'About Caregiver' : 'Role'}</th>
                    <th>Comment</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="targetList" value="${viewType == 'caregiver' ? caregiverFeedback : customerFeedback}" />
                <c:choose>
                    <c:when test="${not empty targetList}">
                        <c:forEach var="feedback" items="${targetList}">
                            <tr>
                                <td><span class="badge" style="background: var(--surface); color: var(--foreground-muted); border: 1px solid var(--border-default);">${feedback.feedbackId}</span></td>
                                <td style="font-weight: 600; color: var(--foreground);">${feedback.userName}</td>
                                <td>
                                    <div style="color: #facc15; display: flex; align-items: center; gap: 4px;">
                                        <i class="fas fa-star"></i> ${feedback.rating}/5
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${viewType == 'customer'}">
                                            <span class="badge" style="background: var(--accent-glow); color: var(--accent-bright); border: 1px solid var(--border-accent);">
                                                ${not empty feedback.caregiverName ? feedback.caregiverName : 'General'}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge" style="background: rgba(59, 130, 246, 0.1); color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.2);">
                                                Caregiver Report
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="color: var(--foreground-muted); max-width: 300px; font-size: 0.9rem;">
                                    ${feedback.comment}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty feedback.adminReply}">
                                            <span style="color: #22c55e; display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 0.85rem;">
                                                <i class="fas fa-check-circle"></i> Replied
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #f59e0b; display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 0.85rem;">
                                                <i class="fas fa-clock"></i> Pending
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${not empty feedback.caregiverReply}">
                                        <div style="margin-top: 4px; color: #3b82f6; font-size: 0.75rem; font-weight: 700; text-transform: uppercase;">
                                            <i class="fas fa-reply"></i> Caregiver Replied
                                        </div>
                                    </c:if>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a class="btn btn-sm btn-secondary" href="${pageContext.request.contextPath}/admin/feedback?action=edit&feedbackId=${feedback.feedbackId}">
                                            <i class="fas fa-reply"></i> ${not empty feedback.adminReply ? 'Update' : 'Reply'}
                                        </a>
                                        <a class="btn btn-sm btn-outline" href="${pageContext.request.contextPath}/admin/feedback?action=delete&feedbackId=${feedback.feedbackId}" style="color: #ef4444; border-color: rgba(239, 68, 68, 0.2);">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" style="text-align:center; padding:4rem; color: var(--foreground-muted);">
                                <div style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.2;">✨</div>
                                <p>No ${viewType == 'customer' ? 'customer reviews' : 'caregiver feedback'} found for this period.</p>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
    
    <p style="margin-top:30px">
        <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-arrow-left" style="margin-right: 8px;"></i> Back to Command Center
        </a>
    </p>
</div>
<jsp:include page="../includes/footer.jsp"/>
