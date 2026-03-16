package DAO;

import Context.DBContext;
import DTO.EventView;
import Entity.EventRegistration;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EventRegistrationDAO extends DBContext {

    public int[] getVolunteerStats(int volunteerId) {
        int[] stats = new int[3];
        String sql = """
            WITH LatestRegistration AS (
                SELECT er.*,
                       ROW_NUMBER() OVER (
                           PARTITION BY er.EventId, er.VolunteerId
                           ORDER BY er.AppliedAt DESC, er.RegistrationId DESC
                       ) AS rn
                FROM EventRegistrations er
                WHERE er.VolunteerId = ?
            )
            SELECT COUNT(*) AS TotalTracked,
                   SUM(CASE WHEN lr.Status = 'Approved' AND e.StartDate >= CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) AS Upcoming,
                   SUM(CASE WHEN lr.Status = 'Approved' AND e.EndDate < CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) AS Completed
            FROM LatestRegistration lr
            JOIN Events e ON e.EventId = lr.EventId
            WHERE lr.rn = 1
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats[0] = rs.getInt("TotalTracked");
                    stats[1] = rs.getInt("Upcoming");
                    stats[2] = rs.getInt("Completed");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<EventView> getMyRegisteredEvents(int volunteerId) {
        List<EventView> list = new ArrayList<>();
        String sql = """
            WITH LatestRegistration AS (
                SELECT er.*,
                       ROW_NUMBER() OVER (
                           PARTITION BY er.EventId, er.VolunteerId
                           ORDER BY er.AppliedAt DESC, er.RegistrationId DESC
                       ) AS rn
                FROM EventRegistrations er
                WHERE er.VolunteerId = ?
            )
            SELECT e.EventId,
                   e.Title,
                   e.Location,
                   e.StartDate,
                   e.EndDate,
                   lr.Status AS RegistrationStatus,
                   lr.AppliedAt
            FROM LatestRegistration lr
            JOIN Events e ON e.EventId = lr.EventId
            WHERE lr.rn = 1
            ORDER BY lr.AppliedAt DESC, e.EventId DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EventView event = new EventView();
                    event.setEventId(rs.getInt("EventId"));
                    event.setEventName(rs.getString("Title"));
                    event.setLocation(rs.getString("Location"));
                    event.setStatus(rs.getString("RegistrationStatus"));

                    java.sql.Date startDate = rs.getDate("StartDate");
                    if (startDate != null) {
                        event.setStartDate(startDate.toLocalDate().atStartOfDay());
                    }

                    java.sql.Date endDate = rs.getDate("EndDate");
                    if (endDate != null) {
                        event.setEndDate(endDate.toLocalDate().atStartOfDay());
                    }

                    list.add(event);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Map<String, Object>> getVolunteersByEvent(int eventId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT er.RegistrationId,
                   er.EventId,
                   er.VolunteerId,
                   er.RegistrationType,
                   er.Status,
                   er.AppliedAt,
                   er.ApplicationReason,
                   er.RelevantExperience,
                   er.CommitmentLevel,
                   er.AvailabilityNote,
                   er.InvitationMessage,
                   er.InvitedBy,
                   er.ReviewedAt,
                   er.ReviewedBy,
                   er.ReviewNote,
                   u.Email,
                   up.FullName,
                   up.Phone,
                   CASE WHEN ec.CoordinatorId IS NOT NULL THEN 1 ELSE 0 END AS IsCoordinator
            FROM EventRegistrations er
            JOIN Users u ON er.VolunteerId = u.UserId
            JOIN UserProfiles up ON u.UserId = up.UserId
            LEFT JOIN EventCoordinators ec
                ON ec.EventId = er.EventId
               AND ec.CoordinatorId = er.VolunteerId
               AND ec.Status = 'Active'
            WHERE er.EventId = ?
            ORDER BY
                CASE er.Status
                    WHEN 'Pending' THEN 1
                    WHEN 'Invited' THEN 2
                    WHEN 'Rejected' THEN 3
                    WHEN 'Declined' THEN 4
                    WHEN 'Approved' THEN 5
                    ELSE 6
                END,
                er.AppliedAt DESC,
                up.FullName ASC,
                u.Email ASC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("registrationId", rs.getInt("RegistrationId"));
                    row.put("eventId", rs.getInt("EventId"));
                    row.put("volunteerId", rs.getInt("VolunteerId"));
                    row.put("registrationType", rs.getString("RegistrationType"));
                    row.put("status", rs.getString("Status"));
                    row.put("appliedAt", rs.getTimestamp("AppliedAt"));
                    row.put("applicationReason", rs.getString("ApplicationReason"));
                    row.put("relevantExperience", rs.getString("RelevantExperience"));
                    row.put("commitmentLevel", rs.getString("CommitmentLevel"));
                    row.put("availabilityNote", rs.getString("AvailabilityNote"));
                    row.put("invitationMessage", rs.getString("InvitationMessage"));
                    row.put("invitedBy", rs.getObject("InvitedBy"));
                    row.put("reviewedAt", rs.getTimestamp("ReviewedAt"));
                    row.put("reviewedBy", rs.getObject("ReviewedBy"));
                    row.put("reviewNote", rs.getString("ReviewNote"));
                    row.put("fullName", rs.getString("FullName"));
                    row.put("email", rs.getString("Email"));
                    row.put("phone", rs.getString("Phone"));
                    row.put("isCoordinator", rs.getInt("IsCoordinator"));
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean approveVolunteer(int registrationId) {
        return approveVolunteer(registrationId, null);
    }

    public boolean approveVolunteer(int registrationId, Integer reviewerId) {
        String sql = """
            UPDATE EventRegistrations
            SET Status = 'Approved',
                ReviewedAt = GETDATE(),
                ReviewedBy = ?,
                ReviewNote = NULL
            WHERE RegistrationId = ?
              AND Status IN ('Pending', 'Invited')
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (reviewerId == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, reviewerId);
            }
            ps.setInt(2, registrationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectVolunteer(int registrationId, int reviewerId, String reviewNote) {
        String sql = """
            UPDATE EventRegistrations
            SET Status = 'Rejected',
                ReviewedBy = ?,
                ReviewedAt = GETDATE(),
                ReviewNote = ?
            WHERE RegistrationId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewerId);
            ps.setString(2, reviewNote);
            ps.setInt(3, registrationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean applyToEvent(int eventId, int volunteerId) {
        return applyToEvent(
                eventId,
                volunteerId,
                "Manual application submitted without volunteer self-description.",
                "Added from an internal management flow without extra details.",
                "Assigned shifts only",
                "Availability note was not provided in the legacy flow."
        );
    }

    public boolean applyToEvent(int eventId, int volunteerId,
                                String applicationReason,
                                String relevantExperience,
                                String commitmentLevel,
                                String availabilityNote) {
        String sql = """
            INSERT INTO EventRegistrations (
                EventId,
                VolunteerId,
                RegistrationType,
                Status,
                AppliedAt,
                ApplicationReason,
                RelevantExperience,
                CommitmentLevel,
                AvailabilityNote
            )
            SELECT ?, ?, 'Application', 'Pending', GETDATE(), ?, ?, ?, ?
            WHERE NOT EXISTS (
                SELECT 1
                FROM EventRegistrations
                WHERE EventId = ?
                  AND VolunteerId = ?
                  AND Status IN ('Pending', 'Approved', 'Invited')
            )
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ps.setString(3, applicationReason);
            ps.setString(4, relevantExperience);
            ps.setString(5, commitmentLevel);
            ps.setString(6, availabilityNote);
            ps.setInt(7, eventId);
            ps.setInt(8, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean inviteVolunteerToEvent(int eventId, int volunteerId, int invitedBy, String invitationMessage) {
        String sql = """
            INSERT INTO EventRegistrations (
                EventId,
                VolunteerId,
                RegistrationType,
                Status,
                AppliedAt,
                InvitationMessage,
                InvitedBy
            )
            SELECT ?, ?, 'Invitation', 'Invited', GETDATE(), ?, ?
            WHERE NOT EXISTS (
                SELECT 1
                FROM EventRegistrations
                WHERE EventId = ?
                  AND VolunteerId = ?
                  AND Status IN ('Pending', 'Approved', 'Invited')
            )
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ps.setString(3, invitationMessage);
            ps.setInt(4, invitedBy);
            ps.setInt(5, eventId);
            ps.setInt(6, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean acceptInvitation(int registrationId) {
        String sql = """
            UPDATE EventRegistrations
            SET Status = 'Approved',
                ReviewedAt = GETDATE(),
                ReviewedBy = COALESCE(InvitedBy, ReviewedBy),
                ReviewNote = NULL
            WHERE RegistrationId = ?
              AND Status = 'Invited'
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, registrationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean declineInvitation(int registrationId) {
        String sql = """
            UPDATE EventRegistrations
            SET Status = 'Declined',
                ReviewedAt = GETDATE(),
                ReviewNote = 'Invitation declined by volunteer.'
            WHERE RegistrationId = ?
              AND Status = 'Invited'
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, registrationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRegistration(int registrationId) {
        String sql = "DELETE FROM EventRegistrations WHERE RegistrationId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, registrationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean canApply(int eventId, int volunteerId) {
        String sql = """
            SELECT COUNT(*)
            FROM EventRegistrations
            WHERE EventId = ?
              AND VolunteerId = ?
              AND Status IN ('Pending', 'Approved', 'Invited')
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public EventRegistration getLatestRegistration(int eventId, int volunteerId) {
        String sql = """
            SELECT TOP 1
                   RegistrationId,
                   EventId,
                   VolunteerId,
                   RegistrationType,
                   Status,
                   AppliedAt,
                   ApplicationReason,
                   RelevantExperience,
                   CommitmentLevel,
                   AvailabilityNote,
                   InvitationMessage,
                   InvitedBy,
                   ReviewedAt,
                   ReviewedBy,
                   ReviewNote
            FROM EventRegistrations
            WHERE EventId = ?
              AND VolunteerId = ?
            ORDER BY AppliedAt DESC, RegistrationId DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRegistration(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String, Object>> getAvailableVolunteersForEvent(int eventId, String keyword) {
        List<Map<String, Object>> volunteers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT TOP 30
                   u.UserId AS VolunteerId,
                   u.Email,
                   up.FullName,
                   up.Phone,
                   up.Province,
                   STRING_AGG(s.SkillName, ', ') WITHIN GROUP (ORDER BY s.SkillName) AS Skills
            FROM Users u
            JOIN UserRoles ur
                ON ur.UserId = u.UserId
               AND ur.Role = 'Volunteer'
            JOIN UserProfiles up
                ON up.UserId = u.UserId
            LEFT JOIN VolunteerSkills vs
                ON vs.VolunteerId = u.UserId
            LEFT JOIN Skills s
                ON s.SkillId = vs.SkillId
            WHERE u.IsActive = 1
              AND NOT EXISTS (
                    SELECT 1
                    FROM EventRegistrations er
                    WHERE er.EventId = ?
                      AND er.VolunteerId = u.UserId
                      AND er.Status IN ('Pending', 'Approved', 'Invited')
              )
              AND NOT EXISTS (
                    SELECT 1
                    FROM EventCoordinators ec
                    WHERE ec.EventId = ?
                      AND ec.CoordinatorId = u.UserId
                      AND ec.Status = 'Active'
              )
        """);

        List<Object> params = new ArrayList<>();
        params.add(eventId);
        params.add(eventId);

        if (keyword != null && !keyword.isBlank()) {
            sql.append("""
                 AND (
                    up.FullName LIKE ?
                    OR u.Email LIKE ?
                    OR up.Phone LIKE ?
                    OR EXISTS (
                        SELECT 1
                        FROM VolunteerSkills vs2
                        JOIN Skills s2 ON s2.SkillId = vs2.SkillId
                        WHERE vs2.VolunteerId = u.UserId
                          AND s2.SkillName LIKE ?
                    )
                 )
            """);
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }

        sql.append("""
            GROUP BY u.UserId, u.Email, up.FullName, up.Phone, up.Province
            ORDER BY up.FullName ASC, u.Email ASC
        """);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> volunteer = new HashMap<>();
                    volunteer.put("volunteerId", rs.getInt("VolunteerId"));
                    volunteer.put("email", rs.getString("Email"));
                    volunteer.put("fullName", rs.getString("FullName"));
                    volunteer.put("phone", rs.getString("Phone"));
                    volunteer.put("province", rs.getString("Province"));
                    volunteer.put("skills", rs.getString("Skills"));
                    volunteers.add(volunteer);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return volunteers;
    }

    public int countAvailableVolunteersForEvent(int eventId) {
        String sql = """
            SELECT COUNT(*)
            FROM Users u
            JOIN UserRoles ur
                ON ur.UserId = u.UserId
               AND ur.Role = 'Volunteer'
            WHERE u.IsActive = 1
              AND NOT EXISTS (
                    SELECT 1
                    FROM EventRegistrations er
                    WHERE er.EventId = ?
                      AND er.VolunteerId = u.UserId
                      AND er.Status IN ('Pending', 'Approved', 'Invited')
              )
              AND NOT EXISTS (
                    SELECT 1
                    FROM EventCoordinators ec
                    WHERE ec.EventId = ?
                      AND ec.CoordinatorId = u.UserId
                      AND ec.Status = 'Active'
              )
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    private EventRegistration mapRegistration(ResultSet rs) throws SQLException {
        EventRegistration registration = new EventRegistration();
        registration.setRegistrationId(rs.getInt("RegistrationId"));
        registration.setEventId(rs.getInt("EventId"));
        registration.setVolunteerId(rs.getInt("VolunteerId"));
        registration.setRegistrationType(rs.getString("RegistrationType"));
        registration.setStatus(rs.getString("Status"));
        registration.setApplicationReason(rs.getString("ApplicationReason"));
        registration.setRelevantExperience(rs.getString("RelevantExperience"));
        registration.setCommitmentLevel(rs.getString("CommitmentLevel"));
        registration.setAvailabilityNote(rs.getString("AvailabilityNote"));
        registration.setInvitationMessage(rs.getString("InvitationMessage"));

        int invitedBy = rs.getInt("InvitedBy");
        if (!rs.wasNull()) {
            registration.setInvitedBy(invitedBy);
        }

        Timestamp appliedAt = rs.getTimestamp("AppliedAt");
        if (appliedAt != null) {
            registration.setAppliedAt(appliedAt.toLocalDateTime());
        }

        Timestamp reviewedAt = rs.getTimestamp("ReviewedAt");
        if (reviewedAt != null) {
            registration.setReviewedAt(reviewedAt.toLocalDateTime());
        }

        int reviewedBy = rs.getInt("ReviewedBy");
        if (!rs.wasNull()) {
            registration.setReviewedBy(reviewedBy);
        }

        registration.setReviewNote(rs.getString("ReviewNote"));
        return registration;
    }
}
