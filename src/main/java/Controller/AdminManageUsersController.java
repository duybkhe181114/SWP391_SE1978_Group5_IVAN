package Controller;

import DAO.AdminUserDAO;
import DAO.SkillDAO;
import DTO.UserView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminManageUsersController", urlPatterns = {"/admin/manage-users"})
public class AdminManageUsersController extends HttpServlet {

    private final AdminUserDAO dao = new AdminUserDAO();
    private final SkillDAO skillDAO = new SkillDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String q = request.getParameter("q");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        int page = parsePositiveInt(request.getParameter("page"), 1);
        int pageSize = 5;

        int totalUsers = dao.countUsers(q, role, status, fromDate, toDate);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalUsers / pageSize));
        page = Math.min(page, totalPages);

        request.setAttribute("users", dao.filterUsers(q, role, status, fromDate, toDate, page, pageSize));
        request.setAttribute("allSkills", skillDAO.getAll());
        request.setAttribute("currentAdminId", request.getSession().getAttribute("userId"));
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/views/manage-users.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        int userId = parsePositiveInt(request.getParameter("userId"), -1);
        Integer adminId = (Integer) request.getSession().getAttribute("userId");

        if (userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=user_not_found");
            return;
        }

        if ("edit".equals(action)) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String province = request.getParameter("province");
            String address = request.getParameter("address");
            String newRole = request.getParameter("role");
            String[] skills = request.getParameterValues("skills");

            dao.updateUser(userId, firstName, lastName, phone, province, address, newRole, skills);
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?success=updated");
            return;
        }

        if (adminId != null && adminId == userId) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=self_block");
            return;
        }

        UserView targetUser = dao.getUserById(userId);
        if (targetUser == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=user_not_found");
            return;
        }

        String activeParam = request.getParameter("active");
        if (!"true".equalsIgnoreCase(activeParam) && !"false".equalsIgnoreCase(activeParam)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=status_update_failed");
            return;
        }

        boolean activate = Boolean.parseBoolean(activeParam);

        if ("Organization".equalsIgnoreCase(targetUser.getRole())
                && targetUser.getApprovalStatus() != null
                && !"Approved".equalsIgnoreCase(targetUser.getApprovalStatus())) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=org_review_flow");
            return;
        }

        if ("Admin".equalsIgnoreCase(targetUser.getRole())
                && !activate
                && targetUser.isActive()
                && dao.countActiveAdmins() <= 1) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=last_admin");
            return;
        }

        boolean updated = dao.setUserStatus(userId, activate);
        if (!updated) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=status_update_failed");
            return;
        }

        response.sendRedirect(request.getContextPath()
                + "/admin/manage-users?success=" + (activate ? "unblocked" : "blocked"));
    }

    private boolean isAdmin(HttpServletRequest request) {
        String role = (String) request.getSession().getAttribute("userRole");
        return "Admin".equals(role);
    }

    private int parsePositiveInt(String rawValue, int defaultValue) {
        if (rawValue == null || rawValue.isBlank()) {
            return defaultValue;
        }

        try {
            int value = Integer.parseInt(rawValue);
            return value > 0 ? value : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
