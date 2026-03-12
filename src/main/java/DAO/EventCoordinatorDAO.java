package DAO;

import Context.DBContext;
import Entity.EventCoordinator;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventCoordinatorDAO extends DBContext {

    /**
     * List all coordinators belonging to events of a specific organization.
     */
    public List<EventCoordinator> getByOrganization(int organizationId) {

        List<EventCoordinator> list = new ArrayList<>();

        String sql = """
                    SELECT ec.EventId, ec.CoordinatorId, ec.PromotedFromVolunteer,
                           ec.PromotedAt, ec.PromotedBy, ec.Status,
                           e.Title AS EventName,
                           u.Email AS CoordinatorEmail,
                           ISNULL(up.FirstName + ' ' + up.LastName, u.Email) AS CoordinatorName
                    FROM EventCoordinators ec
                    JOIN Events e ON ec.EventId = e.EventId
                    JOIN Users u ON ec.CoordinatorId = u.UserId
                    LEFT JOIN UserProfiles up ON u.UserId = up.UserId
                    WHERE e.OrganizationId = ?
                    ORDER BY ec.PromotedAt DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, organizationId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                EventCoordinator ec = new EventCoordinator();
                ec.setEventId(rs.getInt("EventId"));
                ec.setCoordinatorId(rs.getInt("CoordinatorId"));
                ec.setPromotedFromVolunteer(rs.getBoolean("PromotedFromVolunteer"));

                Timestamp promotedAt = rs.getTimestamp("PromotedAt");
                if (promotedAt != null)
                    ec.setPromotedAt(promotedAt.toLocalDateTime());

                ec.setPromotedBy(rs.getInt("PromotedBy"));
                ec.setStatus(rs.getString("Status"));
                ec.setEventName(rs.getString("EventName"));
                ec.setCoordinatorEmail(rs.getString("CoordinatorEmail"));
                ec.setCoordinatorName(rs.getString("CoordinatorName"));

                list.add(ec);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Promote a volunteer to coordinator for a specific event.
     */
    public boolean promote(int eventId, int coordinatorId, int promotedBy) {

        // Check if already exists
        if (exists(eventId, coordinatorId)) {
            return false;
        }

        String sql = """
                    INSERT INTO EventCoordinators (EventId, CoordinatorId, PromotedFromVolunteer, PromotedAt, PromotedBy, Status)
                    VALUES (?, ?, 1, GETDATE(), ?, 'Active')
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, coordinatorId);
            ps.setInt(3, promotedBy);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Assign coordinator to a new event (same as promote but for existing
     * coordinators).
     */
    public boolean assign(int eventId, int coordinatorId, int promotedBy) {
        return promote(eventId, coordinatorId, promotedBy);
    }

    /**
     * Revoke coordinator access for a specific event.
     */
    public boolean revoke(int eventId, int coordinatorId) {

        String sql = """
                    UPDATE EventCoordinators
                    SET Status = 'Revoked'
                    WHERE EventId = ? AND CoordinatorId = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, coordinatorId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Reactivate a previously revoked coordinator.
     */
    public boolean reactivate(int eventId, int coordinatorId) {

        String sql = """
                    UPDATE EventCoordinators
                    SET Status = 'Active'
                    WHERE EventId = ? AND CoordinatorId = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, coordinatorId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if a coordinator record already exists.
     */
    public boolean exists(int eventId, int coordinatorId) {

        String sql = "SELECT 1 FROM EventCoordinators WHERE EventId = ? AND CoordinatorId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, coordinatorId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Find a user (volunteer) by email.
     * Returns: [userId, email, fullName]
     */
    public int[] findVolunteerByEmail(String email) {

        String sql = """
                    SELECT u.UserId, u.Email
                    FROM Users u
                    WHERE u.Email = ? AND u.IsActive = 1
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new int[] { rs.getInt("UserId") };
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get approved volunteers for a specific event (to choose from when promoting).
     */
    public List<EventCoordinator> getApprovedVolunteersByEvent(int eventId) {

        List<EventCoordinator> list = new ArrayList<>();

        String sql = """
                    SELECT er.VolunteerId AS CoordinatorId,
                           u.Email AS CoordinatorEmail,
                           ISNULL(up.FirstName + ' ' + up.LastName, u.Email) AS CoordinatorName
                    FROM EventRegistrations er
                    JOIN Users u ON er.VolunteerId = u.UserId
                    LEFT JOIN UserProfiles up ON u.UserId = up.UserId
                    WHERE er.EventId = ? AND er.Status = 'Approved'
                      AND er.VolunteerId NOT IN (
                          SELECT ec.CoordinatorId FROM EventCoordinators ec
                          WHERE ec.EventId = ? AND ec.Status != 'Revoked'
                      )
                    ORDER BY u.Email
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, eventId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                EventCoordinator ec = new EventCoordinator();
                ec.setCoordinatorId(rs.getInt("CoordinatorId"));
                ec.setCoordinatorEmail(rs.getString("CoordinatorEmail"));
                ec.setCoordinatorName(rs.getString("CoordinatorName"));
                list.add(ec);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean checkIsCoordinator(int eventId, int userId) {
        String sql = "SELECT 1 FROM EventCoordinators WHERE EventId = ? AND CoordinatorId = ? AND Status = 'Active'";
        try (java.sql.PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    /**
     * Get all distinct active coordinators across organization's events (for assign
     * dropdown).
     */
    public List<EventCoordinator> getActiveCoordinatorsByOrg(int organizationId) {

        List<EventCoordinator> list = new ArrayList<>();

        String sql = """
                    SELECT DISTINCT ec.CoordinatorId,
                           u.Email AS CoordinatorEmail,
                           ISNULL(up.FirstName + ' ' + up.LastName, u.Email) AS CoordinatorName
                    FROM EventCoordinators ec
                    JOIN Events e ON ec.EventId = e.EventId
                    JOIN Users u ON ec.CoordinatorId = u.UserId
                    LEFT JOIN UserProfiles up ON u.UserId = up.UserId
                    WHERE e.OrganizationId = ? AND ec.Status = 'Active'
                    ORDER BY u.Email
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, organizationId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                EventCoordinator ec = new EventCoordinator();
                ec.setCoordinatorId(rs.getInt("CoordinatorId"));
                ec.setCoordinatorEmail(rs.getString("CoordinatorEmail"));
                ec.setCoordinatorName(rs.getString("CoordinatorName"));
                list.add(ec);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Integer> getCoordinatedEventIds(int coordinatorId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT EventId FROM EventCoordinators WHERE CoordinatorId = ? AND Status = 'Active'";
        try (java.sql.PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, coordinatorId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt(1));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Lấy thông tin chi tiết các sự kiện đang quản lý để hiển thị ra Portal
    public List<DTO.EventView> getCoordinatedEvents(int coordinatorId) {
        List<DTO.EventView> list = new ArrayList<>();
        String sql = "SELECT e.EventId, e.Title, e.Location, e.StartDate, e.CoverImageUrl, e.Status " +
                "FROM Events e " +
                "JOIN EventCoordinators ec ON e.EventId = ec.EventId " +
                "WHERE ec.CoordinatorId = ? AND ec.Status = 'Active'";
        try (java.sql.PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, coordinatorId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DTO.EventView ev = new DTO.EventView();
                    ev.setEventId(rs.getInt("EventId"));
                    ev.setEventName(rs.getString("Title"));
                    ev.setLocation(rs.getString("Location"));
                    ev.setEventImageUrl(rs.getString("CoverImageUrl"));
                    java.sql.Date sd = rs.getDate("StartDate");
                    if (sd != null) ev.setStartDate(sd.toLocalDate().atStartOfDay());
                    ev.setStatus(rs.getString("Status"));
                    list.add(ev);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Summary Stats cho Coordinator Portal
    public java.util.Map<String, Integer> getCoordinatorStats(int coordinatorId) {
        java.util.Map<String, Integer> stats = new java.util.HashMap<>();
        stats.put("totalEvents", 0);
        stats.put("totalVolunteers", 0);
        stats.put("totalTasks", 0);

        // Đếm số sự kiện đang quản lý
        String sql1 = "SELECT COUNT(*) FROM EventCoordinators WHERE CoordinatorId = ? AND Status = 'Active'";

        // Đếm tổng số lượng Tình nguyện viên (đã Approved) trong các sự kiện mà người này làm sếp
        String sql2 = "SELECT COUNT(DISTINCT er.VolunteerId) FROM EventRegistrations er " +
                "JOIN EventCoordinators ec ON er.EventId = ec.EventId " +
                "WHERE ec.CoordinatorId = ? AND ec.Status = 'Active' AND er.Status = 'Approved'";

        // Đếm tổng số việc đã giao
        String sql3 = "SELECT COUNT(*) FROM Tasks WHERE CoordinatorId = ?";

        try {
            try(java.sql.PreparedStatement ps = connection.prepareStatement(sql1)) {
                ps.setInt(1, coordinatorId);
                java.sql.ResultSet rs = ps.executeQuery();
                if(rs.next()) stats.put("totalEvents", rs.getInt(1));
            }
            try(java.sql.PreparedStatement ps = connection.prepareStatement(sql2)) {
                ps.setInt(1, coordinatorId);
                java.sql.ResultSet rs = ps.executeQuery();
                if(rs.next()) stats.put("totalVolunteers", rs.getInt(1));
            }
            try(java.sql.PreparedStatement ps = connection.prepareStatement(sql3)) {
                ps.setInt(1, coordinatorId);
                java.sql.ResultSet rs = ps.executeQuery();
                if(rs.next()) stats.put("totalTasks", rs.getInt(1));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
}
