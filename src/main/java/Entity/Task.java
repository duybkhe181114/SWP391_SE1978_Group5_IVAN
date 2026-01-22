package Entity;

import java.time.LocalDateTime;

public class Task {

    private Integer taskId;
    private Integer eventId;
    private Integer coordinatorId;
    private Integer volunteerId;
    private String taskDescription;
    private String status;
    private java.time.LocalDateTime assignedAt;
    private java.time.LocalDateTime completedAt;
    private java.time.LocalDateTime confirmedAt;
    private String note;

    public Task(Integer taskId, Integer eventId, Integer coordinatorId, Integer volunteerId, String taskDescription, String status, LocalDateTime assignedAt, LocalDateTime completedAt, LocalDateTime confirmedAt, String note) {
        this.taskId = taskId;
        this.eventId = eventId;
        this.coordinatorId = coordinatorId;
        this.volunteerId = volunteerId;
        this.taskDescription = taskDescription;
        this.status = status;
        this.assignedAt = assignedAt;
        this.completedAt = completedAt;
        this.confirmedAt = confirmedAt;
        this.note = note;
    }

    public Task() {
    }

    public Integer getTaskId() {
        return taskId;
    }
    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

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

    public Integer getVolunteerId() {
        return volunteerId;
    }
    public void setVolunteerId(Integer volunteerId) {
        this.volunteerId = volunteerId;
    }

    public String getTaskDescription() {
        return taskDescription;
    }
    public void setTaskDescription(String taskDescription) {
        this.taskDescription = taskDescription;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public java.time.LocalDateTime getAssignedAt() {
        return assignedAt;
    }
    public void setAssignedAt(java.time.LocalDateTime assignedAt) {
        this.assignedAt = assignedAt;
    }

    public java.time.LocalDateTime getCompletedAt() {
        return completedAt;
    }
    public void setCompletedAt(java.time.LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public java.time.LocalDateTime getConfirmedAt() {
        return confirmedAt;
    }
    public void setConfirmedAt(java.time.LocalDateTime confirmedAt) {
        this.confirmedAt = confirmedAt;
    }

    public String getNote() {
        return note;
    }
    public void setNote(String note) {
        this.note = note;
    }
}
