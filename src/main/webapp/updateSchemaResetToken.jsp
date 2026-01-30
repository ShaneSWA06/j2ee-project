<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Database Schema</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }
        .success { background: #d4edda; border: 2px solid #c3e6cb; color: #155724; padding: 15px; border-radius: 8px; margin: 10px 0; }
        .error { background: #f8d7da; border: 2px solid #f5c6cb; color: #721c24; padding: 15px; border-radius: 8px; margin: 10px 0; }
        .info { background: #d1ecf1; border: 2px solid #bee5eb; color: #0c5460; padding: 15px; border-radius: 8px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>Update Database Schema - Add Reset Token Column</h1>

    <%
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();

            // Add reset_token column to customer table
            String sql = "ALTER TABLE customer ADD COLUMN IF NOT EXISTS reset_token VARCHAR(10)";
            ps = conn.prepareStatement(sql);
            ps.executeUpdate();

            out.println("<div class='success'>");
            out.println("<h2>✓ Schema Updated Successfully!</h2>");
            out.println("<p>Added <code>reset_token</code> column to <code>customer</code> table.</p>");
            out.println("<p>You can now use the Forgot Password feature!</p>");
            out.println("</div>");

            out.println("<div class='info'>");
            out.println("<h3>Next Steps:</h3>");
            out.println("<ul>");
            out.println("<li>Go to <a href='" + request.getContextPath() + "/auth/login.jsp'>Login Page</a></li>");
            out.println("<li>Click 'Forgot Password?' link</li>");
            out.println("<li>Enter your email to test the feature</li>");
            out.println("</ul>");
            out.println("</div>");

        } catch (SQLException e) {
            out.println("<div class='error'>");
            out.println("<h2>⚠ Error Updating Schema</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</div>");
            e.printStackTrace();
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>

</body>
</html>
