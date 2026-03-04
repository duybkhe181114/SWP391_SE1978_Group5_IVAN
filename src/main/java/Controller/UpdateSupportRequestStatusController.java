package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UpdateSupportRequestStatusController",
        urlPatterns = {"/updateSupportRequestStatus"})
public class UpdateSupportRequestStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // =============================
        // 1. CHECK SESSION + ROLE
        // =============================
        if (session == null
                || session.getAttribute("role") == null
                || !"ADMIN".equalsIgnoreCase(session.getAttribute("role").toString())) {

            // Không phải admin → set null hết
            request.setAttribute("requestDetail", null);
            request.getRequestDispatcher("/WEB-INF/views/admin-support-detail.jsp")
                    .forward(request, response);
            return;
        }

        // =============================
        // 2. LẤY USER ID
        // =============================
        Integer adminId = (Integer) session.getAttribute("userId");
        if (adminId == null) {
            request.setAttribute("requestDetail", null);
            request.getRequestDispatcher("/WEB-INF/views/admin-support-detail.jsp")
                    .forward(request, response);
            return;
        }

        // =============================
        // 3. LẤY PARAM
        // =============================
        String status = request.getParameter("status");
        int requestId = Integer.parseInt(request.getParameter("requestId"));

        SupportRequestDAO dao = new SupportRequestDAO();

        // =============================
        // 4. XỬ LÝ APPROVE / REJECT
        // =============================
        if ("APPROVED".equalsIgnoreCase(status)) {

            dao.approveRequestvunh(requestId);

        } else if ("REJECTED".equalsIgnoreCase(status)) {

            String rejectReason = request.getParameter("rejectReason");
            dao.rejectRequestvunh(requestId, rejectReason);

        }

        // =============================
        // 5. LOAD LẠI DATA
        // =============================
        SupportRequest sr = dao.getSPRById(requestId);

        request.setAttribute("requestDetail", sr);

        response.sendRedirect(
                request.getContextPath() + "/admin-support-detail?requestId=" + requestId
        );

    }
}