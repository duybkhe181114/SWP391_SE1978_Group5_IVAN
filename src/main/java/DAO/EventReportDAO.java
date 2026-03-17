package DAO;

import Context.DBContext;
import java.sql.*;
import java.util.*;

public class EventReportDAO extends DBContext {

    /** Returns one row per event with participation + feedback stats. */
    public List<Map<String, Object>> getEventReports(String keyword, String status) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT
                e.EventId,
                e.Title,
                e.Status,
                e.StartDate,
                e.EndDate,
                o.Name AS OrgName,
                e.MaxVolunteers,
                COUNT(DISTINCT CASE WHEN er.Status = 'Approved' THEN er.VolunteerId END) AS ApprovedVolunteers,
                COUNT(DISTINCT CASE WHEN er.Status = 'Pending'  THEN er.VolunteerId END) AS PendingVolunteers,
                COUNT(DISTINCT ec2.CommentId) AS TotalFeedback,
                AVG(CAST(ec2.Rating AS FLOAT))  AS AvgRating
            FROM Events e
            JOIN Organizations o ON o.OrganizationId = e.OrganizationId
            LEFT JOIN EventRegistrations er ON er.EventId = e.EventId
            LEFT JOIN EventComments ec2 ON ec2.EventId = e.EventId AND ec2.IsDeleted = 0
            WHERE 1 = 1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (e.Title LIKE ? OR o.Name LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND e.Status = ? ");
            params.add(status.trim());
        }

        sql.append("""
            GROUP BY e.EventId, e.Title, e.Status, e.StartDate, e.EndDate,
                     o.Name, e.MaxVolunteers
            ORDER BY e.StartDate DESC, e.EventId DESC
        """);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("eventId",            rs.getInt("EventId"));
                    row.put("title",              rs.getString("Title"));
                    row.put("status",             rs.getString("Status"));
                    row.put("startDate",          rs.getDate("StartDate"));
                    row.put("endDate",            rs.getDate("EndDate"));
                    row.put("orgName",            rs.getString("OrgName"));
                    row.put("maxVolunteers",      rs.getInt("MaxVolunteers"));
                    row.put("approvedVolunteers", rs.getInt("ApprovedVolunteers"));
                    row.put("pendingVolunteers",  rs.getInt("PendingVolunteers"));
                    row.put("totalFeedback",      rs.getInt("TotalFeedback"));
                    double avg = rs.getDouble("AvgRating");
                    row.put("avgRating", rs.wasNull() ? null : avg);
                    list.add(row);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Returns all impact reports, newest first. */
    public List<Map<String, Object>> getImpactReports() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT ir.ReportId, ir.EventId, e.Title AS EventTitle,
                   ir.Summary, ir.PeopleImpacted, ir.FundsRaised,
                   ir.CreatedAt, up.FullName AS CreatedByName
            FROM ImpactReports ir
            JOIN Events e ON e.EventId = ir.EventId
            JOIN Users u ON u.UserId = ir.CreatedBy
            JOIN UserProfiles up ON up.UserId = ir.CreatedBy
            ORDER BY ir.CreatedAt DESC
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("reportId",      rs.getInt("ReportId"));
                row.put("eventId",       rs.getInt("EventId"));
                row.put("eventTitle",    rs.getString("EventTitle"));
                row.put("summary",       rs.getString("Summary"));
                row.put("peopleImpacted",rs.getInt("PeopleImpacted"));
                row.put("fundsRaised",   rs.getBigDecimal("FundsRaised"));
                row.put("createdAt",     rs.getTimestamp("CreatedAt"));
                row.put("createdByName", rs.getString("CreatedByName"));
                list.add(row);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean createImpactReport(int eventId, int createdBy, String summary,
                                      int peopleImpacted, java.math.BigDecimal fundsRaised) {
        String sql = """
            INSERT INTO ImpactReports (EventId, CreatedBy, Summary, PeopleImpacted, FundsRaised, CreatedAt)
            VALUES (?, ?, ?, ?, ?, GETDATE())
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, createdBy);
            ps.setString(3, summary);
            ps.setInt(4, peopleImpacted);
            if (fundsRaised != null) ps.setBigDecimal(5, fundsRaised);
            else ps.setNull(5, Types.DECIMAL);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /** Summary counts for the hero stats bar. */
    public Map<String, Integer> getSummaryStats() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String sql = """
            SELECT
                COUNT(*) AS TotalEvents,
                SUM(CASE WHEN Status = 'Approved' THEN 1 ELSE 0 END) AS ApprovedEvents,
                (SELECT COUNT(*) FROM EventRegistrations WHERE Status = 'Approved') AS TotalParticipants,
                (SELECT COUNT(*) FROM EventComments WHERE IsDeleted = 0) AS TotalFeedback
            FROM Events
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("totalEvents",      rs.getInt("TotalEvents"));
                stats.put("approvedEvents",   rs.getInt("ApprovedEvents"));
                stats.put("totalParticipants",rs.getInt("TotalParticipants"));
                stats.put("totalFeedback",    rs.getInt("TotalFeedback"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
}
