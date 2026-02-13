package controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Caregiver;
import model.Booking;
import service.CaregiverServiceAPI;
import service.BookingServiceAPI;

/**
 * AdminCaregiverController handles admin operations for caregivers.
 */
@WebServlet("/admin/caregiver")
public class AdminCaregiverController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CaregiverServiceAPI caregiverAPI;
    private BookingServiceAPI bookingAPI;

    @Override
    public void init() throws ServletException {
        caregiverAPI = new CaregiverServiceAPI();
        bookingAPI = new BookingServiceAPI();
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
                case "bookings":
                    listCaregiverBookings(request, response);
                    break;
                default:
                    listCaregivers(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
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
        
        try {
            if ("create".equals(action)) {
                createCaregiver(request, response);
            } else if ("edit".equals(action)) {
                updateCaregiver(request, response);
            } else if ("delete".equals(action)) {
                deleteCaregiver(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/caregiver");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listCaregivers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Caregiver> caregivers = caregiverAPI.getAllCaregivers();
        request.setAttribute("caregivers", caregivers);
        request.getRequestDispatcher("/admin/adminCaregiverList.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/adminCaregiverCreate.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int caregiverId = Integer.parseInt(request.getParameter("caregiverId"));
        Caregiver caregiver = caregiverAPI.getCaregiverById(caregiverId);
        request.setAttribute("caregiver", caregiver);
        request.getRequestDispatcher("/admin/adminCaregiverEdit.jsp").forward(request, response);
    }

    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int caregiverId = Integer.parseInt(request.getParameter("caregiverId"));
        Caregiver caregiver = caregiverAPI.getCaregiverById(caregiverId);
        request.setAttribute("caregiver", caregiver);
        request.getRequestDispatcher("/admin/adminCaregiverDelete.jsp").forward(request, response);
    }

    private void listCaregiverBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int caregiverId = Integer.parseInt(request.getParameter("caregiverId"));
        Caregiver caregiver = caregiverAPI.getCaregiverById(caregiverId);
        List<Booking> bookings = bookingAPI.getBookingsByCaregiver(caregiverId);
        request.setAttribute("caregiver", caregiver);
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/admin/adminCaregiverBookings.jsp").forward(request, response);
    }

    private void createCaregiver(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Caregiver cg = new Caregiver();
        cg.setName(request.getParameter("name"));
        cg.setSpecialization(request.getParameter("specialization"));
        cg.setPhone(request.getParameter("phone"));
        cg.setEmail(request.getParameter("email"));
        cg.setQualifications(request.getParameter("qualifications"));
        cg.setSpecialties(request.getParameter("specialties"));
        cg.setBio(request.getParameter("bio"));
        cg.setAvailable("true".equals(request.getParameter("available")));
        
        Caregiver created = caregiverAPI.createCaregiver(cg);
        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=create_failed");
        }
    }

    private void updateCaregiver(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("caregiverId"));
        Caregiver cg = caregiverAPI.getCaregiverById(id);
        if (cg == null) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=not_found");
            return;
        }
        
        cg.setName(request.getParameter("name"));
        cg.setSpecialization(request.getParameter("specialization"));
        cg.setPhone(request.getParameter("phone"));
        cg.setEmail(request.getParameter("email"));
        cg.setQualifications(request.getParameter("qualifications"));
        cg.setSpecialties(request.getParameter("specialties"));
        cg.setBio(request.getParameter("bio"));
        cg.setAvailable("true".equals(request.getParameter("available")));
        
        Caregiver updated = caregiverAPI.updateCaregiver(id, cg);
        if (updated != null) {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/caregiver?err=update_failed");
        }
    }

    private void deleteCaregiver(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("caregiverId"));
        boolean success = caregiverAPI.deleteCaregiver(id);
        if (success) {
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
