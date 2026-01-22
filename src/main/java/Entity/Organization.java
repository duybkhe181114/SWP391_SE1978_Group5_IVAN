package Entity;

import java.time.LocalDateTime;

public class Organization {

    private Integer organizationId;
    private String name;
    private String description;
    private String phone;
    private String email;
    private String address;
    private String website;
    private Integer createdBy;
    private java.time.LocalDateTime createdAt;
    private java.time.LocalDateTime updatedAt;

    public Integer getOrganizationId() {
        return organizationId;
    }
    public void setOrganizationId(Integer organizationId) {
        this.organizationId = organizationId;
    }

    public Organization(Integer organizationId, String name, String description, String phone, String email, String address, String website, Integer createdBy, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.organizationId = organizationId;
        this.name = name;
        this.description = description;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.website = website;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Organization() {
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getWebsite() {
        return website;
    }
    public void setWebsite(String website) {
        this.website = website;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }
    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public java.time.LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(java.time.LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public java.time.LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(java.time.LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
