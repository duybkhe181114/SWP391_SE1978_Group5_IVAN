package Controller;

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
            int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
            String taskDescription = request.getParameter("taskDescription");
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
            if (taskDAO.isVolunteerBusy(volunteerId, workDate, startTime, endTime)) {
                String error = URLEncoder.encode("This volunteer already has an overlapping task!", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&error=" + error);
                return;
            }

            taskDAO.assignTaskWithSchedule(eventId, coordinatorId, volunteerId, taskDescription, workDate, startTime, endTime);

            String success = URLEncoder.encode("Task assigned successfully!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&success=" + success);

        } catch (Exception e) {
            e.printStackTrace();
            String error = URLEncoder.encode("Invalid input data!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&error=" + error);
        }
    }
}