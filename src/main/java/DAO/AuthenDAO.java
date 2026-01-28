package DAO;

import Context.DBContext;
import Entity.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthenDAO extends DBContext {

    public User login(String email, String password) {

        String sql = """
            SELECT UserId, Email, IsActive, CreatedAt
            FROM Users
            WHERE Email = ? AND PasswordHash = ? AND IsActive = 1
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
}
