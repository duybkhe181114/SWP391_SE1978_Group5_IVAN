package Controller;

import DAO.EventDAO;
import Entity.Event;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;

public class CreateEventController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            int requiredVolunteers = Integer.parseInt(request.getParameter("requiredVolunteers"));
            
            HttpSession session = request.getSession(false);
            
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            Integer userId = (Integer) session.getAttribute("userId");
            
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Get organizationId from userId
            EventDAO dao = new EventDAO();
            Integer organizationId = dao.getOrganizationIdByUserId(userId);
            
            if (organizationId == null) {
                request.setAttribute("error", "Organization not found");
                request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
                return;
            }
            
            boolean success = dao.createEvent(title, description, location, startDate, endDate, 
                                             requiredVolunteers, organizationId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/organization/dashboard?msg=Event created successfully. Waiting for admin approval.");
            } else {
                request.setAttribute("error", "Failed to create event");
                request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
        }
    }
}
