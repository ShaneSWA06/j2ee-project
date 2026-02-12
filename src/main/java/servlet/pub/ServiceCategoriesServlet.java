package servlet.pub;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import service.ServiceAPI;

import java.io.IOException;
import java.util.List;

@WebServlet("/mvc/public/serviceCategories")
public class ServiceCategoriesServlet extends HttpServlet {
    private ServiceAPI serviceAPI;

    @Override
    public void init() throws ServletException {
        serviceAPI = new ServiceAPI();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Category> categories = serviceAPI.getAllCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/serviceCategories.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/serviceCategories.jsp").forward(request, response);
        }
    }
}
