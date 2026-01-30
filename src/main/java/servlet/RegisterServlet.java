package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBUtil;

/**
 * RegisterServlet handles customer registration
 * Validates input, checks for duplicates, and creates new customer accounts
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handle GET requests - redirect to registration page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer/registerCustomer.jsp");
    }

    /**
     * Handle POST requests - process registration form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String relationship = request.getParameter("relationship");
        String address = request.getParameter("address");
        String careNotes = request.getParameter("care_notes");

        // Validate required fields
        if (username == null || username.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                "/customer/registerCustomer.jsp?err=missing_fields");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            // Check for duplicate email or username
            ps = conn.prepareStatement(
                "SELECT 1 FROM app_user WHERE email=? OR username=?");
            ps.setString(1, email);
            ps.setString(2, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Duplicate found
                response.sendRedirect(request.getContextPath() +
                    "/customer/registerCustomer.jsp?err=duplicate");
                return;
            }

            rs.close();
            ps.close();

            // Insert new customer with role='CUSTOMER'
            ps = conn.prepareStatement(
                "INSERT INTO app_user (username, email, password, role, name, phone, relationship, address, care_notes) " +
                "VALUES (?, ?, ?, 'CUSTOMER', ?, ?, ?, ?, ?)");
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, util.PasswordUtil.hashPassword(password));
            ps.setString(4, name);
            ps.setString(5, phone);
            ps.setString(6, relationship);
            ps.setString(7, address);
            ps.setString(8, careNotes);

            int result = ps.executeUpdate();

            if (result > 0) {
                // Registration successful
                // Set remember cookie
                Cookie cookie = new Cookie("remember_id", username);
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                cookie.setPath("/");
                response.addCookie(cookie);

                response.sendRedirect(request.getContextPath() +
                    "/auth/login.jsp?success=registered");
            } else {
                // Registration failed
                response.sendRedirect(request.getContextPath() +
                    "/customer/registerCustomer.jsp?err=failed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/customer/registerCustomer.jsp?err=" + e.getMessage());
        } finally {
            // Clean up resources
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
}
