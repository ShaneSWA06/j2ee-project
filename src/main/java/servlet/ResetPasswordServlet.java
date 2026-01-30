package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBUtil;

/**
 * ResetPasswordServlet verifies the reset code and updates the password
 * Demonstrates conditional logic and database update operations
 */
@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String resetEmail = (String) session.getAttribute("resetEmail");

        // Check if user came from forgot password flow
        if (resetEmail == null) {
            response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
            return;
        }

        // Get form parameters
        String code = request.getParameter("code");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (code == null || code.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                "/auth/resetPassword.jsp?err=missing");
            return;
        }

        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() +
                "/auth/resetPassword.jsp?err=password_mismatch");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            // Verify the reset token
            ps = conn.prepareStatement(
                "SELECT user_id, name FROM app_user WHERE email = ? AND reset_token = ?");
            ps.setString(1, resetEmail);
            ps.setString(2, code.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
                // Code is valid - update password
                int userId = rs.getInt("user_id");
                String name = rs.getString("name");

                rs.close();
                ps.close();

                // Update password and clear reset token
                ps = conn.prepareStatement(
                    "UPDATE app_user SET password = ?, reset_token = NULL WHERE user_id = ?");
                ps.setString(1, newPassword);
                ps.setInt(2, userId);
                int result = ps.executeUpdate();

                if (result > 0) {
                    // Password reset successful
                    // Clear session
                    session.removeAttribute("resetEmail");

                    // Print success message to console
                    System.out.println("\n========================================");
                    System.out.println("PASSWORD RESET SUCCESSFUL");
                    System.out.println("========================================");
                    System.out.println("Customer: " + name);
                    System.out.println("Email: " + resetEmail);
                    System.out.println("Password updated successfully!");
                    System.out.println("========================================\n");

                    // Redirect to login with success message
                    response.sendRedirect(request.getContextPath() +
                        "/auth/login.jsp?msg=password_reset_success");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/auth/resetPassword.jsp?err=failed");
                }

            } else {
                // Invalid or expired code
                response.sendRedirect(request.getContextPath() +
                    "/auth/resetPassword.jsp?err=invalid_code");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/auth/resetPassword.jsp?err=" + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
}
