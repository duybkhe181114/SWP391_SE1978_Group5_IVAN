package Controller;

import DAO.EventRegistrationDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class VolunteerRegistrationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        // Mock userId - sau này lấy từ session
        int userId = 1;
        
        EventRegistrationDAO dao = new EventRegistrationDAO();
        boolean success = dao.registerForEvent(eventId, userId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/home?msg=Registered successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/home?error=Registration failed");
        }
    }
}
