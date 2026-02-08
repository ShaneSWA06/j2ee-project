<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="Page Not Found | Silver Caregivers"/>
</jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container container--vcentered">
    <div class="card card--glass text-center p-5">
        <div class="error-code mb-4">404</div>
        <h1 class="mb-3">Oops! Page Not Found</h1>
        <p class="text-muted mb-5">The page you're looking for doesn't exist or has been moved. Use the button below to return home.</p>
        <div class="flex justify-center">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary btn-lg">Return to Home</a>
        </div>
    </div>
</div>

<style>
    .error-code {
        font-size: 6rem;
        font-weight: 800;
        background: linear-gradient(135deg, var(--accent) 0%, #a5b4fc 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        line-height: 1;
    }
    .container--vcentered {
        min-height: 70vh;
        display: flex;
        align-items: center;
        justify-content: center;
    }
</style>

<jsp:include page="../includes/footer.jsp"/>
