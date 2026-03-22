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
    
    public int createEvent(String title, String description, String location,
                               String coverImageUrl, String startDate, String endDate,
                               int requiredVolunteers, int orgId, String contactName,
                               String contactEmail, String contactPhone,
                               String requirements, String benefits) {
        String sql = """
            INSERT INTO Events (Title, Description, Location, CoverImageUrl, StartDate, EndDate,
                               MaxVolunteers, OrganizationId, Status, CreatedAt, UpdatedAt,
                               ContactName, ContactEmail, ContactPhone, Requirements, Benefits)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending', GETDATE(), GETDATE(), ?, ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, location);
            ps.setString(4, coverImageUrl);
            if (startDate != null && !startDate.isEmpty()) ps.setDate(5, java.sql.Date.valueOf(startDate));
            else ps.setNull(5, java.sql.Types.DATE);
            if (endDate != null && !endDate.isEmpty()) ps.setDate(6, java.sql.Date.valueOf(endDate));
            else ps.setNull(6, java.sql.Types.DATE);
            ps.setInt(7, requiredVolunteers);
            ps.setInt(8, orgId);
            ps.setString(9, contactName);
            ps.setString(10, contactEmail);
            ps.setString(11, contactPhone);
            ps.setString(12, requirements);
            ps.setString(13, benefits);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean approveEvent(int eventId, Integer adminId, String reviewNote) {
        String sql = """
            UPDATE Events
            SET Status = 'Approved',
                ReviewNote = ?,
                ReviewedAt = GETDATE(),
                ReviewedBy = ?,
                UpdatedAt = GETDATE()
            WHERE EventId = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reviewNote);
            if (adminId == null) ps.setNull(2, Types.INTEGER);
            else ps.setInt(2, adminId);
            ps.setInt(3, eventId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean rejectEvent(int eventId, Integer adminId, String reviewNote) {
        String sql = """
            UPDATE Events
            SET Status = 'Rejected',
                ReviewNote = ?,
                ReviewedAt = GETDATE(),
                ReviewedBy = ?,
                UpdatedAt = GETDATE()
            WHERE EventId = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reviewNote);
            if (adminId == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, adminId);
            }
            ps.setInt(3, eventId);
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
                   e.MaxVolunteers, e.Status, e.CreatedAt, e.CoverImageUrl,
                   e.ContactName, e.ContactEmail, e.ContactPhone, e.Requirements, e.Benefits,
                   e.ReviewNote, e.ReviewedAt,
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
                ev.setEventImageUrl(rs.getString("CoverImageUrl"));
                ev.setDescription(rs.getString("Description"));
                ev.setMaxVolunteers(rs.getInt("MaxVolunteers"));
                mapAdditionalEventFields(rs, ev);
                list.add(ev);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<EventView> getEventsForAdmin(String keyword, String status) {
        List<EventView> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT e.EventId, e.Title, e.Description, e.Location, e.StartDate, e.EndDate,
                   e.MaxVolunteers, e.Status, e.CreatedAt, e.CoverImageUrl,
                   e.ContactName, e.ContactEmail, e.ContactPhone, e.Requirements, e.Benefits,
                   e.ReviewNote, e.ReviewedAt,
                   o.OrganizationId, o.Name AS OrganizationName,
                   (SELECT COUNT(*) FROM EventRegistrations er WHERE er.EventId = e.EventId AND er.Status = 'Approved') AS CurrentVolunteers
            FROM Events e
            JOIN Organizations o ON e.OrganizationId = o.OrganizationId
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append("""
                 AND (
                    e.Title LIKE ?
                    OR o.Name LIKE ?
                    OR e.Location LIKE ?
                    OR e.ContactName LIKE ?
                 )
            """);
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }

        if (status != null && !status.isBlank()) {
            sql.append(" AND e.Status = ? ");
            params.add(status.trim());
        }

        sql.append(" ORDER BY e.CreatedAt DESC, e.EventId DESC ");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
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
                    mapAdditionalEventFields(rs, ev);

                    Date startDate = rs.getDate("StartDate");
                    if (startDate != null) {
                        ev.setStartDate(startDate.toLocalDate().atStartOfDay());
                    }

                    Date endDate = rs.getDate("EndDate");
                    if (endDate != null) {
                        ev.setEndDate(endDate.toLocalDate().atStartOfDay());
                    }

                    list.add(ev);
                }
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
                   MaxVolunteers, Status, CreatedAt, CoverImageUrl,
                   ContactName, ContactEmail, ContactPhone, Requirements, Benefits,
                   ReviewNote, ReviewedAt
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
                ev.setDescription(rs.getString("Description"));
                ev.setMaxVolunteers(rs.getInt("MaxVolunteers"));

                ev.setEventImageUrl(rs.getString("CoverImageUrl"));
                mapAdditionalEventFields(rs, ev);

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

    public boolean isEventOwnedByUser(int eventId, int userId) {
        String sql = """
            SELECT 1
            FROM Events e
            JOIN Organizations o ON e.OrganizationId = o.OrganizationId
            WHERE e.EventId = ? AND o.CreatedBy = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateEventByOrganization(int eventId, int organizationId, String title,
                                             String description, String location,
                                             String coverImageUrl, String startDate,
                                             String endDate, int maxVolunteers,
                                             String contactName, String contactEmail,
                                             String contactPhone, String requirements,
                                             String benefits) {
        String sql = """
            UPDATE Events
            SET Title = ?,
                Description = ?,
                Location = ?,
                CoverImageUrl = ?,
                StartDate = ?,
                EndDate = ?,
                MaxVolunteers = ?,
                ContactName = ?,
                ContactEmail = ?,
                ContactPhone = ?,
                Requirements = ?,
                Benefits = ?,
                Status = CASE WHEN Status = 'Rejected' THEN 'Pending' ELSE Status END,
                ReviewNote = CASE WHEN Status = 'Rejected' THEN NULL ELSE ReviewNote END,
                ReviewedAt = CASE WHEN Status = 'Rejected' THEN NULL ELSE ReviewedAt END,
                ReviewedBy = CASE WHEN Status = 'Rejected' THEN NULL ELSE ReviewedBy END,
                UpdatedAt = GETDATE()
            WHERE EventId = ? AND OrganizationId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, location);
            ps.setString(4, coverImageUrl);

            if (startDate != null && !startDate.isBlank()) {
                ps.setDate(5, Date.valueOf(startDate));
            } else {
                ps.setNull(5, Types.DATE);
            }

            if (endDate != null && !endDate.isBlank()) {
                ps.setDate(6, Date.valueOf(endDate));
            } else {
                ps.setNull(6, Types.DATE);
            }

            ps.setInt(7, maxVolunteers);
            ps.setString(8, contactName);
            ps.setString(9, contactEmail);
            ps.setString(10, contactPhone);
            ps.setString(11, requirements);
            ps.setString(12, benefits);
            ps.setInt(13, eventId);
            ps.setInt(14, organizationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public EventView getEventById(int eventId) {
        String sql = """
            SELECT e.EventId, e.Title, e.Description, e.Location, e.StartDate, e.EndDate,
                   e.MaxVolunteers, e.Status, e.CoverImageUrl, e.CreatedAt,
                   e.ContactName, e.ContactEmail, e.ContactPhone, e.Requirements, e.Benefits,
                   e.ReviewNote, e.ReviewedAt,
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
                mapAdditionalEventFields(rs, ev);

                java.sql.Date startDate = rs.getDate("StartDate");
                if (startDate != null) ev.setStartDate(startDate.toLocalDate().atStartOfDay());

                java.sql.Date endDate = rs.getDate("EndDate");
                if (endDate != null) ev.setEndDate(endDate.toLocalDate().atStartOfDay());

                return ev;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    private void mapAdditionalEventFields(ResultSet rs, EventView event) throws SQLException {
        event.setContactName(rs.getString("ContactName"));
        event.setContactEmail(rs.getString("ContactEmail"));
        event.setContactPhone(rs.getString("ContactPhone"));
        event.setRequirements(rs.getString("Requirements"));
        event.setBenefits(rs.getString("Benefits"));
        event.setReviewNote(rs.getString("ReviewNote"));

        Timestamp reviewedAt = rs.getTimestamp("ReviewedAt");
        if (reviewedAt != null) {
            event.setReviewedAt(reviewedAt.toLocalDateTime());
        }
    }
    
    public Integer getLinkedEventId(int supportRequestId) {
        String sql = "SELECT EventId FROM SupportRequestEvents WHERE RequestId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supportRequestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void linkEventToRequest(int supportRequestId, int eventId) {
        String sql = "INSERT INTO SupportRequestEvents (RequestId, EventId) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supportRequestId);
            ps.setInt(2, eventId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
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
    
    public int getEventsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Events WHERE Status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    
    public int getTotalRegistrations() {
        String sql = "SELECT COUNT(*) FROM EventRegistrations";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
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

    public List<DTO.EventView> getRecommendedEvents(int volunteerId) {
        List<DTO.EventView> list = new ArrayList<>();
        String sql = "SELECT TOP 4 e.EventId, e.Title, e.Location, e.StartDate, e.CoverImageUrl " +
                "FROM Events e " +
                "WHERE e.Status = 'Approved' AND e.EndDate >= CAST(GETDATE() AS DATE) " +
                "AND e.EventId NOT IN (SELECT EventId FROM EventRegistrations WHERE VolunteerId = ?) " +
                "ORDER BY e.StartDate ASC";
        try (java.sql.PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DTO.EventView ev = new DTO.EventView();
                    ev.setEventId(rs.getInt("EventId"));
                    ev.setEventName(rs.getString("Title"));
                    ev.setLocation(rs.getString("Location"));
                    ev.setEventImageUrl(rs.getString("CoverImageUrl"));
                    java.sql.Date sd = rs.getDate("StartDate");
                    if (sd != null) ev.setStartDate(sd.toLocalDate().atStartOfDay());
                    list.add(ev);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
