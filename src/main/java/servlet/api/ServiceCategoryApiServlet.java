package servlet.api;

import com.google.gson.Gson;
import dao.CategoryDAO;
import dao.DAOFactory;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/api/categories")
public class ServiceCategoryApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        categoryDAO = DAOFactory.getCategoryDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // CORS headers to allow B2B partners to access
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET");
        
        try (PrintWriter out = response.getWriter()) {
            List<Category> categories = categoryDAO.getAllCategories();
            String json = gson.toJson(categories);
            out.print(json);
            out.flush();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
            e.printStackTrace();
        }
    }
}
