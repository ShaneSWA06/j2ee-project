package db;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * PaymentSchemaInit - Database migration for Payment module
 * <p>
 * Purpose:
 * - Creates the 'payment' table if it doesn't exist.
 * - Adds 'payment_status' column to the 'booking' table.
 * - Ensures the database is ready for the Payment processing features.
 */
public class PaymentSchemaInit {
    public static void main(String[] args) {
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("Initializing payment schema...");

            // Create payment table
            stmt.execute("CREATE TABLE IF NOT EXISTS payment (" +
                         "payment_id SERIAL PRIMARY KEY, " +
                         "booking_id INTEGER REFERENCES booking(booking_id) ON DELETE SET NULL, " +
                         "amount NUMERIC(10,2) NOT NULL, " +
                         "currency VARCHAR(10) DEFAULT 'SGD', " +
                         "payment_method VARCHAR(50), " +
                         "transaction_id VARCHAR(100), " +
                         "status VARCHAR(50), " +
                         "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            System.out.println("Created payment table.");

            // Add payment_status to booking if not exists
            try {
                stmt.execute("ALTER TABLE booking ADD COLUMN payment_status VARCHAR(50) DEFAULT 'Unpaid'");
                System.out.println("Added payment_status column to booking table.");
            } catch (SQLException e) {
                // Ignore if column already exists
                if (!e.getMessage().contains("duplicate") && !e.getMessage().contains("exists")) {
                    System.out.println("Note: " + e.getMessage());
                }
            }

            System.out.println("Payment schema initialized successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
