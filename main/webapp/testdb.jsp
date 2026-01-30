<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.sql.Connection"%> <%@ page
import="java.sql.Statement"%> <%@ page import="java.sql.ResultSet"%> <%@ page
import="java.sql.SQLException"%> <%@ page import="db.DBUtil"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Database Connection Test</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        max-width: 800px;
        margin: 50px auto;
        padding: 20px;
        background-color: #f5f5f5;
      }
      .container {
        background-color: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
      h1 {
        color: #333;
        border-bottom: 3px solid #4caf50;
        padding-bottom: 10px;
      }
      .success {
        color: #4caf50;
        padding: 15px;
        background-color: #e8f5e9;
        border-left: 4px solid #4caf50;
        margin: 10px 0;
      }
      .error {
        color: #f44336;
        padding: 15px;
        background-color: #ffebee;
        border-left: 4px solid #f44336;
        margin: 10px 0;
      }
      .info {
        background-color: #e3f2fd;
        padding: 10px;
        margin: 10px 0;
        border-radius: 4px;
      }
      pre {
        background-color: #f5f5f5;
        padding: 10px;
        border-radius: 4px;
        overflow-x: auto;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Database Connection Test</h1>
      <% Connection conn = null; Statement stmt = null; ResultSet rs = null; try
      { conn = DBUtil.getConnection(); if (conn != null && !conn.isClosed()) {
      %>
      <div class="success">
        <h2>Connection Successful!</h2>
        <p><strong>Database:</strong> <%=conn.getCatalog()%></p>
        <p><strong>AutoCommit:</strong> <%=conn.getAutoCommit()%></p>
      </div>
      <h3>Database Information:</h3>
      <div class="info">
        <% stmt = conn.createStatement(); rs = stmt.executeQuery("SELECT version(), current_database(), current_user, now()"); if (rs.next()) { %>
       
        <p>
          <strong>PostgreSQL Version:</strong><br /><code
            ><%=rs.getString(1)%></code
          >
        </p>
        <p><strong>Current Database:</strong> <%=rs.getString(2)%></p>
        <p><strong>Current User:</strong> <%=rs.getString(3)%></p>
        <p><strong>Server Time:</strong> <%=rs.getString(4)%></p>
        <% } %>
      </div>
      <% } else { %>
      <div class="error">
        <h2>Connection Failed</h2>
        <p>Connection object is null or closed.</p>
      </div>
      <% } } catch (SQLException e) { %>
      <div class="error">
        <h2>Database Error</h2>
        <p><strong>Error Message:</strong> <%=e.getMessage()%></p>
        <p><strong>SQL State:</strong> <%=e.getSQLState()%></p>
        <p><strong>Error Code:</strong> <%=e.getErrorCode()%></p>
        <h3>Stack Trace:</h3>
        <pre>
<%e.printStackTrace(new java.io.PrintWriter(out));%>
</pre
        >
      </div>
      <% } finally { try { if (rs != null) rs.close(); if (stmt != null)
      stmt.close(); if (conn != null) { conn.close(); %>
      <p style="color: #666; margin-top: 20px">
        Connection closed successfully
      </p>
      <% } } catch (SQLException e) { %>
      <p style="color: #f44336">
        Error closing connection: <%=e.getMessage()%>
      </p>
      <% } } %>
    </div>
  </body>
</html>
