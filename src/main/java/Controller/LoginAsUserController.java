package Controller;

import DAO.AuthenDAO;
import DAO.UserProfileDAO;
import DAO.OrganizationProfileDAO;
import Entity.User;
import Entity.UserProfile;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

public class LoginAsUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            String success = request.getParameter("success");
            String pending = request.getParameter("pending");
            
            if ("registered".equals(success)) {
                request.setAttribute("success", "Registration successful! Please login.");
            }
            if ("true".equals(pending)) {
                request.setAttribute("info", "Registration submitted! Your account is pending admin approval.");
            }
            
            request.getRequestDispatcher("/WEB-INF/Authen/LoginAsUser.jsp")
                    .forward(request, response);
            return;
        }

        AuthenDAO dao = new AuthenDAO();
        User user = dao.login(email, password);

        if (user == null) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/Authen/LoginAsUser.jsp").forward(request, response);
            return;
        }
        
        if (!user.getIsActive()) {
                String role = dao.getUserRole(user.getUserId());
                
                if ("Organization".equals(role)) {
                    OrganizationProfileDAO orgDAO = new OrganizationProfileDAO();
                    Map<String, Object> profile = orgDAO.getOrganizationProfile(user.getUserId());
                    
                    if (profile != null) {
                        String status = (String) profile.get("approvalStatus");
                        
                        if ("Pending".equals(status)) {
                            request.setAttribute("error", "Your account is pending admin approval. Please wait.");
                            request.getRequestDispatcher("/WEB-INF/Authen/LoginAsUser.jsp").forward(request, response);
                            return;
                        } else if ("Rejected".equals(status)) {
                            response.sendRedirect(request.getContextPath() + "/register/organization/resubmit?userId=" + user.getUserId());
                            return;
                        }
                    }
                }
                
                request.setAttribute("error", "Your account is not active. Please contact support.");
                request.getRequestDispatcher("/WEB-INF/Authen/LoginAsUser.jsp").forward(request, response);
                return;
            }
            
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