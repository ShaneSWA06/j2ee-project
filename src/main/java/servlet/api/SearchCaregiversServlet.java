package servlet.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Caregiver;
import service.CaregiverServiceAPI;
import com.google.gson.Gson;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/mvc/api/searchCaregivers")
public class SearchCaregiversServlet extends HttpServlet {
    private CaregiverServiceAPI caregiverAPI;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        caregiverAPI = new CaregiverServiceAPI();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String query = request.getParameter("q");
            List<Caregiver> allCaregivers = caregiverAPI.getAllCaregivers();
            
            List<Caregiver> filteredCaregivers;
            if (query == null || query.trim().isEmpty()) {
                filteredCaregivers = allCaregivers;
            } else {
                String lowerQuery = query.toLowerCase().trim();
                filteredCaregivers = allCaregivers.stream()
                        .filter(c -> 
                            (c.getName() != null && c.getName().toLowerCase().contains(lowerQuery)) ||
                            (c.getQualifications() != null && c.getQualifications().toLowerCase().contains(lowerQuery)) ||
                            (c.getSpecialties() != null && c.getSpecialties().toLowerCase().contains(lowerQuery)) ||
                            (c.getBio() != null && c.getBio().toLowerCase().contains(lowerQuery))
                        )
                        .collect(Collectors.toList());
            }

            out.print(gson.toJson(filteredCaregivers));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
}
