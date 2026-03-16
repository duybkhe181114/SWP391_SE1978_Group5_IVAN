package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/org/support-requests")
public class OrgListSPRController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        if (!"Organization".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        SupportRequestDAO dao = new SupportRequestDAO();
        // Organization chỉ được xem những request đã được admin APPROVED
        List<SupportRequest> list = dao.getApprovedSupportRequests();

        request.setAttribute("requestList", list);
        request.getRequestDispatcher("/WEB-INF/views/org-APsupportRequestList.jsp")
                .forward(request, response);
    }
}
