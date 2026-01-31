package servlet.pub;

import java.io.IOException;
import java.util.List;

import dao.CategoryDAO;
import dao.DAOFactory;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Service;

@WebServlet("/mvc/public/serviceDetails")
public class ServiceDetailsServlet extends HttpServlet {
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
        try {
            String categoryIdParam = request.getParameter("categoryId");
            List<Service> services;
            String categoryName = null;
            Integer categoryId = null;

            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdParam);
                Category category = categoryDAO.getCategoryById(categoryId);
                if (category != null) {
                    categoryName = category.getCategoryName();
                }
                services = serviceDAO.getServicesByCategory(categoryId);
            } else {
                services = serviceDAO.getActiveServices();
            }

            request.setAttribute("services", services);
            request.setAttribute("categoryId", categoryId);
            request.setAttribute("categoryName", categoryName);
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/serviceDetails.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/serviceDetails.jsp").forward(request, response);
        }
    }
}
