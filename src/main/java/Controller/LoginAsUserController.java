package Controller;

import DAO.AuthenDAO;
import Entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginAsUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // ===== MỞ FORM LẦN ĐẦU =====
        if (email == null || password == null) {
            request.getRequestDispatcher("/WEB-INF/Authen/LoginAsUser.jsp")
                    .forward(request, response);
            return;
        }

        AuthenDAO dao = new AuthenDAO();
        User user = dao.login(email, password);

        // ===== ĐĂNG NHẬP THÀNH CÔNG =====
        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("USER", user);
            session.setAttribute("USER_ID", user.getUserId());   // dùng cho change password

            request.setAttribute("SUCCESS",
                    "Đăng nhập thành công! Xin chào " + user.getEmail());

        }
        // ===== ĐĂNG NHẬP THẤT BẠI =====
        else {
            request.setAttribute("ERROR",
                    "Email hoặc mật khẩu không đúng");
        }

        // Ở lại trang login để hiện message
        request.getRequestDispatcher("/WEB-INF/Authen/LoginAsUser.jsp")
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
