package DAO;

import Context.DBContext;
import Entity.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthenDAO extends DBContext {

    public User login(String email, String password) {

        String sql = """
            SELECT u.UserId, u.Email, u.IsActive, u.CreatedAt, ur.Role
            FROM Users u
            LEFT JOIN UserRoles ur ON u.UserId = ur.UserId
            WHERE u.Email = ? AND u.PasswordHash = ? AND u.IsActive = 1
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("UserId"));
                u.setEmail(rs.getString("Email"));
                u.setIsActive(rs.getBoolean("IsActive"));
                u.setCreatedAt(
                        rs.getTimestamp("CreatedAt").toLocalDateTime()
                );
                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
    public String getUserRole(int userId) {
        String sql = "SELECT Role FROM UserRoles WHERE UserId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("Role");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
