package servlet.pub;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Service;
import service.ServiceAPI;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/mvc/public/serviceDetails")
public class ServiceDetailsServlet extends HttpServlet {
    private ServiceAPI serviceAPI;

    @Override
    public void init() throws ServletException {
        serviceAPI = new ServiceAPI();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String categoryIdStr = request.getParameter("categoryId");
            List<Service> services = serviceAPI.getAllServices();
            
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                int categoryId = Integer.parseInt(categoryIdStr);
                services = services.stream()
                        .filter(s -> s.getCategoryId() == categoryId)
                        .collect(Collectors.toList());
                
                request.setAttribute("categoryId", categoryId);
                
                // Get category name
                List<Category> categories = serviceAPI.getAllCategories();
                String categoryName = categories.stream()
                        .filter(c -> c.getCategoryId() == categoryId)
                        .map(Category::getCategoryName)
                        .findFirst()
                        .orElse("Category " + categoryId);
                request.setAttribute("categoryName", categoryName);
            }
            
            request.setAttribute("services", services);
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/serviceDetails.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/serviceDetails.jsp").forward(request, response);
        }
    }
}
