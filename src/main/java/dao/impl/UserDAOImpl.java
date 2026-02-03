package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import dao.UserDAO;
import db.DBUtil;
import model.User;

/**
 * UserDAOImpl - Implementation of UserDAO using JDBC
 */
public class UserDAOImpl implements UserDAO {

    @Override
    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT user_id, username, email, name, password, role, created_at, phone, address, relationship, care_notes, is_verified, verification_token " +
                     "FROM app_user WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT user_id, username, email, name, password, role, created_at, phone, address, relationship, care_notes, is_verified, verification_token " +
                     "FROM app_user WHERE username = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT user_id, username, email, name, password, role, created_at, phone, address, relationship, care_notes, is_verified, verification_token " +
                     "FROM app_user WHERE email = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public java.util.List<User> getUsersByRole(String role) throws SQLException {
        String sql = "SELECT user_id, username, email, name, password, role, created_at, phone, address, relationship, care_notes, is_verified, verification_token " +
                     "FROM app_user WHERE role = ? ORDER BY user_id ASC";

        java.util.List<User> users = new java.util.ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(extractUserFromResultSet(rs));
                }
            }
        }
        return users;
    }

    @Override
    public User validateLogin(String usernameOrEmail, String password) throws SQLException {
        String sql = "SELECT user_id, username, email, name, password, role, created_at, phone, address, relationship, care_notes " +
                     "FROM app_user WHERE (username = ? OR email = ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = extractUserFromResultSet(rs);
                    String storedPassword = user.getPassword();

                    // Check hashed password (new users) OR plain text (existing users)
                    if (util.PasswordUtil.checkPassword(password, storedPassword) ||
                        password.equals(storedPassword)) {
                        return user;
                    }
                }
            }
        }
        return null;
    }

    @Override
    public User createUser(User user) throws SQLException {
        String sql = "INSERT INTO app_user (username, email, name, password, role) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getName());
            ps.setString(4, util.PasswordUtil.hashPassword(user.getPassword()));
            ps.setString(5, user.getRole());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                        return user;
                    }
                }
            }
        }
        return null;
    }

    @Override
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE app_user SET username = ?, email = ?, name = ?, role = ?, phone = ?, address = ?, relationship = ?, care_notes = ? WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getName());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getRelationship());
            ps.setString(8, user.getCareNotes());
            ps.setInt(9, user.getUserId());
            
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM app_user WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean setResetToken(String email, String token, Timestamp expiry) throws SQLException {
        // Reset token functionality not implemented - table doesn't have these columns
        return false;
    }

    @Override
    public User getUserByResetToken(String token) throws SQLException {
        // Reset token functionality not implemented - table doesn't have these columns
        return null;
    }

    @Override
    public boolean clearResetToken(int userId) throws SQLException {
        // Reset token functionality not implemented - table doesn't have these columns
        return false;
    }

    /**
     * Helper method to extract User object from ResultSet
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setName(rs.getString("name"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRelationship(rs.getString("relationship"));
        user.setCareNotes(rs.getString("care_notes"));
        user.setVerified(rs.getBoolean("is_verified"));
        user.setVerificationToken(rs.getString("verification_token"));
        return user;
    }

    @Override
    public User getUserByVerificationToken(String token) throws SQLException {
        String sql = "SELECT user_id, username, email, name, password, role, created_at, phone, address, relationship, care_notes, is_verified, verification_token " +
                     "FROM app_user WHERE verification_token = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean verifyUser(int userId) throws SQLException {
        String sql = "UPDATE app_user SET is_verified = TRUE, verification_token = NULL WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
}
