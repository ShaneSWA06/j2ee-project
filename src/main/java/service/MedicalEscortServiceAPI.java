package service;

import java.util.ArrayList;
import java.util.List;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBUtil;
import model.Service;

/**
 * MedicalEscortServiceAPI - Service for Medical Escort Operations
 * <p>
 * Purpose:
 * - Handles data access for medical escort services directly from the database (Legacy/Hybrid approach).
 * - Unlike other services that use the REST API, this one queries the `medical_escort_service` table.
 * - Used to fetch the catalog of available medical escort options.
 */
public class MedicalEscortServiceAPI {
    public List<Service> getMedicalEscorts() throws SQLException {
        List<Service> escorts = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, base_price, duration_minutes, is_active " +
                     "FROM medical_escort_service WHERE is_active = TRUE ORDER BY service_id ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setDescription(rs.getString("description"));
                service.setBasePrice(rs.getDouble("base_price"));
                service.setDurationMinutes(rs.getInt("duration_minutes"));
                service.setActive(rs.getBoolean("is_active"));
                escorts.add(service);
            }
        }
        return escorts;
    }
}
