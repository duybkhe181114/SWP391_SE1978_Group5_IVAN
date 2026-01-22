package Entity;

import java.time.LocalDateTime;

public class SupportCategory {

    private Integer categoryId;
    private String categoryName;
    private String description;
    private String priority;
    private Integer expectedResponseTime;
    private Boolean isActive;
    private LocalDateTime createdAt;

    // ===== Getter & Setter =====

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public Integer getExpectedResponseTime() {
        return expectedResponseTime;
    }

    public void setExpectedResponseTime(Integer expectedResponseTime) {
        this.expectedResponseTime = expectedResponseTime;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
