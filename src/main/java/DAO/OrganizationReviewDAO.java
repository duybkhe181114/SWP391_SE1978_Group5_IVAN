package DAO;

import Context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrganizationReviewDAO extends DBContext {

    // Lấy danh sách Organization đang Pending
    public List<Map<String, Object>> getPendingOrganizations() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT u.UserId, u.Email, u.CreatedAt, " +
                     "up.OrganizationName, up.OrganizationType, up.EstablishedYear, " +
                     "up.TaxCode, up.BusinessLicenseNumber, up.RepresentativeName, " +
                     "up.RepresentativePosition, up.Phone, up.Address, up.Website, " +
                     "up.FacebookPage, up.Description, up.ApprovalStatus " +
                     "FROM Users u " +
                     "JOIN UserRoles ur ON u.UserId = ur.UserId " +
                     "JOIN UserProfiles up ON u.UserId = up.UserId " +
                     "WHERE ur.Role = 'Organization' AND up.ApprovalStatus = 'Pending' " +
                     "ORDER BY u.CreatedAt DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", rs.getInt("UserId"));
                map.put("email", rs.getString("Email"));
                map.put("createdAt", rs.getTimestamp("CreatedAt"));
                map.put("organizationName", rs.getString("OrganizationName"));
                map.put("organizationType", rs.getString("OrganizationType"));
                map.put("establishedYear", rs.getInt("EstablishedYear"));
                map.put("taxCode", rs.getString("TaxCode"));
                map.put("businessLicense", rs.getString("BusinessLicenseNumber"));
                map.put("representativeName", rs.getString("RepresentativeName"));
                map.put("representativePosition", rs.getString("RepresentativePosition"));
                map.put("phone", rs.getString("Phone"));
                map.put("address", rs.getString("Address"));
                map.put("website", rs.getString("Website"));
                map.put("facebookPage", rs.getString("FacebookPage"));
                map.put("description", rs.getString("Description"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Approve Organization
    public boolean approveOrganization(int userId, int adminId, String reviewNote) {
        String sqlProfile = "UPDATE UserProfiles SET ApprovalStatus = 'Approved', ReviewedBy = ?, ReviewedAt = GETDATE(), ReviewNote = ? WHERE UserId = ?";
        String sqlUser = "UPDATE Users SET IsActive = 1 WHERE UserId = ?";
        
        try {
            connection.setAutoCommit(false);
            
            // Update UserProfiles
            try (PreparedStatement ps1 = connection.prepareStatement(sqlProfile)) {
                ps1.setInt(1, adminId);
                ps1.setString(2, reviewNote);
                ps1.setInt(3, userId);
                ps1.executeUpdate();
            }
            
            // Activate User
            try (PreparedStatement ps2 = connection.prepareStatement(sqlUser)) {
                ps2.setInt(1, userId);
                ps2.executeUpdate();
            }
            
            connection.commit();
            return true;
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
        return false;
    }

    // Reject Organization
    public boolean rejectOrganization(int userId, int adminId, String reviewNote) {
        String sql = "UPDATE UserProfiles SET ApprovalStatus = 'Rejected', ReviewedBy = ?, ReviewedAt = GETDATE(), ReviewNote = ? WHERE UserId = ?";
        
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
}
