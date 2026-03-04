package Entity;

public class Coordinator {

    private int userId;
    private String fullName;
    private String email;
    private String status;       // ACTIVE / BUSY
    private String assignment;   // Event name

    public Coordinator() {}

    public Coordinator(int userId, String fullName, String email, String status, String assignment) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.status = status;
        this.assignment = assignment;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAssignment() {
        return assignment;
    }

    public void setAssignment(String assignment) {
        this.assignment = assignment;
    }
}