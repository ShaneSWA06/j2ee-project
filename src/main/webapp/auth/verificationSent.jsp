<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = request.getParameter("email");
    if (email == null) email = "your email address";
%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Verification Sent"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="form-container" style="text-align: center; max-width: 600px;">
    <div class="success-icon-container" style="margin-bottom: 2rem;">
        <div style="font-size: 5rem; color: var(--accent); filter: drop-shadow(0 0 15px var(--accent-glow));">✉️</div>
    </div>
    
    <h1 style="color: var(--foreground);">Check your email</h1>
    <p class="form-subtitle" style="color: var(--foreground-muted);">We've sent a verification link to <strong style="color: var(--foreground);"><%= email %></strong></p>
    
    <div class="card" style="margin: 2rem 0; background: var(--surface); border-color: var(--border-default); backdrop-filter: blur(12px);">
        <p style="color: var(--foreground-muted); line-height: 1.6;">
            Please click the link in the email to verify your account. 
            If you don't see it, please check your <strong>spam folder</strong>.
        </p>
    </div>
    
    <div class="form-footer" style="margin-top: 2.5rem; border-top-color: var(--border-default);">
        <p style="color: var(--foreground-subtle); margin-bottom: 1.5rem;">Didn't receive the email?</p>
        <div style="display: flex; gap: 1rem; justify-content: center;">
            <a href="${pageContext.request.contextPath}/RegisterServlet" class="btn btn-secondary">Back to Signup</a>
            <a href="${pageContext.request.contextPath}/auth/login.jsp" class="btn btn-primary">Go to Login</a>
        </div>
    </div>
</div>

<style>
    .form-container {
        animation: fadeInScale 0.6s cubic-bezier(0.16, 1, 0.3, 1);
    }
    
    @keyframes fadeInScale {
        from {
            opacity: 0;
            transform: scale(0.95) translateY(10px);
        }
        to {
            opacity: 1;
            transform: scale(1) translateY(0);
        }
    }

    .success-icon-container {
        animation: pulseGlow 3s infinite ease-in-out;
    }

    @keyframes pulseGlow {
        0%, 100% { transform: translateY(0); opacity: 0.8; }
        50% { transform: translateY(-10px); opacity: 1; }
    }
</style>

<jsp:include page="../includes/footer.jsp"/>
