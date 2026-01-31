package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * AdminDashboardController - Handles the main admin dashboard view
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication
        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        // Forward to the dashboard view
        request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
    }
    
    private boolean isAdminLoggedIn(HttpServletRequest request) {
        Object role = request.getSession().getAttribute("sessUserRole");
        return role != null && "ADMIN".equals(role);
    }
}
