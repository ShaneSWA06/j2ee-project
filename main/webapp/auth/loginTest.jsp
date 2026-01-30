<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Login Test</title>
</head>
<body>
    <h1>Login Test Page</h1>

    <!-- DEBUG: Show what we received -->
    <p>Error parameter value: [<%= request.getParameter("err") %>]</p>
    <p>Msg parameter value: [<%= request.getParameter("msg") %>]</p>

    <!-- Error Display Test -->
    <%
    String err = request.getParameter("err");
    String msg = request.getParameter("msg");

    out.println("<!-- DEBUG: err = " + err + " -->");
    out.println("<!-- DEBUG: msg = " + msg + " -->");

    if (err != null) {
    %>
        <div style="background: #f8d7da; border: 2px solid #f5c6cb; color: #721c24; margin-bottom: 20px; padding: 15px; border-radius: 8px;">
            <p style="margin: 0; font-size: 16px;"><strong>ERROR:</strong>
            <% if ("missing".equals(err)) { %>
                Please enter both email/username and password.
            <% } else if ("invalid".equals(err)) { %>
                Invalid username/email or password. Please try again.
            <% } else { %>
                <%= err %>
            <% } %>
            </p>
        </div>
    <% } %>

    <!-- Login Form -->
    <form method="post" action="loginProcess.jsp">
        <div>
            <label>Email or Username:</label><br>
            <input type="text" name="identifier" required />
        </div>
        <div>
            <label>Password:</label><br>
            <input type="password" name="password" required />
        </div>
        <button type="submit">Login</button>
    </form>

    <hr>
    <h3>Test Links:</h3>
    <ul>
        <li><a href="loginTest.jsp?err=invalid">Test with err=invalid</a></li>
        <li><a href="loginTest.jsp?err=missing">Test with err=missing</a></li>
        <li><a href="loginTest.jsp?msg=registered">Test with msg=registered</a></li>
    </ul>
</body>
</html>
