package Entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Schedule {

    private Integer scheduleId;
    private Integer taskId;
    private java.time.LocalDate workDate;
    private java.time.LocalTime startTime;
    private java.time.LocalTime endTime;
    private String note;
    private java.time.LocalDateTime createdAt;

    public Schedule() {
    }

    public Schedule(Integer scheduleId, Integer taskId, LocalDate workDate, LocalTime startTime, LocalTime endTime, String note, LocalDateTime createdAt) {
        this.scheduleId = scheduleId;
        this.taskId = taskId;
        this.workDate = workDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.note = note;
        this.createdAt = createdAt;
    }

    public Integer getScheduleId() {
        return scheduleId;
    }
    public void setScheduleId(Integer scheduleId) {
        this.scheduleId = scheduleId;
    }

    public Integer getTaskId() {
        return taskId;
    }
    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

    public java.time.LocalDate getWorkDate() {
        return workDate;
    }
    public void setWorkDate(java.time.LocalDate workDate) {
        this.workDate = workDate;
    }

    public java.time.LocalTime getStartTime() {
        return startTime;
    }
    public void setStartTime(java.time.LocalTime startTime) {
        this.startTime = startTime;
    }

    public java.time.LocalTime getEndTime() {
        return endTime;
    }
    public void setEndTime(java.time.LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getNote() {
        return note;
    }
    public void setNote(String note) {
        this.note = note;
    }

    public java.time.LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(java.time.LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
