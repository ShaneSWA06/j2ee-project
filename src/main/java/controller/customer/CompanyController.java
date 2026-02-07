package controller.customer;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import dao.CaregiverDAO;
import dao.CompanyDAO;
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

@WebServlet({"/customer/company", "/mvc/public/company"})
public class CompanyController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Gson GSON = new Gson();

    private CompanyDAO companyDAO;
    private CaregiverDAO caregiverDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        companyDAO = DAOFactory.getCompanyDAO();
        caregiverDAO = DAOFactory.getCaregiverDAO();
        serviceDAO = DAOFactory.getServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        if ("/mvc/public/company".equals(servletPath)) {
            handlePublicCompanyRequest(request, response);
            return;
        }

        String companyIdParam = request.getParameter("id");
        if (companyIdParam == null || companyIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            int companyId = Integer.parseInt(companyIdParam);
            Company company = companyDAO.getCompanyById(companyId);
            if (company == null || Boolean.FALSE.equals(company.getIsActive())) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?err=company_not_found");
                return;
            }

            List<Caregiver> caregivers = caregiverDAO.getCaregiversByCompany(companyId);
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

    private void handlePublicCompanyRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        String companyIdParam = request.getParameter("id");
        if (companyIdParam == null || companyIdParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeError(out, "missing_company_id", null);
            return;
        }

        int companyId;
        try {
            companyId = Integer.parseInt(companyIdParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeError(out, "invalid_company_id", null);
            return;
        }

        boolean includeSensitive = "true".equalsIgnoreCase(request.getParameter("includeSensitive"));
        boolean isAuthorized = isAuthorizedForSensitive(request, companyId);
        if (includeSensitive && !isAuthorized) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            writeError(out, "access_restricted", null);
            return;
        }

        try {
            Company company = companyDAO.getCompanyById(companyId);
            if (company == null || Boolean.FALSE.equals(company.getIsActive())) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                writeError(out, "company_not_found", null);
                return;
            }

            List<Service> services = serviceDAO.getServicesByCompany(companyId);
            List<Caregiver> caregivers = caregiverDAO.getCaregiversByCompany(companyId);

            String json = buildCompanyJson(company, services, caregivers, isAuthorized);
            out.write(json);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            writeError(out, "server_error", e.getMessage());
        }
    }

    private boolean isAuthorizedForSensitive(HttpServletRequest request, int companyId) {
        Object userObj = request.getSession(false) != null ? request.getSession(false).getAttribute("user") : null;
        if (!(userObj instanceof model.User)) {
            return false;
        }
        model.User user = (model.User) userObj;
        if (user.isAdmin()) {
            return true;
        }
        return user.isCompanyAdmin() && user.getCompanyId() != null && user.getCompanyId() == companyId;
    }

    private String buildCompanyJson(Company company, List<Service> services, List<Caregiver> caregivers, boolean includeSensitive) {
        JsonObject root = new JsonObject();
        JsonObject companyJson = new JsonObject();
        companyJson.addProperty("companyId", company.getCompanyId());
        companyJson.addProperty("name", company.getName());
        companyJson.addProperty("description", company.getDescription());
        companyJson.addProperty("website", company.getWebsite());
        companyJson.addProperty("logoUrl", company.getLogoUrl());
        companyJson.addProperty("rating", company.getRating() != null ? company.getRating() : 0.0);
        if (includeSensitive) {
            companyJson.addProperty("address", company.getAddress());
            companyJson.addProperty("phone", company.getPhone());
            companyJson.addProperty("email", company.getEmail());
        }
        root.add("company", companyJson);

        JsonArray servicesJson = new JsonArray();
        for (Service s : services) {
            JsonObject serviceJson = new JsonObject();
            serviceJson.addProperty("serviceId", s.getServiceId());
            serviceJson.addProperty("serviceName", s.getServiceName());
            serviceJson.addProperty("description", s.getDescription());
            serviceJson.addProperty("basePrice", s.getBasePrice());
            serviceJson.addProperty("durationMinutes", s.getDurationMinutes());
            serviceJson.addProperty("categoryName", s.getCategoryName());
            servicesJson.add(serviceJson);
        }
        root.add("services", servicesJson);

        JsonArray caregiversJson = new JsonArray();
        for (Caregiver cg : caregivers) {
            JsonObject caregiverJson = new JsonObject();
            caregiverJson.addProperty("caregiverId", cg.getCaregiverId());
            caregiverJson.addProperty("name", cg.getName());
            caregiverJson.addProperty("specialties", cg.getSpecialties());
            caregiverJson.addProperty("rating", cg.getRating() != null ? cg.getRating() : 0.0);
            if (includeSensitive) {
                caregiverJson.addProperty("phone", cg.getPhone());
                caregiverJson.addProperty("email", cg.getEmail());
            }
            caregiversJson.add(caregiverJson);
        }
        root.add("caregivers", caregiversJson);
        return GSON.toJson(root);
    }

    private void writeError(PrintWriter out, String code, String message) {
        JsonObject errorJson = new JsonObject();
        errorJson.addProperty("error", code);
        if (message != null && !message.trim().isEmpty()) {
            errorJson.addProperty("message", message);
        }
        out.write(GSON.toJson(errorJson));
    }
}
