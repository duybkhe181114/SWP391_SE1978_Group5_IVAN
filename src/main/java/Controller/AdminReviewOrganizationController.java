package Controller;

import DAO.OrganizationProfileDAO;
import DAO.OrganizationProfileUpdateRequestDAO;
import DAO.OrganizationReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public class AdminReviewOrganizationController extends HttpServlet {

    private final OrganizationReviewDAO dao = new OrganizationReviewDAO();
    private final OrganizationProfileDAO organizationProfileDAO = new OrganizationProfileDAO();
    private final OrganizationProfileUpdateRequestDAO updateRequestDAO = new OrganizationProfileUpdateRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String keyword = request.getParameter("q");
        String status = request.getParameter("status");

        List<Map<String, Object>> organizations = dao.getOrganizations(keyword, status);
        List<Map<String, Object>> pendingOrgs = dao.getPendingOrganizations();
        List<Map<String, Object>> pendingProfileUpdates = updateRequestDAO.getPendingRequests();

        request.setAttribute("organizations", organizations);
        request.setAttribute("pendingOrganizations", pendingOrgs);
        request.setAttribute("pendingProfileUpdates", pendingProfileUpdates);

        request.getRequestDispatcher("/WEB-INF/views/admin-review-organizations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Integer adminId = (Integer) request.getSession().getAttribute("userId");
        if (adminId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String requestType = request.getParameter("requestType");
        String action = request.getParameter("action");
        String reviewNote = request.getParameter("reviewNote");

        if ("organization_update".equals(requestType)) {
            handleAdminProfileUpdate(request, response, adminId);
            return;
        }

        if ("profile_update".equals(requestType)) {
            int requestId = parsePositiveInt(request.getParameter("requestId"), -1);
            if (requestId <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?error=invalid_request#review-queue");
                return;
            }

            if ("approve".equals(action)) {
                updateRequestDAO.approveRequest(requestId, adminId, reviewNote);
            } else if ("reject".equals(action)) {
                if (reviewNote == null || reviewNote.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/manage-organizations?error=note_required&requestType=profile_update&requestId="
                            + requestId + "#review-queue");
                    return;
                }
                updateRequestDAO.rejectRequest(requestId, adminId, reviewNote);
            }

            response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?success=reviewed#review-queue");
            return;
        }

        int userId = parsePositiveInt(request.getParameter("userId"), -1);
        if (userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?error=invalid_request#review-queue");
            return;
        }

        if ("approve".equals(action)) {
            dao.approveOrganization(userId, adminId, reviewNote);
        } else if ("reject".equals(action)) {
            if (reviewNote == null || reviewNote.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/manage-organizations?error=note_required&requestType=registration&userId="
                        + userId + "#review-queue");
                return;
            }
            dao.rejectOrganization(userId, adminId, reviewNote);
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?success=reviewed#review-queue");
    }

    private void handleAdminProfileUpdate(HttpServletRequest request, HttpServletResponse response, int adminId)
            throws IOException {
        int userId = parsePositiveInt(request.getParameter("userId"), -1);
        if (userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?error=invalid_request");
            return;
        }

        Map<String, Object> currentProfile = organizationProfileDAO.getOrganizationProfile(userId);
        if (currentProfile == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?error=organization_not_found");
            return;
        }

        String approvalStatus = String.valueOf(currentProfile.get("approvalStatus"));
        if (!"Approved".equalsIgnoreCase(approvalStatus)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?error=organization_not_editable#review-queue");
            return;
        }

        if (updateRequestDAO.hasPendingRequest(userId)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?error=pending_update_exists#review-queue");
            return;
        }

        Integer establishedYear = parseNullableInt(request.getParameter("establishedYear"));

        boolean updated = dao.updateOrganizationProfileByAdmin(
                userId,
                request.getParameter("organizationName"),
                request.getParameter("organizationType"),
                establishedYear,
                request.getParameter("taxCode"),
                request.getParameter("businessLicense"),
                request.getParameter("representativeName"),
                request.getParameter("representativePosition"),
                request.getParameter("phone"),
                request.getParameter("address"),
                request.getParameter("website"),
                request.getParameter("facebookPage"),
                request.getParameter("description"),
                request.getParameter("reviewNote"),
                adminId
        );

        if (!updated) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?error=update_failed");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-organizations?success=updated");
    }

    private boolean isAdmin(HttpServletRequest request) {
        String role = (String) request.getSession().getAttribute("userRole");
        return "Admin".equals(role);
    }

    private int parsePositiveInt(String rawValue, int defaultValue) {
        if (rawValue == null || rawValue.isBlank()) {
            return defaultValue;
        }

        try {
            int value = Integer.parseInt(rawValue);
            return value > 0 ? value : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private Integer parseNullableInt(String rawValue) {
        if (rawValue == null || rawValue.isBlank()) {
            return null;
        }

        try {
            return Integer.parseInt(rawValue.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
