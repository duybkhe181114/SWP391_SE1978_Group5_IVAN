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
}
