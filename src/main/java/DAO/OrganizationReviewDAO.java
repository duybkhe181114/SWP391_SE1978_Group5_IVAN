package DAO;

import Context.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrganizationReviewDAO extends DBContext {

    public List<Map<String, Object>> getOrganizations(String keyword, String status) {
        List<Map<String, Object>> organizations = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT u.UserId,
                       u.Email,
                       u.IsActive,
                       u.CreatedAt AS AccountCreatedAt,
                       up.OrganizationName,
                       up.OrganizationType,
                       up.EstablishedYear,
                       up.TaxCode,
                       up.BusinessLicenseNumber,
                       up.RepresentativeName,
                       up.RepresentativePosition,
                       up.Phone,
                       up.Address,
                       up.Website,
                       up.FacebookPage,
                       up.Description,
                       up.ApprovalStatus,
                       up.ReviewNote,
                       up.ReviewedAt,
                       up.UpdatedAt,
                       org.OrganizationId,
                       org.Name AS LinkedOrganizationName,
                       org.LogoUrl,
                       org.CreatedAt AS OrganizationCreatedAt,
                       (
                           SELECT COUNT(*)
                           FROM OrganizationProfileUpdateRequests req
                           WHERE req.UserId = u.UserId
                             AND req.Status = 'Pending'
                       ) AS PendingUpdateRequestCount
                FROM Users u
                JOIN UserRoles ur
                    ON ur.UserId = u.UserId
                LEFT JOIN UserProfiles up
                    ON up.UserId = u.UserId
                OUTER APPLY (
                    SELECT TOP 1 o.OrganizationId,
                                 o.Name,
                                 o.LogoUrl,
                                 o.CreatedAt
                    FROM Organizations o
                    WHERE o.CreatedBy = u.UserId
                    ORDER BY o.OrganizationId DESC
                ) org
                WHERE ur.Role = 'Organization'
                """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append("""
                     AND (
                        u.Email LIKE ?
                        OR up.OrganizationName LIKE ?
                        OR up.RepresentativeName LIKE ?
                        OR up.Phone LIKE ?
                     )
                    """);
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }

        appendStatusFilter(sql, status);
        sql.append(" ORDER BY u.CreatedAt DESC ");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    organizations.add(mapOrganization(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return organizations;
    }

    public List<Map<String, Object>> getPendingOrganizations() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT u.UserId,
                       u.Email,
                       u.CreatedAt,
                       up.OrganizationName,
                       up.OrganizationType,
                       up.EstablishedYear,
                       up.TaxCode,
                       up.BusinessLicenseNumber,
                       up.RepresentativeName,
                       up.RepresentativePosition,
                       up.Phone,
                       up.Address,
                       up.Website,
                       up.FacebookPage,
                       up.Description,
                       up.ApprovalStatus,
                       org.OrganizationId,
                       org.Name AS LinkedOrganizationName
                FROM Users u
                JOIN UserRoles ur
                    ON ur.UserId = u.UserId
                JOIN UserProfiles up
                    ON up.UserId = u.UserId
                OUTER APPLY (
                    SELECT TOP 1 o.OrganizationId,
                                 o.Name
                    FROM Organizations o
                    WHERE o.CreatedBy = u.UserId
                    ORDER BY o.OrganizationId DESC
                ) org
                WHERE ur.Role = 'Organization'
                  AND up.ApprovalStatus = 'Pending'
                ORDER BY u.CreatedAt DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", rs.getInt("UserId"));
                map.put("email", rs.getString("Email"));
                map.put("createdAt", rs.getTimestamp("CreatedAt"));
                map.put("organizationName", rs.getString("OrganizationName"));
                map.put("organizationType", rs.getString("OrganizationType"));
                map.put("establishedYear", rs.getObject("EstablishedYear"));
                map.put("taxCode", rs.getString("TaxCode"));
                map.put("businessLicense", rs.getString("BusinessLicenseNumber"));
                map.put("representativeName", rs.getString("RepresentativeName"));
                map.put("representativePosition", rs.getString("RepresentativePosition"));
                map.put("phone", rs.getString("Phone"));
                map.put("address", rs.getString("Address"));
                map.put("website", rs.getString("Website"));
                map.put("facebookPage", rs.getString("FacebookPage"));
                map.put("description", rs.getString("Description"));
                map.put("approvalStatus", rs.getString("ApprovalStatus"));
                map.put("organizationId", rs.getObject("OrganizationId"));
                map.put("linkedOrganizationName", rs.getString("LinkedOrganizationName"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean approveOrganization(int userId, int adminId, String reviewNote) {
        String sqlProfile = """
                UPDATE UserProfiles
                SET ApprovalStatus = 'Approved',
                    ReviewedBy = ?,
                    ReviewedAt = GETDATE(),
                    ReviewNote = ?
                WHERE UserId = ?
                """;
        String sqlUser = "UPDATE Users SET IsActive = 1 WHERE UserId = ?";
        String updateOrganizationSql = """
                UPDATE o
                SET o.Name = up.OrganizationName,
                    o.Description = up.Description,
                    o.Phone = up.Phone,
                    o.Email = u.Email,
                    o.Address = up.Address,
                    o.Website = up.Website,
                    o.UpdatedAt = GETDATE()
                FROM Organizations o
                JOIN Users u
                    ON u.UserId = o.CreatedBy
                JOIN UserProfiles up
                    ON up.UserId = u.UserId
                WHERE u.UserId = ?
                """;
        String insertOrganizationSql = """
                INSERT INTO Organizations (
                    Name,
                    Description,
                    Phone,
                    Email,
                    Address,
                    Website,
                    CreatedBy,
                    CreatedAt,
                    UpdatedAt
                )
                SELECT up.OrganizationName,
                       up.Description,
                       up.Phone,
                       u.Email,
                       up.Address,
                       up.Website,
                       u.UserId,
                       GETDATE(),
                       GETDATE()
                FROM Users u
                JOIN UserProfiles up
                    ON up.UserId = u.UserId
                WHERE u.UserId = ?
                  AND NOT EXISTS (
                    SELECT 1
                    FROM Organizations o
                    WHERE o.CreatedBy = u.UserId
                  )
                """;

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps1 = connection.prepareStatement(sqlProfile)) {
                ps1.setInt(1, adminId);
                ps1.setString(2, reviewNote);
                ps1.setInt(3, userId);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = connection.prepareStatement(sqlUser)) {
                ps2.setInt(1, userId);
                ps2.executeUpdate();
            }

            try (PreparedStatement ps3 = connection.prepareStatement(updateOrganizationSql)) {
                ps3.setInt(1, userId);
                ps3.executeUpdate();
            }

            try (PreparedStatement ps4 = connection.prepareStatement(insertOrganizationSql)) {
                ps4.setInt(1, userId);
                ps4.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            rollbackQuietly();
            e.printStackTrace();
        } finally {
            resetAutoCommit();
        }

        return false;
    }

    public boolean rejectOrganization(int userId, int adminId, String reviewNote) {
        String sql = """
                UPDATE UserProfiles
                SET ApprovalStatus = 'Rejected',
                    ReviewedBy = ?,
                    ReviewedAt = GETDATE(),
                    ReviewNote = ?
                WHERE UserId = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, reviewNote);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateOrganizationProfileByAdmin(int userId,
                                                    String organizationName,
                                                    String organizationType,
                                                    Integer establishedYear,
                                                    String taxCode,
                                                    String businessLicense,
                                                    String representativeName,
                                                    String representativePosition,
                                                    String phone,
                                                    String address,
                                                    String website,
                                                    String facebookPage,
                                                    String description,
                                                    String adminNote,
                                                    int adminId) {
        String profileSql = """
                UPDATE UserProfiles
                SET OrganizationName = ?,
                    OrganizationType = ?,
                    EstablishedYear = ?,
                    TaxCode = ?,
                    BusinessLicenseNumber = ?,
                    RepresentativeName = ?,
                    RepresentativePosition = ?,
                    Phone = ?,
                    Address = ?,
                    Website = ?,
                    FacebookPage = ?,
                    Description = ?,
                    FirstName = ?,
                    LastName = '',
                    ApprovalStatus = 'Approved',
                    ReviewedBy = ?,
                    ReviewedAt = GETDATE(),
                    ReviewNote = ?,
                    UpdatedAt = SYSDATETIME()
                WHERE UserId = ?
                """;

        String updateOrganizationSql = """
                UPDATE Organizations
                SET Name = ?,
                    Description = ?,
                    Phone = ?,
                    Email = (SELECT Email FROM Users WHERE UserId = ?),
                    Address = ?,
                    Website = ?,
                    UpdatedAt = GETDATE()
                WHERE CreatedBy = ?
                """;

        String insertOrganizationSql = """
                INSERT INTO Organizations (
                    Name,
                    Description,
                    Phone,
                    Email,
                    Address,
                    Website,
                    CreatedBy,
                    CreatedAt,
                    UpdatedAt
                )
                SELECT ?, ?, ?, (SELECT Email FROM Users WHERE UserId = ?), ?, ?, ?, GETDATE(), GETDATE()
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM Organizations
                    WHERE CreatedBy = ?
                )
                """;

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(profileSql)) {
                ps.setString(1, organizationName);
                ps.setString(2, organizationType);
                if (establishedYear != null) {
                    ps.setInt(3, establishedYear);
                } else {
                    ps.setNull(3, java.sql.Types.INTEGER);
                }
                ps.setString(4, taxCode);
                ps.setString(5, businessLicense);
                ps.setString(6, representativeName);
                ps.setString(7, representativePosition);
                ps.setString(8, phone);
                ps.setString(9, address);
                ps.setString(10, website);
                ps.setString(11, facebookPage);
                ps.setString(12, description);
                ps.setString(13, representativeName);
                ps.setInt(14, adminId);
                ps.setString(15, adminNote);
                ps.setInt(16, userId);
                if (ps.executeUpdate() <= 0) {
                    connection.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(updateOrganizationSql)) {
                ps.setString(1, organizationName);
                ps.setString(2, description);
                ps.setString(3, phone);
                ps.setInt(4, userId);
                ps.setString(5, address);
                ps.setString(6, website);
                ps.setInt(7, userId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(insertOrganizationSql)) {
                ps.setString(1, organizationName);
                ps.setString(2, description);
                ps.setString(3, phone);
                ps.setInt(4, userId);
                ps.setString(5, address);
                ps.setString(6, website);
                ps.setInt(7, userId);
                ps.setInt(8, userId);
                ps.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            rollbackQuietly();
            e.printStackTrace();
        } finally {
            resetAutoCommit();
        }

        return false;
    }

    private Map<String, Object> mapOrganization(ResultSet rs) throws SQLException {
        Map<String, Object> org = new HashMap<>();
        org.put("userId", rs.getInt("UserId"));
        org.put("email", rs.getString("Email"));
        org.put("isActive", rs.getBoolean("IsActive"));
        org.put("accountCreatedAt", rs.getTimestamp("AccountCreatedAt"));
        org.put("organizationName", rs.getString("OrganizationName"));
        org.put("organizationType", rs.getString("OrganizationType"));
        org.put("establishedYear", rs.getObject("EstablishedYear"));
        org.put("taxCode", rs.getString("TaxCode"));
        org.put("businessLicense", rs.getString("BusinessLicenseNumber"));
        org.put("representativeName", rs.getString("RepresentativeName"));
        org.put("representativePosition", rs.getString("RepresentativePosition"));
        org.put("phone", rs.getString("Phone"));
        org.put("address", rs.getString("Address"));
        org.put("website", rs.getString("Website"));
        org.put("facebookPage", rs.getString("FacebookPage"));
        org.put("description", rs.getString("Description"));
        org.put("approvalStatus", rs.getString("ApprovalStatus"));
        org.put("reviewNote", rs.getString("ReviewNote"));
        org.put("reviewedAt", rs.getTimestamp("ReviewedAt"));
        org.put("updatedAt", rs.getTimestamp("UpdatedAt"));
        org.put("organizationId", rs.getObject("OrganizationId"));
        org.put("linkedOrganizationName", rs.getString("LinkedOrganizationName"));
        org.put("logoUrl", rs.getString("LogoUrl"));
        org.put("organizationCreatedAt", rs.getTimestamp("OrganizationCreatedAt"));
        org.put("pendingUpdateRequestCount", rs.getInt("PendingUpdateRequestCount"));
        return org;
    }

    private void appendStatusFilter(StringBuilder sql, String status) {
        if (status == null || status.isBlank()) {
            return;
        }

        if ("approved".equalsIgnoreCase(status)) {
            sql.append(" AND up.ApprovalStatus = 'Approved' AND u.IsActive = 1 ");
            return;
        }

        if ("pending".equalsIgnoreCase(status)) {
            sql.append(" AND up.ApprovalStatus = 'Pending' ");
            return;
        }

        if ("rejected".equalsIgnoreCase(status)) {
            sql.append(" AND up.ApprovalStatus = 'Rejected' ");
            return;
        }

        if ("blocked".equalsIgnoreCase(status)) {
            sql.append(" AND up.ApprovalStatus = 'Approved' AND u.IsActive = 0 ");
            return;
        }

        if ("pending_update".equalsIgnoreCase(status)) {
            sql.append("""
                     AND EXISTS (
                        SELECT 1
                        FROM OrganizationProfileUpdateRequests req
                        WHERE req.UserId = u.UserId
                          AND req.Status = 'Pending'
                     )
                    """);
        }
    }

    private void rollbackQuietly() {
        try {
            connection.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void resetAutoCommit() {
        try {
            connection.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
