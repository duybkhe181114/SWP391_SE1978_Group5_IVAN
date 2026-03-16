package Controller;

import DAO.OrganizationDAO;
import DAO.OrganizationProfileDAO;
import DAO.OrganizationProfileUpdateRequestDAO;
import DAO.UserProfileDAO;
import DAO.VolunteerSkillDAO;
import DAO.SkillDAO;
import DAO.ProfileUpdateRequestDAO;
import DTO.ProfileUpdateDTO;
import Entity.UserProfile;
import Entity.Skill;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/profile", "/organization/profile"})
public class VolunteerProfileController extends HttpServlet {

    private final UserProfileDAO profileDAO = new UserProfileDAO();
    private final SkillDAO skillDAO = new SkillDAO();
    private final VolunteerSkillDAO volunteerSkillDAO = new VolunteerSkillDAO();
    private final ProfileUpdateRequestDAO requestDAO = new ProfileUpdateRequestDAO();
    private final OrganizationProfileDAO organizationProfileDAO = new OrganizationProfileDAO();
    private final OrganizationProfileUpdateRequestDAO organizationUpdateRequestDAO = new OrganizationProfileUpdateRequestDAO();
    private final OrganizationDAO organizationDAO = new OrganizationDAO();

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

        if ("Organization".equalsIgnoreCase(role)) {
            handleOrganizationGet(request, response, userId);
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

        request.setCharacterEncoding("UTF-8");

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        String role = (String) request.getSession().getAttribute("userRole");
        if ("Organization".equalsIgnoreCase(role)) {
            handleOrganizationPost(request, response, userId);
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

    private void handleOrganizationGet(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        Map<String, Object> profile = organizationProfileDAO.getOrganizationProfile(userId);
        if (profile == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Organization profile not found");
            return;
        }

        Integer organizationId = parseInteger(profile.get("organizationId"));
        if (organizationId != null) {
            request.setAttribute("organizationRecord", organizationDAO.getOrganizationById(organizationId));
            request.setAttribute("organizationStats", organizationDAO.getOrganizationStats(organizationId));
        }

        boolean hasPendingUpdateRequest = organizationUpdateRequestDAO.hasPendingRequest(userId);
        Map<String, Object> latestUpdateRequest = organizationUpdateRequestDAO.getLatestRequest(userId);

        request.setAttribute("profile", profile);
        request.setAttribute("hasPendingUpdateRequest", hasPendingUpdateRequest);
        request.setAttribute("latestUpdateRequest", latestUpdateRequest);
        request.getRequestDispatcher("/WEB-INF/views/organization-profile.jsp")
                .forward(request, response);
    }

    private void handleOrganizationPost(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String organizationName = trimToNull(request.getParameter("organizationName"));
        String organizationType = trimToNull(request.getParameter("organizationType"));
        Integer establishedYear = parseInteger(trimToNull(request.getParameter("establishedYear")));
        String taxCode = trimToNull(request.getParameter("taxCode"));
        String businessLicense = trimToNull(request.getParameter("businessLicense"));
        String representativeName = trimToNull(request.getParameter("representativeName"));
        String representativePosition = trimToNull(request.getParameter("representativePosition"));
        String phone = trimToNull(request.getParameter("phone"));
        String address = trimToNull(request.getParameter("address"));
        String website = trimToNull(request.getParameter("website"));
        String facebookPage = trimToNull(request.getParameter("facebookPage"));
        String description = trimToNull(request.getParameter("description"));

        if (organizationUpdateRequestDAO.hasPendingRequest(userId)) {
            request.setAttribute("error", "There is already a pending organization profile update request.");
            handleOrganizationGet(request, response, userId);
            return;
        }

        if (organizationName == null || organizationType == null || representativeName == null
                || representativePosition == null || phone == null || address == null || description == null) {
            request.setAttribute("error", "Please fill in all required organization profile fields.");
            handleOrganizationGet(request, response, userId);
            return;
        }

        boolean updated = organizationUpdateRequestDAO.createRequest(
                userId,
                organizationName,
                organizationType,
                establishedYear,
                taxCode,
                businessLicense,
                representativeName,
                representativePosition,
                phone,
                address,
                website,
                facebookPage,
                description
        );

        if (!updated) {
            request.setAttribute("error", "Could not update organization profile. Please try again.");
            handleOrganizationGet(request, response, userId);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/organization/profile?success=1");
    }

    private Integer parseInteger(Object value) {
        if (value == null) {
            return null;
        }

        if (value instanceof Integer) {
            return (Integer) value;
        }

        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }

        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
