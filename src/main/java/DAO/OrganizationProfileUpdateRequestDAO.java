package DAO;

import Context.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrganizationProfileUpdateRequestDAO extends DBContext {

    public boolean hasPendingRequest(int userId) {
        String sql = """
                SELECT COUNT(*)
                FROM OrganizationProfileUpdateRequests
                WHERE UserId = ? AND Status = 'Pending'
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Map<String, Object> getLatestRequest(int userId) {
        String sql = """
                SELECT TOP 1 RequestId,
                             Status,
                             OrganizationName,
                             OrganizationType,
                             EstablishedYear,
                             TaxCode,
                             BusinessLicenseNumber,
                             RepresentativeName,
                             RepresentativePosition,
                             Phone,
                             Address,
                             Website,
                             FacebookPage,
                             Description,
                             RequestedAt,
                             ReviewedAt,
                             ReviewNote
                FROM OrganizationProfileUpdateRequests
                WHERE UserId = ?
                ORDER BY RequestedAt DESC, RequestId DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> request = new HashMap<>();
                request.put("requestId", rs.getInt("RequestId"));
                request.put("status", rs.getString("Status"));
                request.put("organizationName", rs.getString("OrganizationName"));
                request.put("organizationType", rs.getString("OrganizationType"));
                request.put("establishedYear", rs.getObject("EstablishedYear"));
                request.put("taxCode", rs.getString("TaxCode"));
                request.put("businessLicense", rs.getString("BusinessLicenseNumber"));
                request.put("representativeName", rs.getString("RepresentativeName"));
                request.put("representativePosition", rs.getString("RepresentativePosition"));
                request.put("phone", rs.getString("Phone"));
                request.put("address", rs.getString("Address"));
                request.put("website", rs.getString("Website"));
                request.put("facebookPage", rs.getString("FacebookPage"));
                request.put("description", rs.getString("Description"));
                request.put("requestedAt", rs.getTimestamp("RequestedAt"));
                request.put("reviewedAt", rs.getTimestamp("ReviewedAt"));
                request.put("reviewNote", rs.getString("ReviewNote"));
                return request;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean createRequest(int userId, String organizationName, String organizationType,
                                 Integer establishedYear, String taxCode, String businessLicense,
                                 String representativeName, String representativePosition,
                                 String phone, String address, String website, String facebookPage,
                                 String description) {
        String sql = """
                INSERT INTO OrganizationProfileUpdateRequests (
                    UserId,
                    OrganizationName,
                    OrganizationType,
                    EstablishedYear,
                    TaxCode,
                    BusinessLicenseNumber,
                    RepresentativeName,
                    RepresentativePosition,
                    Phone,
                    Address,
                    Website,
                    FacebookPage,
                    Description,
                    Status,
                    RequestedAt
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending', GETDATE())
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, organizationName);
            ps.setString(3, organizationType);
            if (establishedYear != null) {
                ps.setInt(4, establishedYear);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setString(5, taxCode);
            ps.setString(6, businessLicense);
            ps.setString(7, representativeName);
            ps.setString(8, representativePosition);
            ps.setString(9, phone);
            ps.setString(10, address);
            ps.setString(11, website);
            ps.setString(12, facebookPage);
            ps.setString(13, description);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Map<String, Object>> getPendingRequests() {
        List<Map<String, Object>> requests = new ArrayList<>();
        String sql = """
                SELECT r.RequestId,
                       r.UserId,
                       u.Email,
                       r.OrganizationName,
                       r.OrganizationType,
                       r.EstablishedYear,
                       r.TaxCode,
                       r.BusinessLicenseNumber,
                       r.RepresentativeName,
                       r.RepresentativePosition,
                       r.Phone,
                       r.Address,
                       r.Website,
                       r.FacebookPage,
                       r.Description,
                       r.RequestedAt
                FROM OrganizationProfileUpdateRequests r
                JOIN Users u
                    ON u.UserId = r.UserId
                WHERE r.Status = 'Pending'
                ORDER BY r.RequestedAt DESC, r.RequestId DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> request = new HashMap<>();
                request.put("requestId", rs.getInt("RequestId"));
                request.put("userId", rs.getInt("UserId"));
                request.put("email", rs.getString("Email"));
                request.put("organizationName", rs.getString("OrganizationName"));
                request.put("organizationType", rs.getString("OrganizationType"));
                request.put("establishedYear", rs.getObject("EstablishedYear"));
                request.put("taxCode", rs.getString("TaxCode"));
                request.put("businessLicense", rs.getString("BusinessLicenseNumber"));
                request.put("representativeName", rs.getString("RepresentativeName"));
                request.put("representativePosition", rs.getString("RepresentativePosition"));
                request.put("phone", rs.getString("Phone"));
                request.put("address", rs.getString("Address"));
                request.put("website", rs.getString("Website"));
                request.put("facebookPage", rs.getString("FacebookPage"));
                request.put("description", rs.getString("Description"));
                request.put("requestedAt", rs.getTimestamp("RequestedAt"));
                requests.add(request);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return requests;
    }

    public boolean approveRequest(int requestId, int adminId, String reviewNote) {
        String requestSql = """
                SELECT UserId,
                       OrganizationName,
                       OrganizationType,
                       EstablishedYear,
                       TaxCode,
                       BusinessLicenseNumber,
                       RepresentativeName,
                       RepresentativePosition,
                       Phone,
                       Address,
                       Website,
                       FacebookPage,
                       Description
                FROM OrganizationProfileUpdateRequests
                WHERE RequestId = ? AND Status = 'Pending'
                """;

        String updateProfileSql = """
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

        String updateRequestSql = """
                UPDATE OrganizationProfileUpdateRequests
                SET Status = 'Approved',
                    ReviewedBy = ?,
                    ReviewedAt = GETDATE(),
                    ReviewNote = ?
                WHERE RequestId = ?
                """;

        try {
            connection.setAutoCommit(false);

            int userId;
            String organizationName;
            String organizationType;
            Integer establishedYear;
            String taxCode;
            String businessLicense;
            String representativeName;
            String representativePosition;
            String phone;
            String address;
            String website;
            String facebookPage;
            String description;

            try (PreparedStatement ps = connection.prepareStatement(requestSql)) {
                ps.setInt(1, requestId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }

                    userId = rs.getInt("UserId");
                    organizationName = rs.getString("OrganizationName");
                    organizationType = rs.getString("OrganizationType");
                    establishedYear = (Integer) rs.getObject("EstablishedYear");
                    taxCode = rs.getString("TaxCode");
                    businessLicense = rs.getString("BusinessLicenseNumber");
                    representativeName = rs.getString("RepresentativeName");
                    representativePosition = rs.getString("RepresentativePosition");
                    phone = rs.getString("Phone");
                    address = rs.getString("Address");
                    website = rs.getString("Website");
                    facebookPage = rs.getString("FacebookPage");
                    description = rs.getString("Description");
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(updateProfileSql)) {
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
                ps.setString(15, reviewNote);
                ps.setInt(16, userId);
                ps.executeUpdate();
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

            try (PreparedStatement ps = connection.prepareStatement(updateRequestSql)) {
                ps.setInt(1, adminId);
                ps.setString(2, reviewNote);
                ps.setInt(3, requestId);
                ps.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            rollbackQuietly();
            e.printStackTrace();
        } finally {
            resetAutoCommit();
        }

        return false;
    }

    public boolean rejectRequest(int requestId, int adminId, String reviewNote) {
        String sql = """
                UPDATE OrganizationProfileUpdateRequests
                SET Status = 'Rejected',
                    ReviewedBy = ?,
                    ReviewedAt = GETDATE(),
                    ReviewNote = ?
                WHERE RequestId = ? AND Status = 'Pending'
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, reviewNote);
            ps.setInt(3, requestId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
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

    private void resetAutoCommit() {
        try {
            connection.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
