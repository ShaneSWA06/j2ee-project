package dao;

import java.sql.SQLException;
import java.util.List;
import model.Company;

public interface CompanyDAO {
    Company getCompanyById(int companyId) throws SQLException;
    List<Company> getAllCompanies() throws SQLException;
    boolean updateCompany(Company company) throws SQLException;
    
    // Stats for dashboard
    int getCaregiverCount(int companyId) throws SQLException;
    int getServiceCount(int companyId) throws SQLException;
    int getBookingCount(int companyId) throws SQLException;
}
