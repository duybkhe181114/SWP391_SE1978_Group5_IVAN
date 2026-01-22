package Entity;

import java.time.LocalDateTime;

public class SupportRequest {

    private Integer requestId;
    private Integer createdBy;
    private Integer categoryId;
    private String description;
    private String proofUrl;
    private String status;
    private Integer reviewedBy;
    private java.time.LocalDateTime reviewedAt;
    private String rejectReason;
    private java.time.LocalDateTime createdAt;

    public SupportRequest() {
    }

    public SupportRequest(Integer requestId, Integer createdBy, Integer categoryId, String description, String proofUrl, String status, Integer reviewedBy, LocalDateTime reviewedAt, String rejectReason, LocalDateTime createdAt) {
        this.requestId = requestId;
        this.createdBy = createdBy;
        this.categoryId = categoryId;
        this.description = description;
        this.proofUrl = proofUrl;
        this.status = status;
        this.reviewedBy = reviewedBy;
        this.reviewedAt = reviewedAt;
        this.rejectReason = rejectReason;
        this.createdAt = createdAt;
    }

    public Integer getRequestId() {
        return requestId;
    }
    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }
    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getCategoryId() {
        return categoryId;
    }
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getProofUrl() {
        return proofUrl;
    }
    public void setProofUrl(String proofUrl) {
        this.proofUrl = proofUrl;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }
    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public java.time.LocalDateTime getReviewedAt() {
        return reviewedAt;
    }
    public void setReviewedAt(java.time.LocalDateTime reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public String getRejectReason() {
        return rejectReason;
    }
    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public java.time.LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(java.time.LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
