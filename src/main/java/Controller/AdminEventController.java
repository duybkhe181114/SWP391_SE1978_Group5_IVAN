package Controller;

import DAO.EventDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminEventController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");
        
        EventDAO dao = new EventDAO();
        boolean success = false;
        
        if ("approve".equals(action)) {
            success = dao.approveEvent(eventId);
        } else if ("reject".equals(action)) {
            success = dao.rejectEvent(eventId);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/events");
    }
}
