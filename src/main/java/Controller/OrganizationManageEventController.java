package Controller;

import DAO.EventDAO;
import DAO.EventRegistrationDAO;
import DTO.EventView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet(name = "OrganizationManageEventController", urlPatterns = {"/organization/manage-event"})
public class OrganizationManageEventController extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final EventRegistrationDAO registrationDAO = new EventRegistrationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = session == null ? null : (String) session.getAttribute("userRole");
        Integer userId = session == null ? null : (Integer) session.getAttribute("userId");

        if (userId == null || !"Organization".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int eventId;
        try {
            eventId = Integer.parseInt(request.getParameter("eventId"));
        } catch (Exception ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid event ID");
            return;
        }

        if (!eventDAO.isEventOwnedByUser(eventId, userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not own this event");
            return;
        }

        String action = request.getParameter("action");
        String returnTo = trimToNull(request.getParameter("returnTo"));
        if ("update_event".equals(action)) {
            handleUpdateEvent(request, response, userId, eventId, returnTo);
            return;
        }

        if ("invite_volunteer".equals(action)) {
            handleInviteVolunteer(request, response, userId, eventId, returnTo);
            return;
        }

        redirectWithMessage(response, request, eventId, returnTo, "error=invalid_action");
    }

    private void handleUpdateEvent(HttpServletRequest request, HttpServletResponse response,
                                   int userId, int eventId, String returnTo) throws IOException {

        String title = trimToNull(request.getParameter("title"));
        String description = trimToNull(request.getParameter("description"));
        String location = trimToNull(request.getParameter("location"));
        String coverImageUrl = trimToNull(request.getParameter("coverImageUrl"));
        String startDate = trimToNull(request.getParameter("startDate"));
        String endDate = trimToNull(request.getParameter("endDate"));
        String maxVolunteersRaw = trimToNull(request.getParameter("maxVolunteers"));

        Integer organizationId = eventDAO.getOrganizationIdByUserId(userId);
        if (organizationId == null) {
            redirectWithMessage(response, request, eventId, returnTo, "error=organization_not_found");
            return;
        }

        if (title == null || description == null || location == null || startDate == null || endDate == null || maxVolunteersRaw == null) {
            redirectWithMessage(response, request, eventId, returnTo, "error=missing_event_fields");
            return;
        }

        int maxVolunteers;
        try {
            maxVolunteers = Integer.parseInt(maxVolunteersRaw);
        } catch (NumberFormatException ex) {
            redirectWithMessage(response, request, eventId, returnTo, "error=invalid_slot_limit");
            return;
        }

        if (maxVolunteers < 0) {
            redirectWithMessage(response, request, eventId, returnTo, "error=invalid_slot_limit");
            return;
        }

        try {
            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);
            if (end.isBefore(start)) {
                redirectWithMessage(response, request, eventId, returnTo, "error=invalid_event_dates");
                return;
            }
        } catch (Exception ex) {
            redirectWithMessage(response, request, eventId, returnTo, "error=invalid_event_dates");
            return;
        }

        EventView currentEvent = eventDAO.getEventById(eventId);
        if (currentEvent == null) {
            response.sendRedirect(request.getContextPath() + "/organization/dashboard?error=event_not_found");
            return;
        }

        if (maxVolunteers > 0 && currentEvent.getCurrentVolunteers() != null
                && maxVolunteers < currentEvent.getCurrentVolunteers()) {
            redirectWithMessage(response, request, eventId, returnTo, "error=slot_below_joined");
            return;
        }

        boolean updated = eventDAO.updateEventByOrganization(
                eventId,
                organizationId,
                title,
                description,
                location,
                coverImageUrl,
                startDate,
                endDate,
                maxVolunteers
        );

        redirectWithMessage(response, request, eventId, returnTo,
                updated ? "success=event_updated" : "error=event_update_failed");
    }

    private void handleInviteVolunteer(HttpServletRequest request, HttpServletResponse response,
                                       int userId, int eventId, String returnTo) throws IOException {

        String volunteerIdRaw = trimToNull(request.getParameter("volunteerId"));
        String invitationMessage = trimToNull(request.getParameter("invitationMessage"));
        if (volunteerIdRaw == null) {
            redirectWithMessage(response, request, eventId, returnTo, "error=missing_volunteer");
            return;
        }

        int volunteerId;
        try {
            volunteerId = Integer.parseInt(volunteerIdRaw);
        } catch (NumberFormatException ex) {
            redirectWithMessage(response, request, eventId, returnTo, "error=missing_volunteer");
            return;
        }

        EventView event = eventDAO.getEventById(eventId);
        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/organization/dashboard?error=event_not_found");
            return;
        }

        Integer maxVolunteers = event.getMaxVolunteers();
        Integer currentVolunteers = event.getCurrentVolunteers();
        if (maxVolunteers != null && maxVolunteers > 0
                && currentVolunteers != null && currentVolunteers >= maxVolunteers) {
            redirectWithMessage(response, request, eventId, returnTo, "error=event_full");
            return;
        }

        boolean invited = registrationDAO.inviteVolunteerToEvent(
                eventId,
                volunteerId,
                userId,
                invitationMessage == null
                        ? "You are invited to join this event. Please review the details and confirm if you can participate."
                        : invitationMessage
        );

        redirectWithMessage(response, request, eventId, returnTo,
                invited ? "success=volunteer_invited" : "error=volunteer_invite_failed");
    }

    private void redirectWithMessage(HttpServletResponse response, HttpServletRequest request,
                                     int eventId, String returnTo, String query) throws IOException {
        String basePath = resolveReturnPath(request, eventId, returnTo);
        String separator = basePath.contains("?") ? "&" : "?";
        response.sendRedirect(basePath + separator + query);
    }

    private String resolveReturnPath(HttpServletRequest request, int eventId, String returnTo) {
        String contextPath = request.getContextPath();
        if ("volunteer-pool".equalsIgnoreCase(String.valueOf(returnTo))) {
            return contextPath + "/organization/volunteer-pool?eventId=" + eventId;
        }
        if ("active-team".equalsIgnoreCase(String.valueOf(returnTo))) {
            return contextPath + "/organization/active-team?eventId=" + eventId;
        }
        if ("registration-log".equalsIgnoreCase(String.valueOf(returnTo))) {
            return contextPath + "/organization/registration-log?eventId=" + eventId;
        }
        return contextPath + "/event/detail?id=" + eventId;
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }

        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
