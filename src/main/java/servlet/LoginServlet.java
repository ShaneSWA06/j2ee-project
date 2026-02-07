package servlet;

import java.io.IOException;
import java.sql.SQLException;

import dao.DAOFactory;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * LoginServlet handles user authentication for both admin and customer users
 * Processes login form submissions and establishes user sessions
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = DAOFactory.getUserDAO();
    }

    /**
     * Handle GET requests - redirect to login page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
    }

    /**
     * Handle POST requests - process login form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=missing");
            return;
        }

        try {
            // Use DAO to validate login
            User user = userDAO.validateLogin(username, password);

            if (user != null) {
                // Check verification status
                if (!user.isVerified()) {
                    response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=not_verified");
                    return;
                }

                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("sessUserId", user.getUserId());
                session.setAttribute("sessUserRole", user.getRole());
                session.setAttribute("sessUserName", user.getName() != null ? user.getName() : user.getUsername());
                session.setAttribute("sessUserEmail", user.getEmail());

                // Set remember cookie
                Cookie cookie = new Cookie("remember_id", username);
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                cookie.setPath("/");
                response.addCookie(cookie);

                // Route based on role
                session.setAttribute("user", user); // Store full user object
                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else if ("CAREGIVER".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/caregiver/dashboard");
                } else if ("COMPANY_ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/company/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/customer/customerHome.jsp");
                }
                return;
            }

            // Login failed - no matching user
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=invalid");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=" + e.getMessage());
        }
    }
}
