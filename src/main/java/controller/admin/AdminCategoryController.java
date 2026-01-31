package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.CategoryDAO;
import dao.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;

/**
 * AdminCategoryController - Handles all category management operations
 * Replaces: adminCategoryList.jsp, adminCategoryCreate.jsp, adminCategoryEdit.jsp,
 *           adminCategoryDelete.jsp, deleteCategory.jsp, processing JSPs
 */
@WebServlet("/admin/category")
public class AdminCategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = DAOFactory.getCategoryDAO();
    }

    /**
     * Handle GET requests - dispatch to appropriate view based on action parameter
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
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
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    /**
     * Handle POST requests - process form submissions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
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
                    createCategory(request, response);
                    break;
                case "edit":
                    updateCategory(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/category");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    /**
     * List all categories
     */
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/adminCategoryList.jsp").forward(request, response);
    }

    /**
     * Show create category form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/admin/adminCategoryCreate.jsp").forward(request, response);
    }

    /**
     * Show edit category form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String categoryIdParam = request.getParameter("categoryId");
        if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=missing_id");
            return;
        }

        int categoryId = Integer.parseInt(categoryIdParam);
        Category category = categoryDAO.getCategoryById(categoryId);

        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=not_found");
            return;
        }

        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/adminCategoryEdit.jsp").forward(request, response);
    }

    /**
     * Show delete confirmation page
     */
    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String categoryIdParam = request.getParameter("categoryId");
        if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=missing_id");
            return;
        }

        int categoryId = Integer.parseInt(categoryIdParam);
        Category category = categoryDAO.getCategoryById(categoryId);

        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=not_found");
            return;
        }

        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/adminCategoryDelete.jsp").forward(request, response);
    }

    /**
     * Create new category
     */
    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String categoryName = request.getParameter("category_name");
        String description = request.getParameter("description");

        // Validation
        if (categoryName == null || categoryName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category?action=create&err=missing_name");
            return;
        }

        Category category = new Category();
        category.setCategoryName(categoryName.trim());
        category.setDescription(description != null ? description.trim() : "");

        Category created = categoryDAO.createCategory(category);

        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/category?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/category?action=create&err=create_failed");
        }
    }

    /**
     * Update existing category
     */
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String categoryIdParam = request.getParameter("categoryId");
        String categoryName = request.getParameter("category_name");
        String description = request.getParameter("description");

        // Validation
        if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=missing_id");
            return;
        }

        if (categoryName == null || categoryName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category?action=edit&categoryId=" + categoryIdParam + "&err=missing_name");
            return;
        }

        int categoryId = Integer.parseInt(categoryIdParam);
        Category category = new Category();
        category.setCategoryId(categoryId);
        category.setCategoryName(categoryName.trim());
        category.setDescription(description != null ? description.trim() : "");

        boolean updated = categoryDAO.updateCategory(category);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/category?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/category?action=edit&categoryId=" + categoryId + "&err=update_failed");
        }
    }

    /**
     * Delete category
     */
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String categoryIdParam = request.getParameter("categoryId");

        if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=missing_id");
            return;
        }

        int categoryId = Integer.parseInt(categoryIdParam);
        boolean deleted = categoryDAO.deleteCategory(categoryId);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/category?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/category?err=delete_failed");
        }
    }

    /**
     * Check if admin is logged in
     */
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
