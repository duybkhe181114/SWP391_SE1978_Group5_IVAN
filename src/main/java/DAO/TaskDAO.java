package DAO;

import Context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TaskDAO extends DBContext {

    // ─────────────────────────────────────────────────────────────
    // ASSIGN
    // ─────────────────────────────────────────────────────────────

    /**
     * Assign a FLEXIBLE task.
     * Inserts into Tasks (DueDate) and Schedules (WorkDate = date part of dueDate, no times).
     */
    public boolean assignFlexibleTask(int eventId, int coordinatorId, int volunteerId,
                                      String description, String priority,
                                      String dueDateStr, String location) {
        String insertTask = "INSERT INTO Tasks "
                + "(EventId, CoordinatorId, VolunteerId, TaskDescription, Status, Priority, "
                + " TaskType, DueDate, Location, AssignedAt) "
                + "VALUES (?, ?, ?, ?, 'Pending', ?, 'FLEXIBLE', ?, ?, GETDATE())";
        String insertSched = "INSERT INTO Schedules (TaskId, WorkDate, CreatedAt) VALUES (?, ?, GETDATE())";

        try {
            connection.setAutoCommit(false);

            int newTaskId = 0;
            try (PreparedStatement ps = connection.prepareStatement(insertTask, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, eventId);
                ps.setInt(2, coordinatorId);
                ps.setInt(3, volunteerId);
                ps.setString(4, description);
                ps.setString(5, priority != null ? priority : "Medium");
                ps.setString(6, dueDateStr);           // full datetime string
                ps.setString(7, location);              // may be null
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) newTaskId = rs.getInt(1);
            }

            if (newTaskId > 0) {
                // WorkDate = date part of dueDate
                java.sql.Date workDate = java.sql.Date.valueOf(dueDateStr.substring(0, 10));
                try (PreparedStatement ps = connection.prepareStatement(insertSched)) {
                    ps.setInt(1, newTaskId);
                    ps.setDate(2, workDate);
                    ps.executeUpdate();
                }
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return false;
    }

    /**
     * Assign a SCHEDULED task.
     * Inserts into Tasks (StartTime, EndTime) and Schedules (WorkDate, StartTime, EndTime).
     */
    public boolean assignScheduledTask(int eventId, int coordinatorId, int volunteerId,
                                       String description, String priority,
                                       String startDateTimeStr, String endDateTimeStr, String location) {
        String insertTask = "INSERT INTO Tasks "
                + "(EventId, CoordinatorId, VolunteerId, TaskDescription, Status, Priority, "
                + " TaskType, StartTime, EndTime, Location, AssignedAt) "
                + "VALUES (?, ?, ?, ?, 'Pending', ?, 'SCHEDULED', ?, ?, ?, GETDATE())";
        String insertSched = "INSERT INTO Schedules (TaskId, WorkDate, StartTime, EndTime, CreatedAt) "
                + "VALUES (?, ?, ?, ?, GETDATE())";

        try {
            connection.setAutoCommit(false);

            int newTaskId = 0;
            try (PreparedStatement ps = connection.prepareStatement(insertTask, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, eventId);
                ps.setInt(2, coordinatorId);
                ps.setInt(3, volunteerId);
                ps.setString(4, description);
                ps.setString(5, priority != null ? priority : "Medium");
                ps.setString(6, startDateTimeStr);
                ps.setString(7, endDateTimeStr);
                ps.setString(8, location);
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) newTaskId = rs.getInt(1);
            }

            if (newTaskId > 0) {
                java.sql.Date workDate = java.sql.Date.valueOf(startDateTimeStr.substring(0, 10));
                // Extract time portion (HH:mm) from datetime strings for Schedules
                String startTimePart = startDateTimeStr.substring(11, 16); // HH:mm
                String endTimePart = endDateTimeStr.substring(11, 16);
                try (PreparedStatement ps = connection.prepareStatement(insertSched)) {
                    ps.setInt(1, newTaskId);
                    ps.setDate(2, workDate);
                    ps.setTime(3, Time.valueOf(startTimePart + ":00"));
                    ps.setTime(4, Time.valueOf(endTimePart + ":00"));
                    ps.executeUpdate();
                }
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return false;
    }

    // ─────────────────────────────────────────────────────────────
    // VOLUNTEER ACTIONS
    // ─────────────────────────────────────────────────────────────

    /**
     * FLEXIBLE: Volunteer accepts task → AcceptedAt = now, Status = In Progress.
     * SCHEDULED: Volunteer checks in → AcceptedAt = now, Status = In Progress.
     */
    public boolean acceptTask(int taskId, int volunteerId) {
        String sql = "UPDATE Tasks SET Status = 'In Progress', AcceptedAt = GETDATE() "
                + "WHERE TaskId = ? AND VolunteerId = ? AND Status = 'Pending'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ps.setInt(2, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /**
     * FLEXIBLE: Volunteer completes task → Status = 'Completed', CompletedAt = now.
     * Needs coordinator confirmation afterwards.
     */
    public boolean completeFlexibleTask(int taskId, int volunteerId, String note) {
        String sql = "UPDATE Tasks SET Status = 'Completed', CompletedAt = GETDATE(), "
                + "Note = CASE WHEN ? IS NOT NULL AND LEN(?) > 0 THEN ? ELSE Note END "
                + "WHERE TaskId = ? AND VolunteerId = ? AND Status = 'In Progress'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, note);
            ps.setString(2, note);
            ps.setString(3, note);
            ps.setInt(4, taskId);
            ps.setInt(5, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    /**
     * SCHEDULED: Volunteer checks out → Status = 'Confirmed', CompletedAt = now.
     * Auto-confirmed — no coordinator step needed.
     * Appends a timing note if volunteer checked in late or is checking out early.
     */
    public boolean checkOutScheduledTask(int taskId, int volunteerId) {
        // 1. Read planned times and actual AcceptedAt
        String fetchSql = "SELECT t.StartTime, t.EndTime, t.AcceptedAt, t.Note "
                + "FROM Tasks t WHERE t.TaskId = ? AND t.VolunteerId = ? AND t.Status = 'In Progress' AND t.TaskType = 'SCHEDULED'";
        java.time.LocalDateTime plannedStart = null, plannedEnd = null, acceptedAt = null;
        String existingNote = null;
        try (PreparedStatement ps = connection.prepareStatement(fetchSql)) {
            ps.setInt(1, taskId);
            ps.setInt(2, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                java.sql.Timestamp ts = rs.getTimestamp("StartTime");
                java.sql.Timestamp te = rs.getTimestamp("EndTime");
                java.sql.Timestamp ta = rs.getTimestamp("AcceptedAt");
                if (ts != null) plannedStart = ts.toLocalDateTime();
                if (te != null) plannedEnd   = te.toLocalDateTime();
                if (ta != null) acceptedAt   = ta.toLocalDateTime();
                existingNote = rs.getString("Note");
            } else {
                return false; // task not found / wrong state
            }
        } catch (Exception e) { e.printStackTrace(); return false; }

        // 2. Build timing note
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        StringBuilder timingNote = new StringBuilder();

        if (plannedStart != null && acceptedAt != null) {
            long lateMinutes = java.time.Duration.between(plannedStart, acceptedAt).toMinutes();
            if (lateMinutes > 1) {
                timingNote.append("[Checked in ").append(lateMinutes).append(" min late]");
            }
        }
        if (plannedEnd != null) {
            long earlyMinutes = java.time.Duration.between(now, plannedEnd).toMinutes();
            if (earlyMinutes > 1) {
                if (timingNote.length() > 0) timingNote.append(" ");
                timingNote.append("[Checked out ").append(earlyMinutes).append(" min early]");
            }
        }

        // Merge with existing note
        String finalNote = existingNote != null && !existingNote.isEmpty()
                ? existingNote + " " + timingNote
                : timingNote.toString();

        // 3. Update task
        String updateSql = "UPDATE Tasks SET Status = 'Confirmed', CompletedAt = GETDATE(), "
                + "ConfirmedAt = GETDATE(), Note = ? "
                + "WHERE TaskId = ? AND VolunteerId = ?";
        try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
            ps.setString(1, finalNote.isEmpty() ? null : finalNote);
            ps.setInt(2, taskId);
            ps.setInt(3, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ─────────────────────────────────────────────────────────────
    // COORDINATOR ACTIONS
    // ─────────────────────────────────────────────────────────────

    public boolean confirmTask(int taskId) {
        String sql = "UPDATE Tasks SET Status = 'Confirmed', ConfirmedAt = GETDATE() "
                + "WHERE TaskId = ? AND Status = 'Completed' AND TaskType = 'FLEXIBLE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteTask(int taskId, int coordinatorId) {
        String delSchedule = "DELETE FROM Schedules WHERE TaskId = ?";
        String delTask = "DELETE FROM Tasks WHERE TaskId = ? AND CoordinatorId = ?";
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement ps = connection.prepareStatement(delSchedule)) {
                ps.setInt(1, taskId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(delTask)) {
                ps.setInt(1, taskId);
                ps.setInt(2, coordinatorId);
                int rows = ps.executeUpdate();
                connection.commit();
                return rows > 0;
            }
        } catch (Exception e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return false;
    }

    /**
     * Reject & reassign — resets task and updates schedule.
     * Handles both FLEXIBLE and SCHEDULED based on provided parameters.
     */
    public boolean updateAndReassignTask(int taskId, int coordinatorId, int newVolunteerId,
                                         String description, String taskType, String priority,
                                         String dueDateStr, String startDateTimeStr, String endDateTimeStr,
                                         String location) {
        String updateTask;
        if ("FLEXIBLE".equals(taskType)) {
            updateTask = "UPDATE Tasks SET VolunteerId = ?, TaskDescription = ?, Priority = ?, "
                    + "Status = 'Pending', Note = NULL, CompletedAt = NULL, AcceptedAt = NULL, "
                    + "TaskType = 'FLEXIBLE', DueDate = ?, StartTime = NULL, EndTime = NULL, Location = ? "
                    + "WHERE TaskId = ? AND CoordinatorId = ?";
        } else {
            updateTask = "UPDATE Tasks SET VolunteerId = ?, TaskDescription = ?, Priority = ?, "
                    + "Status = 'Pending', Note = NULL, CompletedAt = NULL, AcceptedAt = NULL, "
                    + "TaskType = 'SCHEDULED', StartTime = ?, EndTime = ?, DueDate = NULL, Location = ? "
                    + "WHERE TaskId = ? AND CoordinatorId = ?";
        }

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(updateTask)) {
                ps.setInt(1, newVolunteerId);
                ps.setString(2, description);
                ps.setString(3, priority != null ? priority : "Medium");
                if ("FLEXIBLE".equals(taskType)) {
                    ps.setString(4, dueDateStr);
                    ps.setString(5, location);
                    ps.setInt(6, taskId);
                    ps.setInt(7, coordinatorId);
                } else {
                    ps.setString(4, startDateTimeStr);
                    ps.setString(5, endDateTimeStr);
                    ps.setString(6, location);
                    ps.setInt(7, taskId);
                    ps.setInt(8, coordinatorId);
                }
                int rows = ps.executeUpdate();
                if (rows == 0) { connection.rollback(); return false; }
            }

            // Update Schedules
            String updateSched;
            if ("FLEXIBLE".equals(taskType)) {
                updateSched = "UPDATE Schedules SET WorkDate = ?, StartTime = NULL, EndTime = NULL WHERE TaskId = ?";
                try (PreparedStatement ps = connection.prepareStatement(updateSched)) {
                    ps.setDate(1, java.sql.Date.valueOf(dueDateStr.substring(0, 10)));
                    ps.setInt(2, taskId);
                    ps.executeUpdate();
                }
            } else {
                updateSched = "UPDATE Schedules SET WorkDate = ?, StartTime = ?, EndTime = ? WHERE TaskId = ?";
                try (PreparedStatement ps = connection.prepareStatement(updateSched)) {
                    ps.setDate(1, java.sql.Date.valueOf(startDateTimeStr.substring(0, 10)));
                    String startT = startDateTimeStr.substring(11, 16);
                    String endT = endDateTimeStr.substring(11, 16);
                    ps.setTime(2, Time.valueOf(startT + ":00"));
                    ps.setTime(3, Time.valueOf(endT + ":00"));
                    ps.setInt(4, taskId);
                    ps.executeUpdate();
                }
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return false;
    }

    // ─────────────────────────────────────────────────────────────
    // QUERIES — COORDINATOR VIEW
    // ─────────────────────────────────────────────────────────────

    public List<Map<String, Object>> getPendingReviewTasks(int coordinatorId) {
        List<Map<String, Object>> list = new ArrayList<>();
        // Only FLEXIBLE tasks need coordinator review after completion
        String sql = "SELECT t.TaskId, t.TaskDescription, t.Priority, t.Note, t.TaskType, t.Location, "
                + "t.DueDate, t.StartTime, t.EndTime, t.AcceptedAt, t.CompletedAt, "
                + "s.WorkDate, s.StartTime AS SchedStart, s.EndTime AS SchedEnd, "
                + "e.EventId, e.Title AS EventName, up.FullName AS VolunteerName "
                + "FROM Tasks t "
                + "JOIN Schedules s ON t.TaskId = s.TaskId "
                + "JOIN Events e ON t.EventId = e.EventId "
                + "JOIN UserProfiles up ON t.VolunteerId = up.UserId "
                + "WHERE t.CoordinatorId = ? AND t.Status = 'Completed' AND t.TaskType = 'FLEXIBLE' "
                + "ORDER BY t.CompletedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, coordinatorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs, true));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getTasksByEventFiltered(int eventId, String status, String priority, String volunteerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.TaskId, t.TaskDescription, t.Status, t.Priority, t.Note, t.VolunteerId, "
            + "t.TaskType, t.DueDate, t.StartTime, t.EndTime, t.Location, t.AcceptedAt, t.CompletedAt, "
            + "s.WorkDate, s.StartTime AS SchedStart, s.EndTime AS SchedEnd, "
            + "up.FullName AS VolunteerName, "
            // Impact minutes: AcceptedAt → CompletedAt for both types
            + "(CASE WHEN t.AcceptedAt IS NOT NULL AND t.CompletedAt IS NOT NULL "
            + "  THEN DATEDIFF(MINUTE, t.AcceptedAt, t.CompletedAt) ELSE 0 END) AS DurationMinutes "
            + "FROM Tasks t "
            + "JOIN Schedules s ON t.TaskId = s.TaskId "
            + "JOIN UserProfiles up ON t.VolunteerId = up.UserId "
            + "WHERE t.EventId = ?"
        );

        if (status != null && !status.isEmpty()) sql.append(" AND t.Status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.Priority = ?");
        if (volunteerId != null && !volunteerId.isEmpty()) sql.append(" AND t.VolunteerId = ?");
        sql.append(" ORDER BY t.TaskId DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int p = 1;
            ps.setInt(p++, eventId);
            if (status != null && !status.isEmpty()) ps.setString(p++, status);
            if (priority != null && !priority.isEmpty()) ps.setString(p++, priority);
            if (volunteerId != null && !volunteerId.isEmpty()) ps.setInt(p++, Integer.parseInt(volunteerId));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs, true));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getTasksByEvent(int eventId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT t.TaskId, t.TaskDescription, t.Status, t.Priority, t.Note, "
                + "t.TaskType, t.DueDate, t.StartTime, t.EndTime, t.Location, "
                + "s.WorkDate, s.StartTime AS SchedStart, s.EndTime AS SchedEnd, "
                + "up.FullName AS VolunteerName "
                + "FROM Tasks t "
                + "JOIN Schedules s ON t.TaskId = s.TaskId "
                + "JOIN UserProfiles up ON t.VolunteerId = up.UserId "
                + "WHERE t.EventId = ? "
                + "ORDER BY t.AssignedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs, false));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ─────────────────────────────────────────────────────────────
    // QUERIES — VOLUNTEER VIEW
    // ─────────────────────────────────────────────────────────────

    public List<Map<String, Object>> getTasksForVolunteerInEvent(int eventId, int volunteerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT t.TaskId, t.TaskDescription, t.Status, t.Priority, t.Note, "
                + "t.TaskType, t.DueDate, t.StartTime, t.EndTime, t.Location, "
                + "t.AcceptedAt, t.CompletedAt, "
                + "s.WorkDate, s.StartTime AS SchedStart, s.EndTime AS SchedEnd, "
                + "up.FullName AS CoordinatorName, "
                + "(CASE WHEN t.AcceptedAt IS NOT NULL AND t.CompletedAt IS NOT NULL "
                + "  THEN DATEDIFF(MINUTE, t.AcceptedAt, t.CompletedAt) ELSE 0 END) AS DurationMinutes "
                + "FROM Tasks t "
                + "JOIN Schedules s ON t.TaskId = s.TaskId "
                + "JOIN UserProfiles up ON t.CoordinatorId = up.UserId "
                + "WHERE t.EventId = ? AND t.VolunteerId = ? "
                + "ORDER BY s.WorkDate ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = mapRow(rs, true);
                map.put("coordinatorName", rs.getString("CoordinatorName"));
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getAllTasksForVolunteer(int volunteerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT t.TaskId, t.TaskDescription, t.Status, t.Priority, "
                + "t.TaskType, t.DueDate, t.StartTime, t.EndTime, t.Location, t.Note, "
                + "s.WorkDate, s.StartTime AS SchedStart, s.EndTime AS SchedEnd, "
                + "e.EventId, e.Title AS EventName, up.FullName AS CoordinatorName "
                + "FROM Tasks t "
                + "JOIN Schedules s ON t.TaskId = s.TaskId "
                + "JOIN Events e ON t.EventId = e.EventId "
                + "JOIN UserProfiles up ON t.CoordinatorId = up.UserId "
                + "WHERE t.VolunteerId = ? "
                + "ORDER BY COALESCE(t.StartTime, t.DueDate) ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                String taskType = rs.getString("TaskType");
                map.put("taskId", rs.getInt("TaskId"));
                map.put("description", rs.getString("TaskDescription"));
                map.put("status", rs.getString("Status"));
                map.put("priority", rs.getString("Priority"));
                map.put("taskType", taskType);
                map.put("note", rs.getString("Note"));
                map.put("location", rs.getString("Location"));
                map.put("eventId", rs.getInt("EventId"));
                map.put("eventName", rs.getString("EventName"));
                map.put("coordinatorName", rs.getString("CoordinatorName"));

                if ("SCHEDULED".equals(taskType)) {
                    // Use Tasks.StartTime / EndTime for calendar slots
                    java.sql.Timestamp ts = rs.getTimestamp("StartTime");
                    java.sql.Timestamp te = rs.getTimestamp("EndTime");
                    map.put("calStart", ts != null ? ts.toLocalDateTime().toString() : "");
                    map.put("calEnd",   te != null ? te.toLocalDateTime().toString() : "");
                } else {
                    // FLEXIBLE: show on the due-date day, use Schedules times as fallback slot width
                    java.sql.Timestamp due = rs.getTimestamp("DueDate");
                    java.sql.Time ss = rs.getTime("SchedStart");
                    java.sql.Time se = rs.getTime("SchedEnd");
                    java.sql.Date wd = rs.getDate("WorkDate");
                    if (due != null) {
                        // Show as 1-hour block at the due time
                        java.time.LocalDateTime dueLDT = due.toLocalDateTime();
                        java.time.LocalDateTime endLDT = dueLDT.plusHours(1);
                        map.put("calStart", dueLDT.toString());
                        map.put("calEnd",   endLDT.toString());
                    } else if (wd != null && ss != null) {
                        String dateStr = wd.toString();
                        map.put("calStart", dateStr + "T" + ss.toString().substring(0, 5));
                        map.put("calEnd",   dateStr + "T" + (se != null ? se.toString().substring(0, 5) : ss.toString().substring(0, 5)));
                    } else {
                        map.put("calStart", "");
                        map.put("calEnd",   "");
                    }
                }
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ─────────────────────────────────────────────────────────────
    // IMPACT HOURS
    // ─────────────────────────────────────────────────────────────

    /**
     * Impact hours = AcceptedAt → CompletedAt for BOTH task types.
     */
    public double getTotalImpactHours(int volunteerId) {
        int totalMinutes = 0;
        String sql = "SELECT SUM(DATEDIFF(MINUTE, t.AcceptedAt, t.CompletedAt)) "
                + "FROM Tasks t "
                + "WHERE t.VolunteerId = ? "
                + "AND t.Status IN ('Completed', 'Confirmed') "
                + "AND t.AcceptedAt IS NOT NULL "
                + "AND t.CompletedAt IS NOT NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalMinutes = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }

        int hours = totalMinutes / 60;
        int minutes = totalMinutes % 60;
        String formatted = String.format(java.util.Locale.US, "%d.%02d", hours, minutes);
        return Double.parseDouble(formatted);
    }

    // ─────────────────────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────────────────────

    public boolean isVolunteerBusy(int volunteerId, String startDateTimeStr, String endDateTimeStr) {
        // Check overlap using Tasks.StartTime / EndTime for SCHEDULED
        // For FLEXIBLE, check DueDate overlap (simplified: no overlap check on pure deadline tasks)
        String sql = "SELECT COUNT(*) FROM Tasks t "
                + "WHERE t.VolunteerId = ? "
                + "AND t.TaskType = 'SCHEDULED' "
                + "AND t.Status IN ('Pending', 'In Progress') "
                + "AND t.StartTime < ? AND t.EndTime > ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ps.setString(2, endDateTimeStr);
            ps.setString(3, startDateTimeStr);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public String getVolunteerName(int volunteerId) {
        String name = "Volunteer ID " + volunteerId;
        String sql = "SELECT FullName FROM UserProfiles WHERE UserId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) name = rs.getString("FullName");
        } catch (Exception e) { e.printStackTrace(); }
        return name;
    }

    // ─────────────────────────────────────────────────────────────
    // PRIVATE MAP HELPER
    // ─────────────────────────────────────────────────────────────

    private Map<String, Object> mapRow(ResultSet rs, boolean includeSchedule) throws SQLException {
        Map<String, Object> map = new HashMap<>();
        map.put("taskId", rs.getInt("TaskId"));
        map.put("description", rs.getString("TaskDescription"));
        map.put("status", rs.getString("Status"));
        map.put("priority", rs.getString("Priority"));
        map.put("note", rs.getString("Note"));
        map.put("taskType", rs.getString("TaskType"));
        map.put("dueDate", rs.getTimestamp("DueDate"));
        map.put("startTime", rs.getTimestamp("StartTime"));
        map.put("endTime", rs.getTimestamp("EndTime"));
        map.put("location", rs.getString("Location"));
        map.put("acceptedAt", rs.getTimestamp("AcceptedAt"));
        map.put("completedAt", rs.getTimestamp("CompletedAt"));

        if (includeSchedule) {
            try { map.put("workDate", rs.getDate("WorkDate")); } catch (Exception ignored) {}
            try { map.put("schedStart", rs.getTime("SchedStart")); } catch (Exception ignored) {}
            try { map.put("schedEnd", rs.getTime("SchedEnd")); } catch (Exception ignored) {}
        }

        // Duration text (AcceptedAt → CompletedAt)
        try {
            int dur = rs.getInt("DurationMinutes");
            map.put("durationMinutes", dur);
            map.put("durationText", String.format("%dh %02dm", dur / 60, dur % 60));
        } catch (Exception ignored) {}

        // Try volunteer/coordinator name depending on which is present
        try { map.put("volunteerName", rs.getString("VolunteerName")); } catch (Exception ignored) {}
        try { map.put("volunteerId", rs.getInt("VolunteerId")); } catch (Exception ignored) {}

        return map;
    }

    /** Legacy bridge — kept for backward compat with any existing callers */
    public boolean assignTaskWithSchedule(int eventId, int coordinatorId, int volunteerId,
                                          String description, String workDate,
                                          String startTime, String endTime, String priority) {
        String startDT = workDate + "T" + startTime + ":00";
        String endDT   = workDate + "T" + endTime   + ":00";
        return assignScheduledTask(eventId, coordinatorId, volunteerId, description, priority,
                startDT, endDT, null);
    }

    /** Legacy — kept for backward compat */
    public boolean updateTaskStatus(int taskId, int volunteerId, String newStatus, String note) {
        if ("In Progress".equals(newStatus)) return acceptTask(taskId, volunteerId);
        if ("Completed".equals(newStatus)) return completeFlexibleTask(taskId, volunteerId, note);
        return false;
    }
}