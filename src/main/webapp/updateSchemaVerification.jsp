<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><title>Update Schema - Verification</title></head>
<body>
<h2>Updating Database Schema for Email Verification...</h2>
<pre>
<%
    try (Connection conn = DBUtil.getConnection();
         Statement stmt = conn.createStatement()) {

        // Add is_verified column
        try {
            stmt.executeUpdate("ALTER TABLE app_user ADD COLUMN is_verified BOOLEAN DEFAULT FALSE");
            out.println("Added column 'is_verified'.");
        } catch (SQLException e) {
            out.println("Column 'is_verified' might already exist: " + e.getMessage());
        }

        // Add verification_token column
        try {
            stmt.executeUpdate("ALTER TABLE app_user ADD COLUMN verification_token VARCHAR(255)");
            out.println("Added column 'verification_token'.");
        } catch (SQLException e) {
            out.println("Column 'verification_token' might already exist: " + e.getMessage());
        }

        out.println("\nSchema update completed.");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
</pre>
</body>
</html>