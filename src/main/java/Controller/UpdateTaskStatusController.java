package Controller;

import DAO.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

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
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String action = request.getParameter("action"); // 'start' hoặc 'complete'

            String newStatus = "start".equals(action) ? "In Progress" : "Completed";
            String note = request.getParameter("note");

            TaskDAO taskDAO = new TaskDAO();
            taskDAO.updateTaskStatus(taskId, volunteerId, newStatus, note);

            response.sendRedirect(request.getContextPath() + "/volunteer/workspace?eventId=" + eventId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}