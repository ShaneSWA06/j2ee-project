package dao;

import java.sql.SQLException;
import java.util.List;

import model.Caregiver;

/**
 * CaregiverDAO - Data Access Object interface for Caregiver operations
 */
public interface CaregiverDAO {

    /**
     * Get caregiver by ID
     */
    Caregiver getCaregiverById(int caregiverId) throws SQLException;

    /**
     * Get all caregivers
     */
    List<Caregiver> getAllCaregivers() throws SQLException;

    /**
     * Get only available caregivers
     */
    List<Caregiver> getAvailableCaregivers() throws SQLException;

    /**
     * Create a new caregiver
     * @return the created caregiver with generated ID
     */
    Caregiver createCaregiver(Caregiver caregiver) throws SQLException;

    /**
     * Update existing caregiver
     */
    boolean updateCaregiver(Caregiver caregiver) throws SQLException;

    /**
     * Delete caregiver by ID
     */
    boolean deleteCaregiver(int caregiverId) throws SQLException;

    /**
     * Search caregivers by query string
     */
    List<Caregiver> searchCaregivers(String query) throws SQLException;

    /**
     * Get caregiver by Email
     */
    Caregiver getCaregiverByEmail(String email) throws SQLException;

    /**
     * Get caregiver by User ID
     */
    Caregiver getCaregiverByUserId(int userId) throws SQLException;

    /**
     * Get all caregivers for a specific company
     */
    List<Caregiver> getCaregiversByCompany(int companyId) throws SQLException;
}
