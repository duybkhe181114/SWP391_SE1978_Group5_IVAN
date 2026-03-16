package Controller;

import DAO.AdminUserDAO;
import DAO.SkillDAO; // Thêm import này
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminManageUsersController", urlPatterns = {"/admin/manage-users"})
public class AdminManageUsersController extends HttpServlet {

    private AdminUserDAO dao = new AdminUserDAO();
    private SkillDAO skillDAO = new SkillDAO(); //

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

        int page = 1;
        int pageSize = 5;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        int totalUsers = dao.countUsers(q, role, status, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        request.setAttribute("users", dao.filterUsers(q, role, status, fromDate, toDate, page, pageSize));

        // Ném danh sách allSkills sang cho Modal
        request.setAttribute("allSkills", skillDAO.getAll());

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
        int userId = Integer.parseInt(request.getParameter("userId"));

        if ("edit".equals(action)) {
            // Nhận các tham số mới
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String province = request.getParameter("province");
            String address = request.getParameter("address");
            String newRole = request.getParameter("role");
            String[] skills = request.getParameterValues("skills");

            dao.updateUser(userId, firstName, lastName, phone, province, address, newRole, skills);

        } else {
            dao.toggleUserStatus(userId);
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-users");
    }

    private boolean isAdmin(HttpServletRequest request) {
        String role = (String) request.getSession().getAttribute("userRole");
        return "Admin".equals(role);
    }
}