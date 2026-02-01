package DAO;

import Context.DBContext;
import java.sql.*;
import java.util.*;

public class EventRegistrationDAO extends DBContext {

    public boolean registerForEvent(int eventId, int userId) {
        String sql = """
            INSERT INTO EventRegistrations (EventId, UserId, Status, RegisteredAt)
            VALUES (?, ?, 'Pending', GETDATE())
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Map<String, Object>> getVolunteersByEvent(int eventId) {
        List<Map<String, Object>> list = new ArrayList<>();
        
        String sql = """
            SELECT er.RegistrationId, er.Status, er.RegisteredAt,
                   u.UserId, u.Email,
                   up.FullName, up.Phone, up.DateOfBirth, up.Gender, up.Address
            FROM EventRegistrations er
            JOIN Users u ON er.UserId = u.UserId
            LEFT JOIN UserProfiles up ON u.UserId = up.UserId
            WHERE er.EventId = ?
            ORDER BY er.RegisteredAt DESC
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> volunteer = new HashMap<>();
                volunteer.put("registrationId", rs.getInt("RegistrationId"));
                volunteer.put("status", rs.getString("Status"));
                volunteer.put("registeredAt", rs.getTimestamp("RegisteredAt"));
                volunteer.put("userId", rs.getInt("UserId"));
                volunteer.put("email", rs.getString("Email"));
                volunteer.put("fullName", rs.getString("FullName"));
                volunteer.put("phone", rs.getString("Phone"));
                volunteer.put("dateOfBirth", rs.getDate("DateOfBirth"));
                volunteer.put("gender", rs.getString("Gender"));
                volunteer.put("address", rs.getString("Address"));
                list.add(volunteer);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean approveVolunteer(int registrationId) {
        String sql = "UPDATE EventRegistrations SET Status = 'Approved' WHERE RegistrationId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, registrationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean rejectVolunteer(int registrationId) {
        String sql = "UPDATE EventRegistrations SET Status = 'Rejected' WHERE RegistrationId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, registrationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
