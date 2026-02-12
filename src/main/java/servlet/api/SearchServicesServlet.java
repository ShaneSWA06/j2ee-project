package servlet.api;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;
import service.ServiceAPI;

import java.io.IOException;
import java.util.List;

@WebServlet("/mvc/api/searchServices")
public class SearchServicesServlet extends HttpServlet {
    private ServiceAPI serviceAPI;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        serviceAPI = new ServiceAPI();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        String categoryIdStr = request.getParameter("categoryId");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            Integer categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.valueOf(categoryIdStr) : null;
            List<Service> services = serviceAPI.searchServices(query != null ? query : "", categoryId);
            response.getWriter().write(gson.toJson(services));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            com.google.gson.JsonObject error = new com.google.gson.JsonObject();
            error.addProperty("error", e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }
}
