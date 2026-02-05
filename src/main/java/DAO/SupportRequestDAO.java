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
            SELECT RequestId,
                   CategoryId,
                   Description,
                   Status,
                   CreatedAt
            FROM SupportRequests
            WHERE Status = 'Approved'
            ORDER BY CreatedAt DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SupportRequest sr = new SupportRequest();
                sr.setRequestId(rs.getInt("RequestId"));
                sr.setCategoryId(rs.getInt("CategoryId"));
                sr.setDescription(rs.getString("Description"));
                sr.setStatus(rs.getString("Status"));

                Timestamp created = rs.getTimestamp("CreatedAt");
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
