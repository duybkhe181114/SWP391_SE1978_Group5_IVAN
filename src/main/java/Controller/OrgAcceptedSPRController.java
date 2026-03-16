package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

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

        request.setAttribute("acceptedList", list);
        request.getRequestDispatcher("/WEB-INF/views/org-accepted-spr-list.jsp")
                .forward(request, response);
    }
}
