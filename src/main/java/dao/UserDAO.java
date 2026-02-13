package dao;

import java.sql.SQLException;

import model.User;

/**
 * UserDAO - Data Access Interface for Users
 * <p>
 * Purpose:
 * - Defines the contract for accessing and modifying `app_user` data.
 * - Handles authentication (login), registration, and profile management queries.
 */
public interface UserDAO {

    /**
     * Get user by ID
     */
    User getUserById(int userId) throws SQLException;

    /**
     * Get user by username
     */
    User getUserByUsername(String username) throws SQLException;

    /**
     * Get user by email
     */
    User getUserByEmail(String email) throws SQLException;

    /**
     * Get all users by role (ADMIN or CUSTOMER)
     */
    java.util.List<User> getUsersByRole(String role) throws SQLException;

    /**
     * Validate user login credentials
     * @param usernameOrEmail can be either username or email
     * @param password plain text password
     * @return User object if valid, null if invalid
     */
    User validateLogin(String usernameOrEmail, String password) throws SQLException;

    /**
     * Create a new user
     * @return the created user with generated ID
     */
    User createUser(User user) throws SQLException;

    /**
     * Update existing user
     */
    boolean updateUser(User user) throws SQLException;

    /**
     * Delete user by ID
     */
    boolean deleteUser(int userId) throws SQLException;

    /**
     * Set password reset token
     */
    boolean setResetToken(String email, String token, java.sql.Timestamp expiry) throws SQLException;

    /**
     * Get user by reset token
     */
    User getUserByResetToken(String token) throws SQLException;

    /**
     * Clear reset token after password reset
     */
    boolean clearResetToken(int userId) throws SQLException;

    /**
     * Get user by verification token
     */
    User getUserByVerificationToken(String token) throws SQLException;

    /**
     * Mark user as verified
     */
    boolean verifyUser(int userId) throws SQLException;
}
