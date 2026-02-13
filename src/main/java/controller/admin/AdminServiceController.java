package controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Service;
import model.Category;
import service.ServiceAPI;

/**
 * AdminServiceController handles admin operations for services.
 */
@WebServlet("/admin/service")
public class AdminServiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceAPI serviceAPI;

    @Override
    public void init() throws ServletException {
        serviceAPI = new ServiceAPI();
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
                createService(request, response);
            } else if ("edit".equals(action)) {
                updateService(request, response);
            } else if ("delete".equals(action)) {
                deleteService(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/service");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Service> services = serviceAPI.getAllServices();
        request.setAttribute("services", services);
        request.getRequestDispatcher("/admin/adminServiceList.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = serviceAPI.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/adminServiceCreate.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        Service service = serviceAPI.getServiceById(serviceId);
        List<Category> categories = serviceAPI.getAllCategories();
        request.setAttribute("service", service);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/adminServiceEdit.jsp").forward(request, response);
    }

    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        Service service = serviceAPI.getServiceById(serviceId);
        request.setAttribute("service", service);
        request.getRequestDispatcher("/admin/adminServiceDelete.jsp").forward(request, response);
    }

    private void createService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Service s = new Service();
        s.setCategoryId(Integer.parseInt(request.getParameter("category_id")));
        s.setServiceName(request.getParameter("service_name"));
        s.setDescription(request.getParameter("description"));
        s.setBasePrice(Double.parseDouble(request.getParameter("base_price")));
        s.setDurationMinutes(Integer.parseInt(request.getParameter("duration_minutes")));
        s.setActive("true".equals(request.getParameter("is_active")));
        
        Service created = serviceAPI.createService(s);
        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/service?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=create_failed");
        }
    }

    private void updateService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("serviceId"));
        Service s = serviceAPI.getServiceById(id);
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=not_found");
            return;
        }
        
        s.setCategoryId(Integer.parseInt(request.getParameter("category_id")));
        s.setServiceName(request.getParameter("service_name"));
        s.setDescription(request.getParameter("description"));
        s.setBasePrice(Double.parseDouble(request.getParameter("base_price")));
        s.setDurationMinutes(Integer.parseInt(request.getParameter("duration_minutes")));
        s.setActive("true".equals(request.getParameter("is_active")));
        
        Service updated = serviceAPI.updateService(id, s);
        if (updated != null) {
            response.sendRedirect(request.getContextPath() + "/admin/service?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=update_failed");
        }
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("serviceId"));
        boolean success = serviceAPI.deleteService(id);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/service?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/service?err=delete_failed");
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
