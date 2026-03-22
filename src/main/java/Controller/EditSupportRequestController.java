package Controller;

import DAO.SupportCategoryDAO;
import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/editSupportRequest")
public class EditSupportRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        int requestId = Integer.parseInt(request.getParameter("id"));

        SupportRequest sr = new SupportRequestDAO().getSPRById(requestId);

        // Chỉ cho phép owner edit khi PENDING hoặc REJECTED
        if (sr == null || !sr.getCreatedBy().equals(userId)
                || "ACCEPTED".equalsIgnoreCase(sr.getStatus())
                || "APPROVED".equalsIgnoreCase(sr.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/viewSpRequestUser");
            return;
        }

        request.setAttribute("sr", sr);
        request.setAttribute("categories", new SupportCategoryDAO().getAll());
        request.getRequestDispatcher("/WEB-INF/views/edit-support-request.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        int requestId = Integer.parseInt(request.getParameter("requestId"));

        String affectedStr = request.getParameter("affectedPeople");
        String amountStr   = request.getParameter("estimatedAmount");

        SupportRequest sr = new SupportRequest();
        sr.setRequestId(requestId);
        sr.setCreatedBy(userId);
        sr.setTitle(request.getParameter("title"));
        sr.setCategoryId(request.getParameter("categoryId"));
        sr.setPriority(request.getParameter("priority"));
        sr.setSupportLocation(request.getParameter("supportLocation"));
        sr.setBeneficiaryName(request.getParameter("beneficiaryName"));
        sr.setAffectedPeople(affectedStr == null || affectedStr.isEmpty() ? null : Integer.parseInt(affectedStr));
        sr.setEstimatedAmount(amountStr == null || amountStr.isEmpty() ? null : Double.parseDouble(amountStr));
        sr.setDescription(request.getParameter("description"));
        sr.setContactEmail(request.getParameter("contactEmail"));
        sr.setContactPhone(request.getParameter("contactPhone"));

        SupportRequestDAO dao = new SupportRequestDAO();
        SupportRequest existing = dao.getSPRById(requestId);
        // Chỉ cho phép edit khi PENDING hoặc REJECTED và đúng owner
        if (existing == null || !existing.getCreatedBy().equals(userId)
                || ("ACCEPTED".equalsIgnoreCase(existing.getStatus()) || "APPROVED".equalsIgnoreCase(existing.getStatus()))) {
            response.sendRedirect(request.getContextPath() + "/viewSpRequestUser");
            return;
        }
        dao.update(sr);
        response.sendRedirect(request.getContextPath() + "/viewSpRequestUser");
    }
}
