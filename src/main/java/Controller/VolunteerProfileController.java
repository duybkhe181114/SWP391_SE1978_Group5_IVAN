package Controller;

import DAO.UserProfileDAO;
import DAO.VolunteerSkillDAO;
import DAO.SkillDAO;
import Entity.User;
import Entity.UserProfile;
import Entity.Skill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/profile")
public class VolunteerProfileController extends HttpServlet {

    private UserProfileDAO profileDAO = new UserProfileDAO();
    private SkillDAO skillDAO = new SkillDAO();
    private VolunteerSkillDAO volunteerSkillDAO = new VolunteerSkillDAO();

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

        request.setAttribute("profile", profile);
        request.setAttribute("allSkills", allSkills);
        request.setAttribute("selectedSkills", selectedSkills);

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        try {
            // Create profile object
            UserProfile profile = new UserProfile();

            profile.setUserId(userId);
            profile.setFirstName(request.getParameter("firstName"));
            profile.setLastName(request.getParameter("lastName"));
            profile.setPhone(request.getParameter("phone"));
            profile.setProvince(request.getParameter("province"));
            profile.setGender(request.getParameter("gender"));
            profile.setAddress(request.getParameter("address"));
            profile.setEmergencyContactName(request.getParameter("emergencyName"));
            profile.setEmergencyContactPhone(request.getParameter("emergencyPhone"));

            String dob = request.getParameter("dateOfBirth");
            if (dob != null && !dob.isEmpty()) {
                profile.setDateOfBirth(LocalDate.parse(dob));
            }

            String[] skills = request.getParameterValues("skills");

            // Update DB
            profileDAO.updateProfile(profile);
            volunteerSkillDAO.updateVolunteerSkills(userId, skills);

            response.sendRedirect(request.getContextPath() + "/profile?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}