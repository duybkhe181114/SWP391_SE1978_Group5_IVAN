package DAO;

import Context.DBContext;
import Entity.SupportRequest;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SupportRequestDAO extends DBContext {

    public List<SupportRequest> getApprovedSupportRequests() {
        List<SupportRequest> list = new ArrayList<>();

        String sql = """
            SELECT request_id,
                   category_id,
                   subject,
                   description,
                   status,
                   created_at
            FROM SupportRequest
            WHERE status = 'APPROVED'
            ORDER BY created_at DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SupportRequest sr = new SupportRequest();
                sr.setRequestId(rs.getInt("request_id"));
                sr.setCategoryId(rs.getInt("category_id"));
                sr.setSubject(rs.getString("subject"));
                sr.setDescription(rs.getString("description"));
                sr.setStatus(rs.getString("status"));

                Timestamp created = rs.getTimestamp("created_at");
                if (created != null) {
                    sr.setCreatedAt(created.toLocalDateTime());
                }

                list.add(sr);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
