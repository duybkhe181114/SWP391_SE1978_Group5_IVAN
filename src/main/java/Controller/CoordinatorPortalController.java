package Controller;

import DAO.EventCoordinatorDAO;
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

@WebServlet(name = "CoordinatorPortalController", urlPatterns = {"/coordinator/portal"})
public class CoordinatorPortalController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        String userRole = (String) request.getSession().getAttribute("userRole");

        boolean canUseCoordinatorPortal = "Volunteer".equals(userRole) || "Coordinator".equals(userRole);
        if (userId == null || !canUseCoordinatorPortal) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        EventCoordinatorDAO coordDAO = new EventCoordinatorDAO();
        List<EventView> managedEvents = coordDAO.getCoordinatedEvents(userId);

        Map<String, Integer> stats = coordDAO.getCoordinatorStats(userId);
        request.setAttribute("stats", stats);

        request.setAttribute("managedEvents", managedEvents);

        TaskDAO taskDAO = new TaskDAO();
        List<Map<String, Object>> pendingReviewTasks = taskDAO.getPendingReviewTasks(userId);
        request.setAttribute("pendingReviewTasks", pendingReviewTasks);

        request.getRequestDispatcher("/WEB-INF/views/coordinator-portal.jsp").forward(request, response);
    }
}
