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
import java.util.List;
import java.util.Map;

@WebServlet(name = "VolunteerWorkspaceController", urlPatterns = {"/volunteer/workspace"})
public class VolunteerWorkspaceController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        String userRole = (String) request.getSession().getAttribute("userRole");

        // Chặn người lạ
        if (userId == null || !"Volunteer".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));

        // Kiểm tra xem có đúng là Volunteer đã được Approved của event này không
        EventDAO eventDAO = new EventDAO();
        String enrollStatus = eventDAO.getEnrollmentStatus(eventId, userId);

        if (!"Approved".equals(enrollStatus)) {
            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId);
            return;
        }

        // Kéo data Event và Task lên
        EventView event = eventDAO.getEventById(eventId);
        TaskDAO taskDAO = new TaskDAO();
        List<Map<String, Object>> myTasks = taskDAO.getTasksForVolunteerInEvent(eventId, userId);

        request.setAttribute("event", event);
        request.setAttribute("myTasks", myTasks);
        request.getRequestDispatcher("/WEB-INF/views/volunteer-workspace.jsp").forward(request, response);
    }
}