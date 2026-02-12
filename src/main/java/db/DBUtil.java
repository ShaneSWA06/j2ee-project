package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBUtil handles the JDBC Database Connection management.
 * <p>
 * What it does:
 * - Loads the PostgreSQL JDBC driver.
 * - Establishes a connection to the remote Neon database using the provided credentials and URL.
 * - Returns a valid `Connection` object for DAOs to use.
 * <p>
 * Configuration Intent:
 * - Cloud-Native: The connection URL targets a Neon Serverless PostgreSQL instance hosted on AWS.
 * - Security: We enforce `sslmode=require` to ensure data in transit is encrypted, which is mandatory 
 *   for production database connections over the public internet.
 */
public class DBUtil {
    // Connection string details. 
    // In a real production scenario, these should be loaded from Environment Variables (System.getenv)
    // to avoid committing credentials to version control.
    private static final String URL = "jdbc:postgresql://ep-rapid-flower-a1p7ybi1-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require";
    private static final String USER = "neondb_owner";
    private static final String PASSWORD = "npg_yKJZTuk6MWO5";

    public static Connection getConnection() throws SQLException {
        try {
            // Explicitly load the PostgreSQL Driver.
            // While modern JDBC (Java 6+) supports automatic driver discovery via SPI,
            // many Servlet Containers (like Tomcat/Jetty) still require this explicit load
            // to ensure the driver is registered in the webapp's ClassLoader.
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC Driver not found", e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
