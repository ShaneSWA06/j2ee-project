package model;

import java.io.Serializable;

/**
 * Caregiver - DTO for Spring Boot API
 */
public class Caregiver implements Serializable {
    private static final long serialVersionUID = 1L;

    private int caregiverId;
    private Integer userId;
    private String name;
    private String specialization;
    private String phone;
    private String email;
    private boolean isAvailable;
    private java.sql.Timestamp createdAt;
    private String qualifications;
    private String specialties;
    private Integer experienceYears;
    private String bio;
    private String availableHours;
    private java.math.BigDecimal rating;
    private String profileImage;
    private Integer companyId;

    public Caregiver() {}

    // Getters and Setters
    public int getCaregiverId() { return caregiverId; }
    public void setCaregiverId(int caregiverId) { this.caregiverId = caregiverId; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    public String getQualifications() { return qualifications; }
    public void setQualifications(String qualifications) { this.qualifications = qualifications; }
    public String getSpecialties() { return specialties; }
    public void setSpecialties(String specialties) { this.specialties = specialties; }
    public Integer getExperienceYears() { return experienceYears; }
    public void setExperienceYears(Integer experienceYears) { this.experienceYears = experienceYears; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public String getAvailableHours() { return availableHours; }
    public void setAvailableHours(String availableHours) { this.availableHours = availableHours; }
    public java.math.BigDecimal getRating() { return rating; }
    public void setRating(java.math.BigDecimal rating) { this.rating = rating; }
    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }
    public Integer getCompanyId() { return companyId; }
    public void setCompanyId(Integer companyId) { this.companyId = companyId; }
    
    // Alias for compatibility
    public Integer getExperience() { return experienceYears; }
    public void setExperience(Integer experience) { this.experienceYears = experience; }
}
