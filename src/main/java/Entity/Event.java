package Entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Event {

    private Integer eventId;
    private Integer organizationId;
    private String title;
    private String description;
    private String location;
    private Integer maxVolunteers;
    private String status;
    private java.time.LocalDate startDate;
    private java.time.LocalDate endDate;
    private java.time.LocalDateTime createdAt;
    private java.time.LocalDateTime updatedAt;


    public Event() {
    }

    public Event(Integer eventId, Integer organizationId, String title, String description, String location, Integer maxVolunteers, String status, LocalDate startDate, LocalDate endDate, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.eventId = eventId;
        this.organizationId = organizationId;
        this.title = title;
        this.description = description;
        this.location = location;
        this.maxVolunteers = maxVolunteers;
        this.status = status;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Integer getEventId() {
        return eventId;
    }
    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public Integer getOrganizationId() {
        return organizationId;
    }
    public void setOrganizationId(Integer organizationId) {
        this.organizationId = organizationId;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }
    public void setLocation(String location) {
        this.location = location;
    }

    public Integer getMaxVolunteers() {
        return maxVolunteers;
    }
    public void setMaxVolunteers(Integer maxVolunteers) {
        this.maxVolunteers = maxVolunteers;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public java.time.LocalDate getStartDate() {
        return startDate;
    }
    public void setStartDate(java.time.LocalDate startDate) {
        this.startDate = startDate;
    }

    public java.time.LocalDate getEndDate() {
        return endDate;
    }
    public void setEndDate(java.time.LocalDate endDate) {
        this.endDate = endDate;
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
