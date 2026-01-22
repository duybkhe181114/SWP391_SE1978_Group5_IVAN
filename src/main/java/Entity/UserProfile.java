package Entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class UserProfile {

    private Integer userId;
    private String firstName;
    private String lastName;
    private String fullName;

    private String phone;
    private java.time.LocalDate dateOfBirth;
    private String gender;
    private String avatar;

    private String address;
    private String wardCommune;
    private String district;
    private String province;
    private String postalCode;

    private String emergencyContactName;
    private String emergencyContactPhone;

    private java.time.LocalDateTime createdAt;
    private java.time.LocalDateTime updatedAt;

    public UserProfile() {
    }

    public UserProfile(Integer userId, String firstName, String lastName, String fullName, String phone, LocalDate dateOfBirth, String gender, String avatar, String address, String wardCommune, String district, String province, String postalCode, String emergencyContactName, String emergencyContactPhone, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.fullName = fullName;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.avatar = avatar;
        this.address = address;
        this.wardCommune = wardCommune;
        this.district = district;
        this.province = province;
        this.postalCode = postalCode;
        this.emergencyContactName = emergencyContactName;
        this.emergencyContactPhone = emergencyContactPhone;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public java.time.LocalDate getDateOfBirth() {
        return dateOfBirth;
    }
    public void setDateOfBirth(java.time.LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAvatar() {
        return avatar;
    }
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getWardCommune() {
        return wardCommune;
    }
    public void setWardCommune(String wardCommune) {
        this.wardCommune = wardCommune;
    }

    public String getDistrict() {
        return district;
    }
    public void setDistrict(String district) {
        this.district = district;
    }

    public String getProvince() {
        return province;
    }
    public void setProvince(String province) {
        this.province = province;
    }

    public String getPostalCode() {
        return postalCode;
    }
    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getEmergencyContactName() {
        return emergencyContactName;
    }
    public void setEmergencyContactName(String emergencyContactName) {
        this.emergencyContactName = emergencyContactName;
    }

    public String getEmergencyContactPhone() {
        return emergencyContactPhone;
    }
    public void setEmergencyContactPhone(String emergencyContactPhone) {
        this.emergencyContactPhone = emergencyContactPhone;
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
