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

            // Debug: List tables
            java.sql.DatabaseMetaData md = conn.getMetaData();
            java.sql.ResultSet rs = md.getTables(null, null, "%", new String[]{"TABLE"});
            while (rs.next()) {
                System.out.println("Table: " + rs.getString("TABLE_NAME"));
            }

            // Create tables if not exist (based on setupSchema.jsp)
            
            stmt.execute("CREATE TABLE IF NOT EXISTS service_category ("+
                         "category_id SERIAL PRIMARY KEY, "+
                         "category_name VARCHAR(120) NOT NULL, "+
                         "description TEXT)");
                         
            stmt.execute("CREATE TABLE IF NOT EXISTS service ("+
                         "service_id SERIAL PRIMARY KEY, "+
                         "service_name VARCHAR(150) NOT NULL, "+
                         "category_id INTEGER REFERENCES service_category(category_id) ON DELETE SET NULL, "+
                         "description TEXT, "+
                         "base_price NUMERIC(10,2), "+
                         "duration_minutes INTEGER, "+
                         "is_active BOOLEAN DEFAULT TRUE)");

            stmt.execute("CREATE TABLE IF NOT EXISTS booking ("+
                         "booking_id SERIAL PRIMARY KEY, "+
                         "user_id INTEGER NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE, "+
                         "service_id INTEGER NOT NULL REFERENCES service(service_id) ON DELETE CASCADE, "+
                         "caregiver_id INTEGER REFERENCES caregiver(caregiver_id) ON DELETE SET NULL, "+
                         "booking_date DATE NOT NULL, "+
                         "booking_time TIME NOT NULL, "+
                         "status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Confirmed', 'Completed', 'Cancelled')), "+
                         "notes TEXT, "+
                         "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
                         "caregiver_status VARCHAR(50) DEFAULT 'Pending')"); // Added caregiver_status here

            stmt.execute("CREATE TABLE IF NOT EXISTS feedback ("+
                         "feedback_id SERIAL PRIMARY KEY, "+
                         "user_id INTEGER NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE, "+
                         "caregiver_id INTEGER REFERENCES caregiver(caregiver_id) ON DELETE SET NULL, "+
                         "booking_id INTEGER REFERENCES booking(booking_id) ON DELETE SET NULL, "+
                         "star_rating INTEGER NOT NULL CHECK (star_rating >= 1 AND star_rating <= 5), "+
                         "comment TEXT, "+
                         "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            // Add caregiver_status column to booking table if it exists but missing column
            try {
                stmt.executeUpdate("ALTER TABLE booking ADD COLUMN caregiver_status VARCHAR(50) DEFAULT 'Pending'");
                System.out.println("Added column 'caregiver_status' to booking table.");
            } catch (SQLException e) {
                System.out.println("Column 'caregiver_status' might already exist: " + e.getMessage());
            }

            // Add payment_status column to booking table
            try {
                stmt.executeUpdate("ALTER TABLE booking ADD COLUMN payment_status VARCHAR(50) DEFAULT 'Unpaid'");
                System.out.println("Added column 'payment_status' to booking table.");
            } catch (SQLException e) {
                System.out.println("Column 'payment_status' might already exist: " + e.getMessage());
            }

            System.out.println("Schema update completed.");

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
