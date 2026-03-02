package DAO;

import Context.DBContext;
import Entity.UserProfile;

import java.sql.*;

public class UserProfileDAO extends DBContext {

    public UserProfile getByUserId(int userId) {
        String sql = """
            SELECT *
            FROM UserProfiles
            WHERE UserId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserProfile profile = new UserProfile();

                    profile.setUserId(rs.getInt("UserId"));
                    profile.setFirstName(rs.getString("FirstName"));
                    profile.setLastName(rs.getString("LastName"));
                    profile.setFullName(rs.getString("FullName"));
                    profile.setPhone(rs.getString("Phone"));
                    profile.setProvince(rs.getString("Province"));
                    profile.setGender(rs.getString("Gender"));
                    profile.setAddress(rs.getString("Address"));
                    profile.setEmergencyContactName(rs.getString("EmergencyContactName"));
                    profile.setEmergencyContactPhone(rs.getString("EmergencyContactPhone"));

                    Date dob = rs.getDate("DateOfBirth");
                    if (dob != null) {
                        profile.setDateOfBirth(dob.toLocalDate());
                    }

                    return profile;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void updateProfile(UserProfile profile) {

        String sql = """
            UPDATE UserProfiles
            SET FirstName = ?,
                LastName = ?,
                Phone = ?,
                Province = ?,
                Gender = ?,
                DateOfBirth = ?,
                Address = ?,
                EmergencyContactName = ?,
                EmergencyContactPhone = ?,
                UpdatedAt = SYSDATETIME()
            WHERE UserId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, profile.getFirstName());
            ps.setString(2, profile.getLastName());
            ps.setString(3, profile.getPhone());
            ps.setString(4, profile.getProvince());
            ps.setString(5, profile.getGender());

            if (profile.getDateOfBirth() != null) {
                ps.setDate(6, Date.valueOf(profile.getDateOfBirth()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            ps.setString(7, profile.getAddress());
            ps.setString(8, profile.getEmergencyContactName());
            ps.setString(9, profile.getEmergencyContactPhone());
            ps.setInt(10, profile.getUserId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}