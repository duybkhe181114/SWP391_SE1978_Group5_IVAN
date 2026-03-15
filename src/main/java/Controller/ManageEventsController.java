package Controller;

import DAO.EventDAO;
import DTO.EventView;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ManageEventsController extends HttpServlet {

    private final EventDAO dao = new EventDAO();

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
        
        List<EventView> pendingEvents = dao.getPendingEvents();
        
        request.setAttribute("pendingEvents", pendingEvents);
        request.getRequestDispatcher("/WEB-INF/views/admin-manage-events.jsp")
                .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String action = request.getParameter("action");
        Integer adminId = (Integer) session.getAttribute("userId");
        int eventId;
        try {
            eventId = Integer.parseInt(request.getParameter("eventId"));
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-events?error=invalid_event");
            return;
        }

        String reviewNote = trimToNull(request.getParameter("reviewNote"));

        if ("approve".equals(action)) {
            dao.approveEvent(eventId, adminId, reviewNote);
        } else if ("reject".equals(action)) {
            if (reviewNote == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/manage-events?error=note_required&eventId=" + eventId + "#event-" + eventId);
                return;
            }
            dao.rejectEvent(eventId, adminId, reviewNote);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-events?error=invalid_action");
            return;
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-events?success=reviewed");
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
