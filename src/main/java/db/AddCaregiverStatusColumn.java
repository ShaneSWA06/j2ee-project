package db;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * AddCaregiverStatusColumn - Database migration script
 * <p>
 * Purpose:
 * - Adds the 'caregiver_status' column to the 'booking' table.
 * - This allows caregivers to Accept/Reject bookings independently of the main booking status.
 */
public class AddCaregiverStatusColumn {
    public static void main(String[] args) {
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("Adding caregiver_status column to booking table...");

            try {
                stmt.execute("ALTER TABLE booking ADD COLUMN caregiver_status VARCHAR(50) DEFAULT 'Pending'");
                System.out.println("Success: Added caregiver_status column.");
            } catch (SQLException e) {
                if (e.getMessage().contains("duplicate") || e.getMessage().contains("exists")) {
                    System.out.println("Column caregiver_status already exists.");
                } else {
                    throw e;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
