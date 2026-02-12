package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

import db.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * ForgotPasswordServlet handles password reset requests
 * Generates a 6-digit verification code and stores it in the database
 * Simulates email by printing code to console
 */
@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        // Validate input
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/forgotPassword.jsp?err=missing");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            // Check if email exists in app_user table
            ps = conn.prepareStatement("SELECT user_id, name FROM app_user WHERE email = ?");
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String name = rs.getString("name");

                // Generate random 6-digit code
                Random random = new Random();
                int code = 100000 + random.nextInt(900000); // Generates 6-digit number
                String resetToken = String.valueOf(code);

                rs.close();
                ps.close();

                // Update user with reset token
                ps = conn.prepareStatement(
                    "UPDATE app_user SET reset_token = ? WHERE user_id = ?");
                ps.setString(1, resetToken);
                ps.setInt(2, userId);
                int result = ps.executeUpdate();

                if (result > 0) {
                    // Store email in session for verification page
                    HttpSession session = request.getSession();
                    session.setAttribute("resetEmail", email);

                    // Send real email via EmailService
                    try {
                        service.EmailService.sendPasswordResetEmail(email, resetToken, name);
                    } catch (Exception e) {
                        System.err.println("Failed to send reset email: " + e.getMessage());
                        // Even if email fails, we continue to reset page so user can see code in console if needed for dev
                    }

                    // Log to console for debugging/audit
                    System.out.println("DEBUG - Password reset email sent to: " + email + " with code: " + resetToken);

                    // Redirect to reset password page
                    response.sendRedirect(request.getContextPath() +
                        "/auth/resetPassword.jsp?success=code_sent");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/auth/forgotPassword.jsp?err=failed");
                }

            } else {
                // Email not found
                response.sendRedirect(request.getContextPath() +
                    "/auth/forgotPassword.jsp?err=notfound");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/auth/forgotPassword.jsp?err=" + e.getMessage());
        } finally {
            if (rs != null) {
				try { rs.close(); } catch (SQLException ignore) {}
			}
            if (ps != null) {
				try { ps.close(); } catch (SQLException ignore) {}
			}
            if (conn != null) {
				try { conn.close(); } catch (SQLException ignore) {}
			}
        }
    }
}
