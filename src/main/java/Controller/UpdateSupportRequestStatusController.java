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
        if ("APPROVED".equalsIgnoreCase(status) && "Admin".equalsIgnoreCase(userRole)) {
            dao.approveRequest(requestId, userId, null);
            response.sendRedirect(request.getContextPath() + "/viewSpRequestAdmin");

        } else if ("REJECTED".equalsIgnoreCase(status) && "Admin".equalsIgnoreCase(userRole)) {
            String rejectReason = request.getParameter("rejectReason");
            dao.rejectRequest(requestId, userId, rejectReason, null);
            response.sendRedirect(request.getContextPath() + "/viewSpRequestAdmin");

        } else if ("ACCEPTED".equalsIgnoreCase(status) && "Organization".equalsIgnoreCase(userRole)) {
            dao.acceptRequest(requestId, userId);
            response.sendRedirect(request.getContextPath() + "/org/support-requests");

        } else if ("RESUBMIT".equalsIgnoreCase(status)) {
            dao.resubmit(requestId, userId);
            response.sendRedirect(request.getContextPath() + "/viewSpRequestUser");

        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
        return;
    }
}