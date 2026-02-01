package Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class OrganizationDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("orgName", "Green Earth Foundation");
        request.setAttribute("totalEvents", 12);
        request.setAttribute("activeEvents", 5);
        request.setAttribute("totalVolunteers", 234);
        
        request.getRequestDispatcher("/WEB-INF/views/organization-dashboard.jsp")
                .forward(request, response);
    }
}
