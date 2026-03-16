package DAO;

import Context.DBContext;
import DTO.UserView;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                up.FirstName,
                up.LastName,
                up.FullName,
                up.Phone,
                up.Province,
                up.Address,
                up.ApprovalStatus,
                (SELECT STRING_AGG(CAST(SkillId AS VARCHAR), ',')
                 FROM VolunteerSkills
                 WHERE VolunteerId = u.UserId) AS SkillIds
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

    public boolean setUserStatus(int userId, boolean active) {
        String sql = "UPDATE Users SET IsActive = ? WHERE UserId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<UserView> filterUsers(String q, String role, String status,
                                      String fromDate, String toDate,
                                      int page, int pageSize) {

        List<UserView> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT
                u.UserId,
                u.Email,
                u.IsActive,
                u.CreatedAt,
                ur.Role,
                up.FirstName,
                up.LastName,
                up.FullName,
                up.Phone,
                up.Province,
                up.Address,
                up.ApprovalStatus,
                (SELECT STRING_AGG(CAST(SkillId AS VARCHAR), ',')
                 FROM VolunteerSkills
                 WHERE VolunteerId = u.UserId) AS SkillIds
            FROM Users u
            JOIN UserRoles ur ON u.UserId = ur.UserId
            LEFT JOIN UserProfiles up ON u.UserId = up.UserId
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (q != null && !q.isBlank()) {
            sql.append(" AND (u.Email LIKE ? OR up.FullName LIKE ? OR up.Phone LIKE ?) ");
            String keyword = "%" + q + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        if (role != null && !role.isBlank()) {
            sql.append(" AND ur.Role = ? ");
            params.add(role);
        }

        appendStatusFilter(sql, params, status);

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
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUserView(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countUsers(String q, String role, String status, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM Users u
            JOIN UserRoles ur ON u.UserId = ur.UserId
            LEFT JOIN UserProfiles up ON u.UserId = up.UserId
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (q != null && !q.isBlank()) {
            sql.append(" AND (u.Email LIKE ? OR up.FullName LIKE ? OR up.Phone LIKE ?) ");
            String keyword = "%" + q + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        if (role != null && !role.isBlank()) {
            sql.append(" AND ur.Role = ? ");
            params.add(role);
        }

        appendStatusFilter(sql, params, status);

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
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public UserView getUserById(int userId) {
        String sql = """
            SELECT
                u.UserId,
                u.Email,
                u.IsActive,
                u.CreatedAt,
                ur.Role,
                up.FirstName,
                up.LastName,
                up.FullName,
                up.Phone,
                up.Province,
                up.Address,
                up.ApprovalStatus,
                (SELECT STRING_AGG(CAST(SkillId AS VARCHAR), ',')
                 FROM VolunteerSkills
                 WHERE VolunteerId = u.UserId) AS SkillIds
            FROM Users u
            JOIN UserRoles ur ON u.UserId = ur.UserId
            LEFT JOIN UserProfiles up ON u.UserId = up.UserId
            WHERE u.UserId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUserView(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public int countActiveAdmins() {
        String sql = """
            SELECT COUNT(*)
            FROM Users u
            JOIN UserRoles ur ON u.UserId = ur.UserId
            WHERE ur.Role = 'Admin' AND u.IsActive = 1
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void updateUser(int userId, String firstName, String lastName, String phone,
                           String province, String address, String role, String[] skills) {

        String sqlProfile = "UPDATE UserProfiles SET FirstName=?, LastName=?, Phone=?, Province=?, Address=? WHERE UserId=?";
        String sqlRole = "UPDATE UserRoles SET Role=? WHERE UserId=?";
        String sqlDeleteSkills = "DELETE FROM VolunteerSkills WHERE VolunteerId=?";
        String sqlInsertSkill = "INSERT INTO VolunteerSkills (VolunteerId, SkillId) VALUES (?, ?)";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps1 = connection.prepareStatement(sqlProfile)) {
                ps1.setString(1, firstName);
                ps1.setString(2, lastName);
                ps1.setString(3, phone);
                ps1.setString(4, province);
                ps1.setString(5, address);
                ps1.setInt(6, userId);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = connection.prepareStatement(sqlRole)) {
                ps2.setString(1, role);
                ps2.setInt(2, userId);
                ps2.executeUpdate();
            }

            try (PreparedStatement ps3 = connection.prepareStatement(sqlDeleteSkills)) {
                ps3.setInt(1, userId);
                ps3.executeUpdate();
            }

            if (skills != null && skills.length > 0) {
                try (PreparedStatement ps4 = connection.prepareStatement(sqlInsertSkill)) {
                    for (String skillId : skills) {
                        ps4.setInt(1, userId);
                        ps4.setInt(2, Integer.parseInt(skillId));
                        ps4.addBatch();
                    }
                    ps4.executeBatch();
                }
            }

            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    private UserView mapResultSetToUserView(ResultSet rs) throws SQLException {
        UserView user = new UserView();
        user.setUserId(rs.getInt("UserId"));
        user.setEmail(rs.getString("Email"));
        user.setActive(rs.getBoolean("IsActive"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        user.setRole(rs.getString("Role"));
        user.setFullName(rs.getString("FullName"));
        user.setFirstName(rs.getString("FirstName"));
        user.setLastName(rs.getString("LastName"));
        user.setPhone(rs.getString("Phone"));
        user.setProvince(rs.getString("Province"));
        user.setAddress(rs.getString("Address"));
        user.setSkillIds(rs.getString("SkillIds"));
        user.setApprovalStatus(rs.getString("ApprovalStatus"));
        return user;
    }

    private void appendStatusFilter(StringBuilder sql, List<Object> params, String status) {
        if (status == null || status.isBlank()) {
            return;
        }

        if ("active".equalsIgnoreCase(status)) {
            sql.append(" AND u.IsActive = 1 ");
            return;
        }

        if ("blocked".equalsIgnoreCase(status) || "inactive".equalsIgnoreCase(status)) {
            sql.append("""
                 AND u.IsActive = 0
                 AND (
                    ur.Role <> 'Organization'
                    OR up.ApprovalStatus IS NULL
                    OR up.ApprovalStatus = 'Approved'
                 )
                """);
            return;
        }

        if ("review".equalsIgnoreCase(status)) {
            sql.append("""
                 AND ur.Role = 'Organization'
                 AND up.ApprovalStatus IN ('Pending', 'Rejected')
                """);
        }
    }
}
