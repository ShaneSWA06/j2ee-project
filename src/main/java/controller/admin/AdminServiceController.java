package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.CategoryDAO;
import dao.DAOFactory;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.Service;

/**
 * AdminServiceController - Handles all service management operations
 */
@WebServlet("/admin/service")
public class AdminServiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceDAO serviceDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        serviceDAO = DAOFactory.getServiceDAO();
        categoryDAO = DAOFactory.getCategoryDAO();
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
                    listServices(request, response);
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
                    listServices(request, response);
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
                    createService(request, response);
                    break;
                case "edit":
                    updateService(request, response);
                    break;
                case "delete":
                    deleteService(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/service");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void listServices(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Service> services = serviceDAO.getAllServices();
        request.setAttribute("services", services);
        request.getRequestDispatcher("/admin/adminServiceList.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/adminServiceCreate.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String serviceIdParam = request.getParameter("serviceId");
        if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=missing_id");
            return;
        }

        int serviceId = Integer.parseInt(serviceIdParam);
        Service service = serviceDAO.getServiceById(serviceId);

        if (service == null) {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=not_found");
            return;
        }

        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("service", service);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/adminServiceEdit.jsp").forward(request, response);
    }

    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String serviceIdParam = request.getParameter("serviceId");
        if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=missing_id");
            return;
        }

        int serviceId = Integer.parseInt(serviceIdParam);
        Service service = serviceDAO.getServiceById(serviceId);

        if (service == null) {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=not_found");
            return;
        }

        request.setAttribute("service", service);
        request.getRequestDispatcher("/admin/adminServiceDelete.jsp").forward(request, response);
    }

    private void createService(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String serviceName = request.getParameter("service_name");
        String description = request.getParameter("description");
        String basePriceStr = request.getParameter("base_price");
        String durationStr = request.getParameter("duration_minutes");
        String categoryIdStr = request.getParameter("category_id");
        String isActiveStr = request.getParameter("is_active");

        if (serviceName == null || serviceName.trim().isEmpty() ||
            basePriceStr == null || categoryIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/service?action=create&err=missing_fields");
            return;
        }

        Service service = new Service();
        service.setServiceName(serviceName.trim());
        service.setDescription(description != null ? description.trim() : "");
        service.setBasePrice(Double.parseDouble(basePriceStr));
        service.setDurationMinutes(Integer.parseInt(durationStr));
        service.setCategoryId(Integer.parseInt(categoryIdStr));
        service.setActive("true".equals(isActiveStr) || "on".equals(isActiveStr));

        Service created = serviceDAO.createService(service);

        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/service?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/service?action=create&err=create_failed");
        }
    }

    private void updateService(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String serviceIdStr = request.getParameter("serviceId");
        String serviceName = request.getParameter("service_name");
        String description = request.getParameter("description");
        String basePriceStr = request.getParameter("base_price");
        String durationStr = request.getParameter("duration_minutes");
        String categoryIdStr = request.getParameter("category_id");
        String isActiveStr = request.getParameter("is_active");

        if (serviceIdStr == null || serviceName == null || serviceName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=missing_fields");
            return;
        }

        int serviceId = Integer.parseInt(serviceIdStr);
        Service service = new Service();
        service.setServiceId(serviceId);
        service.setServiceName(serviceName.trim());
        service.setDescription(description != null ? description.trim() : "");
        service.setBasePrice(Double.parseDouble(basePriceStr));
        service.setDurationMinutes(Integer.parseInt(durationStr));
        service.setCategoryId(Integer.parseInt(categoryIdStr));
        service.setActive("true".equals(isActiveStr) || "on".equals(isActiveStr));

        boolean updated = serviceDAO.updateService(service);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/service?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/service?action=edit&serviceId=" + serviceId + "&err=update_failed");
        }
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String serviceIdStr = request.getParameter("serviceId");

        if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=missing_id");
            return;
        }

        int serviceId = Integer.parseInt(serviceIdStr);
        boolean deleted = serviceDAO.deleteService(serviceId);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/service?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=delete_failed");
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
