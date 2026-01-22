package Entity;

public class UserRole {

    private Integer userRoleId;
    private Integer userId;
    private String role;

    public Integer getUserRoleId() {
        return userRoleId;
    }

    public void setUserRoleId(Integer userRoleId) {
        this.userRoleId = userRoleId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public UserRole() {
    }

    public UserRole(Integer userRoleId, Integer userId, String role) {
        this.userRoleId = userRoleId;
        this.userId = userId;
        this.role = role;
    }
}
