package Controller;

import DAO.EventDAO;
import DTO.EventView;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class OrganizationDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        EventDAO dao = new EventDAO();
        Integer organizationId = dao.getOrganizationIdByUserId(userId);
        
        if (organizationId != null) {
            List<EventView> events = dao.getEventsByOrganization(organizationId);
            request.setAttribute("events", events);
            
            // Calculate stats
            long totalEvents = events.size();
            long approvedEvents = events.stream().filter(e -> "Approved".equals(e.getStatus())).count();
            long pendingEvents = events.stream().filter(e -> "Pending".equals(e.getStatus())).count();
            
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("approvedEvents", approvedEvents);
            request.setAttribute("pendingEvents", pendingEvents);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/organization-dashboard.jsp")
                .forward(request, response);
    }
}
