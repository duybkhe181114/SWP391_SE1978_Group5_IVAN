package Controller;

import DAO.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "VolunteerScheduleController", urlPatterns = {"/volunteer/my-schedule"})
public class VolunteerScheduleController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        String userRole = (String) request.getSession().getAttribute("userRole");

        if (userId == null || !"Volunteer".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Map<String, Object>> allTasks = taskDAO.getAllTasksForVolunteer(userId);

        request.setAttribute("allTasks", allTasks);
        request.getRequestDispatcher("/WEB-INF/views/volunteer-schedule.jsp").forward(request, response);
    }
}