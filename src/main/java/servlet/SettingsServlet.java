package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

import dao.DAOFactory;
import dao.UserDAO;
import model.User;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = DAOFactory.getUserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("sessUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        int userId = (Integer) session.getAttribute("sessUserId");

        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                // Should note happen if session is valid
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/customer/settings.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("sessUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        int userId = (Integer) session.getAttribute("sessUserId");
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String relationship = request.getParameter("relationship");
        String careNotes = request.getParameter("care_notes");
        String medicalHistory = request.getParameter("medical_history");
        String allergies = request.getParameter("allergies");
        String password = request.getParameter("password"); // Optional

        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
                return;
            }

            user.setName(name);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setRelationship(relationship);
            user.setCareNotes(careNotes);
            user.setMedicalHistory(medicalHistory);
            user.setAllergies(allergies);
            
            // Only update password if provided and not empty
            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(util.PasswordUtil.hashPassword(password));
            }

            boolean updated = userDAO.updateUser(user);

            if (updated) {
                // Update session attributes
                session.setAttribute("sessUserName", user.getName());
                session.setAttribute("sessUserEmail", user.getEmail());
                
                request.setAttribute("user", user);
                request.setAttribute("success", "Profile updated successfully!");
            } else {
                request.setAttribute("user", user);
                request.setAttribute("error", "Failed to update profile.");
            }
            
            request.getRequestDispatcher("/customer/settings.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
