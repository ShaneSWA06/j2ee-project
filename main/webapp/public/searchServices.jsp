<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<%@ page import="java.util.*" %>
<%
// Set response type to JSON
response.setContentType("application/json");

// Get search parameters
String query = request.getParameter("q");
String categoryId = request.getParameter("categoryId");

// Start JSON array
StringBuilder json = new StringBuilder();
json.append("[");

try (Connection conn = DBUtil.getConnection()) {
    // Build SQL query based on parameters
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT s.service_id, s.service_name, s.description, s.base_price, ");
    sql.append("s.duration_minutes, c.category_name ");
    sql.append("FROM service s ");
    sql.append("LEFT JOIN service_category c ON s.category_id = c.category_id ");
    sql.append("WHERE s.is_active = TRUE ");

    // Add search filter if query is provided
    if (query != null && !query.trim().isEmpty()) {
        sql.append("AND (LOWER(s.service_name) LIKE LOWER(?) ");
        sql.append("OR LOWER(s.description) LIKE LOWER(?) ");
        sql.append("OR LOWER(c.category_name) LIKE LOWER(?)) ");
    }

    // Add category filter if provided
    if (categoryId != null && !categoryId.trim().isEmpty()) {
        sql.append("AND s.category_id = ? ");
    }

    sql.append("ORDER BY s.service_name");

    try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        int paramIndex = 1;

        // Set search query parameters
        if (query != null && !query.trim().isEmpty()) {
            String searchPattern = "%" + query.trim() + "%";
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
        }

        // Set category filter parameter
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            ps.setInt(paramIndex++, Integer.parseInt(categoryId));
        }

        try (ResultSet rs = ps.executeQuery()) {
            boolean first = true;

            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                first = false;

                // Build JSON object for each service
                json.append("{");
                json.append("\"serviceId\":").append(rs.getInt("service_id")).append(",");
                json.append("\"serviceName\":\"").append(escapeJson(rs.getString("service_name"))).append("\",");
                json.append("\"description\":\"").append(escapeJson(rs.getString("description"))).append("\",");
                json.append("\"basePrice\":").append(rs.getBigDecimal("base_price")).append(",");
                json.append("\"durationMinutes\":").append(rs.getInt("duration_minutes")).append(",");
                json.append("\"categoryName\":\"").append(escapeJson(rs.getString("category_name"))).append("\"");
                json.append("}");
            }
        }
    }
} catch (Exception e) {
    // Return error as JSON
    json.setLength(0);
    json.append("{\"error\":\"").append(escapeJson(e.getMessage())).append("\"}");
    out.print(json.toString());
    return;
}

json.append("]");
out.print(json.toString());
%>

<%!
// Helper method to escape JSON strings
private String escapeJson(String str) {
    if (str == null) return "";
    return str.replace("\\", "\\\\")
              .replace("\"", "\\\"")
              .replace("\n", "\\n")
              .replace("\r", "\\r")
              .replace("\t", "\\t");
}
%>
