package DAO;

import Context.DBContext;
import DTO.UserView;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminUserDAO extends DBContext {

    public List<UserView> getAllUsers() {
        List<UserView> list = new ArrayList<>();

        // Dùng Subquery và STRING_AGG để lấy danh sách SkillId của user đó (ngăn cách bởi dấu phẩy)
        String sql = """
            SELECT
                u.UserId, u.Email, u.IsActive, u.CreatedAt,
                ur.Role, up.FirstName, up.LastName, up.FullName, up.Phone, up.Province, up.Address,
                (SELECT STRING_AGG(CAST(SkillId AS VARCHAR), ',') 
                 FROM VolunteerSkills WHERE VolunteerId = u.UserId) AS SkillIds
            FROM Users u
            JOIN UserRoles ur ON u.UserId = ur.UserId
            LEFT JOIN UserProfiles up ON u.UserId = up.UserId
            ORDER BY u.CreatedAt DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToUserView(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void toggleUserStatus(int userId) {
        String sql = """
            UPDATE Users
            SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END
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
                ur.Role, up.FirstName, up.LastName, up.FullName, up.Phone, up.Province, up.Address,
                (SELECT STRING_AGG(CAST(SkillId AS VARCHAR), ',') 
                 FROM VolunteerSkills WHERE VolunteerId = u.UserId) AS SkillIds
            FROM Users u
            JOIN UserRoles ur ON u.UserId = ur.UserId
            LEFT JOIN UserProfiles up ON u.UserId = up.UserId
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (q != null && !q.isBlank()) {
            sql.append(" AND (u.Email LIKE ? OR up.FullName LIKE ? OR up.Phone LIKE ?) ");
            String keyword = "%" + q + "%";
            params.add(keyword); params.add(keyword); params.add(keyword);
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

        sql.append(" ORDER BY u.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        int offset = (page - 1) * pageSize;
        params.add(offset);
        params.add(pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToUserView(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countUsers(String q, String role, String status, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) FROM Users u
            JOIN UserRoles ur ON u.UserId = ur.UserId
            LEFT JOIN UserProfiles up ON u.UserId = up.UserId
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (q != null && !q.isBlank()) {
            sql.append(" AND (u.Email LIKE ? OR up.FullName LIKE ? OR up.Phone LIKE ?) ");
            String keyword = "%" + q + "%";
            params.add(keyword); params.add(keyword); params.add(keyword);
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

    // Đã nâng cấp hàm updateUser nhận 8 tham số
    public void updateUser(int userId, String firstName, String lastName, String phone,
                           String province, String address, String role, String[] skills) {

        String sqlProfile = "UPDATE UserProfiles SET FirstName=?, LastName=?, Phone=?, Province=?, Address=? WHERE UserId=?";
        String sqlRole = "UPDATE UserRoles SET Role=? WHERE UserId=?";
        String sqlDeleteSkills = "DELETE FROM VolunteerSkills WHERE VolunteerId=?";
        String sqlInsertSkill = "INSERT INTO VolunteerSkills (VolunteerId, SkillId) VALUES (?, ?)";

        try {
            // Tắt auto-commit để chạy Transaction (đảm bảo cập nhật 3 bảng cùng lúc không bị lỗi giữa chừng)
            connection.setAutoCommit(false);

            // 1. Cập nhật UserProfiles
            try (PreparedStatement ps1 = connection.prepareStatement(sqlProfile)) {
                ps1.setString(1, firstName);
                ps1.setString(2, lastName);
                ps1.setString(3, phone);
                ps1.setString(4, province);
                ps1.setString(5, address);
                ps1.setInt(6, userId);
                ps1.executeUpdate();
            }

            // 2. Cập nhật UserRoles
            try (PreparedStatement ps2 = connection.prepareStatement(sqlRole)) {
                ps2.setString(1, role);
                ps2.setInt(2, userId);
                ps2.executeUpdate();
            }

            // 3. Xóa toàn bộ Skill cũ của User
            try (PreparedStatement ps3 = connection.prepareStatement(sqlDeleteSkills)) {
                ps3.setInt(1, userId);
                ps3.executeUpdate();
            }

            // 4. Thêm Skill mới vào (nếu admin có check)
            if (skills != null && skills.length > 0) {
                try (PreparedStatement ps4 = connection.prepareStatement(sqlInsertSkill)) {
                    for (String skillId : skills) {
                        ps4.setInt(1, userId);
                        ps4.setInt(2, Integer.parseInt(skillId));
                        ps4.addBatch(); // Gom lệnh lại chạy 1 lần cho nhanh
                    }
                    ps4.executeBatch();
                }
            }

            // Lưu tất cả thay đổi
            connection.commit();

        } catch (SQLException e) {
            try {
                connection.rollback(); // Nếu có lỗi thì hoàn tác tất cả
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true); // Trả lại trạng thái mặc định cho Connection
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    // Hàm phụ trợ dùng chung để mapping ResultSet ra DTO
    private UserView mapResultSetToUserView(ResultSet rs) throws SQLException {
        UserView u = new UserView();
        u.setUserId(rs.getInt("UserId"));
        u.setEmail(rs.getString("Email"));
        u.setActive(rs.getBoolean("IsActive"));
        u.setCreatedAt(rs.getTimestamp("CreatedAt"));
        u.setRole(rs.getString("Role"));
        u.setFullName(rs.getString("FullName"));
        u.setFirstName(rs.getString("FirstName"));
        u.setLastName(rs.getString("LastName"));
        u.setPhone(rs.getString("Phone"));
        u.setProvince(rs.getString("Province"));
        u.setAddress(rs.getString("Address"));
        u.setSkillIds(rs.getString("SkillIds")); // Chuỗi skill "1,2,5"
        return u;
    }
}