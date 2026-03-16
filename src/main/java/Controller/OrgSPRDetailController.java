package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/org/support-request-detail")
public class OrgSPRDetailController extends HttpServlet {

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

        String idRaw = request.getParameter("id");
        int requestId;
        try {
            requestId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/org/support-requests");
            return;
        }

        SupportRequestDAO dao = new SupportRequestDAO();
        SupportRequest spr = dao.getByIdvunh(requestId);

        // Organization chỉ được xem request đã APPROVED
        if (spr == null || !"APPROVED".equalsIgnoreCase(spr.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/org/support-requests");
            return;
        }

        request.setAttribute("requestDetail", spr);
        request.getRequestDispatcher("/WEB-INF/views/org-APsupportRequestDetail.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        int userId = (Integer) session.getAttribute("userId");
        String idRaw = request.getParameter("requestId");
        String action = request.getParameter("action");

        int requestId;
        try {
            requestId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/org/support-requests");
            return;
        }

        SupportRequestDAO dao = new SupportRequestDAO();
        if ("ACCEPT".equals(action)) {
            dao.acceptRequest(requestId, userId);
        }

        response.sendRedirect(request.getContextPath() + "/org/support-requests");
    }
}
