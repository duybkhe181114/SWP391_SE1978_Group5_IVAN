package Controller;

import DAO.EventDAO;
import DAO.EventRegistrationDAO;
import DAO.TaskDAO;
import DTO.EventView;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "VolunteerDashboardController", urlPatterns = {"/volunteer/dashboard"})
public class VolunteerDashboardController extends HttpServlet {

    private EventRegistrationDAO registrationDAO = new EventRegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null || !"Volunteer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int[] stats = registrationDAO.getVolunteerStats(userId);
        List<EventView> myEvents = registrationDAO.getMyRegisteredEvents(userId);

        TaskDAO taskDAO = new TaskDAO();
        double impactHours = taskDAO.getTotalImpactHours(userId);

        EventDAO eventDAO = new EventDAO();
        List<EventView> recommendedEvents = eventDAO.getRecommendedEvents(userId);

        request.setAttribute("registeredEvents", stats[0]);
        request.setAttribute("upcomingEvents", stats[1]);
        request.setAttribute("completedEvents", stats[2]);
        request.setAttribute("myEvents", myEvents);

        request.setAttribute("impactHours", impactHours);
        request.setAttribute("recommendedEvents", recommendedEvents);

        request.getRequestDispatcher("/WEB-INF/views/volunteer-dashboard.jsp").forward(request, response);
    }
}