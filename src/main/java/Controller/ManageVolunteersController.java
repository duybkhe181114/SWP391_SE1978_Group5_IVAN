package Controller;

import DAO.EventRegistrationDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class ManageVolunteersController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String eventIdParam = request.getParameter("eventId");
        if (eventIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/organization/dashboard");
            return;
        }
        int eventId = Integer.parseInt(eventIdParam);
        
        EventRegistrationDAO dao = new EventRegistrationDAO();
        List<Map<String, Object>> volunteers = dao.getVolunteersByEvent(eventId);
        
        request.setAttribute("volunteers", volunteers);
        request.setAttribute("eventId", eventId);
        request.getRequestDispatcher("/WEB-INF/views/manage-volunteers.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int registrationId = Integer.parseInt(request.getParameter("registrationId"));
        String action = request.getParameter("action");
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        
        HttpSession session = request.getSession();
        Integer reviewerId = (Integer) session.getAttribute("userId");
        
        EventRegistrationDAO dao = new EventRegistrationDAO();
        
        if ("approve".equals(action)) {
            dao.approveVolunteer(registrationId);
        } else if ("reject".equals(action)) {
            String reviewNote = request.getParameter("reviewNote");
            if (reviewNote == null || reviewNote.trim().isEmpty()) {
                request.setAttribute("error", "Review note is required for rejection");
                doGet(request, response);
                return;
            }
            dao.rejectVolunteer(registrationId, reviewerId, reviewNote);
        }
        
        response.sendRedirect(request.getContextPath() + "/organization/manage-volunteers?eventId=" + eventId);
    }
}
