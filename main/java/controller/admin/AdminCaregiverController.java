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

import dao.CaregiverDAO;
import dao.DAOFactory;
import model.Caregiver;

/**
 * AdminCaregiverController - Handles caregiver management
 */
@WebServlet("/admin/caregiver")
public class AdminCaregiverController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CaregiverDAO caregiverDAO;

    @Override
    public void init() throws ServletException {
        caregiverDAO = DAOFactory.getCaregiverDAO();
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
                    listCaregivers(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    showDeleteConfirmation(request, response);
                    break;
                default:
                    listCaregivers(request, response);
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
                case "create":
                    createCaregiver(request, response);
                    break;
                case "edit":
                    updateCaregiver(request, response);
                    break;
                case "delete":
                    deleteCaregiver(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/caregiver");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listCaregivers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        List<Caregiver> caregivers = caregiverDAO.getAllCaregivers();
        request.setAttribute("caregivers", caregivers);
        request.getRequestDispatcher("/admin/adminCaregiverList.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/admin/adminCaregiverCreate.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        String caregiverIdParam = request.getParameter("caregiverId");
        if (caregiverIdParam == null || caregiverIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=missing_id");
            return;
        }

        int caregiverId = Integer.parseInt(caregiverIdParam);
        Caregiver caregiver = caregiverDAO.getCaregiverById(caregiverId);
        
        if (caregiver == null) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=not_found");
            return;
        }

        request.setAttribute("caregiver", caregiver);
        request.getRequestDispatcher("/admin/adminCaregiverEdit.jsp").forward(request, response);
    }

    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        String caregiverIdParam = request.getParameter("caregiverId");
        if (caregiverIdParam == null || caregiverIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=missing_id");
            return;
        }

        int caregiverId = Integer.parseInt(caregiverIdParam);
        Caregiver caregiver = caregiverDAO.getCaregiverById(caregiverId);
        
        if (caregiver == null) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=not_found");
            return;
        }

        request.setAttribute("caregiver", caregiver);
        request.getRequestDispatcher("/admin/adminCaregiverDelete.jsp").forward(request, response);
    }

    private void createCaregiver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String name = request.getParameter("name");
        String qualifications = request.getParameter("qualifications");
        String specialties = request.getParameter("specialties"); // Map to specialization/specialties
        String experienceYearsStr = request.getParameter("experience_years");
        String bio = request.getParameter("bio");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String isAvailableStr = request.getParameter("is_available");

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?action=create&err=missing_name");
            return;
        }

        Caregiver caregiver = new Caregiver();
        caregiver.setName(name.trim());
        caregiver.setQualifications(qualifications != null ? qualifications.trim() : "");
        caregiver.setSpecialties(specialties != null ? specialties.trim() : "");
        caregiver.setSpecialization(specialties != null ? specialties.trim() : ""); // Sync legacy field
        
        if (experienceYearsStr != null && !experienceYearsStr.trim().isEmpty()) {
            try {
                caregiver.setExperienceYears(Integer.parseInt(experienceYearsStr.trim()));
            } catch (NumberFormatException e) {
                // Ignore or set to 0
                caregiver.setExperienceYears(0);
            }
        }
        
        caregiver.setBio(bio != null ? bio.trim() : "");
        caregiver.setPhone(phone != null ? phone.trim() : "");
        caregiver.setEmail(email != null ? email.trim() : "");
        caregiver.setAvailable("true".equals(isAvailableStr) || "on".equals(isAvailableStr));

        Caregiver created = caregiverDAO.createCaregiver(caregiver);

        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?action=create&err=create_failed");
        }
    }

    private void updateCaregiver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String caregiverIdStr = request.getParameter("caregiverId");
        String name = request.getParameter("name");
        String qualifications = request.getParameter("qualifications");
        String specialties = request.getParameter("specialties");
        String experienceYearsStr = request.getParameter("experience_years");
        String bio = request.getParameter("bio");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String isAvailableStr = request.getParameter("is_available");

        if (caregiverIdStr == null || name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=missing_fields");
            return;
        }

        int caregiverId = Integer.parseInt(caregiverIdStr);
        Caregiver caregiver = new Caregiver();
        caregiver.setCaregiverId(caregiverId);
        caregiver.setName(name.trim());
        caregiver.setQualifications(qualifications != null ? qualifications.trim() : "");
        caregiver.setSpecialties(specialties != null ? specialties.trim() : "");
        caregiver.setSpecialization(specialties != null ? specialties.trim() : ""); // Sync legacy field
        
        if (experienceYearsStr != null && !experienceYearsStr.trim().isEmpty()) {
            try {
                caregiver.setExperienceYears(Integer.parseInt(experienceYearsStr.trim()));
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        caregiver.setBio(bio != null ? bio.trim() : "");
        caregiver.setPhone(phone != null ? phone.trim() : "");
        caregiver.setEmail(email != null ? email.trim() : "");
        caregiver.setAvailable("true".equals(isAvailableStr) || "on".equals(isAvailableStr));

        boolean updated = caregiverDAO.updateCaregiver(caregiver);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?action=edit&caregiverId=" + caregiverId + "&err=update_failed");
        }
    }

    private void deleteCaregiver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        String caregiverIdStr = request.getParameter("caregiverId");

        if (caregiverIdStr == null || caregiverIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=missing_id");
            return;
        }

        int caregiverId = Integer.parseInt(caregiverIdStr);
        boolean deleted = caregiverDAO.deleteCaregiver(caregiverId);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=delete_failed");
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
