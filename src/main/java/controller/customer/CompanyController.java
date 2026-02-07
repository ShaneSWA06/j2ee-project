package controller.customer;

import java.io.IOException;
import java.util.List;

import dao.DAOFactory;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Caregiver;
import model.Company;
import model.Service;
import service.CompanyServiceAPI;

@WebServlet("/customer/company")
public class CompanyController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CompanyServiceAPI companyAPI;

    @Override
    public void init() throws ServletException {
        companyAPI = new CompanyServiceAPI();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String companyIdParam = request.getParameter("id");
        if (companyIdParam == null || companyIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            int companyId = Integer.parseInt(companyIdParam);
            Company company = companyAPI.getCompanyById(companyId);
            
            if (company == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?err=company_not_found");
                return;
            }

            List<Caregiver> caregivers = companyAPI.getCaregiversByCompany(companyId);
            
            ServiceDAO serviceDAO = DAOFactory.getServiceDAO();
            List<Service> services = serviceDAO.getServicesByCompany(companyId);
            
            request.setAttribute("company", company);
            request.setAttribute("caregivers", caregivers);
            request.setAttribute("services", services);
            
            request.getRequestDispatcher("/customer/companyProfile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?err=server_error");
        }
    }
}
