package DAO;

import Context.DBContext;
import Entity.EventComment;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EventCommentDAO extends DBContext {

    public List<EventComment> getCommentsByEventId(int eventId, Integer ratingFilter, String sortOrder) {
        List<EventComment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT ec.CommentId,
                   ec.EventId,
                   ec.UserId,
                   ec.Comment,
                   ec.Rating,
                   ec.CreatedAt,
                   ec.UpdatedAt,
                   up.FullName AS UserName
            FROM EventComments ec
            JOIN UserProfiles up ON ec.UserId = up.UserId
            WHERE ec.EventId = ?
              AND ec.IsDeleted = 0
        """);

        if (ratingFilter != null && ratingFilter > 0) {
            sql.append(" AND ec.Rating = ?");
        }

        sql.append(" ORDER BY ec.CreatedAt ");
        sql.append("oldest".equals(sortOrder) ? "ASC" : "DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setInt(1, eventId);
            if (ratingFilter != null && ratingFilter > 0) {
                ps.setInt(2, ratingFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EventComment comment = new EventComment();
                    comment.setCommentId(rs.getInt("CommentId"));
                    comment.setEventId(rs.getInt("EventId"));
                    comment.setUserId(rs.getInt("UserId"));
                    comment.setComment(rs.getString("Comment"));
                    comment.setRating(rs.getInt("Rating"));
                    comment.setUserName(rs.getString("UserName"));
                    comment.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    comment.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    list.add(comment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addComment(int eventId, int userId, String comment, int rating) {
        String sql = """
            INSERT INTO EventComments (EventId, UserId, Comment, Rating, CreatedAt, UpdatedAt, IsDeleted)
            VALUES (?, ?, ?, ?, GETDATE(), GETDATE(), 0)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            ps.setString(3, comment);
            ps.setInt(4, rating);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean canComment(int eventId, int userId) {
        String sql = """
            SELECT COUNT(*)
            FROM EventRegistrations er
            JOIN Events e ON e.EventId = er.EventId
            WHERE er.EventId = ?
              AND er.VolunteerId = ?
              AND er.Status = 'Approved'
              AND (
                    e.Status = 'Closed'
                    OR (e.EndDate IS NOT NULL AND e.EndDate < CAST(GETDATE() AS DATE))
                  )
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Double getAverageRating(int eventId) {
        String sql = "SELECT AVG(CAST(Rating AS FLOAT)) FROM EventComments WHERE EventId = ? AND IsDeleted = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
