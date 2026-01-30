package servlet.pub;

import dao.DAOFactory;
import dao.CaregiverDAO;
import model.Caregiver;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/mvc/api/searchCaregivers")
public class SearchCaregiversServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CaregiverDAO caregiverDAO;

    @Override
    public void init() throws ServletException {
        caregiverDAO = DAOFactory.getCaregiverDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String query = request.getParameter("q");
        PrintWriter out = response.getWriter();
        
        try {
            List<Caregiver> caregivers = caregiverDAO.searchCaregivers(query);
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            
            for (int i = 0; i < caregivers.size(); i++) {
                Caregiver c = caregivers.get(i);
                if (i > 0) {
                    json.append(",");
                }
                
                json.append("{");
                json.append("\"caregiverId\":").append(c.getCaregiverId()).append(",");
                json.append("\"name\":\"").append(escapeJson(c.getName())).append("\",");
                json.append("\"qualifications\":\"").append(escapeJson(c.getQualifications())).append("\",");
                json.append("\"specialties\":\"").append(escapeJson(c.getSpecialties())).append("\",");
                
                Integer years = c.getExperienceYears();
                json.append("\"experienceYears\":").append(years != null ? years : "null").append(",");
                
                json.append("\"bio\":\"").append(escapeJson(c.getBio())).append("\",");
                json.append("\"phone\":\"").append(escapeJson(c.getPhone())).append("\",");
                json.append("\"email\":\"").append(escapeJson(c.getEmail())).append("\"");
                json.append("}");
            }
            json.append("]");
            
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            // Return error JSON
            out.print("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
