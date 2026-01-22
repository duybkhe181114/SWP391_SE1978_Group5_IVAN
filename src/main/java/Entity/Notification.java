package Entity;

import java.time.LocalDateTime;

public class Notification {

    private Integer notificationId;
    private Integer userId;
    private String content;
    private String type;
    private Integer referenceId;
    private Boolean isRead;
    private java.time.LocalDateTime createdAt;

    public Notification() {
    }

    public Notification(Integer notificationId, Integer userId, String content, String type, Integer referenceId, Boolean isRead, LocalDateTime createdAt) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.content = content;
        this.type = type;
        this.referenceId = referenceId;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    public Integer getNotificationId() {
        return notificationId;
    }
    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public Integer getUserId() {
        return userId;
    }
    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }

    public Integer getReferenceId() {
        return referenceId;
    }
    public void setReferenceId(Integer referenceId) {
        this.referenceId = referenceId;
    }

    public Boolean getIsRead() {
        return isRead;
    }
    public void setIsRead(Boolean isRead) {
        this.isRead = isRead;
    }

    public java.time.LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(java.time.LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
