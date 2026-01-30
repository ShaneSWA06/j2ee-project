<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Login</title>
</head>
<body>
    <h1>Debug Information</h1>

    <h2>URL Parameters:</h2>
    <p><strong>err parameter:</strong> <%= request.getParameter("err") %></p>
    <p><strong>msg parameter:</strong> <%= request.getParameter("msg") %></p>

    <h2>Test Error Display:</h2>
    <%
    String err = request.getParameter("err");
    if (err != null) {
    %>
        <div style="background: red; color: white; padding: 20px; margin: 10px 0;">
            ERROR DETECTED: <%= err %>
        </div>
    <% } else { %>
        <div style="background: yellow; padding: 20px; margin: 10px 0;">
            No error parameter found
        </div>
    <% } %>

    <h2>Test Links:</h2>
    <p><a href="debugLogin.jsp?err=test">Click here to test with err=test</a></p>
    <p><a href="debugLogin.jsp?err=invalid">Click here to test with err=invalid</a></p>
    <p><a href="login.jsp?err=invalid">Go to actual login page with error</a></p>

    <h2>All Request Parameters:</h2>
    <ul>
    <%
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while(paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
    %>
            <li><strong><%= paramName %>:</strong> <%= paramValue %></li>
    <%
        }
    %>
    </ul>
</body>
</html>
