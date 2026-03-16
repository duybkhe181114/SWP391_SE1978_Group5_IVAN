package DAO;

import Context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TaskDAO extends DBContext {

    public boolean assignTaskWithSchedule(int eventId, int coordinatorId, int volunteerId, String description, String workDate, String startTime, String endTime, String priority) {
        String insertTaskSql = "INSERT INTO Tasks (EventId, CoordinatorId, VolunteerId, TaskDescription, Status, Priority, AssignedAt) VALUES (?, ?, ?, ?, 'Pending', ?, GETDATE())";
        String insertScheduleSql = "INSERT INTO Schedules (TaskId, WorkDate, StartTime, EndTime, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";

        try {
            connection.setAutoCommit(false);

            // 1. Insert Task
            int newTaskId = 0;
            try (PreparedStatement psTask = connection.prepareStatement(insertTaskSql, Statement.RETURN_GENERATED_KEYS)) {
                psTask.setInt(1, eventId);
                psTask.setInt(2, coordinatorId);
                psTask.setInt(3, volunteerId);
                psTask.setString(4, description);
                psTask.setString(5, priority != null ? priority : "Medium");
                psTask.executeUpdate();

                ResultSet rs = psTask.getGeneratedKeys();
                if (rs.next()) {
                    newTaskId = rs.getInt(1);
                }
            }

            // 2. Insert Schedule dựa trên TaskId
            if (newTaskId > 0) {
                try (PreparedStatement psSchedule = connection.prepareStatement(insertScheduleSql)) {
                    psSchedule.setInt(1, newTaskId);
                    psSchedule.setDate(2, Date.valueOf(workDate)); // Ép kiểu YYYY-MM-DD
                    psSchedule.setTime(3, Time.valueOf(startTime + ":00")); // Ép kiểu HH:MM:SS
                    psSchedule.setTime(4, Time.valueOf(endTime + ":00"));
                    psSchedule.executeUpdate();
                }
            }

            // Commit Transaction nếu mọi thứ ngon lành
            connection.commit();
            return true;

        } catch (Exception e) {
            try {
                // Có lỗi thì Rollback, không lưu nửa vời
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true); // Trả lại trạng thái cũ
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
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

    public boolean confirmTask(int taskId) {
        String sql = "UPDATE Tasks SET Status = 'Confirmed', ConfirmedAt = GETDATE() WHERE TaskId = ? AND Status = 'Completed'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 2. Lấy danh sách Task của 1 sự kiện để in ra bảng Tiến độ
    public List<Map<String, Object>> getTasksByEvent(int eventId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT t.TaskId, t.TaskDescription, t.Status, t.Priority, t.Note,
                   s.WorkDate, s.StartTime, s.EndTime,
                   up.FullName AS VolunteerName
            FROM Tasks t
            JOIN Schedules s ON t.TaskId = s.TaskId
            JOIN UserProfiles up ON t.VolunteerId = up.UserId
            WHERE t.EventId = ?
            ORDER BY t.AssignedAt DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("taskId", rs.getInt("TaskId"));
                map.put("description", rs.getString("TaskDescription"));
                map.put("status", rs.getString("Status"));
                map.put("priority", rs.getString("Priority"));
                map.put("note", rs.getString("Note"));
                map.put("workDate", rs.getDate("WorkDate"));
                map.put("startTime", rs.getTime("StartTime"));
                map.put("endTime", rs.getTime("EndTime"));
                map.put("volunteerName", rs.getString("VolunteerName"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getTasksForVolunteerInEvent(int eventId, int volunteerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT t.TaskId, t.TaskDescription, t.Status, t.Priority, " +
                "s.WorkDate, s.StartTime, s.EndTime, up.FullName AS CoordinatorName " +
                "FROM Tasks t " +
                "JOIN Schedules s ON t.TaskId = s.TaskId " +
                "JOIN UserProfiles up ON t.CoordinatorId = up.UserId " +
                "WHERE t.EventId = ? AND t.VolunteerId = ? " +
                "ORDER BY s.WorkDate ASC, s.StartTime ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("taskId", rs.getInt("TaskId"));
                map.put("description", rs.getString("TaskDescription"));
                map.put("status", rs.getString("Status"));
                map.put("priority", rs.getString("Priority"));
                map.put("workDate", rs.getDate("WorkDate"));
                map.put("startTime", rs.getTime("StartTime"));
                map.put("endTime", rs.getTime("EndTime"));
                map.put("coordinatorName", rs.getString("CoordinatorName"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Volunteer tự cập nhật trạng thái Task
    public boolean updateTaskStatus(int taskId, int volunteerId, String newStatus, String note) {
        String sql = "UPDATE Tasks SET Status = ?, " +
                "CompletedAt = CASE WHEN ? = 'Completed' THEN GETDATE() ELSE CompletedAt END, " +
                "Note = CASE WHEN ? IS NOT NULL AND LEN(?) > 0 THEN ? ELSE Note END " +
                "WHERE TaskId = ? AND VolunteerId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, newStatus);
            ps.setString(3, note);
            ps.setString(4, note);
            ps.setString(5, note);
            ps.setInt(6, taskId);
            ps.setInt(7, volunteerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isVolunteerBusy(int volunteerId, String workDate, String startTime, String endTime) {
        String sql = "SELECT COUNT(*) FROM Tasks t " +
                "JOIN Schedules s ON t.TaskId = s.TaskId " +
                "WHERE t.VolunteerId = ? AND s.WorkDate = ? " +
                "AND t.Status IN ('Pending', 'In Progress') " +
                "AND (s.StartTime < ? AND s.EndTime > ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ps.setDate(2, Date.valueOf(workDate));
            ps.setTime(3, Time.valueOf(endTime + ":00"));
            ps.setTime(4, Time.valueOf(startTime + ":00"));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getAllTasksForVolunteer(int volunteerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT t.TaskId, t.TaskDescription, t.Status, t.Priority, " +
                "s.WorkDate, s.StartTime, s.EndTime, " +
                "e.EventId, e.Title AS EventName, up.FullName AS CoordinatorName " +
                "FROM Tasks t " +
                "JOIN Schedules s ON t.TaskId = s.TaskId " +
                "JOIN Events e ON t.EventId = e.EventId " +
                "JOIN UserProfiles up ON t.CoordinatorId = up.UserId " +
                "WHERE t.VolunteerId = ? " +
                "ORDER BY s.WorkDate ASC, s.StartTime ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("taskId", rs.getInt("TaskId"));
                map.put("description", rs.getString("TaskDescription"));
                map.put("status", rs.getString("Status"));
                map.put("priority", rs.getString("Priority"));
                map.put("workDate", rs.getDate("WorkDate"));
                map.put("startTime", rs.getTime("StartTime"));
                map.put("endTime", rs.getTime("EndTime"));
                map.put("eventId", rs.getInt("EventId"));
                map.put("eventName", rs.getString("EventName"));
                map.put("coordinatorName", rs.getString("CoordinatorName"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalImpactHours(int volunteerId) {
        double totalHours = 0;
        String sql = "SELECT SUM(DATEDIFF(MINUTE, s.StartTime, s.EndTime)) / 60.0 " +
                "FROM Tasks t JOIN Schedules s ON t.TaskId = s.TaskId " +
                "WHERE t.VolunteerId = ? AND t.Status IN ('Completed', 'Confirmed')";
        try (java.sql.PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalHours = rs.getDouble(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Math.round(totalHours * 10.0) / 10.0; // Làm tròn 1 chữ số thập phân
    }
}