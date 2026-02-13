package model;

import java.io.Serializable;

/**
 * Category - Service Classification Entity
 * <p>
 * Purpose:
 * - Represents a logical grouping of services (e.g., "Medical", "Cleaning", "Companionship").
 * - Maps to the `categories` table.
 * - Used to organize services in the UI for easier browsing.
 */
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    private int categoryId;
    private String categoryName;
    private String description;
    private java.sql.Timestamp createdAt;

    public Category() {}

    // Getters and Setters
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
}
