package Controller;

import DAO.OrganizationDAO;
import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/adminSpRequestDetail")
public class AdminSPRDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userRole = null;
        if (session != null && session.getAttribute("userRole") != null) {
            userRole = session.getAttribute("userRole").toString();
        }

        request.setAttribute("userRole", userRole);

        String idRaw = request.getParameter("id");

        int requestId;

        try {
            requestId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect("viewSpRequestAdmin");
            return;
        }

        SupportRequestDAO dao = new SupportRequestDAO();
        SupportRequest spr = dao.getSPRById(requestId);

        request.setAttribute("requestDetail", spr);

        if (spr != null && "ACCEPTED".equalsIgnoreCase(spr.getStatus()) && spr.getReviewedBy() != null) {
            OrganizationDAO orgDao = new OrganizationDAO();
            Map<String, Object> org = orgDao.getOrgByUserId(spr.getReviewedBy());
            request.setAttribute("acceptedByOrg", org);
        }

        request.getRequestDispatcher("/WEB-INF/views/admin-support-detail.jsp")
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