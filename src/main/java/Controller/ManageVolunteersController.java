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
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        
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
        
        EventRegistrationDAO dao = new EventRegistrationDAO();
        
        if ("approve".equals(action)) {
            dao.approveVolunteer(registrationId);
        } else if ("reject".equals(action)) {
            dao.rejectVolunteer(registrationId);
        }
        
        response.sendRedirect(request.getContextPath() + "/organization/manage-volunteers?eventId=" + eventId);
    }
}
