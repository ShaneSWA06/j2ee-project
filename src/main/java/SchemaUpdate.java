
import java.sql.Connection;
import java.sql.Statement;
import db.DBUtil;

/**
 * SchemaUpdate - Additional Database Migrations
 * <p>
 * Purpose:
 * - Adds health-related columns (medical_history, allergies) to User table.
 * - Adds image URL columns to Service and Caregiver tables.
 * - Adds tax fields to Payment table.
 * <p>
 * Note: This appears to be a supplementary migration script used during development.
 */
public class SchemaUpdate {
    public static void main(String[] args) {
        try {
            Connection conn = DBUtil.getConnection();
            Statement stmt = conn.createStatement();
            
            try {
                stmt.execute("ALTER TABLE app_user ADD COLUMN IF NOT EXISTS medical_history TEXT");
                System.out.println("Added medical_history column");
            } catch(Exception e) { System.out.println("Error adding medical_history: " + e.getMessage()); }
            
            try {
                stmt.execute("ALTER TABLE app_user ADD COLUMN IF NOT EXISTS allergies TEXT");
                System.out.println("Added allergies column");
            } catch(Exception e) { System.out.println("Error adding allergies: " + e.getMessage()); }
            
            // Also ensure image columns exist (from previous step)
            try {
                stmt.execute("ALTER TABLE service ADD COLUMN IF NOT EXISTS image_url VARCHAR(255)");
            } catch(Exception e) {}
            try {
                stmt.execute("ALTER TABLE caregiver ADD COLUMN IF NOT EXISTS profile_image VARCHAR(255)");
            } catch(Exception e) {}

            try {
                stmt.execute("ALTER TABLE payment ADD COLUMN IF NOT EXISTS tax_amount NUMERIC(10,2) DEFAULT 0.0");
                System.out.println("Added tax_amount column to payment");
            } catch(Exception e) { System.out.println("Error adding tax_amount: " + e.getMessage()); }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
