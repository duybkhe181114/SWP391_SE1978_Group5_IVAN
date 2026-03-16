package Controller;

import DAO.UserProfileDAO;
import DAO.VolunteerSkillDAO;
import DAO.SkillDAO;
import DAO.ProfileUpdateRequestDAO;
import DTO.ProfileUpdateDTO;
import Entity.User;
import Entity.UserProfile;
import Entity.Skill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class VolunteerProfileController extends HttpServlet {

    private UserProfileDAO profileDAO = new UserProfileDAO();
    private SkillDAO skillDAO = new SkillDAO();
    private VolunteerSkillDAO volunteerSkillDAO = new VolunteerSkillDAO();
    private ProfileUpdateRequestDAO requestDAO = new ProfileUpdateRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("userRole");
        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        UserProfile profile = profileDAO.getByUserId(userId);
        List<Skill> allSkills = skillDAO.getAll();
        List<Integer> selectedSkills = volunteerSkillDAO.getSkillIdsByUser(userId);

        boolean hasPending = requestDAO.hasPendingRequest(userId);
        List<ProfileUpdateDTO> requestHistory = requestDAO.getHistoryByUserId(userId);
        request.setAttribute("requestHistory", requestHistory);
        request.setAttribute("profile", profile);
        request.setAttribute("allSkills", allSkills);
        request.setAttribute("selectedSkills", selectedSkills);
        request.setAttribute("hasPendingRequest", hasPending);

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String province = request.getParameter("province");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String dob = request.getParameter("dateOfBirth");

            String[] skills = request.getParameterValues("skills");
            String skillIds = "";
            if (skills != null && skills.length > 0) {
                skillIds = String.join(",", skills);
            }

            requestDAO.createRequest(userId, firstName, lastName, phone, gender, dob, province, address, skillIds);

            response.sendRedirect(request.getContextPath() + "/profile?success=2");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}