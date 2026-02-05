package Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class VolunteerDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("volunteerName", "John Doe");
        request.setAttribute("registeredEvents", 8);
        request.setAttribute("completedEvents", 5);
        request.setAttribute("upcomingEvents", 3);
        
        request.getRequestDispatcher("/WEB-INF/views/volunteer-dashboard.jsp")
                .forward(request, response);
    }
}
