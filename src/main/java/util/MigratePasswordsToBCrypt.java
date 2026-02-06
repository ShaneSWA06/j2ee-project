package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBUtil;

/**
 * MigratePasswordsToBCrypt - One-time utility to migrate existing passwords to BCrypt
 * 
 * WARNING: This will only work if you know the plain text passwords or have a way to reset them.
 * For production, you should:
 * 1. Force all users to reset their passwords
 * 2. OR migrate during a maintenance window with user notification
 * 
 * This script assumes existing passwords in the database are plain text.
 * If they're already hashed with SHA-256, you'll need to force password resets.
 */
public class MigratePasswordsToBCrypt {

    public static void main(String[] args) {
        System.out.println("=== Password Migration to BCrypt ===");
        System.out.println("WARNING: This will attempt to migrate existing passwords.");
        System.out.println("Make sure you have a database backup before proceeding!\n");

        try {
            migratePasswords();
            System.out.println("\n✓ Migration completed successfully!");
        } catch (SQLException e) {
            System.err.println("\n✗ Migration failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void migratePasswords() throws SQLException {
        String selectSql = "SELECT user_id, username, password FROM app_user";
        String updateSql = "UPDATE app_user SET password = ? WHERE user_id = ?";

        int totalUsers = 0;
        int migratedUsers = 0;
        int skippedUsers = 0;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement selectPs = conn.prepareStatement(selectSql);
             PreparedStatement updatePs = conn.prepareStatement(updateSql)) {

            ResultSet rs = selectPs.executeQuery();

            while (rs.next()) {
                totalUsers++;
                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String currentPassword = rs.getString("password");

                // Check if password is already a BCrypt hash
                if (PasswordUtil.isBCryptHash(currentPassword)) {
                    System.out.println("⊘ Skipping user '" + username + "' (already BCrypt)");
                    skippedUsers++;
                    continue;
                }

                // If password is plain text or old hash, we need to handle it
                // Option 1: If you have plain text passwords, hash them
                // Option 2: Set a temporary password and force reset
                
                // For this example, we'll set a temporary password
                // In production, you should email users to reset their passwords
                String tempPassword = "ChangeMe123!"; // Temporary password
                String hashedPassword = PasswordUtil.hashPassword(tempPassword);

                updatePs.setString(1, hashedPassword);
                updatePs.setInt(2, userId);
                updatePs.executeUpdate();

                System.out.println("✓ Migrated user '" + username + "' (temp password: " + tempPassword + ")");
                migratedUsers++;
            }

            rs.close();
        }

        System.out.println("\n--- Migration Summary ---");
        System.out.println("Total users: " + totalUsers);
        System.out.println("Migrated: " + migratedUsers);
        System.out.println("Skipped (already BCrypt): " + skippedUsers);
    }

    /**
     * Alternative method: Migrate only if you have the plain text passwords
     * This assumes your current passwords are stored in plain text
     */
    @SuppressWarnings("unused")
    private static void migratePlainTextPasswords() throws SQLException {
        String selectSql = "SELECT user_id, username, password FROM app_user";
        String updateSql = "UPDATE app_user SET password = ? WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement selectPs = conn.prepareStatement(selectSql);
             PreparedStatement updatePs = conn.prepareStatement(updateSql)) {

            ResultSet rs = selectPs.executeQuery();

            while (rs.next()) {
                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String plainPassword = rs.getString("password");

                // Skip if already BCrypt
                if (PasswordUtil.isBCryptHash(plainPassword)) {
                    continue;
                }

                // Hash the plain text password
                String hashedPassword = PasswordUtil.hashPassword(plainPassword);

                updatePs.setString(1, hashedPassword);
                updatePs.setInt(2, userId);
                updatePs.executeUpdate();

                System.out.println("✓ Migrated user '" + username + "'");
            }

            rs.close();
        }
    }
}
