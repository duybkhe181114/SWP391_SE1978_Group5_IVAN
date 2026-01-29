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
                ev.setStartDate(rs.getTimestamp("StartDate").toLocalDateTime());
                ev.setEndDate(rs.getTimestamp("EndDate").toLocalDateTime());
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
                               RequiredVolunteers, OrganizationId, Status, CreatedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending', GETDATE())
        """;
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, location);
            ps.setString(4, startDate);
            ps.setString(5, endDate);
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
}
