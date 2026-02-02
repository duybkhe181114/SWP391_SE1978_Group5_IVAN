package Controller;

import Entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String role = (String) session.getAttribute("userRole");
        
        if ("Admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if ("Organization".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/organization/dashboard");
        } else if ("Volunteer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/volunteer/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/index.html");
        }
    }
}
