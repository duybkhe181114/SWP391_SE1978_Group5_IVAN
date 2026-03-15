package Controller;

import DAO.EventDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"Admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        EventDAO eventDAO = new EventDAO();
        
        // Get statistics
        int totalUsers = eventDAO.getTotalUsers();
        int totalOrganizations = eventDAO.getTotalOrganizations();
        int totalEvents = eventDAO.getTotalEvents();
        int totalRegistrations = eventDAO.getTotalRegistrations();
        
        int pendingEvents = eventDAO.getEventsByStatus("Pending");
        int approvedEvents = eventDAO.getEventsByStatus("Approved");
        int rejectedEvents = eventDAO.getEventsByStatus("Rejected");

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalOrganizations", totalOrganizations);
        request.setAttribute("totalEvents", totalEvents);
        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("pendingEvents", pendingEvents);
        request.setAttribute("approvedEvents", approvedEvents);
        request.setAttribute("rejectedEvents", rejectedEvents);

        request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
    }
}
