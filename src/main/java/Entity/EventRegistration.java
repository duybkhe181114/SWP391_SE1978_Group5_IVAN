package Entity;

import java.time.LocalDateTime;

public class EventRegistration {

    private Integer registrationId;
    private Integer eventId;
    private Integer volunteerId;
    private String registrationType;
    private String status;
    private LocalDateTime appliedAt;
    private String applicationReason;
    private String relevantExperience;
    private String commitmentLevel;
    private String availabilityNote;
    private String invitationMessage;
    private Integer invitedBy;
    private LocalDateTime reviewedAt;
    private Integer reviewedBy;
    private String reviewNote;

    public Integer getRegistrationId() {
        return registrationId;
    }

    public void setRegistrationId(Integer registrationId) {
        this.registrationId = registrationId;
    }

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public Integer getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Integer volunteerId) {
        this.volunteerId = volunteerId;
    }

    public String getRegistrationType() {
        return registrationType;
    }

    public void setRegistrationType(String registrationType) {
        this.registrationType = registrationType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(LocalDateTime appliedAt) {
        this.appliedAt = appliedAt;
    }

    public String getApplicationReason() {
        return applicationReason;
    }

    public void setApplicationReason(String applicationReason) {
        this.applicationReason = applicationReason;
    }

    public String getRelevantExperience() {
        return relevantExperience;
    }

    public void setRelevantExperience(String relevantExperience) {
        this.relevantExperience = relevantExperience;
    }

    public String getCommitmentLevel() {
        return commitmentLevel;
    }

    public void setCommitmentLevel(String commitmentLevel) {
        this.commitmentLevel = commitmentLevel;
    }

    public String getAvailabilityNote() {
        return availabilityNote;
    }

    public void setAvailabilityNote(String availabilityNote) {
        this.availabilityNote = availabilityNote;
    }

    public String getInvitationMessage() {
        return invitationMessage;
    }

    public void setInvitationMessage(String invitationMessage) {
        this.invitationMessage = invitationMessage;
    }

    public Integer getInvitedBy() {
        return invitedBy;
    }

    public void setInvitedBy(Integer invitedBy) {
        this.invitedBy = invitedBy;
    }

    public LocalDateTime getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(LocalDateTime reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public String getReviewNote() {
        return reviewNote;
    }

    public void setReviewNote(String reviewNote) {
        this.reviewNote = reviewNote;
    }
}
