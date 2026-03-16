package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/orgViewSpRequest")
public class OrgListSPRController extends HttpServlet {

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

        SupportRequestDAO dao = new SupportRequestDAO();

        // Organization CHỈ xem request đã được Admin phê duyệt (APPROVED)
        List<SupportRequest> list = dao.getApprovedWithCategoryName();

        request.setAttribute("requestList", list);
        request.setAttribute("userRole", userRole);

        request.getRequestDispatcher("/WEB-INF/views/org-APsupportRequestList.jsp")
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
