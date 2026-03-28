package Controller;

import Context.DBContext;
import DAO.EventDAO;
import DAO.TaskDAO;
import DTO.EventView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet(name = "AssignTaskController", urlPatterns = {"/coordinator/assign-task"})
public class AssignTaskController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer coordinatorId = (Integer) request.getSession().getAttribute("userId");
        if (coordinatorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));

        try {
            String[] volunteerIdsStr = request.getParameterValues("volunteerId");
            if (volunteerIdsStr == null || volunteerIdsStr.length == 0) {
                String error = URLEncoder.encode("Please select at least one volunteer!", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&error=" + error);
                return;
            }

            String taskDescription = request.getParameter("taskDescription");
            String priority = request.getParameter("priority");
            String workDate = request.getParameter("workDate"); // format YYYY-MM-DD
            String startTime = request.getParameter("startTime"); // format HH:MM
            String endTime = request.getParameter("endTime");

            LocalTime start = LocalTime.parse(startTime);
            LocalTime end = LocalTime.parse(endTime);
            if (!start.isBefore(end)) {
                String error = URLEncoder.encode("Start time must be before end time!", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&error=" + error);
                return;
            }

            EventDAO eventDAO = new EventDAO();
            EventView event = eventDAO.getEventById(eventId);
            LocalDate taskD = LocalDate.parse(workDate);
            LocalDate evStart = event.getStartDate().toLocalDate();
            LocalDate evEnd = event.getEndDate().toLocalDate();

            if (taskD.isBefore(evStart) || taskD.isAfter(evEnd)) {
                String error = URLEncoder.encode("Task date must be within the event period!", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&error=" + error);
                return;
            }

            TaskDAO taskDAO = new TaskDAO();
            
            // Validate all volunteers first
            for (String vIdStr : volunteerIdsStr) {
                int volunteerId = Integer.parseInt(vIdStr);
                if (taskDAO.isVolunteerBusy(volunteerId, workDate, startTime, endTime)) {
                    String busyName = taskDAO.getVolunteerName(volunteerId);
                    String error = URLEncoder.encode(busyName + " already has an overlapping task! Please adjust schedule.", "UTF-8");
                    response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&error=" + error);
                    return;
                }
            }

            // Assign to all if validation passed
            for (String vIdStr : volunteerIdsStr) {
                int volunteerId = Integer.parseInt(vIdStr);
                taskDAO.assignTaskWithSchedule(eventId, coordinatorId, volunteerId, taskDescription, workDate, startTime, endTime, priority);
            }

            String success = URLEncoder.encode("Task assigned successfully to " + volunteerIdsStr.length + " volunteer(s)!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&success=" + success);

        } catch (Exception e) {
            e.printStackTrace();
            String error = URLEncoder.encode("Invalid input data!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&error=" + error);
        }
    }
}