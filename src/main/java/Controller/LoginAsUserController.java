package Controller;

import DAO.AuthenDAO;
import Entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class LoginAsUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Nếu vào bằng GET (chưa submit form)
        if (email == null || password == null) {
            request.getRequestDispatcher("/WEB-INF/Authen/LoginAsUser.jsp")
                    .forward(request, response);
            return;
        }

        AuthenDAO dao = new AuthenDAO();
        User user = dao.login(email, password);

        if (user != null) {
            String role = dao.getUserRole(user.getUserId());
            
            HttpSession session = request.getSession();
            session.setAttribute("USER", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", role);

            response.sendRedirect(request.getContextPath() + "/home");

        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/Authen/LoginAsUser.jsp")
                    .forward(request, response);
        }
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
