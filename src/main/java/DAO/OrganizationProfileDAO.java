package DAO;

import Context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class OrganizationProfileDAO extends DBContext {

    public Map<String, Object> getOrganizationProfile(int userId) {
        String sql = """
                SELECT u.UserId,
                       u.Email,
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
                       org.LogoUrl,
                       org.CreatedAt AS OrganizationCreatedAt
                FROM Users u
                LEFT JOIN UserProfiles up
                    ON up.UserId = u.UserId
                OUTER APPLY (
                    SELECT TOP 1 o.OrganizationId,
                                 o.LogoUrl,
                                 o.CreatedAt,
                                 o.Name
                    FROM Organizations o
                    WHERE o.CreatedBy = u.UserId
                    ORDER BY o.OrganizationId DESC
                ) org
                WHERE u.UserId = ?
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> profile = new HashMap<>();
                profile.put("userId", rs.getInt("UserId"));
                profile.put("email", rs.getString("Email"));
                profile.put("accountCreatedAt", rs.getTimestamp("AccountCreatedAt"));
                profile.put("organizationName", rs.getString("OrganizationName"));
                profile.put("organizationType", rs.getString("OrganizationType"));
                profile.put("establishedYear", rs.getObject("EstablishedYear"));
                profile.put("taxCode", rs.getString("TaxCode"));
                profile.put("businessLicense", rs.getString("BusinessLicenseNumber"));
                profile.put("representativeName", rs.getString("RepresentativeName"));
                profile.put("representativePosition", rs.getString("RepresentativePosition"));
                profile.put("phone", rs.getString("Phone"));
                profile.put("address", rs.getString("Address"));
                profile.put("website", rs.getString("Website"));
                profile.put("facebookPage", rs.getString("FacebookPage"));
                profile.put("description", rs.getString("Description"));
                profile.put("approvalStatus", rs.getString("ApprovalStatus"));
                profile.put("reviewNote", rs.getString("ReviewNote"));
                profile.put("reviewedAt", rs.getTimestamp("ReviewedAt"));
                profile.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                profile.put("organizationId", rs.getObject("OrganizationId"));
                profile.put("logoUrl", rs.getString("LogoUrl"));
                profile.put("organizationCreatedAt", rs.getTimestamp("OrganizationCreatedAt"));
                return profile;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateOrganizationProfile(int userId, String organizationName, String organizationType,
                                            Integer establishedYear, String taxCode, String businessLicense,
                                            String representativeName, String representativePosition,
                                            String phone, String address, String website, String facebookPage,
                                            String description) {
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
                    ApprovalStatus = 'Pending',
                    ReviewNote = NULL,
                    ReviewedBy = NULL,
                    ReviewedAt = NULL,
                    UpdatedAt = SYSDATETIME()
                WHERE UserId = ?
                """;

        String organizationSql = """
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

        try {
            connection.setAutoCommit(false);

            boolean updated;
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
                ps.setInt(14, userId);
                updated = ps.executeUpdate() > 0;
            }

            try (PreparedStatement ps = connection.prepareStatement(organizationSql)) {
                ps.setString(1, organizationName);
                ps.setString(2, description);
                ps.setString(3, phone);
                ps.setInt(4, userId);
                ps.setString(5, address);
                ps.setString(6, website);
                ps.setInt(7, userId);
                ps.executeUpdate();
            }

            connection.commit();
            return updated;
        } catch (Exception e) {
            rollbackQuietly();
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    private void rollbackQuietly() {
        try {
            connection.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
