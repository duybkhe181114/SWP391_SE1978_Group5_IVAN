package DAO;

import Context.DBContext;
import Entity.EventComment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventCommentDAO extends DBContext {

    public List<EventComment> getCommentsByEventId(int eventId, Integer ratingFilter, String sortOrder) {
        List<EventComment> list = new ArrayList<>();
        String sql = "SELECT ec.CommentId, ec.EventId, ec.UserId, ec.Comment, ec.Rating, ec.CreatedAt, ec.UpdatedAt, " +
                     "up.FullName AS UserName " +
                     "FROM EventComments ec " +
                     "JOIN UserProfiles up ON ec.UserId = up.UserId " +
                     "WHERE ec.EventId = ? AND ec.IsDeleted = 0";
        
        if (ratingFilter != null && ratingFilter > 0) {
            sql += " AND ec.Rating = ?";
        }
        
        sql += " ORDER BY ec.CreatedAt " + ("oldest".equals(sortOrder) ? "ASC" : "DESC");
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            if (ratingFilter != null && ratingFilter > 0) {
                ps.setInt(2, ratingFilter);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EventComment ec = new EventComment();
                ec.setCommentId(rs.getInt("CommentId"));
                ec.setEventId(rs.getInt("EventId"));
                ec.setUserId(rs.getInt("UserId"));
                ec.setComment(rs.getString("Comment"));
                ec.setRating(rs.getInt("Rating"));
                ec.setUserName(rs.getString("UserName"));
                ec.setCreatedAt(rs.getTimestamp("CreatedAt"));
                ec.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                
                list.add(ec);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean addComment(int eventId, int userId, String comment, int rating) {
        String sql = "INSERT INTO EventComments (EventId, UserId, Comment, Rating, CreatedAt, UpdatedAt, IsDeleted) " +
                     "VALUES (?, ?, ?, ?, GETDATE(), GETDATE(), 0)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            ps.setString(3, comment);
            ps.setInt(4, rating);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean canComment(int eventId, int userId) {
        String sql = "SELECT COUNT(*) FROM EventRegistrations WHERE EventId = ? AND VolunteerId = ? AND Status = 'Approved'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public Double getAverageRating(int eventId) {
        String sql = "SELECT AVG(CAST(Rating AS FLOAT)) FROM EventComments WHERE EventId = ? AND IsDeleted = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}
