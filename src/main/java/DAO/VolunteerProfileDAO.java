package DAO;

import Context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VolunteerProfileDAO extends DBContext {

    // 1. Lấy thông tin cá nhân cơ bản
    public Map<String, Object> getVolunteerProfile(int volunteerId) {
        Map<String, Object> profile = new HashMap<>();
        String sql = "SELECT u.Email, up.FullName, up.Phone, up.Gender, up.DateOfBirth, " +
                "up.Address, up.Province, up.EmergencyContactName, up.EmergencyContactPhone, up.Avatar " +
                "FROM Users u " +
                "JOIN UserProfiles up ON u.UserId = up.UserId " +
                "WHERE u.UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                profile.put("email", rs.getString("Email"));
                profile.put("fullName", rs.getString("FullName"));
                profile.put("phone", rs.getString("Phone"));
                profile.put("gender", rs.getString("Gender"));
                profile.put("dob", rs.getDate("DateOfBirth"));
                profile.put("address", rs.getString("Address"));
                profile.put("province", rs.getString("Province"));
                profile.put("emergencyName", rs.getString("EmergencyContactName"));
                profile.put("emergencyPhone", rs.getString("EmergencyContactPhone"));
                profile.put("avatar", rs.getString("Avatar"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return profile;
    }

    // 2. Lấy danh sách kỹ năng (Skills) của người này
    public List<String> getVolunteerSkills(int volunteerId) {
        List<String> skills = new ArrayList<>();
        String sql = "SELECT s.SkillName FROM VolunteerSkills vs " +
                "JOIN Skills s ON vs.SkillId = s.SkillId " +
                "WHERE vs.VolunteerId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                skills.add(rs.getString("SkillName"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return skills;
    }
}