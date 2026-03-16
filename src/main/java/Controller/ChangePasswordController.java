package Controller;

import DAO.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/changepassword")
public class ChangePasswordController extends HttpServlet {

    private static final String VIEW = "/WEB-INF/Authen/ChangePassword.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        Integer userId = (session != null)
                ? (Integer) session.getAttribute("USER_ID")
                : null;

        // ===== CHƯA LOGIN =====
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String method = request.getMethod();

        if ("GET".equalsIgnoreCase(method)) {
            // GET → hiển thị form
            request.getRequestDispatcher(VIEW).forward(request, response);

        } else if ("POST".equalsIgnoreCase(method)) {
            // POST → xử lý submit
            try {
                String oldPass = request.getParameter("oldPassword");
                String newPass = request.getParameter("newPassword");
                String confirm = request.getParameter("confirmPassword");

                // ===== VALIDATE CONFIRM =====
                if (!newPass.equals(confirm)) {
                    request.setAttribute("ERROR", "Mật khẩu xác nhận không khớp");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }

                UserDAO dao = new UserDAO();

                // ===== CHECK PASS CŨ =====
                boolean isCorrect = dao.checkOldPassword(userId, oldPass);

                if (!isCorrect) {
                    request.setAttribute("ERROR", "Mật khẩu cũ không đúng");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }

                // ===== UPDATE =====
                boolean updateOk = dao.updatePassword(userId, newPass);

                if (updateOk) {
                    request.setAttribute("SUCCESS", "Đổi mật khẩu thành công");
                } else {
                    request.setAttribute("ERROR", "Không thể cập nhật mật khẩu");
                }

                request.getRequestDispatcher(VIEW).forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("ERROR", "Lỗi hệ thống: " + e.getMessage());
                request.getRequestDispatcher(VIEW).forward(request, response);
            }

        } else {
            // Các method khác → 405
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                    "Method " + method + " không được hỗ trợ");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processRequest(req, resp);
    }
}
