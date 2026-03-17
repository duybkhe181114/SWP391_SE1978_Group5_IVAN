package Controller;

import DAO.EventDAO;
import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/org/accepted-requests")
public class OrgAcceptedSPRController extends HttpServlet {

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

        int userId = (Integer) session.getAttribute("userId");

        SupportRequestDAO dao = new SupportRequestDAO();
        List<SupportRequest> list = dao.getAcceptedByOrg(userId);

        // Build map requestId -> linkedEventId
        EventDAO eventDAO = new EventDAO();
        Map<Integer, Integer> linkedEventMap = new HashMap<>();
        for (SupportRequest sr : list) {
            Integer eventId = eventDAO.getLinkedEventId(sr.getRequestId());
            if (eventId != null) linkedEventMap.put(sr.getRequestId(), eventId);
        }

        request.setAttribute("acceptedList", list);
        request.setAttribute("linkedEventMap", linkedEventMap);
        request.getRequestDispatcher("/WEB-INF/views/org-accepted-spr-list.jsp")
                .forward(request, response);
    }
}
