package Entity;

import java.time.LocalDateTime;

public class User {

    private Integer userId;
    private String email;
    private String passwordHash;
    private Boolean isActive;
    private java.time.LocalDateTime createdAt;

    public User() {
    }

    public User(Integer userId, String email, String passwordHash, Boolean isActive, LocalDateTime createdAt) {
        this.userId = userId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }
// Getter & Setter

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public java.time.LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.time.LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

