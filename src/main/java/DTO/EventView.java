package DTO;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class EventView {

    private Integer eventId;
    private String eventName;
    private String location;
    private LocalDateTime startDate;
    private LocalDateTime endDate;

    // Event image (cover)
    private String eventImageUrl;

    // Organization info
    private Integer organizationId;
    private String organizationName;
    private String organizationLogoUrl;

    private String status;

    // ===== Getters & Setters =====

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public String getEventImageUrl() {
        return eventImageUrl;
    }

    public void setEventImageUrl(String eventImageUrl) {
        this.eventImageUrl = eventImageUrl;
    }

    public Integer getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(Integer organizationId) {
        this.organizationId = organizationId;
    }

    public String getOrganizationName() {
        return organizationName;
    }

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }

    public String getOrganizationLogoUrl() {
        return organizationLogoUrl;
    }

    public void setOrganizationLogoUrl(String organizationLogoUrl) {
        this.organizationLogoUrl = organizationLogoUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getStartDateAsDate() {
        return startDate == null ? null :
                Date.from(startDate.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Date getEndDateAsDate() {
        return endDate == null ? null :
                Date.from(endDate.atZone(ZoneId.systemDefault()).toInstant());
    }
}

