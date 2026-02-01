package Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class MockLoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String role = request.getParameter("role");
        
        if ("volunteer".equals(role)) {
            request.getSession().setAttribute("userRole", "volunteer");
            request.getSession().setAttribute("userId", 1);
            request.getSession().setAttribute("userName", "John Doe");
        } else if ("organization".equals(role)) {
            request.getSession().setAttribute("userRole", "organization");
            request.getSession().setAttribute("userId", 1);
            request.getSession().setAttribute("orgName", "Green Earth Foundation");
        }
        
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
