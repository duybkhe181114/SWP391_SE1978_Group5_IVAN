package Controller;

import DAO.OrganizationReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class AdminReviewOrganizationController extends HttpServlet {

    private OrganizationReviewDAO dao = new OrganizationReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("userRole");
        if (!"Admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        List<Map<String, Object>> pendingOrgs = dao.getPendingOrganizations();
        request.setAttribute("pendingOrganizations", pendingOrgs);

        request.getRequestDispatcher("/WEB-INF/views/admin-review-organizations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("userRole");
        if (!"Admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));
        String action = request.getParameter("action");
        String reviewNote = request.getParameter("reviewNote");
        Integer adminId = (Integer) request.getSession().getAttribute("userId");

        if ("approve".equals(action)) {
            dao.approveOrganization(userId, adminId, reviewNote);
        } else if ("reject".equals(action)) {
            if (reviewNote == null || reviewNote.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/review-organizations?error=note_required");
                return;
            }
            dao.rejectOrganization(userId, adminId, reviewNote);
        }

        response.sendRedirect(request.getContextPath() + "/admin/review-organizations?success=1");
    }
}
