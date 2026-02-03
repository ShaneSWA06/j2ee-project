package servlet;

import java.io.IOException;
import java.sql.SQLException;

import dao.DAOFactory;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet("/verify-email")
public class VerifyEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=invalid_token");
            return;
        }

        try {
            UserDAO userDAO = DAOFactory.getUserDAO();
            User user = userDAO.getUserByVerificationToken(token);

            if (user != null) {
                // Verify user
                if (userDAO.verifyUser(user.getUserId())) {
                    response.sendRedirect(request.getContextPath() + "/auth/login.jsp?success=verified");
                } else {
                    response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=verification_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=invalid_token");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=" + e.getMessage());
        }
    }
}
