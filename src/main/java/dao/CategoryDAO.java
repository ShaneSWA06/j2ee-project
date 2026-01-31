package dao;

import java.sql.SQLException;
import java.util.List;

import model.Category;

/**
 * CategoryDAO - Data Access Object interface for Category operations
 */
public interface CategoryDAO {

    /**
     * Get category by ID
     */
    Category getCategoryById(int categoryId) throws SQLException;

    /**
     * Get all categories
     */
    List<Category> getAllCategories() throws SQLException;

    /**
     * Create a new category
     * @return the created category with generated ID
     */
    Category createCategory(Category category) throws SQLException;

    /**
     * Update existing category
     */
    boolean updateCategory(Category category) throws SQLException;

    /**
     * Delete category by ID
     */
    boolean deleteCategory(int categoryId) throws SQLException;
}
