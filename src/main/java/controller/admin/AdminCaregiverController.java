package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Caregiver;
import dao.CaregiverDAO;
import dao.DAOFactory;
import dao.UserDAO;

/**
 * AdminCaregiverController - Handles caregiver management via Spring Boot REST API
 * Demonstrates microservices architecture with J2EE frontend and Spring Boot backend
 */
@WebServlet("/admin/caregiver")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class AdminCaregiverController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CaregiverDAO caregiverDAO;
    private dao.BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        caregiverDAO = DAOFactory.getCaregiverDAO();
        bookingDAO = DAOFactory.getBookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
			action = "list";
		}

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
                case "bookings":
                    listCaregiverBookings(request, response);
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
        if (action == null) {
			action = "list";
		}

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

    private void listCaregiverBookings(HttpServletRequest request, HttpServletResponse response)
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

        List<model.Booking> bookings = bookingDAO.getBookingsByCaregiver(caregiverId);

        request.setAttribute("caregiver", caregiver);
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/admin/adminCaregiverBookings.jsp").forward(request, response);
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
            throws SQLException, IOException, ServletException {

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

        // Handle image upload
        Part filePart = request.getPart("image");
        String imageUrl = saveImage(filePart, "caregivers");
        caregiver.setProfileImage(imageUrl);

        // Create associated User account if email is provided
        if (caregiver.getEmail() != null && !caregiver.getEmail().isEmpty()) {
            UserDAO userDAO = DAOFactory.getUserDAO();
            model.User existingUser = userDAO.getUserByEmail(caregiver.getEmail());
            
            if (existingUser == null) {
                model.User newUser = new model.User();
                newUser.setUsername(caregiver.getEmail()); // Use email as username
                newUser.setEmail(caregiver.getEmail());
                newUser.setName(caregiver.getName());
                newUser.setPassword("password123"); // Default temporary password
                newUser.setRole("CAREGIVER");
                newUser.setPhone(caregiver.getPhone());
                newUser.setVerified(true);
                // Address, Relationship, CareNotes are optional/empty
                
                userDAO.createUser(newUser);
            }
        }

        Caregiver created = caregiverDAO.createCaregiver(caregiver);

        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?action=create&err=create_failed");
        }
    }

    private void updateCaregiver(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

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
        Caregiver existingCaregiver = caregiverDAO.getCaregiverById(caregiverId);

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

        // Handle image upload
        Part filePart = request.getPart("image");
        String imageUrl = saveImage(filePart, "caregivers");
        
        if (imageUrl != null) {
            caregiver.setProfileImage(imageUrl);
        } else if (existingCaregiver != null) {
            caregiver.setProfileImage(existingCaregiver.getProfileImage());
        }

        boolean updated = caregiverDAO.updateCaregiver(caregiver);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?action=edit&caregiverId=" + caregiverId + "&err=update_failed");
        }
    }
    
    private String saveImage(Part filePart, String subDir) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return null;
        }
        
        String fileName = Paths.get(submittedFileName).getFileName().toString();
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        
        // Get upload directory path
        String uploadDir = getServletContext().getRealPath("") + java.io.File.separator + "uploads" + java.io.File.separator + subDir;
        java.io.File uploadDirFile = new java.io.File(uploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }
        
        String filePath = uploadDir + java.io.File.separator + uniqueFileName;
        filePart.write(filePath);
        
        return "uploads/" + subDir + "/" + uniqueFileName;
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
        if (session == null) {
			return false;
		}
        Integer userId = (Integer) session.getAttribute("sessUserId");
        String role = (String) session.getAttribute("sessUserRole");
        return userId != null && "ADMIN".equals(role);
    }
}
