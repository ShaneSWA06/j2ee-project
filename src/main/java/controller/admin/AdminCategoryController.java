package controller.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Category;
import service.ServiceAPI;

/**
 * AdminCategoryController handles admin operations for service categories.
 */
@WebServlet("/admin/category")
public class AdminCategoryController extends HttpServlet {
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
                    listCategories(request, response);
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
                    listCategories(request, response);
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
                createCategory(request, response);
            } else if ("edit".equals(action)) {
                updateCategory(request, response);
            } else if ("delete".equals(action)) {
                deleteCategory(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/category");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = serviceAPI.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/adminCategoryList.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/adminCategoryCreate.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        Category category = serviceAPI.getCategoryById(categoryId);
        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/adminCategoryEdit.jsp").forward(request, response);
    }

    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        Category category = serviceAPI.getCategoryById(categoryId);
        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/adminCategoryDelete.jsp").forward(request, response);
    }

    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Category c = new Category();
        c.setCategoryName(request.getParameter("category_name"));
        c.setDescription(request.getParameter("description"));
        
        Category created = serviceAPI.createCategory(c);
        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/category?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=create_failed");
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("categoryId"));
        Category c = serviceAPI.getCategoryById(id);
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=not_found");
            return;
        }
        
        c.setCategoryName(request.getParameter("category_name"));
        c.setDescription(request.getParameter("description"));
        
        Category updated = serviceAPI.updateCategory(id, c);
        if (updated != null) {
            response.sendRedirect(request.getContextPath() + "/admin/category?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=update_failed");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("categoryId"));
        boolean success = serviceAPI.deleteCategory(id);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/category?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=delete_failed");
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
