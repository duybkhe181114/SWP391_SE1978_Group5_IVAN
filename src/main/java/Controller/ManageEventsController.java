package Controller;

import DAO.EventDAO;
import DTO.EventView;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ManageEventsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        if (!"Admin".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        EventDAO dao = new EventDAO();
        List<EventView> pendingEvents = dao.getPendingEvents();
        
        request.setAttribute("pendingEvents", pendingEvents);
        request.getRequestDispatcher("/WEB-INF/views/admin-manage-events.jsp")
                .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        
        EventDAO dao = new EventDAO();
        
        if ("approve".equals(action)) {
            dao.approveEvent(eventId);
        } else if ("reject".equals(action)) {
            dao.rejectEvent(eventId);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-events");
    }
}
