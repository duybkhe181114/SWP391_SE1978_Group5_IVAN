package Controller;

import DAO.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

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

        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
            String taskDescription = request.getParameter("taskDescription");
            String workDate = request.getParameter("workDate"); // format YYYY-MM-DD
            String startTime = request.getParameter("startTime"); // format HH:MM
            String endTime = request.getParameter("endTime");

            TaskDAO taskDAO = new TaskDAO();
            taskDAO.assignTaskWithSchedule(eventId, coordinatorId, volunteerId, taskDescription, workDate, startTime, endTime);

            // Giao xong thì ném về lại trang cũ
            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}