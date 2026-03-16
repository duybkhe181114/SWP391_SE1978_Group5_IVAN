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

        // ===== RBAC: CHỈ ADMIN =====
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String userRole = session.getAttribute("userRole").toString();
        if (!"Admin".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SupportRequestDAO dao = new SupportRequestDAO();

        // Admin xem tất cả
        List<SupportRequest> list = dao.getALLSPRForAdmin();

        // Đếm stats cho dashboard
        int totalCount = list.size();
        int pendingCount = 0, approvedCount = 0, rejectedCount = 0, acceptedCount = 0;
        for (SupportRequest sr : list) {
            String st = sr.getStatus();
            if ("PENDING".equalsIgnoreCase(st)) pendingCount++;
            else if ("APPROVED".equalsIgnoreCase(st)) approvedCount++;
            else if ("REJECTED".equalsIgnoreCase(st)) rejectedCount++;
            else if ("ACCEPTED".equalsIgnoreCase(st)) acceptedCount++;
        }
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("acceptedCount", acceptedCount);

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