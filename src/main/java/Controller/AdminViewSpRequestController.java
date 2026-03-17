package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewSpRequestAdmin")
public class AdminViewSpRequestController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        SupportRequestDAO dao = new SupportRequestDAO();

        HttpSession session = request.getSession(false);
        String userRole = session != null ? (String) session.getAttribute("userRole") : null;

        List<SupportRequest> list;
        if ("Organization".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/org/support-requests");
            return;
        } else if ("Admin".equalsIgnoreCase(userRole)) {
            list = dao.getALLSPRForAdmin();
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("requestList", list);

        request.getRequestDispatcher("/WEB-INF/views/admin-SupportRequestList.jsp")
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}