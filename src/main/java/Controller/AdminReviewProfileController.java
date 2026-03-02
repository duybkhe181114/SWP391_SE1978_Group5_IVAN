package Controller;

import DAO.ProfileUpdateRequestDAO;
import DAO.SkillDAO;
import DTO.ProfileUpdateDTO;
import Entity.Skill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminReviewProfileController", urlPatterns = {"/admin/review-profiles"})
public class AdminReviewProfileController extends HttpServlet {

    private ProfileUpdateRequestDAO requestDAO = new ProfileUpdateRequestDAO();
    private SkillDAO skillDAO = new SkillDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("userRole");
        if (!"Admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Lấy danh sách Request đang Pending
        List<ProfileUpdateDTO> pendingRequests = requestDAO.getPendingRequests();

        // Lấy danh sách Skill để mapping tên Skill ở JSP
        List<Skill> allSkills = skillDAO.getAll();

        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("allSkills", allSkills);

        request.getRequestDispatcher("/WEB-INF/views/review-profiles.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền Admin
        String role = (String) request.getSession().getAttribute("userRole");
        if (!"Admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String reviewNote = request.getParameter("reviewNote");
        Integer adminId = (Integer) request.getSession().getAttribute("userId");
        String action = request.getParameter("action");
        int requestId = Integer.parseInt(request.getParameter("requestId"));

        // Xử lý Duyệt hoặc Từ chối
        if ("approve".equals(action)) {
            requestDAO.approveRequest(requestId, adminId, reviewNote);
        } else if ("reject".equals(action)) {
            requestDAO.rejectRequest(requestId, adminId, reviewNote);
        }

        // Xử lý xong thì load lại trang
        response.sendRedirect(request.getContextPath() + "/admin/review-profiles?success=1");
    }
}