package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

import dao.DAOFactory;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.EmailService;

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
        response.sendRedirect(request.getContextPath() + "/public/registerClient.jsp");
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
                "/public/registerClient.jsp?err=missing_fields");
            return;
        }

        try {
            UserDAO userDAO = DAOFactory.getUserDAO();

            // Check for duplicate email or username
            if (userDAO.getUserByEmail(email) != null || userDAO.getUserByUsername(username) != null) {
                response.sendRedirect(request.getContextPath() +
                    "/public/registerClient.jsp?err=duplicate");
                return;
            }

            // Create new User object
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password); // UserDAO will hash this
            user.setName(name);
            user.setRole("CUSTOMER");
            user.setPhone(phone);
            user.setRelationship(relationship);
            user.setAddress(address);
            user.setCareNotes(careNotes);
            
            // Set verification token
            String token = UUID.randomUUID().toString();
            user.setVerificationToken(token);
            user.setVerified(false);

            // Save user
            if (userDAO.createUser(user) != null) {
                // Send verification email asynchronously
                String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
                new Thread(() -> {
                    try {
                        EmailService.sendVerificationEmail(email, token, baseUrl);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }).start();

                response.sendRedirect(request.getContextPath() +
                    "/auth/verificationSent.jsp?email=" + email);
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/public/registerClient.jsp?err=failed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/public/registerClient.jsp?err=" + e.getMessage());
        }
    }
}
