package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.UserDAO;
import dao.DAOFactory;
import model.User;

/**
 * AdminClientController - Handles client/customer management for admins
 */
@WebServlet("/admin/client")
public class AdminClientController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = DAOFactory.getUserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listClients(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    showDeleteConfirmation(request, response);
                    break;
                default:
                    listClients(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "edit":
                    updateClient(request, response);
                    break;
                case "delete":
                    deleteClient(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/client");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listClients(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        List<User> clients = userDAO.getUsersByRole("CUSTOMER");
        request.setAttribute("clients", clients);
        request.getRequestDispatcher("/admin/adminClientList.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/client?err=missing_id");
            return;
        }

        int userId = Integer.parseInt(userIdParam);
        User user = userDAO.getUserById(userId);
        
        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/client?err=not_found");
            return;
        }

        request.setAttribute("client", user);
        request.getRequestDispatcher("/admin/adminClientEdit.jsp").forward(request, response);
    }

    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/client?err=missing_id");
            return;
        }

        int userId = Integer.parseInt(userIdParam);
        User user = userDAO.getUserById(userId);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/admin/client?err=not_found");
            return;
        }

        request.setAttribute("client", user);
        request.getRequestDispatcher("/admin/adminClientDelete.jsp").forward(request, response);
    }

    private void updateClient(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String userIdStr = request.getParameter("userId");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String name = request.getParameter("name");

        if (userIdStr == null || username == null || username.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/client?err=missing_fields");
            return;
        }

        int userId = Integer.parseInt(userIdStr);
        User user = new User();
        user.setUserId(userId);
        user.setUsername(username.trim());
        user.setEmail(email != null ? email.trim() : "");
        user.setName(name != null ? name.trim() : "");
        user.setRole("CUSTOMER"); // Maintain role

        boolean updated = userDAO.updateUser(user);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/client?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/client?action=edit&userId=" + userId + "&err=update_failed");
        }
    }

    private void deleteClient(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/client?err=missing_id");
            return;
        }

        int userId = Integer.parseInt(userIdStr);
        boolean deleted = userDAO.deleteUser(userId);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/client?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/client?err=delete_failed");
        }
    }

    private boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        Integer userId = (Integer) session.getAttribute("sessUserId");
        String role = (String) session.getAttribute("sessUserRole");
        return userId != null && "ADMIN".equals(role);
    }
}
