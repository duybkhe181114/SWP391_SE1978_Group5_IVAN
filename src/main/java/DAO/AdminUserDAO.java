package DAO;

import Context.DBContext;
import DTO.UserView;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AdminUserDAO extends DBContext {

    public List<UserView> getAllUsers() {
        List<UserView> list = new ArrayList<>();

        String sql = """
        SELECT
            u.UserId,
            u.Email,
            u.IsActive,
            u.CreatedAt,
            ur.Role,
            up.FullName,
            up.Phone,
            up.Province
        FROM Users u
        JOIN UserRoles ur ON u.UserId = ur.UserId
        LEFT JOIN UserProfiles up ON u.UserId = up.UserId
        ORDER BY u.CreatedAt DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                UserView u = new UserView();
                u.setUserId(rs.getInt("UserId"));
                u.setEmail(rs.getString("Email"));
                u.setActive(rs.getBoolean("IsActive"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                u.setRole(rs.getString("Role"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setProvince(rs.getString("Province"));

                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void toggleUserStatus(int userId) {
        String sql = """
        UPDATE Users
        SET IsActive = CASE 
            WHEN IsActive = 1 THEN 0
            ELSE 1
        END
        WHERE UserId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<UserView> filterUsers(String q, String role, String status,
                                      String fromDate, String toDate,
                                      int page, int pageSize) {

        List<UserView> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                    SELECT
                        u.UserId, u.Email, u.IsActive, u.CreatedAt,
                        ur.Role, up.FullName, up.Phone, up.Province
                    FROM Users u
                    JOIN UserRoles ur ON u.UserId = ur.UserId
                    LEFT JOIN UserProfiles up ON u.UserId = up.UserId
                    WHERE 1=1
                """);

        List<Object> params = new ArrayList<>();

        if (q != null && !q.isBlank()) {
            sql.append("""
                        AND (
                            u.Email LIKE ?
                            OR up.FullName LIKE ?
                            OR up.Phone LIKE ?
                        )
                    """);
            String keyword = "%" + q + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        if (role != null && !role.isBlank()) {
            sql.append(" AND ur.Role = ? ");
            params.add(role);
        }

        if (status != null && !status.isBlank()) {
            sql.append(" AND u.IsActive = ? ");
            params.add("active".equals(status));
        }

        if (fromDate != null && !fromDate.isBlank()) {
            sql.append(" AND u.CreatedAt >= ? ");
            params.add(fromDate);
        }

        if (toDate != null && !toDate.isBlank()) {
            sql.append(" AND u.CreatedAt <= ? ");
            params.add(toDate);
        }

        sql.append("""
                    ORDER BY u.CreatedAt DESC
                    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """);

        int offset = (page - 1) * pageSize;
        params.add(offset);
        params.add(pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserView u = new UserView();
                u.setUserId(rs.getInt("UserId"));
                u.setEmail(rs.getString("Email"));
                u.setActive(rs.getBoolean("IsActive"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                u.setRole(rs.getString("Role"));
                u.setFullName(rs.getString("FullName"));
                u.setPhone(rs.getString("Phone"));
                u.setProvince(rs.getString("Province"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countUsers(String q, String role, String status,
                          String fromDate, String toDate) {

        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM Users u
        JOIN UserRoles ur ON u.UserId = ur.UserId
        LEFT JOIN UserProfiles up ON u.UserId = up.UserId
        WHERE 1=1
    """);

        List<Object> params = new ArrayList<>();

        if (q != null && !q.isBlank()) {
            sql.append("""
            AND (
                u.Email LIKE ?
                OR up.FullName LIKE ?
                OR up.Phone LIKE ?
            )
        """);
            String keyword = "%" + q + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        if (role != null && !role.isBlank()) {
            sql.append(" AND ur.Role = ? ");
            params.add(role);
        }

        if (status != null && !status.isBlank()) {
            sql.append(" AND u.IsActive = ? ");
            params.add("active".equals(status));
        }

        if (fromDate != null && !fromDate.isBlank()) {
            sql.append(" AND u.CreatedAt >= ? ");
            params.add(fromDate);
        }

        if (toDate != null && !toDate.isBlank()) {
            sql.append(" AND u.CreatedAt <= ? ");
            params.add(toDate);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void updateUser(int userId,
                           String fullName,
                           String phone,
                           String province,
                           String role) {

        String firstName = null;
        String lastName = null;

        if (fullName != null && !fullName.trim().isEmpty()) {
            String[] parts = fullName.trim().split("\\s+");
            lastName = parts[parts.length - 1];
            firstName = String.join(" ",
                    java.util.Arrays.copyOf(parts, parts.length - 1));
        }

        String sqlProfile = """
        UPDATE UserProfiles
        SET FirstName = ?, LastName = ?, Phone = ?, Province = ?
        WHERE UserId = ?
    """;

        String sqlRole = """
        UPDATE UserRoles
        SET Role = ?
        WHERE UserId = ?
    """;

        try {
            // Update profile
            PreparedStatement ps1 = connection.prepareStatement(sqlProfile);
            ps1.setString(1, firstName);
            ps1.setString(2, lastName);
            ps1.setString(3, phone);
            ps1.setString(4, province);
            ps1.setInt(5, userId);
            ps1.executeUpdate();

            // Update role
            PreparedStatement ps2 = connection.prepareStatement(sqlRole);
            ps2.setString(1, role);
            ps2.setInt(2, userId);
            ps2.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
