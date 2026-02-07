package util;

import java.sql.Connection;
import java.sql.Statement;
import db.DBUtil;

public class SchemaUpdater {
    public static void main(String[] args) {
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Checking schema...");
            
            // Add caregiver_status column to booking table
            String sql = "ALTER TABLE booking ADD COLUMN caregiver_status VARCHAR(20) DEFAULT 'Pending'";
            try {
                stmt.executeUpdate(sql);
                System.out.println("Added caregiver_status column to booking table.");
            } catch (Exception e) {
                if (e.getMessage().contains("already exists")) {
                    System.out.println("Column caregiver_status already exists.");
                } else {
                    System.out.println("Error adding column: " + e.getMessage());
                }
            }
            
            // Update existing records to have 'Accepted' if they have a caregiver assigned
            String updateSql = "UPDATE booking SET caregiver_status = 'Accepted' WHERE caregiver_id IS NOT NULL AND (caregiver_status IS NULL OR caregiver_status = 'Pending')";
            int rows = stmt.executeUpdate(updateSql);
            System.out.println("Updated " + rows + " existing bookings to 'Accepted' status.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
