package Entity;

import java.time.LocalDateTime;

public class SupportRequest {

    private Integer requestId;

    // ===== BASIC INFORMATION =====
    private String title;                 // Tiêu đề yêu cầu
    private String description;           // Mô tả hoàn cảnh

    // ===== SUPPORT DETAILS =====
    private String categoryId;           // MEDICAL, FOOD, EDUCATION, DISASTER, FINANCIAL
    private String priority;              // LOW, MEDIUM, HIGH, URGENT
    private String supportLocation;       // Địa điểm cần hỗ trợ
    private String beneficiaryName;       // Người / nhóm cần giúp
    private Integer affectedPeople;       // Số người bị ảnh hưởng
    private Double estimatedAmount;       // Số tiền ước tính cần hỗ trợ

    // ===== CONTACT INFO =====
    private String contactEmail;
    private String contactPhone;

    // ===== PROOF =====
    private String proofImageUrl;         // Ảnh minh chứng

    // ===== SYSTEM INFO =====
    private Integer createdBy;            // User tạo request
    private String status;                // PENDING, APPROVED, REJECTED, COMPLETED
    private String adminNote;             // Ghi chú nội bộ
    private String rejectReason;          // Lý do từ chối

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime reviewedAt;
    private Integer reviewedBy;

    private Boolean isDeleted;

    public SupportRequest() {
    }

    public SupportRequest(Integer requestId, String title, String description,
                                 String supportType, String priority,
                                 String supportLocation, String beneficiaryName,
                                 Integer affectedPeople, Double estimatedAmount,
                                 String contactEmail, String contactPhone,
                                 String proofImageUrl, Integer createdBy,
                                 String status, String adminNote,
                                 String rejectReason, LocalDateTime createdAt,
                                 LocalDateTime updatedAt, LocalDateTime reviewedAt,
                                 Integer reviewedBy, Boolean isDeleted) {

        this.requestId = requestId;
        this.title = title;
        this.description = description;
        this.categoryId = categoryId;
        this.priority = priority;
        this.supportLocation = supportLocation;
        this.beneficiaryName = beneficiaryName;
        this.affectedPeople = affectedPeople;
        this.estimatedAmount = estimatedAmount;
        this.contactEmail = contactEmail;
        this.contactPhone = contactPhone;
        this.proofImageUrl = proofImageUrl;
        this.createdBy = createdBy;
        this.status = status;
        this.adminNote = adminNote;
        this.rejectReason = rejectReason;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.reviewedAt = reviewedAt;
        this.reviewedBy = reviewedBy;
        this.isDeleted = isDeleted;
    }

    // ===== Getter & Setter =====

    public Integer getRequestId() { return requestId; }
    public void setRequestId(Integer requestId) { this.requestId = requestId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getSupportLocation() { return supportLocation; }
    public void setSupportLocation(String supportLocation) { this.supportLocation = supportLocation; }

    public String getBeneficiaryName() { return beneficiaryName; }
    public void setBeneficiaryName(String beneficiaryName) { this.beneficiaryName = beneficiaryName; }

    public Integer getAffectedPeople() { return affectedPeople; }
    public void setAffectedPeople(Integer affectedPeople) { this.affectedPeople = affectedPeople; }

    public Double getEstimatedAmount() { return estimatedAmount; }
    public void setEstimatedAmount(Double estimatedAmount) { this.estimatedAmount = estimatedAmount; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getProofImageUrl() { return proofImageUrl; }
    public void setProofImageUrl(String proofImageUrl) { this.proofImageUrl = proofImageUrl; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminNote() { return adminNote; }
    public void setAdminNote(String adminNote) { this.adminNote = adminNote; }

    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public LocalDateTime getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }

    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

    public Boolean getIsDeleted() { return isDeleted; }
    public void setIsDeleted(Boolean isDeleted) { this.isDeleted = isDeleted; }
}