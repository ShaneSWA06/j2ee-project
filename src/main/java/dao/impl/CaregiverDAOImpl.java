package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import dao.CaregiverDAO;
import db.DBUtil;
import model.Caregiver;

/**
 * CaregiverDAOImpl - Implementation of CaregiverDAO using JDBC
 */
public class CaregiverDAOImpl implements CaregiverDAO {

    @Override
    public Caregiver getCaregiverById(int caregiverId) throws SQLException {
        String sql = "SELECT caregiver_id, user_id, name, qualifications, specialties, experience_years, bio, phone, email, is_active, created_at " +
                     "FROM caregiver WHERE caregiver_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCaregiverFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Caregiver> getAllCaregivers() throws SQLException {
        String sql = "SELECT caregiver_id, user_id, name, qualifications, specialties, experience_years, bio, phone, email, is_active, created_at " +
                     "FROM caregiver ORDER BY caregiver_id ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Caregiver> caregivers = new ArrayList<>();
            while (rs.next()) {
                caregivers.add(extractCaregiverFromResultSet(rs));
            }
            return caregivers;
        }
    }

    @Override
    public List<Caregiver> getAvailableCaregivers() throws SQLException {
        String sql = "SELECT caregiver_id, user_id, name, qualifications, specialties, experience_years, bio, phone, email, is_active, created_at " +
                     "FROM caregiver WHERE is_active = TRUE ORDER BY caregiver_id ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Caregiver> caregivers = new ArrayList<>();
            while (rs.next()) {
                caregivers.add(extractCaregiverFromResultSet(rs));
            }
            return caregivers;
        }
    }

    @Override
    public List<Caregiver> searchCaregivers(String query) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT caregiver_id, user_id, name, qualifications, specialties, experience_years, bio, phone, email, is_active, created_at ");
        sql.append("FROM caregiver ");
        sql.append("WHERE is_active = TRUE ");

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(name) LIKE LOWER(?) ");
            sql.append("OR LOWER(qualifications) LIKE LOWER(?) ");
            sql.append("OR LOWER(specialties) LIKE LOWER(?) ");
            sql.append("OR LOWER(bio) LIKE LOWER(?)) ");
        }

        sql.append("ORDER BY name");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (query != null && !query.trim().isEmpty()) {
                String searchPattern = "%" + query.trim() + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
                ps.setString(3, searchPattern);
                ps.setString(4, searchPattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                List<Caregiver> caregivers = new ArrayList<>();
                while (rs.next()) {
                    caregivers.add(extractCaregiverFromResultSet(rs));
                }
                return caregivers;
            }
        }
    }

    @Override
    public Caregiver createCaregiver(Caregiver caregiver) throws SQLException {
        String sql = "INSERT INTO caregiver (name, qualifications, specialties, experience_years, bio, phone, email, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, caregiver.getName());
            ps.setString(2, caregiver.getQualifications());
            ps.setString(3, caregiver.getSpecialties());
            if (caregiver.getExperienceYears() != null) {
                ps.setInt(4, caregiver.getExperienceYears());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, caregiver.getBio());
            ps.setString(6, caregiver.getPhone());
            ps.setString(7, caregiver.getEmail());
            ps.setBoolean(8, caregiver.isAvailable());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        caregiver.setCaregiverId(rs.getInt(1));
                        return caregiver;
                    }
                }
            }
        }
        return null;
    }

    @Override
    public boolean updateCaregiver(Caregiver caregiver) throws SQLException {
        String sql = "UPDATE caregiver SET name = ?, qualifications = ?, specialties = ?, experience_years = ?, bio = ?, " +
                     "phone = ?, email = ?, is_active = ? WHERE caregiver_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, caregiver.getName());
            ps.setString(2, caregiver.getQualifications());
            ps.setString(3, caregiver.getSpecialties());
            if (caregiver.getExperienceYears() != null) {
                ps.setInt(4, caregiver.getExperienceYears());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, caregiver.getBio());
            ps.setString(6, caregiver.getPhone());
            ps.setString(7, caregiver.getEmail());
            ps.setBoolean(8, caregiver.isAvailable());
            ps.setInt(9, caregiver.getCaregiverId());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteCaregiver(int caregiverId) throws SQLException {
        String sql = "DELETE FROM caregiver WHERE caregiver_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Helper method to extract Caregiver object from ResultSet
     */
    private Caregiver extractCaregiverFromResultSet(ResultSet rs) throws SQLException {
        Caregiver caregiver = new Caregiver();
        caregiver.setCaregiverId(rs.getInt("caregiver_id"));
        caregiver.setUserId(rs.getObject("user_id", Integer.class));
        caregiver.setName(rs.getString("name"));
        caregiver.setQualifications(rs.getString("qualifications"));
        caregiver.setSpecialties(rs.getString("specialties"));
        caregiver.setSpecialization(rs.getString("specialties")); // Map specialties to specialization for backward compatibility
        caregiver.setExperienceYears(rs.getObject("experience_years", Integer.class));
        caregiver.setBio(rs.getString("bio"));
        caregiver.setPhone(rs.getString("phone"));
        caregiver.setEmail(rs.getString("email"));
        caregiver.setAvailable(rs.getBoolean("is_active"));
        caregiver.setCreatedAt(rs.getTimestamp("created_at"));
        return caregiver;
    }
    @Override
    public Caregiver getCaregiverByEmail(String email) throws SQLException {
        String sql = "SELECT caregiver_id, user_id, name, qualifications, specialties, experience_years, bio, phone, email, is_active, created_at " +
                     "FROM caregiver WHERE email = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCaregiverFromResultSet(rs);
                }
            }
        }
        return null;
    }
}
