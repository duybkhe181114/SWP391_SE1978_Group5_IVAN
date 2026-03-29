package Controller;

import DAO.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Volunteer task status actions:
 *  - FLEXIBLE:  action=accept  → AcceptedAt=now, Status=In Progress
 *               action=complete → CompletedAt=now, Status=Completed (awaits coordinator)
 *  - SCHEDULED: action=checkin  → AcceptedAt=now, Status=In Progress
 *               action=checkout → CompletedAt=now, Status=Confirmed (auto-confirmed)
 */
@WebServlet(name = "UpdateTaskStatusController", urlPatterns = {"/volunteer/update-task"})
public class UpdateTaskStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer volunteerId = (Integer) request.getSession().getAttribute("userId");
        if (volunteerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            int taskId  = Integer.parseInt(request.getParameter("taskId"));
            String action = request.getParameter("action");
            String redirectUrl = request.getContextPath() + "/volunteer/workspace?eventId=" + eventId;

            TaskDAO dao = new TaskDAO();

            switch (action) {
                case "accept":
                    // FLEXIBLE: volunteer accepts → In Progress
                    dao.acceptTask(taskId, volunteerId);
                    break;
                case "complete":
                    // FLEXIBLE: volunteer marks complete → Completed (needs coordinator confirm)
                    String note = request.getParameter("note");
                    dao.completeFlexibleTask(taskId, volunteerId, note);
                    break;
                case "checkin":
                    // SCHEDULED: volunteer checks in → In Progress
                    dao.acceptTask(taskId, volunteerId);
                    break;
                case "checkout":
                    // SCHEDULED: volunteer checks out → Confirmed (auto)
                    dao.checkOutScheduledTask(taskId, volunteerId);
                    break;
                default:
                    break;
            }

            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}