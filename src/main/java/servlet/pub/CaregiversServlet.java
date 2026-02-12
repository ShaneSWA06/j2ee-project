package servlet.pub;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Caregiver;
import service.CaregiverServiceAPI;

import java.io.IOException;
import java.util.List;

@WebServlet("/mvc/public/caregivers")
public class CaregiversServlet extends HttpServlet {
    private CaregiverServiceAPI caregiverAPI;

    @Override
    public void init() throws ServletException {
        caregiverAPI = new CaregiverServiceAPI();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Caregiver> caregivers = caregiverAPI.getAllCaregivers();
            request.setAttribute("caregivers", caregivers);
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/caregivers.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/caregivers.jsp").forward(request, response);
        }
    }
}
