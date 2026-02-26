package Controller;

import DAO.EventDAO;
import DTO.EventView;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class EventDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        int eventId = Integer.parseInt(idParam);
        EventDAO dao = new EventDAO();
        EventView event = dao.getEventById(eventId);
        
        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.setAttribute("event", event);
        request.getRequestDispatcher("/WEB-INF/views/event-detail.jsp").forward(request, response);
    }
}
