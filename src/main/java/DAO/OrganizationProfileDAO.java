package DAO;

import Context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class OrganizationProfileDAO extends DBContext {

    public Map<String, Object> getOrganizationProfile(int userId) {
        String sql = "SELECT * FROM UserProfiles WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> profile = new HashMap<>();
                profile.put("userId", rs.getInt("UserId"));
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
        String sql = "UPDATE UserProfiles SET OrganizationName=?, OrganizationType=?, EstablishedYear=?, " +
                     "TaxCode=?, BusinessLicenseNumber=?, RepresentativeName=?, RepresentativePosition=?, " +
                     "Phone=?, Address=?, Website=?, FacebookPage=?, Description=?, " +
                     "FirstName=?, ApprovalStatus='Pending' WHERE UserId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
