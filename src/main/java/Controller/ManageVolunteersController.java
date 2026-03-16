package Controller;

import DAO.EventRegistrationDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ManageVolunteersController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String eventIdParam = request.getParameter("eventId");
        if (eventIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/organization/dashboard");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/organization/active-team?eventId=" + eventIdParam);
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
            dao.approveVolunteer(registrationId, reviewerId);
        } else if ("reject".equals(action)) {
            String reviewNote = request.getParameter("reviewNote");
            if (reviewNote == null || reviewNote.trim().isEmpty()) {
                request.setAttribute("error", "Review note is required for rejection");
                doGet(request, response);
                return;
            }
            dao.rejectVolunteer(registrationId, reviewerId, reviewNote);
        }
        
        response.sendRedirect(request.getContextPath() + "/organization/registration-log?eventId=" + eventId);
    }
}
