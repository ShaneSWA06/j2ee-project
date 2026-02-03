package db;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class UpdateSchema {
    public static void main(String[] args) {
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement()) {

            // Add is_verified column
            try {
                stmt.executeUpdate("ALTER TABLE app_user ADD COLUMN is_verified BOOLEAN DEFAULT FALSE");
                System.out.println("Added column 'is_verified'.");
            } catch (SQLException e) {
                System.out.println("Column 'is_verified' might already exist: " + e.getMessage());
            }

            // Add verification_token column
            try {
                stmt.executeUpdate("ALTER TABLE app_user ADD COLUMN verification_token VARCHAR(255)");
                System.out.println("Added column 'verification_token'.");
            } catch (SQLException e) {
                System.out.println("Column 'verification_token' might already exist: " + e.getMessage());
            }

            System.out.println("Schema update completed.");

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
