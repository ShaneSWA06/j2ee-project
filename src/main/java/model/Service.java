package model;

import java.io.Serializable;

/**
 * Service represents a service offering in the service table
 */
public class Service implements Serializable {
    private static final long serialVersionUID = 1L;

    private int serviceId;
    private String serviceName;
    private String description;
    private double basePrice;
    private int durationMinutes;
    private int categoryId;
    private String categoryName; // For joined queries
    private boolean isActive;
    private Integer companyId;
    private String imageUrl;
    private java.sql.Timestamp createdAt;

    // Constructors
    public Service() {
    }

    public Service(int serviceId, String serviceName, String description,
                   double basePrice, int durationMinutes, int categoryId, boolean isActive) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.description = description;
        this.basePrice = basePrice;
        this.durationMinutes = durationMinutes;
        this.categoryId = categoryId;
        this.isActive = isActive;
    }

    // Getters and Setters
    public Integer getCompanyId() { return companyId; }
    public void setCompanyId(Integer companyId) { this.companyId = companyId; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Service{" +
                "serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
                ", basePrice=" + basePrice +
                '}';
    }
}
