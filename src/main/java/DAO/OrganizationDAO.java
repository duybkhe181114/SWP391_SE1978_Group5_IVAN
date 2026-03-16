package DAO;

import Context.DBContext;
import Entity.Organization;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrganizationDAO extends DBContext {

    // 1. Tạo tổ chức (Đã thêm LogoUrl)
    public boolean createOrganization(Organization org, int createdBy) {
        String sql = "INSERT INTO Organizations (Name, Description, Phone, Email, Address, Website, CreatedBy, LogoUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, org.getName());
            ps.setString(2, org.getDescription());
            ps.setString(3, org.getPhone());
            ps.setString(4, org.getEmail());
            ps.setString(5, org.getAddress());
            ps.setString(6, org.getWebsite());
            ps.setInt(7, createdBy);
            ps.setString(8, org.getLogoUrl());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getTopOrganizations() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP 3 OrganizationId, Name, LogoUrl, Description, Address FROM Organizations ORDER BY CreatedAt ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("OrganizationId", rs.getInt("OrganizationId"));
                map.put("Name", rs.getString("Name"));
                map.put("LogoUrl", rs.getString("LogoUrl"));

                map.put("Description", rs.getString("Description"));
                map.put("Address", rs.getString("Address"));

                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Map<String, Object> getOrgByUserId(int userId) {
        String sql = """
                SELECT o.OrganizationId, o.Name, o.Description, o.Phone, o.Email,
                       o.Address, o.Website, o.LogoUrl
                FROM Organizations o
                WHERE o.CreatedBy = ?
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("OrganizationId", rs.getInt("OrganizationId"));
                map.put("Name", rs.getString("Name"));
                map.put("Description", rs.getString("Description"));
                map.put("Phone", rs.getString("Phone"));
                map.put("Email", rs.getString("Email"));
                map.put("Address", rs.getString("Address"));
                map.put("Website", rs.getString("Website"));
                map.put("LogoUrl", rs.getString("LogoUrl"));
                return map;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public Map<String, Object> getOrganizationById(int id) {
        String sql = "SELECT OrganizationId, Name, Description, Phone, Email, Address, Website, CreatedAt, LogoUrl FROM Organizations WHERE OrganizationId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("OrganizationId", rs.getInt("OrganizationId"));
                map.put("Name", rs.getString("Name"));
                map.put("Description", rs.getString("Description"));
                map.put("Phone", rs.getString("Phone"));
                map.put("Email", rs.getString("Email"));
                map.put("Address", rs.getString("Address"));
                map.put("Website", rs.getString("Website"));
                map.put("CreatedAt", rs.getDate("CreatedAt"));
                map.put("LogoUrl", rs.getString("LogoUrl"));
                return map;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public Map<String, Integer> getOrganizationStats(int orgId) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalEvents", 0);
        stats.put("totalVolunteers", 0);

        String sqlEvents = "SELECT COUNT(*) FROM Events WHERE OrganizationId = ? AND Status = 'Approved'";
        String sqlVols = "SELECT COUNT(er.VolunteerId) FROM EventRegistrations er JOIN Events e ON er.EventId = e.EventId WHERE e.OrganizationId = ? AND er.Status = 'Approved'";

        try {
            try (PreparedStatement ps1 = connection.prepareStatement(sqlEvents)) {
                ps1.setInt(1, orgId);
                ResultSet rs1 = ps1.executeQuery();
                if (rs1.next()) stats.put("totalEvents", rs1.getInt(1));
            }
            try (PreparedStatement ps2 = connection.prepareStatement(sqlVols)) {
                ps2.setInt(1, orgId);
                ResultSet rs2 = ps2.executeQuery();
                if (rs2.next()) stats.put("totalVolunteers", rs2.getInt(1));
            }
        } catch (Exception e) { e.printStackTrace(); }

        return stats;
    }
}