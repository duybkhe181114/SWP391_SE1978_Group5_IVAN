package DAO;

import Context.DBContext;
import DTO.EventView;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO extends DBContext {

    public List<EventView> getApprovedEventsForHome() {
        List<EventView> list = new ArrayList<>();

        String sql = """
                
                                SELECT\s
                    e.EventId,
                    e.Title,
                    e.Location,
                    e.StartDate,
                    e.EndDate,
                    e.CoverImageUrl,
                    o.OrganizationId,
                    o.Name AS OrganizationName
                FROM Events e
                JOIN Organizations o\s
                    ON e.OrganizationId = o.OrganizationId
                WHERE e.Status = 'Approved'
                ORDER BY e.StartDate ASC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                EventView ev = new EventView();
                ev.setEventId(rs.getInt("EventId"));
                ev.setEventName(rs.getString("Title"));
                ev.setLocation(rs.getString("Location"));
                
                java.sql.Date startDate = rs.getDate("StartDate");
                if (startDate != null) {
                    ev.setStartDate(startDate.toLocalDate().atStartOfDay());
                }
                
                java.sql.Date endDate = rs.getDate("EndDate");
                if (endDate != null) {
                    ev.setEndDate(endDate.toLocalDate().atStartOfDay());
                }
                
                ev.setOrganizationId(rs.getInt("OrganizationId"));
                ev.setOrganizationName(rs.getString("OrganizationName"));
                ev.setEventImageUrl(rs.getString("CoverImageUrl"));

                list.add(ev);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return list;
    }
    
    public boolean createEvent(String title, String description, String location, 
                               String startDate, String endDate, int requiredVolunteers, int orgId) {
        String sql = """
            INSERT INTO Events (Title, Description, Location, StartDate, EndDate, 
                               MaxVolunteers, OrganizationId, Status, CreatedAt, UpdatedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending', GETDATE(), GETDATE())
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, location);
            
            if (startDate != null && !startDate.isEmpty()) {
                ps.setDate(4, java.sql.Date.valueOf(startDate));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            
            if (endDate != null && !endDate.isEmpty()) {
                ps.setDate(5, java.sql.Date.valueOf(endDate));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }
            
            ps.setInt(6, requiredVolunteers);
            ps.setInt(7, orgId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean approveEvent(int eventId) {
        String sql = "UPDATE Events SET Status = 'Approved' WHERE EventId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean rejectEvent(int eventId) {
        String sql = "UPDATE Events SET Status = 'Rejected' WHERE EventId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Integer getOrganizationIdByUserId(int userId) {
        String sql = "SELECT OrganizationId FROM Organizations WHERE CreatedBy = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("OrganizationId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<EventView> getPendingEvents() {
        List<EventView> list = new ArrayList<>();
        String sql = """
            SELECT e.EventId, e.Title, e.Description, e.Location, e.StartDate, e.EndDate, 
                   e.MaxVolunteers, e.Status, e.CreatedAt,
                   o.OrganizationId, o.Name AS OrganizationName
            FROM Events e
            JOIN Organizations o ON e.OrganizationId = o.OrganizationId
            WHERE e.Status = 'Pending'
            ORDER BY e.CreatedAt DESC
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                EventView ev = new EventView();
                ev.setEventId(rs.getInt("EventId"));
                ev.setEventName(rs.getString("Title"));
                ev.setLocation(rs.getString("Location"));
                
                java.sql.Date startDate = rs.getDate("StartDate");
                if (startDate != null) {
                    ev.setStartDate(startDate.toLocalDate().atStartOfDay());
                }
                
                java.sql.Date endDate = rs.getDate("EndDate");
                if (endDate != null) {
                    ev.setEndDate(endDate.toLocalDate().atStartOfDay());
                }
                
                ev.setOrganizationId(rs.getInt("OrganizationId"));
                ev.setOrganizationName(rs.getString("OrganizationName"));
                list.add(ev);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<EventView> getEventsByOrganization(int organizationId) {
        List<EventView> list = new ArrayList<>();
        String sql = """
            SELECT EventId, Title, Description, Location, StartDate, EndDate, 
                   MaxVolunteers, Status, CreatedAt, CoverImageUrl
            FROM Events
            WHERE OrganizationId = ?
            ORDER BY CreatedAt DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, organizationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EventView ev = new EventView();
                ev.setEventId(rs.getInt("EventId"));
                ev.setEventName(rs.getString("Title"));
                ev.setLocation(rs.getString("Location"));
                ev.setStatus(rs.getString("Status"));

                ev.setEventImageUrl(rs.getString("CoverImageUrl"));

                java.sql.Date startDate = rs.getDate("StartDate");
                if (startDate != null) {
                    ev.setStartDate(startDate.toLocalDate().atStartOfDay());
                }

                java.sql.Date endDate = rs.getDate("EndDate");
                if (endDate != null) {
                    ev.setEndDate(endDate.toLocalDate().atStartOfDay());
                }

                list.add(ev);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public EventView getEventById(int eventId) {
        String sql = """
            SELECT e.EventId, e.Title, e.Description, e.Location, e.StartDate, e.EndDate, 
                   e.MaxVolunteers, e.Status, e.CoverImageUrl, e.CreatedAt,
                   o.OrganizationId, o.Name AS OrganizationName,
                   (SELECT COUNT(*) FROM EventRegistrations er WHERE er.EventId = e.EventId AND er.Status = 'Approved') AS CurrentVolunteers
            FROM Events e
            JOIN Organizations o ON e.OrganizationId = o.OrganizationId
            WHERE e.EventId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                EventView ev = new EventView();
                ev.setEventId(rs.getInt("EventId"));
                ev.setEventName(rs.getString("Title"));
                ev.setDescription(rs.getString("Description"));
                ev.setLocation(rs.getString("Location"));
                ev.setMaxVolunteers(rs.getInt("MaxVolunteers"));
                ev.setCurrentVolunteers(rs.getInt("CurrentVolunteers"));
                ev.setStatus(rs.getString("Status"));
                ev.setEventImageUrl(rs.getString("CoverImageUrl"));
                ev.setOrganizationId(rs.getInt("OrganizationId"));
                ev.setOrganizationName(rs.getString("OrganizationName"));

                java.sql.Date startDate = rs.getDate("StartDate");
                if (startDate != null) ev.setStartDate(startDate.toLocalDate().atStartOfDay());

                java.sql.Date endDate = rs.getDate("EndDate");
                if (endDate != null) ev.setEndDate(endDate.toLocalDate().atStartOfDay());

                return ev;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE IsActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTotalOrganizations() {
        String sql = "SELECT COUNT(*) FROM Organizations";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTotalEvents() {
        String sql = "SELECT COUNT(*) FROM Events";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // xem user này đã đăng ký sự kiện này chưa
    public String getEnrollmentStatus(int eventId, int volunteerId) {
        String sql = "SELECT Status FROM EventRegistrations WHERE EventId = ? AND VolunteerId = ? ORDER BY AppliedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("Status"); // Trả về Pending, Approved, hoặc Rejected
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null; // Chưa đăng ký
    }
    
    // Lấy lý do từ chối
    public String getRejectReason(int eventId, int volunteerId) {
        String sql = "SELECT ReviewNote FROM EventRegistrations WHERE EventId = ? AND VolunteerId = ? AND Status = 'Rejected' ORDER BY AppliedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("ReviewNote");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    //enroll
    public boolean enrollEvent(int eventId, int volunteerId) {
        String sql = "INSERT INTO EventRegistrations (EventId, VolunteerId, Status, AppliedAt) VALUES (?, ?, 'Pending', GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

//cancel
    public boolean cancelEnrollment(int eventId, int volunteerId) {
        String sql = "DELETE FROM EventRegistrations WHERE EventId = ? AND VolunteerId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<EventView> searchEvents(String keyword,
                                        String location,
                                        String sortBy,
                                        int page,
                                        int pageSize) {

        List<EventView> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT e.EventId, e.Title, e.Description, e.Location, " +
                "e.StartDate, e.EndDate, e.MaxVolunteers, e.CoverImageUrl, e.CreatedAt, " +
                "o.Name AS OrganizationName, " +
                "(SELECT COUNT(*) FROM EventRegistrations er WHERE er.EventId = e.EventId AND er.Status = 'Approved') AS CurrentVolunteers " +
                "FROM Events e " +
                "JOIN Organizations o ON e.OrganizationId = o.OrganizationId " +
                "WHERE e.Status = 'Approved' ";

        if (keyword != null && !keyword.isEmpty())
            sql += " AND e.Title LIKE ? ";

        if (location != null && !location.isEmpty())
            sql += " AND e.Location LIKE ? ";

        // Smart sort: đẩy event đã qua xuống cuối
        if ("newest".equals(sortBy)) {
            sql += " ORDER BY CASE WHEN e.StartDate < GETDATE() THEN 1 ELSE 0 END ASC, " +
                    "e.CreatedAt DESC ";
        } else {
            sql += " ORDER BY CASE WHEN e.StartDate < GETDATE() THEN 1 ELSE 0 END ASC, " +
                    "e.StartDate ASC ";
        }

        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int paramIdx = 1;

            if (keyword != null && !keyword.isEmpty())
                ps.setString(paramIdx++, "%" + keyword + "%");

            if (location != null && !location.isEmpty())
                ps.setString(paramIdx++, "%" + location + "%");

            ps.setInt(paramIdx++, offset);
            ps.setInt(paramIdx, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                EventView ev = new EventView();

                ev.setEventId(rs.getInt("EventId"));
                ev.setEventName(rs.getString("Title"));
                ev.setDescription(rs.getString("Description"));
                ev.setLocation(rs.getString("Location"));
                ev.setOrganizationName(rs.getString("OrganizationName"));
                ev.setEventImageUrl(rs.getString("CoverImageUrl"));

                ev.setMaxVolunteers(rs.getInt("MaxVolunteers"));
                ev.setCurrentVolunteers(rs.getInt("CurrentVolunteers"));

                java.sql.Date startDate = rs.getDate("StartDate");
                if (startDate != null)
                    ev.setStartDate(startDate.toLocalDate().atStartOfDay());

                java.sql.Date endDate = rs.getDate("EndDate");
                if (endDate != null)
                    ev.setEndDate(endDate.toLocalDate().atStartOfDay());

                list.add(ev);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
