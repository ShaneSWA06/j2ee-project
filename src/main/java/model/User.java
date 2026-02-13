package model;

import java.io.Serializable;

/**
 * User - Core Identity & Profile Entity
 * <p>
 * Purpose:
 * - Represents a registered user in the system (Customer, Admin, Caregiver, etc.).
 * - Maps to the `app_user` table.
 * - Handles authentication (password, roles) and profile data.
 * <p>
 * Security Note:
 * - Passwords should be hashed before storage.
 * - Sensitive fields (resetToken, password) should be handled with care in logs/responses.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String username;
    private String email;
    private String name;
    private String password;
    private String role; // "ADMIN", "CUSTOMER", "CAREGIVER", "COMPANY_ADMIN"
    private String resetToken;
    private java.sql.Timestamp resetTokenExpiry;
    private java.sql.Timestamp createdAt;
    
    // Additional Profile Fields
    private String phone;
    private String address;
    private String relationship;
    private String careNotes;
    private String medicalHistory;
    private String allergies;
    private Integer companyId;

    // Email Verification Fields
    private boolean isVerified;
    private String verificationToken;

    // Constructors
    public User() {
    }

    public User(int userId, String username, String email, String name, String role) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.name = name;
        this.role = role;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getResetToken() { return resetToken; }
    public void setResetToken(String resetToken) { this.resetToken = resetToken; }

    public java.sql.Timestamp getResetTokenExpiry() { return resetTokenExpiry; }
    public void setResetTokenExpiry(java.sql.Timestamp resetTokenExpiry) { this.resetTokenExpiry = resetTokenExpiry; }

    public java.sql.Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean isVerified) { this.isVerified = isVerified; }

    public String getVerificationToken() { return verificationToken; }
    public void setVerificationToken(String verificationToken) { this.verificationToken = verificationToken; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRelationship() { return relationship; }
    public void setRelationship(String relationship) { this.relationship = relationship; }

    public String getCareNotes() { return careNotes; }
    public void setCareNotes(String careNotes) { this.careNotes = careNotes; }

    public String getMedicalHistory() { return medicalHistory; }
    public void setMedicalHistory(String medicalHistory) { this.medicalHistory = medicalHistory; }

    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }

    public Integer getCompanyId() { return companyId; }
    public void setCompanyId(Integer companyId) { this.companyId = companyId; }

    // Helper methods
    public boolean isAdmin() { return "ADMIN".equals(role); }
    public boolean isCustomer() { return "CUSTOMER".equals(role); }
    public boolean isCompanyAdmin() { return "COMPANY_ADMIN".equals(role); }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", role='" + role + '\'' +
                ", companyId=" + companyId +
                '}';
    }
}
