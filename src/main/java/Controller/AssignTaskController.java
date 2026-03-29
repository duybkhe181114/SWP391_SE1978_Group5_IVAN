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
import java.time.LocalDateTime;

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
        String redirectBase = request.getContextPath() + "/event/detail?id=" + eventId;

        try {
            String[] volunteerIdsStr = request.getParameterValues("volunteerId");
            if (volunteerIdsStr == null || volunteerIdsStr.length == 0) {
                String error = URLEncoder.encode("Please select at least one volunteer!", "UTF-8");
                response.sendRedirect(redirectBase + "&error=" + error);
                return;
            }

            String taskDescription = request.getParameter("taskDescription");
            String priority = request.getParameter("priority");
            String taskType = request.getParameter("taskType"); // FLEXIBLE or SCHEDULED
            String location = request.getParameter("location"); // optional

            if (taskType == null || (!taskType.equals("FLEXIBLE") && !taskType.equals("SCHEDULED"))) {
                String error = URLEncoder.encode("Invalid task type!", "UTF-8");
                response.sendRedirect(redirectBase + "&error=" + error);
                return;
            }

            EventDAO eventDAO = new EventDAO();
            EventView event = eventDAO.getEventById(eventId);
            LocalDate evStart = event.getStartDate().toLocalDate();
            LocalDate evEnd = event.getEndDate().toLocalDate();

            TaskDAO taskDAO = new TaskDAO();

            if ("FLEXIBLE".equals(taskType)) {
                // Expects: dueDate as "YYYY-MM-DDTHH:mm" (datetime-local input)
                String dueDateRaw = request.getParameter("dueDate"); // datetime-local → "YYYY-MM-DDTHH:mm"
                if (dueDateRaw == null || dueDateRaw.isEmpty()) {
                    response.sendRedirect(redirectBase + "&error=" + URLEncoder.encode("Due date is required for Flexible tasks!", "UTF-8"));
                    return;
                }
                // Normalize: HTML datetime-local returns "YYYY-MM-DDTHH:mm"
                // We store as SQL-compatible string "YYYY-MM-DD HH:mm:00"
                String dueDateStr = normalizeDatetime(dueDateRaw);
                LocalDate dueD = LocalDate.parse(dueDateStr.substring(0, 10));
                if (dueD.isBefore(evStart) || dueD.isAfter(evEnd)) {
                    response.sendRedirect(redirectBase + "&error=" + URLEncoder.encode("Due date must be within the event period!", "UTF-8"));
                    return;
                }

                for (String vIdStr : volunteerIdsStr) {
                    taskDAO.assignFlexibleTask(eventId, coordinatorId, Integer.parseInt(vIdStr),
                            taskDescription, priority, dueDateStr, location);
                }

            } else { // SCHEDULED
                String startRaw = request.getParameter("startDateTime");
                String endRaw = request.getParameter("endDateTime");
                if (startRaw == null || endRaw == null || startRaw.isEmpty() || endRaw.isEmpty()) {
                    response.sendRedirect(redirectBase + "&error=" + URLEncoder.encode("Start and End date/time are required for Scheduled tasks!", "UTF-8"));
                    return;
                }
                String startStr = normalizeDatetime(startRaw);
                String endStr   = normalizeDatetime(endRaw);

                LocalDateTime startDT = LocalDateTime.parse(startStr.replace(" ", "T"));
                LocalDateTime endDT   = LocalDateTime.parse(endStr.replace(" ", "T"));

                if (!startDT.isBefore(endDT)) {
                    response.sendRedirect(redirectBase + "&error=" + URLEncoder.encode("Start time must be before end time!", "UTF-8"));
                    return;
                }
                LocalDate taskD = startDT.toLocalDate();
                if (taskD.isBefore(evStart) || taskD.isAfter(evEnd)) {
                    response.sendRedirect(redirectBase + "&error=" + URLEncoder.encode("Task date must be within the event period!", "UTF-8"));
                    return;
                }

                // Validate no overlapping scheduled task
                for (String vIdStr : volunteerIdsStr) {
                    int vId = Integer.parseInt(vIdStr);
                    if (taskDAO.isVolunteerBusy(vId, startStr, endStr)) {
                        String busyName = taskDAO.getVolunteerName(vId);
                        response.sendRedirect(redirectBase + "&error=" + URLEncoder.encode(busyName + " already has an overlapping scheduled task!", "UTF-8"));
                        return;
                    }
                }

                for (String vIdStr : volunteerIdsStr) {
                    taskDAO.assignScheduledTask(eventId, coordinatorId, Integer.parseInt(vIdStr),
                            taskDescription, priority, startStr, endStr, location);
                }
            }

            String success = URLEncoder.encode("Task assigned successfully to " + volunteerIdsStr.length + " volunteer(s)!", "UTF-8");
            response.sendRedirect(redirectBase + "&success=" + success);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectBase + "&error=" + URLEncoder.encode("Invalid input data!", "UTF-8"));
        }
    }

    /** Converts HTML datetime-local "YYYY-MM-DDTHH:mm" to SQL-safe "YYYY-MM-DD HH:mm:00" */
    private String normalizeDatetime(String raw) {
        return raw.replace("T", " ") + (raw.length() == 16 ? ":00" : "");
    }
}