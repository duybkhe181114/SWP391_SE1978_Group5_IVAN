package DAO;

import Context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO extends DBContext {

    // Kiểm tra mật khẩu cũ
    public boolean checkOldPassword(int userId, String oldPass) {
        try {
            String sql = "SELECT PasswordHash FROM Users WHERE UserId = ?";

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String currentPass = rs.getString("PasswordHash");
                return currentPass.equals(oldPass);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update password mới
    public boolean updatePassword(int userId, String newPass) {
        try {
            String sql = "UPDATE Users SET PasswordHash = ? WHERE UserId = ?";

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newPass);
            ps.setInt(2, userId);

            int row = ps.executeUpdate();

            return row > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Kiểm tra email đã tồn tại chưa
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tạo user mới (Volunteer - Active ngay)
    public int createVolunteer(String email, String password) {
        String sql = "INSERT INTO Users (Email, PasswordHash, IsActive) VALUES (?, ?, 1)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, password);
            
            if (ps.executeUpdate() > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Tạo user mới (Organization - Pending, chờ admin duyệt)
    public int createOrganization(String email, String password) {
        String sql = "INSERT INTO Users (Email, PasswordHash, IsActive) VALUES (?, ?, 0)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, password);
            
            if (ps.executeUpdate() > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Gán role cho user
    public boolean assignRole(int userId, String role) {
        String sql = "INSERT INTO UserRoles (UserId, Role) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, role);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tạo profile rỗng cho Volunteer
    public boolean createEmptyProfile(int userId, String firstName, String lastName) {
        String sql = "INSERT INTO UserProfiles (UserId, FirstName, LastName, ApprovalStatus) VALUES (?, ?, ?, 'Approved')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, firstName);
            ps.setString(3, lastName);
            int result = ps.executeUpdate();
            System.out.println("[DEBUG] createEmptyProfile - Rows inserted: " + result);
            return result > 0;
        } catch (Exception e) {
            System.err.println("[ERROR] createEmptyProfile failed for userId: " + userId);
            e.printStackTrace();
        }
        return false;
    }

    // Tạo profile cho Organization (Pending)
    public boolean createOrganizationProfile(int userId, String organizationName, String organizationType,
                                            Integer establishedYear, String taxCode, String businessLicense,
                                            String representativeName, String representativePosition,
                                            String phone, String address, String website, String facebookPage,
                                            String description) {
        String sql = "INSERT INTO UserProfiles " +
                     "(UserId, FirstName, LastName, OrganizationName, OrganizationType, EstablishedYear, TaxCode, " +
                     "BusinessLicenseNumber, RepresentativeName, RepresentativePosition, " +
                     "Phone, Address, Website, FacebookPage, Description, ApprovalStatus) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, representativeName);
            ps.setString(3, "");
            ps.setString(4, organizationName);
            ps.setString(5, organizationType);
            if (establishedYear != null) {
                ps.setInt(6, establishedYear);
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setString(7, taxCode);
            ps.setString(8, businessLicense);
            ps.setString(9, representativeName);
            ps.setString(10, representativePosition);
            ps.setString(11, phone);
            ps.setString(12, address);
            ps.setString(13, website);
            ps.setString(14, facebookPage);
            ps.setString(15, description);
            
            int result = ps.executeUpdate();
            System.out.println("[DEBUG] createOrganizationProfile - Rows inserted: " + result);
            return result > 0;
        } catch (Exception e) {
            System.err.println("[ERROR] createOrganizationProfile failed for userId: " + userId);
            e.printStackTrace();
        }
        return false;
    }
}
