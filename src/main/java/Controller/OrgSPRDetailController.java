package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/orgSpRequestDetail")
public class OrgSPRDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        // ===== RBAC: CHỈ ORGANIZATION =====
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String userRole = session.getAttribute("userRole").toString();
        if (!"Organization".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ===== LẤY ID =====
        String idRaw = request.getParameter("id");
        int requestId;
        try {
            requestId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orgViewSpRequest");
            return;
        }

        // ===== LẤY DATA =====
        SupportRequestDAO dao = new SupportRequestDAO();
        SupportRequest spr = dao.getById(requestId);

        // Org chỉ được xem APPROVED hoặc ACCEPTED
        if (spr == null || (!"APPROVED".equalsIgnoreCase(spr.getStatus())
                && !"ACCEPTED".equalsIgnoreCase(spr.getStatus()))) {
            response.sendRedirect(request.getContextPath() + "/orgViewSpRequest");
            return;
        }

        request.setAttribute("requestDetail", spr);
        request.setAttribute("userRole", userRole);

        request.getRequestDispatcher("/WEB-INF/views/org-APsupportRequestDetail.jsp")
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
