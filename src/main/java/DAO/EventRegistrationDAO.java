package DAO;

import Context.DBContext;
import DTO.EventView;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EventRegistrationDAO extends DBContext {

    // 1. Lấy thống kê Dashboard cho Volunteer (Total, Upcoming, Completed)
    public int[] getVolunteerStats(int volunteerId) {
        int[] stats = new int[3]; // [0]: Total, [1]: Upcoming, [2]: Completed
        String sql = "SELECT COUNT(*) AS TotalApplied, " +
                "SUM(CASE WHEN er.Status = 'Approved' AND e.StartDate >= GETDATE() THEN 1 ELSE 0 END) AS Upcoming, " +
                "SUM(CASE WHEN er.Status = 'Approved' AND e.EndDate < GETDATE() THEN 1 ELSE 0 END) AS Completed " +
                "FROM EventRegistrations er " +
                "JOIN Events e ON er.EventId = e.EventId " +
                "WHERE er.VolunteerId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats[0] = rs.getInt("TotalApplied");
                stats[1] = rs.getInt("Upcoming");
                stats[2] = rs.getInt("Completed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // 2. Lấy danh sách sự kiện đã đăng ký của Volunteer
    public List<EventView> getMyRegisteredEvents(int volunteerId) {
        List<EventView> list = new ArrayList<>();
        String sql = "SELECT e.EventId, e.Title, e.Location, e.StartDate, e.EndDate, " +
                "er.Status AS RegistrationStatus, er.AppliedAt " +
                "FROM EventRegistrations er " +
                "JOIN Events e ON er.EventId = e.EventId " +
                "WHERE er.VolunteerId = ? " +
                "ORDER BY er.AppliedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EventView ev = new EventView();
                ev.setEventId(rs.getInt("EventId"));
                ev.setEventName(rs.getString("Title"));
                ev.setLocation(rs.getString("Location"));

                // Mượn field Status của EventView để lưu Status của phần Đăng ký (Pending/Approved/Rejected)
                ev.setStatus(rs.getString("RegistrationStatus"));

                Date startDate = rs.getDate("StartDate");
                if (startDate != null) ev.setStartDate(startDate.toLocalDate().atStartOfDay());

                Date endDate = rs.getDate("EndDate");
                if (endDate != null) ev.setEndDate(endDate.toLocalDate().atStartOfDay());

                list.add(ev);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. ORGANIZATION QUẢN LÝ TÌNH NGUYỆN VIÊN (ĐÃ SỬA ORDER BY)
    public List<Map<String, Object>> getVolunteersByEvent(int eventId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT er.RegistrationId, u.UserId AS VolunteerId, up.FullName, u.Email, up.Phone, er.Status, " +
                "CASE WHEN ec.CoordinatorId IS NOT NULL THEN 1 ELSE 0 END AS IsCoordinator " +
                "FROM EventRegistrations er " +
                "JOIN Users u ON er.VolunteerId = u.UserId " +
                "JOIN UserProfiles up ON u.UserId = up.UserId " +
                "LEFT JOIN EventCoordinators ec ON er.EventId = ec.EventId " +
                "     AND u.UserId = ec.CoordinatorId AND ec.Status = 'Active' " +
                "WHERE er.EventId = ? " +
                "ORDER BY " +
                "    IsCoordinator DESC, " + // Đưa Coordinator lên đầu
                "    CASE er.Status " +
                "        WHEN 'Pending' THEN 1 " + // Pending đứng thứ hai
                "        WHEN 'Approved' THEN 2 " + // Approved đứng thứ ba
                "        ELSE 3 " + // Còn lại (Rejected) xuống cuối
                "    END ASC, " +
                "    up.FullName ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("registrationId", rs.getInt("RegistrationId"));
                map.put("volunteerId", rs.getInt("VolunteerId"));
                map.put("fullName", rs.getString("FullName"));
                map.put("email", rs.getString("Email"));
                map.put("phone", rs.getString("Phone"));
                map.put("status", rs.getString("Status"));
                map.put("isCoordinator", rs.getInt("IsCoordinator")); // 1 = Có, 0 = Không
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Duyệt (Approve) Volunteer
    public boolean approveVolunteer(int registrationId) {
        String sql = "UPDATE EventRegistrations SET Status = 'Approved' WHERE RegistrationId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, registrationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Từ chối (Reject) Volunteer
    public boolean rejectVolunteer(int registrationId, int reviewerId, String reviewNote) {
        String sql = "UPDATE EventRegistrations SET Status = 'Rejected', ReviewedBy = ?, ReviewedAt = GETDATE(), ReviewNote = ? WHERE RegistrationId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewerId);
            ps.setString(2, reviewNote);
            ps.setInt(3, registrationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 6. Volunteer nộp đơn tham gia sự kiện
    public boolean applyToEvent(int eventId, int volunteerId) {
        String sql = "INSERT INTO EventRegistrations (EventId, VolunteerId, Status) VALUES (?, ?, 'Pending')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 7. Kiểm tra xem Volunteer đã nộp đơn chưa
    public boolean canApply(int eventId, int volunteerId) {
        String sql = "SELECT COUNT(*) FROM EventRegistrations WHERE EventId = ? AND VolunteerId = ? AND Status IN ('Pending', 'Approved')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) == 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}