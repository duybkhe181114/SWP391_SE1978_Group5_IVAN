package Controller;

import DAO.EventDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        if (!"Admin".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        EventDAO dao = new EventDAO();
        request.setAttribute("totalUsers", dao.getTotalUsers());
        request.setAttribute("totalOrganizations", dao.getTotalOrganizations());
        request.setAttribute("totalEvents", dao.getTotalEvents());
        
        request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp")
                .forward(request, response);
    }
}
