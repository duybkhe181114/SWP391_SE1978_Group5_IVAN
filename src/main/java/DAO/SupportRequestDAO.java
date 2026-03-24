package DAO;

import Context.DBContext;
import Entity.SupportRequest;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SupportRequestDAO extends DBContext {

    public List<SupportRequest> getApprovedSupportRequests() {
        List<SupportRequest> list = new ArrayList<>();

        String sql = """
                    SELECT r.RequestId, r.Title, r.CategoryId, c.Name AS CategoryName,
                           r.Priority, r.Status, r.SupportLocation,
                           r.BeneficiaryName, r.AffectedPeople, r.EstimatedAmount,
                           r.ContactEmail, r.ContactPhone, r.Description, r.CreatedAt
                    FROM SupportRequests r
                    LEFT JOIN SupportCategories c ON r.CategoryId = c.CategoryId
                    WHERE UPPER(r.Status) = 'APPROVED' AND r.IsDeleted = 0
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
                sr.setSupportLocation(rs.getString("SupportLocation"));
                sr.setBeneficiaryName(rs.getString("BeneficiaryName"));
                sr.setAffectedPeople((Integer) rs.getObject("AffectedPeople"));
                BigDecimal amt1 = (BigDecimal) rs.getObject("EstimatedAmount");
                sr.setEstimatedAmount(amt1 != null ? amt1.doubleValue() : null);
                sr.setContactEmail(rs.getString("ContactEmail"));
                sr.setContactPhone(rs.getString("ContactPhone"));
                sr.setDescription(rs.getString("Description"));

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
                    BigDecimal amt2 = (BigDecimal) rs.getObject("EstimatedAmount");
                    sr.setEstimatedAmount(amt2 != null ? amt2.doubleValue() : null);
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

                    if (created != null)
                        sr.setCreatedAt(created.toLocalDateTime());
                    if (updated != null)
                        sr.setUpdatedAt(updated.toLocalDateTime());
                    if (reviewed != null)
                        sr.setReviewedAt(reviewed.toLocalDateTime());

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
                    SELECT r.*, c.Name AS CategoryName
                    FROM SupportRequests r
                    LEFT JOIN SupportCategories c ON r.CategoryId = c.CategoryId
                    WHERE r.RequestId = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SupportRequest r = new SupportRequest();
                    r.setRequestId(rs.getInt("RequestId"));
                    r.setTitle(rs.getString("Title"));
                    r.setDescription(rs.getString("Description"));
                    r.setCategoryId(String.valueOf(rs.getInt("CategoryId")));
                    r.setCategoryName(rs.getString("CategoryName"));
                    r.setPriority(rs.getString("Priority"));
                    r.setSupportLocation(rs.getString("SupportLocation"));
                    r.setBeneficiaryName(rs.getString("BeneficiaryName"));
                    r.setAffectedPeople((Integer) rs.getObject("AffectedPeople"));
                    BigDecimal amt = (BigDecimal) rs.getObject("EstimatedAmount");
                    r.setEstimatedAmount(amt != null ? amt.doubleValue() : null);
                    r.setContactEmail(rs.getString("ContactEmail"));
                    r.setContactPhone(rs.getString("ContactPhone"));
                    r.setProofImageUrl(rs.getString("ProofUrl"));
                    r.setStatus(rs.getString("Status"));
                    r.setRejectReason(rs.getString("RejectReason"));
                    r.setAdminNote(rs.getString("AdminNote"));
                    r.setCreatedBy(rs.getInt("CreatedBy"));
                    r.setReviewedBy((Integer) rs.getObject("ReviewedBy"));
                    Timestamp created = rs.getTimestamp("CreatedAt");
                    if (created != null) r.setCreatedAt(created.toLocalDateTime());
                    return r;
                }
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
    }

    public void approveRequestvunh(int requestId) {

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
    }

    public void rejectRequestvunh(int requestId, String rejectReason) {

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

    public List<SupportRequest> getAcceptedByOrg(int orgUserId) {

        List<SupportRequest> list = new ArrayList<>();

        String sql = """
                    SELECT r.RequestId, r.Title, r.CategoryId, c.Name AS CategoryName,
                           r.Priority, r.Status, r.SupportLocation,
                           r.BeneficiaryName, r.AffectedPeople, r.EstimatedAmount,
                           r.ContactEmail, r.ContactPhone, r.ReviewedAt
                    FROM SupportRequests r
                    LEFT JOIN SupportCategories c ON r.CategoryId = c.CategoryId
                    WHERE r.Status = 'ACCEPTED'
                      AND r.ReviewedBy = ?
                      AND r.IsDeleted = 0
                    ORDER BY r.ReviewedAt DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, orgUserId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SupportRequest sr = new SupportRequest();
                    sr.setRequestId(rs.getInt("RequestId"));
                    sr.setTitle(rs.getString("Title"));
                    sr.setCategoryId(rs.getString("CategoryId"));
                    sr.setCategoryName(rs.getString("CategoryName"));
                    sr.setPriority(rs.getString("Priority"));
                    sr.setStatus(rs.getString("Status"));
                    sr.setSupportLocation(rs.getString("SupportLocation"));
                    sr.setBeneficiaryName(rs.getString("BeneficiaryName"));
                    sr.setAffectedPeople(rs.getInt("AffectedPeople"));
                    BigDecimal amt = (BigDecimal) rs.getObject("EstimatedAmount");
                    sr.setEstimatedAmount(amt != null ? amt.doubleValue() : null);
                    sr.setContactEmail(rs.getString("ContactEmail"));
                    sr.setContactPhone(rs.getString("ContactPhone"));
                    Timestamp reviewed = rs.getTimestamp("ReviewedAt");
                    if (reviewed != null) sr.setReviewedAt(reviewed.toLocalDateTime());
                    list.add(sr);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void acceptRequest(int requestId, int organizationUserId) {

        String sql = """
                    UPDATE SupportRequests
                    SET Status = 'ACCEPTED',
                        ReviewedAt = GETDATE(),
                        ReviewedBy = ?,
                        UpdatedAt = GETDATE()
                    WHERE RequestId = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, organizationUserId);
            ps.setInt(2, requestId);

            int rows = ps.executeUpdate();
            System.out.println("Accept updated rows: " + rows);

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

                if (created != null)
                    sr.setCreatedAt(created.toLocalDateTime());
                if (updated != null)
                    sr.setUpdatedAt(updated.toLocalDateTime());
                if (reviewed != null)
                    sr.setReviewedAt(reviewed.toLocalDateTime());

                sr.setReviewedBy((Integer) rs.getObject("ReviewedBy"));
                sr.setIsDeleted(rs.getBoolean("IsDeleted"));

                return sr;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void update(SupportRequest sr) {
        String sql = """
                    UPDATE SupportRequests
                    SET Title = ?, CategoryId = ?, Priority = ?, SupportLocation = ?,
                        BeneficiaryName = ?, AffectedPeople = ?, EstimatedAmount = ?,
                        Description = ?, ContactEmail = ?, ContactPhone = ?,
                        Status = 'PENDING',
                        RejectReason = NULL, AdminNote = NULL,
                        ReviewedAt = NULL, ReviewedBy = NULL, UpdatedAt = GETDATE()
                    WHERE RequestId = ? AND CreatedBy = ? AND Status IN ('REJECTED', 'PENDING')
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, sr.getTitle());
            if (sr.getCategoryId() != null && !sr.getCategoryId().trim().isEmpty())
                ps.setInt(2, Integer.parseInt(sr.getCategoryId()));
            else
                ps.setNull(2, Types.INTEGER);
            ps.setString(3, sr.getPriority());
            ps.setString(4, sr.getSupportLocation());
            ps.setString(5, sr.getBeneficiaryName());
            if (sr.getAffectedPeople() != null) ps.setInt(6, sr.getAffectedPeople());
            else ps.setNull(6, Types.INTEGER);
            if (sr.getEstimatedAmount() != null) ps.setDouble(7, sr.getEstimatedAmount());
            else ps.setNull(7, Types.DOUBLE);
            ps.setString(8, sr.getDescription());
            ps.setString(9, sr.getContactEmail());
            ps.setString(10, sr.getContactPhone());
            ps.setInt(11, sr.getRequestId());
            ps.setInt(12, sr.getCreatedBy());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void resubmit(int requestId, int userId) {
        String sql = """
                    UPDATE SupportRequests
                    SET Status = 'PENDING',
                        RejectReason = NULL,
                        ReviewedAt = NULL,
                        ReviewedBy = NULL,
                        UpdatedAt = GETDATE()
                    WHERE RequestId = ? AND CreatedBy = ? AND Status = 'REJECTED'
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<SupportRequest> getAllByUser(int userId) {

        List<SupportRequest> list = new ArrayList<>();

        String sql = """
                    SELECT r.RequestId, r.Title, r.CategoryId, c.Name AS CategoryName,
                           r.Priority, r.Status, r.SupportLocation,
                           r.BeneficiaryName, r.AffectedPeople, r.EstimatedAmount,
                           r.CreatedBy, r.CreatedAt, r.RejectReason
                    FROM SupportRequests r
                    LEFT JOIN SupportCategories c ON r.CategoryId = c.CategoryId
                    WHERE r.CreatedBy = ? AND r.IsDeleted = 0
                    ORDER BY r.CreatedAt DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    SupportRequest sr = new SupportRequest();

                    sr.setRequestId(rs.getInt("RequestId"));
                    sr.setTitle(rs.getString("Title"));
                    sr.setCategoryId(rs.getString("CategoryId"));
                    sr.setCategoryName(rs.getString("CategoryName"));
                    sr.setPriority(rs.getString("Priority"));
                    sr.setStatus(rs.getString("Status"));
                    sr.setSupportLocation(rs.getString("SupportLocation"));
                    sr.setBeneficiaryName(rs.getString("BeneficiaryName"));
                    sr.setAffectedPeople(rs.getInt("AffectedPeople"));
                    sr.setEstimatedAmount(rs.getDouble("EstimatedAmount"));
                    sr.setCreatedBy(rs.getInt("CreatedBy"));
                    sr.setRejectReason(rs.getString("RejectReason"));

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
}
