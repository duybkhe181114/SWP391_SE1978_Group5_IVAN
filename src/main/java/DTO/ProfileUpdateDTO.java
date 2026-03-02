package DTO;

import java.sql.Timestamp;

public class ProfileUpdateDTO {

    private int requestId;
    private int userId;
    private String email;

    // Dữ liệu cũ (Hiện tại)
    private String oldFirstName;
    private String oldLastName;
    private String oldPhone;
    private String oldProvince;
    private String oldAddress;
    private String oldSkillIds;

    // Dữ liệu mới (Yêu cầu thay đổi)
    private String newFirstName;
    private String newLastName;
    private String newPhone;
    private String newProvince;
    private String newAddress;
    private String newSkillIds;
    private String status;
    private String reviewNote;
    private Timestamp reviewedAt;
    private Timestamp requestedAt;

    // Constructor rỗng
    public ProfileUpdateDTO() {
    }

    // ===== GETTER & SETTER =====

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOldFirstName() {
        return oldFirstName;
    }

    public void setOldFirstName(String oldFirstName) {
        this.oldFirstName = oldFirstName;
    }

    public String getOldLastName() {
        return oldLastName;
    }

    public void setOldLastName(String oldLastName) {
        this.oldLastName = oldLastName;
    }

    public String getOldPhone() {
        return oldPhone;
    }

    public void setOldPhone(String oldPhone) {
        this.oldPhone = oldPhone;
    }

    public String getOldProvince() {
        return oldProvince;
    }

    public void setOldProvince(String oldProvince) {
        this.oldProvince = oldProvince;
    }

    public String getOldAddress() {
        return oldAddress;
    }

    public void setOldAddress(String oldAddress) {
        this.oldAddress = oldAddress;
    }

    public String getOldSkillIds() {
        return oldSkillIds;
    }

    public void setOldSkillIds(String oldSkillIds) {
        this.oldSkillIds = oldSkillIds;
    }

    public String getNewFirstName() {
        return newFirstName;
    }

    public void setNewFirstName(String newFirstName) {
        this.newFirstName = newFirstName;
    }

    public String getNewLastName() {
        return newLastName;
    }

    public void setNewLastName(String newLastName) {
        this.newLastName = newLastName;
    }

    public String getNewPhone() {
        return newPhone;
    }

    public void setNewPhone(String newPhone) {
        this.newPhone = newPhone;
    }

    public String getNewProvince() {
        return newProvince;
    }

    public void setNewProvince(String newProvince) {
        this.newProvince = newProvince;
    }

    public String getNewAddress() {
        return newAddress;
    }

    public void setNewAddress(String newAddress) {
        this.newAddress = newAddress;
    }

    public String getNewSkillIds() {
        return newSkillIds;
    }

    public void setNewSkillIds(String newSkillIds) {
        this.newSkillIds = newSkillIds;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReviewNote() {
        return reviewNote;
    }

    public void setReviewNote(String reviewNote) {
        this.reviewNote = reviewNote;
    }

    public Timestamp getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(Timestamp reviewedAt) {
        this.reviewedAt = reviewedAt;
    }
}