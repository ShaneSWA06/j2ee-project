package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dao.CategoryDAO;
import db.DBUtil;
import model.Category;

/**
 * CategoryDAOImpl - Implementation of CategoryDAO using JDBC
 */
public class CategoryDAOImpl implements CategoryDAO {

    @Override
    public Category getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT category_id, category_name, description FROM service_category WHERE category_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCategoryFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Category> getAllCategories() throws SQLException {
        String sql = "SELECT category_id, category_name, description FROM service_category ORDER BY category_id ASC";
        List<Category> categories = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
        }
        return categories;
    }

    @Override
    public Category createCategory(Category category) throws SQLException {
        String sql = "INSERT INTO service_category (category_name, description) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        category.setCategoryId(rs.getInt(1));
                        return category;
                    }
                }
            }
        }
        return null;
    }

    @Override
    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE service_category SET category_name = ?, description = ? WHERE category_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteCategory(int categoryId) throws SQLException {
        String sql = "DELETE FROM service_category WHERE category_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Helper method to extract Category object from ResultSet
     */
    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        return category;
    }
}
