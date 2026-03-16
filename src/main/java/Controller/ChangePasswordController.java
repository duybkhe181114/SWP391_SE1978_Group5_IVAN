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
                ? (Integer) session.getAttribute("userId")
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

                // ===== VALIDATE EMPTY =====
                if (oldPass == null || oldPass.trim().isEmpty()
                        || newPass == null || newPass.trim().isEmpty()
                        || confirm == null || confirm.trim().isEmpty()) {
                    request.setAttribute("ERROR", "All fields are required");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }

                // ===== VALIDATE CONFIRM =====
                if (!newPass.equals(confirm)) {
                    request.setAttribute("ERROR", "New password and confirmation do not match");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }

                // ===== VALIDATE STRENGTH =====
                if (newPass.length() < 8) {
                    request.setAttribute("ERROR", "New password must be at least 8 characters");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }
                if (!newPass.matches(".*[A-Z].*")) {
                    request.setAttribute("ERROR", "New password must contain at least 1 uppercase letter");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }
                if (!newPass.matches(".*[0-9].*")) {
                    request.setAttribute("ERROR", "New password must contain at least 1 number");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }

                // ===== CHECK NEW != OLD =====
                if (oldPass.equals(newPass)) {
                    request.setAttribute("ERROR", "New password must be different from old password");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }

                UserDAO dao = new UserDAO();

                // ===== CHECK PASS CŨ =====
                boolean isCorrect = dao.checkOldPassword(userId, oldPass);

                if (!isCorrect) {
                    request.setAttribute("ERROR", "Current password is incorrect");
                    request.getRequestDispatcher(VIEW).forward(request, response);
                    return;
                }

                // ===== UPDATE =====
                boolean updateOk = dao.updatePassword(userId, newPass);

                if (updateOk) {
                    request.setAttribute("SUCCESS", "Password changed successfully!");
                } else {
                    request.setAttribute("ERROR", "Unable to update password. Please try again.");
                }

                request.getRequestDispatcher(VIEW).forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("ERROR", "System error: " + e.getMessage());
                request.getRequestDispatcher(VIEW).forward(request, response);
            }

        } else {
            // Các method khác → 405
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                    "Method " + method + " is not supported");
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
