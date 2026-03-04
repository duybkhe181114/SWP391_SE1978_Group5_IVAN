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
                sr.setCategoryId(rs.getString("CategoryId"));
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
    public void insert(SupportRequest sr) {

        String sql = """
        INSERT INTO SupportRequests (
            Title, CategoryId, Priority, SupportLocation,
            BeneficiaryName, AffectedPeople, EstimatedAmount,
            Description, ProofUrl, ContactEmail, ContactPhone,
            CreatedBy, Status, CreatedAt, UpdatedAt, IsDeleted
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, sr.getTitle());

            // CategoryId
            if (sr.getCategoryId() != null && !sr.getCategoryId().trim().isEmpty())
                ps.setInt(2, Integer.parseInt(sr.getCategoryId()));
            else
                ps.setNull(2, Types.INTEGER);

            ps.setString(3, sr.getPriority());
            ps.setString(4, sr.getSupportLocation());
            ps.setString(5, sr.getBeneficiaryName());

            if (sr.getAffectedPeople() != null)
                ps.setInt(6, sr.getAffectedPeople());
            else
                ps.setNull(6, Types.INTEGER);

            if (sr.getEstimatedAmount() != null)
                ps.setDouble(7, sr.getEstimatedAmount());
            else
                ps.setNull(7, Types.DOUBLE);

            ps.setString(8, sr.getDescription());
            ps.setString(9, sr.getProofImageUrl());
            ps.setString(10, sr.getContactEmail());
            ps.setString(11, sr.getContactPhone());

            if (sr.getCreatedBy() != null)
                ps.setInt(12, sr.getCreatedBy());
            else
                ps.setNull(12, Types.INTEGER);

            ps.setString(13, sr.getStatus());

            ps.setTimestamp(14, new Timestamp(System.currentTimeMillis()));
            ps.setTimestamp(15, new Timestamp(System.currentTimeMillis()));

            ps.setBoolean(16, sr.getIsDeleted() != null ? sr.getIsDeleted() : false);

            ps.executeUpdate();

            System.out.println("INSERT SUCCESS");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<SupportRequest> getALLSPRForAdmin() {

        List<SupportRequest> list = new ArrayList<>();

        String sql = """
    SELECT r.RequestId,
           r.Title,
           r.CategoryId,
           c.Name AS CategoryName,
           r.Priority,
           r.Status,
           r.BeneficiaryName,
           r.SupportLocation,
           r.AffectedPeople,
           r.EstimatedAmount,
           r.CreatedBy,
           r.CreatedAt
    FROM SupportRequests r
    LEFT JOIN SupportCategories c
           ON r.CategoryId = c.CategoryId
    WHERE r.IsDeleted = 0
    ORDER BY r.CreatedAt DESC
""";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                SupportRequest sr = new SupportRequest();

                sr.setRequestId(rs.getInt("RequestId"));
                sr.setTitle(rs.getString("Title"));
                sr.setCategoryId(rs.getString("CategoryId"));
                sr.setCategoryName(rs.getString("CategoryName"));
                sr.setPriority(rs.getString("Priority"));
                sr.setStatus(rs.getString("Status"));

                sr.setBeneficiaryName(rs.getString("BeneficiaryName"));
                sr.setSupportLocation(rs.getString("SupportLocation"));
                sr.setAffectedPeople(rs.getInt("AffectedPeople"));
                sr.setEstimatedAmount(rs.getDouble("EstimatedAmount"));
                sr.setCreatedBy(rs.getInt("CreatedBy"));

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
    public SupportRequest getById(int requestId) {

        String sql = """
SELECT r.*, c.Name AS CategoryName
FROM SupportRequests r
LEFT JOIN SupportCategories c
ON r.CategoryId = c.CategoryId
WHERE r.RequestId = ? AND r.IsDeleted = 0
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, requestId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    SupportRequest sr = new SupportRequest();

                    sr.setRequestId(rs.getInt("RequestId"));
                    sr.setTitle(rs.getString("Title"));
                    sr.setDescription(rs.getString("Description"));
                    sr.setCategoryId(rs.getString("CategoryId"));
                    sr.setPriority(rs.getString("Priority"));
                    sr.setSupportLocation(rs.getString("SupportLocation"));
                    sr.setBeneficiaryName(rs.getString("BeneficiaryName"));
                    sr.setAffectedPeople((Integer) rs.getObject("AffectedPeople"));
                    sr.setEstimatedAmount((Double) rs.getObject("EstimatedAmount"));
                    sr.setContactEmail(rs.getString("ContactEmail"));
                    sr.setContactPhone(rs.getString("ContactPhone"));
                    sr.setProofImageUrl(rs.getString("ProofUrl"));
                    sr.setStatus(rs.getString("Status"));
                    sr.setRejectReason(rs.getString("RejectReason"));
                    sr.setAdminNote(rs.getString("AdminNote"));
                    sr.setCreatedBy(rs.getInt("CreatedBy"));

                    Timestamp created = rs.getTimestamp("CreatedAt");
                    Timestamp updated = rs.getTimestamp("UpdatedAt");
                    Timestamp reviewed = rs.getTimestamp("ReviewedAt");

                    if (created != null) sr.setCreatedAt(created.toLocalDateTime());
                    if (updated != null) sr.setUpdatedAt(updated.toLocalDateTime());
                    if (reviewed != null) sr.setReviewedAt(reviewed.toLocalDateTime());

                    sr.setReviewedBy((Integer) rs.getObject("ReviewedBy"));
                    sr.setIsDeleted(rs.getBoolean("IsDeleted"));

                    return sr;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public void approveRequest(int requestId, int adminId, String adminNote) {

        String sql = """
        UPDATE SupportRequests
        SET Status = 'APPROVED',
            AdminNote = ?,
            ReviewedAt = ?,
            ReviewedBy = ?,
            UpdatedAt = ?
        WHERE RequestId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            LocalDateTime now = LocalDateTime.now();

            ps.setString(1, adminNote);
            ps.setTimestamp(2, Timestamp.valueOf(now));
            ps.setInt(3, adminId);
            ps.setTimestamp(4, Timestamp.valueOf(now));
            ps.setInt(5, requestId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void rejectRequest(int requestId,
                              int adminId,
                              String rejectReason,
                              String adminNote) {

        String sql = """
        UPDATE SupportRequests
        SET Status = 'REJECTED',
            RejectReason = ?,
            AdminNote = ?,
            ReviewedAt = ?,
            ReviewedBy = ?,
            UpdatedAt = ?
        WHERE RequestId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            LocalDateTime now = LocalDateTime.now();

            ps.setString(1, rejectReason);
            ps.setString(2, adminNote);
            ps.setTimestamp(3, Timestamp.valueOf(now));
            ps.setInt(4, adminId);
            ps.setTimestamp(5, Timestamp.valueOf(now));
            ps.setInt(6, requestId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<SupportRequest> getByStatus(String status) {

        List<SupportRequest> list = new ArrayList<>();

        String sql = """
        SELECT RequestId, Title, CategoryId, Priority, Status, CreatedAt
        FROM SupportRequests
        WHERE Status = ? AND IsDeleted = 0
        ORDER BY CreatedAt DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    SupportRequest sr = new SupportRequest();

                    sr.setRequestId(rs.getInt("RequestId"));
                    sr.setTitle(rs.getString("Title"));
                    sr.setCategoryId(rs.getString("CategoryId"));
                    sr.setPriority(rs.getString("Priority"));
                    sr.setStatus(rs.getString("Status"));

                    Timestamp created = rs.getTimestamp("CreatedAt");
                    if (created != null) {
                        sr.setCreatedAt(created.toLocalDateTime());
                    }

                    list.add(sr);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<SupportRequest> getApprovedByUser(int userId) {

        List<SupportRequest> list = new ArrayList<>();

        String sql = """
        SELECT RequestId, Title, CategoryId, Priority, Status, CreatedAt
        FROM SupportRequests
        WHERE CreatedBy = ?
          AND Status = 'APPROVED'
          AND IsDeleted = 0
        ORDER BY CreatedAt DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    SupportRequest sr = new SupportRequest();

                    sr.setRequestId(rs.getInt("RequestId"));
                    sr.setTitle(rs.getString("Title"));
                    sr.setCategoryId(rs.getString("CategoryId"));
                    sr.setPriority(rs.getString("Priority"));
                    sr.setStatus(rs.getString("Status"));

                    Timestamp created = rs.getTimestamp("CreatedAt");
                    if (created != null) {
                        sr.setCreatedAt(created.toLocalDateTime());
                    }

                    list.add(sr);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public SupportRequest getSPRById(int id) {

        String sql = """
        SELECT *
        FROM SupportRequests
        WHERE RequestId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                SupportRequest r = new SupportRequest();

                r.setRequestId(rs.getInt("RequestId"));
                r.setTitle(rs.getString("Title"));
                r.setDescription(rs.getString("Description"));
                r.setCategoryId(rs.getString("CategoryId"));
                r.setPriority(rs.getString("Priority"));
                r.setSupportLocation(rs.getString("SupportLocation"));
                r.setBeneficiaryName(rs.getString("BeneficiaryName"));
                r.setAffectedPeople((Integer) rs.getObject("AffectedPeople"));
                r.setEstimatedAmount(rs.getDouble("EstimatedAmount"));
                r.setContactEmail(rs.getString("ContactEmail"));
                r.setContactPhone(rs.getString("ContactPhone"));
                r.setProofImageUrl(rs.getString("ProofUrl"));
                r.setStatus(rs.getString("Status"));
                r.setRejectReason(rs.getString("RejectReason"));
                r.setAdminNote(rs.getString("AdminNote"));
                r.setCreatedBy(rs.getInt("CreatedBy"));

                return r;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public void updateStatus(int requestId,
                             String status,
                             String rejectReason) {

        String sql = """
        UPDATE SupportRequests
        SET status = ?,
            rejectReason = ?,
            reviewedAt = GETDATE()
        WHERE requestId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, status);

            if (rejectReason != null) {
                ps.setString(2, rejectReason);
            } else {
                ps.setNull(2, java.sql.Types.VARCHAR);
            }

            ps.setInt(3, requestId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }public void approveRequestvunh(int requestId) {

        String sql = """
        UPDATE SupportRequests
        SET Status = 'APPROVED',
            ReviewedAt = GETDATE(),
            ReviewedBy = 1,
            UpdatedAt = GETDATE()
        WHERE RequestId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, requestId);

            int rows = ps.executeUpdate();
            System.out.println("Approve updated rows: " + rows);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }public void rejectRequestvunh(int requestId, String rejectReason) {

        String sql = """
        UPDATE SupportRequests
        SET Status = 'REJECTED',
            RejectReason = ?,
            ReviewedAt = GETDATE(),
            ReviewedBy = 1,
            UpdatedAt = GETDATE()
        WHERE RequestId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, rejectReason);
            ps.setInt(2, requestId);

            int rows = ps.executeUpdate();
            System.out.println("Reject updated rows: " + rows);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public SupportRequest getByIdvunh(int requestId) {

        String sql = """
        SELECT r.*, c.Name AS CategoryName
        FROM SupportRequests r
        LEFT JOIN SupportCategories c
               ON r.CategoryId = c.CategoryId
        WHERE r.RequestId = ? 
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, requestId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                SupportRequest sr = new SupportRequest();

                sr.setRequestId(rs.getInt("RequestId"));
                sr.setTitle(rs.getString("Title"));
                sr.setDescription(rs.getString("Description"));
                sr.setCategoryId(rs.getString("CategoryId"));
                sr.setCategoryName(rs.getString("CategoryName"));
                sr.setPriority(rs.getString("Priority"));
                sr.setSupportLocation(rs.getString("SupportLocation"));
                sr.setBeneficiaryName(rs.getString("BeneficiaryName"));
                sr.setAffectedPeople(rs.getInt("AffectedPeople"));
                sr.setEstimatedAmount(rs.getDouble("EstimatedAmount"));
                sr.setContactEmail(rs.getString("ContactEmail"));
                sr.setContactPhone(rs.getString("ContactPhone"));
                sr.setProofImageUrl(rs.getString("ProofUrl"));
                sr.setStatus(rs.getString("Status"));
                sr.setRejectReason(rs.getString("RejectReason"));
                sr.setAdminNote(rs.getString("AdminNote"));
                sr.setCreatedBy(rs.getInt("CreatedBy"));

                Timestamp created = rs.getTimestamp("CreatedAt");
                Timestamp updated = rs.getTimestamp("UpdatedAt");
                Timestamp reviewed = rs.getTimestamp("ReviewedAt");

                if (created != null) sr.setCreatedAt(created.toLocalDateTime());
                if (updated != null) sr.setUpdatedAt(updated.toLocalDateTime());
                if (reviewed != null) sr.setReviewedAt(reviewed.toLocalDateTime());

                sr.setReviewedBy((Integer) rs.getObject("ReviewedBy"));
                sr.setIsDeleted(rs.getBoolean("IsDeleted"));

                return sr;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
