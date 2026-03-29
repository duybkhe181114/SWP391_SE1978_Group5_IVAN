package Controller;

import DAO.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "CoordinatorConfirmTaskController", urlPatterns = {"/coordinator/task-action"})
public class CoordinatorConfirmTaskController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer coordinatorId = (Integer) request.getSession().getAttribute("userId");
        if (coordinatorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        int taskId  = Integer.parseInt(request.getParameter("taskId"));
        String action = request.getParameter("action");
        String redirectBase = request.getContextPath() + "/event/detail?id=" + eventId;

        TaskDAO taskDAO = new TaskDAO();
        String msg;

        try {
            if ("confirm".equals(action)) {
                // Only FLEXIBLE tasks need manual confirmation
                boolean ok = taskDAO.confirmTask(taskId);
                msg = ok ? URLEncoder.encode("Task confirmed!", "UTF-8")
                         : URLEncoder.encode("Could not confirm task (may already be Confirmed or is a SCHEDULED task).", "UTF-8");
                response.sendRedirect(redirectBase + (ok ? "&success=" : "&error=") + msg);

            } else if ("delete".equals(action)) {
                boolean ok = taskDAO.deleteTask(taskId, coordinatorId);
                msg = ok ? URLEncoder.encode("Task deleted.", "UTF-8")
                         : URLEncoder.encode("Could not delete task.", "UTF-8");
                response.sendRedirect(redirectBase + (ok ? "&success=" : "&error=") + msg);

            } else if ("reject_reassign".equals(action)) {
                int newVolunteerId = Integer.parseInt(request.getParameter("volunteerId"));
                String taskDescription = request.getParameter("taskDescription").trim();
                if (!taskDescription.startsWith("[Reassigned]")) {
                    taskDescription = "[Reassigned] " + taskDescription;
                }

                String priority = request.getParameter("priority");
                String taskType = request.getParameter("taskType");   // FLEXIBLE or SCHEDULED
                String location = request.getParameter("location");   // optional

                String dueDateStr = null, startStr = null, endStr = null;
                if ("FLEXIBLE".equals(taskType)) {
                    String raw = request.getParameter("dueDate");
                    if (raw != null) dueDateStr = raw.replace("T", " ") + (raw.length() == 16 ? ":00" : "");
                } else {
                    String sRaw = request.getParameter("startDateTime");
                    String eRaw = request.getParameter("endDateTime");
                    if (sRaw != null) startStr = sRaw.replace("T", " ") + (sRaw.length() == 16 ? ":00" : "");
                    if (eRaw != null) endStr   = eRaw.replace("T", " ") + (eRaw.length() == 16 ? ":00" : "");
                }

                boolean ok = taskDAO.updateAndReassignTask(taskId, coordinatorId, newVolunteerId,
                        taskDescription, taskType, priority, dueDateStr, startStr, endStr, location);
                msg = ok ? URLEncoder.encode("Task rejected and successfully reassigned!", "UTF-8")
                         : URLEncoder.encode("Could not reassign task.", "UTF-8");
                response.sendRedirect(redirectBase + (ok ? "&success=" : "&error=") + msg);

            } else {
                response.sendRedirect(redirectBase);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
