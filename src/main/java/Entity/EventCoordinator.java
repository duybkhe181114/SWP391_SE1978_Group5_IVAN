package Entity;

import java.time.LocalDateTime;

public class EventCoordinator {

    private Integer eventId;
    private Integer coordinatorId;
    private Boolean promotedFromVolunteer;
    private LocalDateTime promotedAt;
    private Integer promotedBy;
    private String status; // Active / Busy / Revoked

    // Display fields (JOIN)
    private String coordinatorName;
    private String coordinatorEmail;
    private String eventName;

    public EventCoordinator() {
    }

    // Getters & Setters
    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public Integer getCoordinatorId() {
        return coordinatorId;
    }

    public void setCoordinatorId(Integer coordinatorId) {
        this.coordinatorId = coordinatorId;
    }

    public Boolean getPromotedFromVolunteer() {
        return promotedFromVolunteer;
    }

    public void setPromotedFromVolunteer(Boolean promotedFromVolunteer) {
        this.promotedFromVolunteer = promotedFromVolunteer;
    }

    public LocalDateTime getPromotedAt() {
        return promotedAt;
    }

    public void setPromotedAt(LocalDateTime promotedAt) {
        this.promotedAt = promotedAt;
    }

    public Integer getPromotedBy() {
        return promotedBy;
    }

    public void setPromotedBy(Integer promotedBy) {
        this.promotedBy = promotedBy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCoordinatorName() {
        return coordinatorName;
    }

    public void setCoordinatorName(String coordinatorName) {
        this.coordinatorName = coordinatorName;
    }

    public String getCoordinatorEmail() {
        return coordinatorEmail;
    }

    public void setCoordinatorEmail(String coordinatorEmail) {
        this.coordinatorEmail = coordinatorEmail;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }
}
