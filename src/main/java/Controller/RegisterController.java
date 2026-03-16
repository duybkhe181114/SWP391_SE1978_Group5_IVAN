package Controller;

import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterController", urlPatterns = {"/register", "/register/volunteer", "/register/user", "/register/organization", "/register/organization/resubmit"})
public class RegisterController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if ("/register".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/register-choice.jsp").forward(request, response);
        } else if ("/register/volunteer".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/register-volunteer.jsp").forward(request, response);
        } else if ("/register/user".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/register-user.jsp").forward(request, response);
        } else if ("/register/organization".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/register-organization.jsp").forward(request, response);
        } else if ("/register/organization/resubmit".equals(path)) {
            handleResubmitGet(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if ("/register/volunteer".equals(path)) {
            handleVolunteerRegister(request, response);
        } else if ("/register/user".equals(path)) {
            handleUserRegister(request, response);
        } else if ("/register/organization".equals(path)) {
            handleOrganizationRegister(request, response);
        } else if ("/register/organization/resubmit".equals(path)) {
            handleResubmitPost(request, response);
        }
    }
    
    // Xử lý đăng ký Volunteer
    private void handleVolunteerRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        
        // Validate
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/WEB-INF/views/register-volunteer.jsp").forward(request, response);
            return;
        }
        
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("/WEB-INF/views/register-volunteer.jsp").forward(request, response);
            return;
        }
        
        // Tạo Volunteer (Active ngay)
        int userId = userDAO.createVolunteer(email, password);
        
        if (userId > 0) {
            userDAO.assignRole(userId, "Volunteer");
            userDAO.createEmptyProfile(userId, firstName, lastName);
            response.sendRedirect(request.getContextPath() + "/login?success=registered");
        } else {
            request.setAttribute("error", "Registration failed");
            request.getRequestDispatcher("/WEB-INF/views/register-volunteer.jsp").forward(request, response);
        }
    }
    
    // Xử lý đăng ký User (giống Volunteer nhưng không tham gia sự kiện)
    private void handleUserRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        
        // Validate
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/WEB-INF/views/register-user.jsp").forward(request, response);
            return;
        }
        
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("/WEB-INF/views/register-user.jsp").forward(request, response);
            return;
        }
        
        // Tạo User (Active ngay, role = User)
        int userId = userDAO.createVolunteer(email, password);
        
        if (userId > 0) {
            userDAO.assignRole(userId, "User");
            userDAO.createEmptyProfile(userId, firstName, lastName);
            response.sendRedirect(request.getContextPath() + "/login?success=registered");
        } else {
            request.setAttribute("error", "Registration failed");
            request.getRequestDispatcher("/WEB-INF/views/register-user.jsp").forward(request, response);
        }
    }
    
    // Xử lý đăng ký Organization
    private void handleOrganizationRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Organization Info
        String organizationName = request.getParameter("organizationName");
        String organizationType = request.getParameter("organizationType");
        String establishedYearStr = request.getParameter("establishedYear");
        String taxCode = request.getParameter("taxCode");
        String businessLicense = request.getParameter("businessLicense");
        
        // Contact Info
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String website = request.getParameter("website");
        String facebookPage = request.getParameter("facebookPage");
        
        // Representative Info
        String representativeName = request.getParameter("representativeName");
        String representativePosition = request.getParameter("representativePosition");
        
        // Description
        String description = request.getParameter("description");
        
        // Validate
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/WEB-INF/views/register-organization.jsp").forward(request, response);
            return;
        }
        
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("/WEB-INF/views/register-organization.jsp").forward(request, response);
            return;
        }
        
        // Parse Established Year
        Integer establishedYear = null;
        if (establishedYearStr != null && !establishedYearStr.isEmpty()) {
            try {
                establishedYear = Integer.parseInt(establishedYearStr);
            } catch (NumberFormatException e) {}
        }
        
        // Tạo Organization (Pending, chờ admin duyệt)
        int userId = userDAO.createOrganization(email, password);
        
        System.out.println("[DEBUG] Organization Register - userId: " + userId);
        System.out.println("[DEBUG] Organization Register - organizationName: " + organizationName);
        
        if (userId > 0) {
            boolean roleAssigned = userDAO.assignRole(userId, "Organization");
            System.out.println("[DEBUG] Role assigned: " + roleAssigned);
            
            boolean profileCreated = userDAO.createOrganizationProfile(
                userId, organizationName, organizationType, establishedYear,
                taxCode, businessLicense, representativeName, representativePosition,
                phone, address, website, facebookPage, description
            );
            System.out.println("[DEBUG] Profile created: " + profileCreated);
            
            response.sendRedirect(request.getContextPath() + "/login?pending=true");
        } else {
            System.err.println("[ERROR] Failed to create user account");
            request.setAttribute("error", "Registration failed");
            request.getRequestDispatcher("/WEB-INF/views/register-organization.jsp").forward(request, response);
        }
    }
    
    private void handleResubmitGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        DAO.OrganizationProfileDAO dao = new DAO.OrganizationProfileDAO();
        java.util.Map<String, Object> profile = dao.getOrganizationProfile(userId);
        
        if (profile != null) {
            request.setAttribute("profile", profile);
            request.setAttribute("resubmit", true);
            request.getRequestDispatcher("/WEB-INF/views/register-organization.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    private void handleResubmitPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        String organizationName = request.getParameter("organizationName");
        String organizationType = request.getParameter("organizationType");
        String establishedYearStr = request.getParameter("establishedYear");
        String taxCode = request.getParameter("taxCode");
        String businessLicense = request.getParameter("businessLicense");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String website = request.getParameter("website");
        String facebookPage = request.getParameter("facebookPage");
        String representativeName = request.getParameter("representativeName");
        String representativePosition = request.getParameter("representativePosition");
        String description = request.getParameter("description");
        
        Integer establishedYear = null;
        if (establishedYearStr != null && !establishedYearStr.isEmpty()) {
            try {
                establishedYear = Integer.parseInt(establishedYearStr);
            } catch (NumberFormatException e) {}
        }
        
        DAO.OrganizationProfileDAO dao = new DAO.OrganizationProfileDAO();
        boolean updated = dao.updateOrganizationProfile(userId, organizationName, organizationType,
                establishedYear, taxCode, businessLicense, representativeName, representativePosition,
                phone, address, website, facebookPage, description);
        
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/login?pending=true");
        } else {
            request.setAttribute("error", "Update failed");
            handleResubmitGet(request, response);
        }
    }
}
