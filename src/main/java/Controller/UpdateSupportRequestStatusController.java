package Controller;

import DAO.SupportRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UpdateSupportRequestStatusController", urlPatterns = { "/updateSupportRequestStatus" })
public class UpdateSupportRequestStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // =============================
        // 1. CHECK SESSION
        // =============================
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userRole = session.getAttribute("userRole").toString();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // =============================
        // 2. LẤY PARAM
        // =============================
        String status = request.getParameter("status");
        int requestId = Integer.parseInt(request.getParameter("requestId"));

        SupportRequestDAO dao = new SupportRequestDAO();

        // =============================
        // 3. PHÂN QUYỀN + XỬ LÝ
        // =============================
        if ("APPROVED".equalsIgnoreCase(status) && "ADMIN".equalsIgnoreCase(userRole)) {
            // Admin approve PENDING → APPROVED
            dao.approveRequestvunh(requestId);

        } else if ("REJECTED".equalsIgnoreCase(status) && "ADMIN".equalsIgnoreCase(userRole)) {
            // Admin reject PENDING → REJECTED
            String rejectReason = request.getParameter("rejectReason");
            dao.rejectRequestvunh(requestId, rejectReason);

        } else if ("ACCEPTED".equalsIgnoreCase(status) && "Organization".equalsIgnoreCase(userRole)) {
            // Organization accept APPROVED → ACCEPTED
            dao.acceptRequest(requestId, userId);

        } else {
            // Role không được phép → redirect về danh sách
            response.sendRedirect(request.getContextPath() + "/viewSpRequestAdmin");
            return;
        }

        // =============================
        // 4. REDIRECT VỀ DANH SÁCH
        // =============================
        response.sendRedirect(request.getContextPath() + "/viewSpRequestAdmin");
    }
}