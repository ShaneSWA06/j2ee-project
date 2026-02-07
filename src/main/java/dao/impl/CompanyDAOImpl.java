package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import dao.CompanyDAO;
import db.DBUtil;
import model.Company;

public class CompanyDAOImpl implements CompanyDAO {

    @Override
    public Company getCompanyById(int companyId) throws SQLException {
        String sql = "SELECT * FROM company WHERE company_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCompanyFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Company> getAllCompanies() throws SQLException {
        String sql = "SELECT * FROM company WHERE is_active = TRUE ORDER BY name ASC";
        List<Company> companies = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                companies.add(extractCompanyFromResultSet(rs));
            }
        }
        return companies;
    }

    @Override
    public boolean updateCompany(Company company) throws SQLException {
        String sql = "UPDATE company SET name = ?, description = ?, address = ?, phone = ?, email = ?, website = ?, updated_at = CURRENT_TIMESTAMP WHERE company_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, company.getName());
            ps.setString(2, company.getDescription());
            ps.setString(3, company.getAddress());
            ps.setString(4, company.getPhone());
            ps.setString(5, company.getEmail());
            ps.setString(6, company.getWebsite());
            ps.setInt(7, company.getCompanyId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public int getCaregiverCount(int companyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM caregiver WHERE company_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    @Override
    public int getServiceCount(int companyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM service WHERE company_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    @Override
    public int getBookingCount(int companyId) throws SQLException {
        // Count bookings for services belonging to this company
        String sql = "SELECT COUNT(*) FROM booking b JOIN service s ON b.service_id = s.service_id WHERE s.company_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    private Company extractCompanyFromResultSet(ResultSet rs) throws SQLException {
        Company company = new Company();
        company.setCompanyId(rs.getInt("company_id"));
        company.setName(rs.getString("name"));
        company.setDescription(rs.getString("description"));
        company.setAddress(rs.getString("address"));
        company.setPhone(rs.getString("phone"));
        company.setEmail(rs.getString("email"));
        company.setWebsite(rs.getString("website"));
        company.setLogoUrl(rs.getString("logo_url"));
        company.setRating(rs.getDouble("rating"));
        company.setIsActive(rs.getBoolean("is_active"));
        company.setCreatedAt(rs.getTimestamp("created_at"));
        company.setUpdatedAt(rs.getTimestamp("updated_at"));
        return company;
    }
}
