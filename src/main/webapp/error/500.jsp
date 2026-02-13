<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ page import="java.io.*" %>
<jsp:include page="../includes/header.jsp">
    <jsp:param name="title" value="System Error | Silver Caregivers"/>
</jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container container--vcentered">
    <div class="card card--glass p-5 max-w-2xl mx-auto">
        <div class="text-center">
            <div class="error-icon mb-4">⚠️</div>
            <h1 class="mb-3">Oops! Something Went Wrong</h1>
            <p class="text-muted mb-4">We're sorry for the inconvenience. Our team has been notified and is working to fix this.</p>
        </div>

        <% 
            String errorMsg = (String) request.getAttribute("jakarta.servlet.error.message");
            if (errorMsg == null && exception != null) errorMsg = exception.getMessage();
            if (errorMsg == null) errorMsg = "An unexpected server error occurred.";
        %>
        <div class="error-details bg-black/20 p-4 rounded-lg text-left mb-5">
            <p class="font-bold text-red-400 mb-2">Error Details:</p>
            <code class="text-sm text-gray-300">
                <%= errorMsg %>
            </code>
            <% if (exception != null) { %>
                <pre class="text-xs text-gray-500 mt-2" style="max-height: 200px; overflow: auto;">
                    <% 
                        java.io.StringWriter sw = new java.io.StringWriter();
                        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                        exception.printStackTrace(pw);
                        out.print(sw.toString());
                    %>
                </pre>
            <% } %>
        </div>

        <div class="flex justify-center flex-col sm:flex-row gap-4">
            <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Return Home</a>
        </div>
    </div>
</div>

<style>
    .error-icon {
        font-size: 5rem;
    }
    .container--vcentered {
        min-height: 70vh;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .error-details {
        border-left: 4px solid var(--accent);
    }
</style>

<jsp:include page="../includes/footer.jsp"/>
