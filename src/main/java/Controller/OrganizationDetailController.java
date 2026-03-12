package Controller;

import DAO.EventDAO;
import DAO.OrganizationDAO;
import DTO.EventView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrganizationDetailController", urlPatterns = {"/organization/detail"})
public class OrganizationDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int orgId = Integer.parseInt(idParam);

        OrganizationDAO orgDAO = new OrganizationDAO();
        Map<String, Object> org = orgDAO.getOrganizationById(orgId);

        if (org == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Organization not found");
            return;
        }

        EventDAO eventDAO = new EventDAO();
        List<EventView> orgEvents = eventDAO.getEventsByOrganization(orgId);

        Map<String, Integer> orgStats = orgDAO.getOrganizationStats(orgId);

        request.setAttribute("org", org);
        request.setAttribute("orgEvents", orgEvents);
        request.setAttribute("orgStats", orgStats);

        request.getRequestDispatcher("/WEB-INF/views/org-detail.jsp").forward(request, response);
    }
}
