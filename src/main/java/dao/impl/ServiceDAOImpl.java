package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dao.ServiceDAO;
import db.DBUtil;
import model.Service;

/**
 * ServiceDAOImpl - Implementation of ServiceDAO using JDBC
 */
public class ServiceDAOImpl implements ServiceDAO {

    @Override
    public Service getServiceById(int serviceId) throws SQLException {
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_price, s.duration_minutes, " +
                     "s.category_id, s.is_active, s.company_id, s.image_url, c.category_name " +
                     "FROM service s " +
                     "LEFT JOIN service_category c ON s.category_id = c.category_id " +
                     "WHERE s.service_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractServiceFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Service> getAllServices() throws SQLException {
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_price, s.duration_minutes, " +
                     "s.category_id, s.is_active, s.company_id, s.image_url, c.category_name " +
                     "FROM service s " +
                     "LEFT JOIN service_category c ON s.category_id = c.category_id " +
                     "ORDER BY s.service_id ASC";
        return executeServiceQuery(sql);
    }

    @Override
    public List<Service> getActiveServices() throws SQLException {
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_price, s.duration_minutes, " +
                     "s.category_id, s.is_active, s.company_id, s.image_url, c.category_name " +
                     "FROM service s " +
                     "LEFT JOIN service_category c ON s.category_id = c.category_id " +
                     "WHERE s.is_active = TRUE " +
                     "ORDER BY s.service_id ASC";
        return executeServiceQuery(sql);
    }

    @Override
    public List<Service> getServicesByCategory(int categoryId) throws SQLException {
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_price, s.duration_minutes, " +
                     "s.category_id, s.is_active, s.company_id, s.image_url, c.category_name " +
                     "FROM service s " +
                     "LEFT JOIN service_category c ON s.category_id = c.category_id " +
                     "WHERE s.category_id = ? AND s.is_active = TRUE " +
                     "ORDER BY s.service_id ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Service> services = new ArrayList<>();
                while (rs.next()) {
                    services.add(extractServiceFromResultSet(rs));
                }
                return services;
            }
        }
    }

    @Override
    public Service createService(Service service) throws SQLException {
        String sql = "INSERT INTO service (service_name, description, base_price, duration_minutes, category_id, is_active, company_id, image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setDouble(3, service.getBasePrice());
            ps.setInt(4, service.getDurationMinutes());
            ps.setInt(5, service.getCategoryId());
            ps.setBoolean(6, service.isActive());
            if (service.getCompanyId() != null) {
                ps.setInt(7, service.getCompanyId());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            ps.setString(8, service.getImageUrl());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        service.setServiceId(rs.getInt(1));
                        return service;
                    }
                }
            }
        }
        return null;
    }

    @Override
    public boolean updateService(Service service) throws SQLException {
        String sql = "UPDATE service SET service_name = ?, description = ?, base_price = ?, " +
                     "duration_minutes = ?, category_id = ?, is_active = ?, company_id = ?, image_url = ? WHERE service_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setDouble(3, service.getBasePrice());
            ps.setInt(4, service.getDurationMinutes());
            ps.setInt(5, service.getCategoryId());
            ps.setBoolean(6, service.isActive());
            if (service.getCompanyId() != null) {
                ps.setInt(7, service.getCompanyId());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            ps.setString(8, service.getImageUrl());
            ps.setInt(9, service.getServiceId());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteService(int serviceId) throws SQLException {
        String sql = "DELETE FROM service WHERE service_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Service> getServicesByCompany(int companyId) throws SQLException {
        String sql = "SELECT s.*, c.category_name " +
                     "FROM service s " +
                     "LEFT JOIN service_category c ON s.category_id = c.category_id " +
                     "WHERE s.company_id = ? AND s.is_active = TRUE " +
                     "ORDER BY s.service_id ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Service> services = new ArrayList<>();
                while (rs.next()) {
                    services.add(extractServiceFromResultSet(rs));
                }
                return services;
            }
        }
    }

    /**
     * Helper method to execute service query and return list
     */
    private List<Service> executeServiceQuery(String sql) throws SQLException {
        List<Service> services = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                services.add(extractServiceFromResultSet(rs));
            }
        }
        return services;
    }

    /**
     * Helper method to extract Service object from ResultSet
     */
    private Service extractServiceFromResultSet(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setServiceId(rs.getInt("service_id"));
        service.setServiceName(rs.getString("service_name"));
        service.setDescription(rs.getString("description"));
        service.setBasePrice(rs.getDouble("base_price"));
        service.setDurationMinutes(rs.getInt("duration_minutes"));
        service.setCategoryId(rs.getInt("category_id"));
        service.setActive(rs.getBoolean("is_active"));
        service.setCategoryName(rs.getString("category_name"));
        service.setCompanyId(rs.getObject("company_id", Integer.class));
        service.setImageUrl(rs.getString("image_url"));
        return service;
    }
}
