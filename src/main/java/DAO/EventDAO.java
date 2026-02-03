package DAO;

import Context.DBContext;
import DTO.EventView;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class EventDAO extends DBContext {

    public List<EventView> getApprovedEventsForHome() {
        List<EventView> list = new ArrayList<>();

        String sql = """
        SELECT 
            e.EventId,
            e.Title,
            e.Location,
            e.StartDate,
            e.EndDate,
            o.OrganizationId,
            o.Name AS OrganizationName,
            o.Website AS LogoUrl
        FROM dbo.Events e
        JOIN dbo.Organizations o 
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
                ev.setOrganizationLogoUrl(rs.getString("LogoUrl"));

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
                   MaxVolunteers, Status, CreatedAt
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
                   e.MaxVolunteers, e.Status, e.CreatedAt,
                   o.OrganizationId, o.Name AS OrganizationName
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
                ev.setLocation(rs.getString("Location"));
                ev.setStatus(rs.getString("Status"));
                ev.setOrganizationName(rs.getString("OrganizationName"));
                
                java.sql.Date startDate = rs.getDate("StartDate");
                if (startDate != null) {
                    ev.setStartDate(startDate.toLocalDate().atStartOfDay());
                }
                
                java.sql.Date endDate = rs.getDate("EndDate");
                if (endDate != null) {
                    ev.setEndDate(endDate.toLocalDate().atStartOfDay());
                }
                
                return ev;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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
}
