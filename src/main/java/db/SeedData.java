package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * SeedData - Database Seeder
 * <p>
 * Purpose:
 * - Populates the database with initial/sample data.
 * - Creates default Service Categories (Medical Escort, Cleaning, etc).
 * - Creates default Services (Basic Medical Escort, Deep Cleaning, etc).
 * <p>
 * Usage:
 * - Run this main class to initialize a fresh database with usable content.
 */
public class SeedData {

    public static void main(String[] args) {
        try (Connection conn = DBUtil.getConnection()) {
            
            // 1. Ensure "Medical Escort" category exists
            int categoryId = getOrCreateCategory(conn, "Medical Escort", "Professional accompaniment for medical appointments");
            System.out.println("Category 'Medical Escort' ID: " + categoryId);

            // 2. Insert Services
            createServiceIfMissing(conn, "Basic Medical Escort", 
                    "Transport and company to medical appointments.", 
                    50.00, 120, categoryId);
            
            createServiceIfMissing(conn, "Nurse Escort", 
                    "Professional nurse accompaniment for dialysis/chemo.", 
                    120.00, 120, categoryId);
            
            createServiceIfMissing(conn, "Wheelchair Transport", 
                    "Specialized transport with trained medical staff.", 
                    80.00, 60, categoryId);

            // 3. Insert Cleaning Services
            int cleaningCatId = getOrCreateCategory(conn, "Home Cleaning", "Professional home cleaning services");
            
            createServiceIfMissing(conn, "Basic Home Cleaning", 
                    "Standard cleaning for living areas, kitchen, and bathrooms.", 
                    80.00, 180, cleaningCatId);
            
            createServiceIfMissing(conn, "Deep Cleaning", 
                    "Thorough deep cleaning including windows, corners, and appliances.", 
                    150.00, 240, cleaningCatId);

            // 4. Insert Personal Care Services
            int personalCatId = getOrCreateCategory(conn, "Personal Care", "Assistance with daily living activities");
            
            createServiceIfMissing(conn, "Bathing Assistance", 
                    "Safe and respectful assistance with bathing and hygiene.", 
                    60.00, 45, personalCatId);

            // 5. Insert Meal Preparation Services
            int mealCatId = getOrCreateCategory(conn, "Meal Preparation", "Nutritious meal cooking and preparation");
            
            createServiceIfMissing(conn, "Daily Meal Prep", 
                    "Preparation of healthy home-cooked meals.", 
                    40.00, 60, mealCatId);
            
            createServiceIfMissing(conn, "Special Diet Cooking", 
                    "Cooking for specific dietary requirements (diabetes, low-salt, etc).", 
                    60.00, 90, mealCatId);

            System.out.println("Seed data insertion completed.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static int getOrCreateCategory(Connection conn, String name, String description) throws Exception {
        // Check if exists
        String checkSql = "SELECT category_id FROM service_category WHERE category_name = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("category_id");
                }
            }
        }

        // Insert if not exists
        String insertSql = "INSERT INTO service_category (category_name, description) VALUES (?, ?) RETURNING category_id";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setString(1, name);
            ps.setString(2, description);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("category_id");
                }
            }
        }
        
        throw new RuntimeException("Failed to get or create category: " + name);
    }

    private static void createServiceIfMissing(Connection conn, String name, String description, 
                                             double price, int duration, int categoryId) throws Exception {
        
        // Check if exists
        String checkSql = "SELECT service_id FROM service WHERE service_name = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("Service already exists: " + name);
                    return;
                }
            }
        }

        // Insert
        String insertSql = "INSERT INTO service (service_name, description, base_price, duration_minutes, category_id, is_active) " +
                           "VALUES (?, ?, ?, ?, ?, TRUE)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setInt(4, duration);
            ps.setInt(5, categoryId);
            ps.executeUpdate();
            System.out.println("Created service: " + name);
        }
    }
}
