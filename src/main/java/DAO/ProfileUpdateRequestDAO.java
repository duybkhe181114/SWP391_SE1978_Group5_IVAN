package DAO;

import Context.DBContext;
import DTO.ProfileUpdateDTO;

import java.sql.*;
import java.util.List;

public class ProfileUpdateRequestDAO extends DBContext {

    public void createRequest(int userId, String firstName, String lastName, String phone,
                              String gender, String dob, String province, String address, String skillIds) {

        String sql = """
            INSERT INTO ProfileUpdateRequests 
            (UserId, NewFirstName, NewLastName, NewPhone, NewGender, NewDateOfBirth, NewProvince, NewAddress, NewSkillIds, Status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, firstName);
            ps.setString(3, lastName);
            ps.setString(4, phone);
            ps.setString(5, gender);

            if (dob != null && !dob.isEmpty()) {
                ps.setDate(6, Date.valueOf(dob));
            } else {
                ps.setNull(6, Types.DATE);
            }

            ps.setString(7, province);
            ps.setString(8, address);
            ps.setString(9, skillIds);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean hasPendingRequest(int userId) {
        String sql = "SELECT 1 FROM ProfileUpdateRequests WHERE UserId = ? AND Status = 'Pending'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 1. Lấy danh sách các Request đang Pending (Kèm dữ liệu cũ để so sánh)
    public List<ProfileUpdateDTO> getPendingRequests() {
        List<DTO.ProfileUpdateDTO> list = new java.util.ArrayList<>();
        String sql = """
            SELECT 
                r.RequestId, r.UserId, u.Email, r.RequestedAt,
                up.FirstName AS OldFirstName, up.LastName AS OldLastName, up.Phone AS OldPhone, 
                up.Province AS OldProvince, up.Address AS OldAddress,
                (SELECT STRING_AGG(CAST(SkillId AS VARCHAR), ',') FROM VolunteerSkills WHERE VolunteerId = r.UserId) AS OldSkillIds,
                r.NewFirstName, r.NewLastName, r.NewPhone, r.NewProvince, r.NewAddress, r.NewSkillIds
            FROM ProfileUpdateRequests r
            JOIN Users u ON r.UserId = u.UserId
            LEFT JOIN UserProfiles up ON r.UserId = up.UserId
            WHERE r.Status = 'Pending'
            ORDER BY r.RequestedAt ASC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DTO.ProfileUpdateDTO dto = new DTO.ProfileUpdateDTO();
                dto.setRequestId(rs.getInt("RequestId"));
                dto.setUserId(rs.getInt("UserId"));
                dto.setEmail(rs.getString("Email"));
                dto.setRequestedAt(rs.getTimestamp("RequestedAt"));

                dto.setOldFirstName(rs.getString("OldFirstName"));
                dto.setOldLastName(rs.getString("OldLastName"));
                dto.setOldPhone(rs.getString("OldPhone"));
                dto.setOldProvince(rs.getString("OldProvince"));
                dto.setOldAddress(rs.getString("OldAddress"));
                dto.setOldSkillIds(rs.getString("OldSkillIds"));

                dto.setNewFirstName(rs.getString("NewFirstName"));
                dto.setNewLastName(rs.getString("NewLastName"));
                dto.setNewPhone(rs.getString("NewPhone"));
                dto.setNewProvince(rs.getString("NewProvince"));
                dto.setNewAddress(rs.getString("NewAddress"));
                dto.setNewSkillIds(rs.getString("NewSkillIds"));

                list.add(dto);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 2. Hàm Approve Request
    public void approveRequest(int requestId, int adminId, String reviewNote) {
        String sqlGetRequest = "SELECT UserId, NewFirstName, NewLastName, NewPhone, NewProvince, NewAddress, NewSkillIds FROM ProfileUpdateRequests WHERE RequestId = ?";
        String sqlUpdateProfile = "UPDATE UserProfiles SET FirstName=?, LastName=?, Phone=?, Province=?, Address=?, UpdatedAt=SYSDATETIME() WHERE UserId=?";
        String sqlDeleteSkills = "DELETE FROM VolunteerSkills WHERE VolunteerId=?";
        String sqlInsertSkill = "INSERT INTO VolunteerSkills (VolunteerId, SkillId) VALUES (?, ?)";

        // Đã thêm ReviewNote=?
        String sqlUpdateRequest = "UPDATE ProfileUpdateRequests SET Status='Approved', ReviewedBy=?, ReviewedAt=GETDATE(), ReviewNote=? WHERE RequestId=?";

        try {
            connection.setAutoCommit(false);

            int userId = 0;
            String newFirst = "", newLast = "", newPhone = "", newProv = "", newAddr = "", newSkills = "";

            try (PreparedStatement psGet = connection.prepareStatement(sqlGetRequest)) {
                psGet.setInt(1, requestId);
                ResultSet rs = psGet.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("UserId");
                    newFirst = rs.getString("NewFirstName");
                    newLast = rs.getString("NewLastName");
                    newPhone = rs.getString("NewPhone");
                    newProv = rs.getString("NewProvince");
                    newAddr = rs.getString("NewAddress");
                    newSkills = rs.getString("NewSkillIds");
                }
            }

            if (userId > 0) {
                try (PreparedStatement psProf = connection.prepareStatement(sqlUpdateProfile)) {
                    psProf.setString(1, newFirst);
                    psProf.setString(2, newLast);
                    psProf.setString(3, newPhone);
                    psProf.setString(4, newProv);
                    psProf.setString(5, newAddr);
                    psProf.setInt(6, userId);
                    psProf.executeUpdate();
                }

                try (PreparedStatement psDel = connection.prepareStatement(sqlDeleteSkills)) {
                    psDel.setInt(1, userId);
                    psDel.executeUpdate();
                }

                if (newSkills != null && !newSkills.trim().isEmpty()) {
                    String[] skillArr = newSkills.split(",");
                    try (PreparedStatement psIns = connection.prepareStatement(sqlInsertSkill)) {
                        for (String sId : skillArr) {
                            psIns.setInt(1, userId);
                            psIns.setInt(2, Integer.parseInt(sId.trim()));
                            psIns.addBatch();
                        }
                        psIns.executeBatch();
                    }
                }
            }

            // SET PARAMETER CHO REQUEST
            try (PreparedStatement psReq = connection.prepareStatement(sqlUpdateRequest)) {
                psReq.setInt(1, adminId);
                psReq.setString(2, reviewNote); // Set note vào đây
                psReq.setInt(3, requestId);
                psReq.executeUpdate();
            }

            connection.commit();

        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }

    // 3. Hàm Reject Request
    public void rejectRequest(int requestId, int adminId, String reviewNote) {
        String sql = "UPDATE ProfileUpdateRequests SET Status='Rejected', ReviewedBy=?, ReviewedAt=GETDATE(), ReviewNote=? WHERE RequestId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setString(2, reviewNote); // Set note vào đây
            ps.setInt(3, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ProfileUpdateDTO> getHistoryByUserId(int userId) {
        List<ProfileUpdateDTO> list = new java.util.ArrayList<>();
        String sql = "SELECT RequestId, RequestedAt, Status, ReviewedAt, ReviewNote FROM ProfileUpdateRequests WHERE UserId = ? ORDER BY RequestedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProfileUpdateDTO dto = new ProfileUpdateDTO();
                dto.setRequestId(rs.getInt("RequestId"));
                dto.setRequestedAt(rs.getTimestamp("RequestedAt"));
                dto.setStatus(rs.getString("Status"));
                dto.setReviewedAt(rs.getTimestamp("ReviewedAt"));
                dto.setReviewNote(rs.getString("ReviewNote"));
                list.add(dto);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}