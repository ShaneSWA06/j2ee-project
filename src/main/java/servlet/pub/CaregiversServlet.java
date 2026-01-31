package servlet.pub;

import java.io.IOException;
import java.util.List;

import dao.CaregiverDAO;
import dao.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Caregiver; // Ensure this import is correct

@WebServlet("/mvc/public/caregivers")
public class CaregiversServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CaregiverDAO caregiverDAO;

    @Override
    public void init() throws ServletException {
        caregiverDAO = DAOFactory.getCaregiverDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get all available caregivers
            List<Caregiver> caregivers = caregiverDAO.getAvailableCaregivers();

            request.setAttribute("caregivers", caregivers);
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/caregivers.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load caregivers.");
            request.setAttribute("mvcLoaded", true);
            request.getRequestDispatcher("/public/caregivers.jsp").forward(request, response);
        }
    }
}
