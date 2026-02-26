package Controller;

import DAO.AuthenDAO;
import DAO.UserProfileDAO;
import Entity.User;
import Entity.UserProfile;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class LoginAsUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

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

            UserProfileDAO profileDAO = new UserProfileDAO();
            UserProfile profile = profileDAO.getByUserId(user.getUserId());

            String displayName = "User";
            if (profile != null && profile.getFirstName() != null) {
                displayName = profile.getFirstName();
                if (profile.getLastName() != null) {
                    displayName += " " + profile.getLastName();
                }
            } else {
                displayName = email.substring(0, email.indexOf("@"));
            }
            session.setAttribute("userName", displayName);

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