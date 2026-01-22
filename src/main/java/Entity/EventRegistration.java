package Entity;

import java.time.LocalDateTime;

public class EventRegistration {

    private Integer registrationId;
    private Integer eventId;
    private Integer volunteerId;
    private String status;
    private java.time.LocalDateTime appliedAt;
    private java.time.LocalDateTime reviewedAt;
    private Integer reviewedBy;
    private String reviewNote;


    public EventRegistration() {
    }

    public EventRegistration(Integer registrationId, Integer eventId, Integer volunteerId, String status, LocalDateTime appliedAt, LocalDateTime reviewedAt, Integer reviewedBy, String reviewNote) {
        this.registrationId = registrationId;
        this.eventId = eventId;
        this.volunteerId = volunteerId;
        this.status = status;
        this.appliedAt = appliedAt;
        this.reviewedAt = reviewedAt;
        this.reviewedBy = reviewedBy;
        this.reviewNote = reviewNote;
    }

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

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public java.time.LocalDateTime getAppliedAt() {
        return appliedAt;
    }
    public void setAppliedAt(java.time.LocalDateTime appliedAt) {
        this.appliedAt = appliedAt;
    }

    public java.time.LocalDateTime getReviewedAt() {
        return reviewedAt;
    }
    public void setReviewedAt(java.time.LocalDateTime reviewedAt) {
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

