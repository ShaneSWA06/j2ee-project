package controller.company;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.BookingDAO;
import dao.CaregiverDAO;
import dao.CompanyDAO;
import dao.DAOFactory;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Caregiver;
import model.Company;
import model.Service;
import model.User;

@WebServlet("/company/dashboard")
public class CompanyDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Auth check
        if (user == null || !"COMPANY_ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        int companyId = user.getCompanyId();
        
        try {
            CompanyDAO companyDAO = DAOFactory.getCompanyDAO();
            ServiceDAO serviceDAO = DAOFactory.getServiceDAO();
            CaregiverDAO caregiverDAO = DAOFactory.getCaregiverDAO();
            BookingDAO bookingDAO = DAOFactory.getBookingDAO();

            Company company = companyDAO.getCompanyById(companyId);
            List<Service> services = serviceDAO.getServicesByCompany(companyId);
            List<Caregiver> caregivers = caregiverDAO.getCaregiversByCompany(companyId);
            List<Booking> recentBookings = bookingDAO.getBookingsByCompany(companyId, 5); // Need to implement this

            // Stats
            int caregiverCount = companyDAO.getCaregiverCount(companyId);
            int serviceCount = companyDAO.getServiceCount(companyId);
            int bookingCount = companyDAO.getBookingCount(companyId);

            request.setAttribute("company", company);
            request.setAttribute("services", services);
            request.setAttribute("caregivers", caregivers);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("caregiverCount", caregiverCount);
            request.setAttribute("serviceCount", serviceCount);
            request.setAttribute("bookingCount", bookingCount);

            request.getRequestDispatcher("/company/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=db_error");
        }
    }
}
