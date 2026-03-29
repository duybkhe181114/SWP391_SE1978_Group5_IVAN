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

    // --- New fields ---
    private TaskType taskType;       // FLEXIBLE or SCHEDULED
    private LocalDateTime dueDate;   // FLEXIBLE only
    private LocalDateTime startTime; // SCHEDULED only (planned)
    private LocalDateTime endTime;   // SCHEDULED only (planned)
    private String location;         // optional
    private LocalDateTime acceptedAt; // when volunteer accepts / checks in

    public Task() {}

    // --- Getters & Setters (original) ---

    public Integer getTaskId() { return taskId; }
    public void setTaskId(Integer taskId) { this.taskId = taskId; }

    public Integer getEventId() { return eventId; }
    public void setEventId(Integer eventId) { this.eventId = eventId; }

    public Integer getCoordinatorId() { return coordinatorId; }
    public void setCoordinatorId(Integer coordinatorId) { this.coordinatorId = coordinatorId; }

    public Integer getVolunteerId() { return volunteerId; }
    public void setVolunteerId(Integer volunteerId) { this.volunteerId = volunteerId; }

    public String getTaskDescription() { return taskDescription; }
    public void setTaskDescription(String taskDescription) { this.taskDescription = taskDescription; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public java.time.LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(java.time.LocalDateTime assignedAt) { this.assignedAt = assignedAt; }

    public java.time.LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(java.time.LocalDateTime completedAt) { this.completedAt = completedAt; }

    public java.time.LocalDateTime getConfirmedAt() { return confirmedAt; }
    public void setConfirmedAt(java.time.LocalDateTime confirmedAt) { this.confirmedAt = confirmedAt; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    // --- Getters & Setters (new fields) ---

    public TaskType getTaskType() { return taskType; }
    public void setTaskType(TaskType taskType) { this.taskType = taskType; }

    public LocalDateTime getDueDate() { return dueDate; }
    public void setDueDate(LocalDateTime dueDate) { this.dueDate = dueDate; }

    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }

    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public LocalDateTime getAcceptedAt() { return acceptedAt; }
    public void setAcceptedAt(LocalDateTime acceptedAt) { this.acceptedAt = acceptedAt; }
}
