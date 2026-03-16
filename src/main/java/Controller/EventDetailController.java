package Controller;

import DAO.EventCommentDAO;
import DAO.EventDAO;
import DAO.EventRegistrationDAO;
import DTO.EventView;
import Entity.EventComment;
import Entity.EventRegistration;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "EventDetailController", urlPatterns = {"/event/detail"})
public class EventDetailController extends HttpServlet {

    private static final DateTimeFormatter REGISTRATION_TIME_FORMAT =
            DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");

    private final EventDAO eventDAO = new EventDAO();
    private final EventRegistrationDAO regDAO = new EventRegistrationDAO();
    private final EventCommentDAO commentDAO = new EventCommentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer eventId = parseEventId(request.getParameter("id"));
        if (eventId == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        EventView event = eventDAO.getEventById(eventId);
        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
            return;
        }

        request.setAttribute("event", event);

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        if ("Organization".equals(userRole) && userId != null) {
            Integer currentOrgId = eventDAO.getOrganizationIdByUserId(userId);
            if (currentOrgId != null && currentOrgId.equals(event.getOrganizationId())) {
                List<Map<String, Object>> volunteers = regDAO.getVolunteersByEvent(eventId);
                long activeTeamCount = countActiveMembers(eventId, volunteers);
                long pendingRegistrationCount = countByStatus(volunteers, "Pending");
                long invitedRegistrationCount = countByStatus(volunteers, "Invited");
                long rejectedRegistrationCount = countByStatus(volunteers, "Rejected");
                long declinedRegistrationCount = countByStatus(volunteers, "Declined");
                int availableVolunteerCount = regDAO.countAvailableVolunteersForEvent(eventId);

                request.setAttribute("activeTeamCount", activeTeamCount);
                request.setAttribute("pendingRegistrationCount", pendingRegistrationCount);
                request.setAttribute("invitedRegistrationCount", invitedRegistrationCount);
                request.setAttribute("rejectedRegistrationCount", rejectedRegistrationCount);
                request.setAttribute("declinedRegistrationCount", declinedRegistrationCount);
                request.setAttribute("availableVolunteerCount", availableVolunteerCount);

                request.getRequestDispatcher("/WEB-INF/views/organization-event-manage.jsp")
                        .forward(request, response);
                return;
            }
        }

        if (("Volunteer".equals(userRole) || "Coordinator".equals(userRole)) && userId != null) {
            DAO.EventCoordinatorDAO coordDAO = new DAO.EventCoordinatorDAO();
            boolean isCoordinator = coordDAO.checkIsCoordinator(eventId, userId);
            if (isCoordinator) {
                List<Map<String, Object>> allVolunteers = regDAO.getVolunteersByEvent(eventId);
                request.setAttribute("allVolunteers", allVolunteers);

                List<Map<String, Object>> approvedVolunteers = new ArrayList<>();
                for (Map<String, Object> volunteer : allVolunteers) {
                    String status = (String) volunteer.get("status");
                    Integer volunteerId = (Integer) volunteer.get("volunteerId");
                    if ("Approved".equals(status) && volunteerId != null && !volunteerId.equals(userId)) {
                        approvedVolunteers.add(volunteer);
                    }
                }

                request.setAttribute("approvedVolunteers", approvedVolunteers);

                DAO.TaskDAO taskDAO = new DAO.TaskDAO();
                String filterStatus = trimToNull(request.getParameter("filterStatus"));
                String filterPriority = trimToNull(request.getParameter("filterPriority"));
                String filterVolunteerId = trimToNull(request.getParameter("filterVolunteerId"));
                request.setAttribute("eventTasks", taskDAO.getTasksByEventFiltered(eventId, filterStatus, filterPriority, filterVolunteerId));
                request.setAttribute("filterStatus", filterStatus);
                request.setAttribute("filterPriority", filterPriority);
                request.setAttribute("filterVolunteerId", filterVolunteerId);
                request.getRequestDispatcher("/WEB-INF/views/coordinator-event-manage.jsp")
                        .forward(request, response);
                return;
            }
        }

        EventRegistration latestRegistration = null;
        String enrollStatus = null;
        String rejectReason = null;

        if (userId != null && "Volunteer".equals(userRole)) {
            latestRegistration = regDAO.getLatestRegistration(eventId, userId);
            if (latestRegistration != null) {
                enrollStatus = latestRegistration.getStatus();
            }

            if ("Rejected".equals(enrollStatus) && latestRegistration != null) {
                rejectReason = latestRegistration.getReviewNote();
            } else if ("Approved".equals(enrollStatus)) {
                DAO.TaskDAO taskDAO = new DAO.TaskDAO();
                request.setAttribute("myTasks", taskDAO.getTasksForVolunteerInEvent(eventId, userId));
            }
        }

        request.setAttribute("latestRegistration", latestRegistration);
        request.setAttribute(
                "latestRegistrationAppliedLabel",
                latestRegistration != null && latestRegistration.getAppliedAt() != null
                        ? latestRegistration.getAppliedAt().format(REGISTRATION_TIME_FORMAT)
                        : null
        );
        request.setAttribute("enrollStatus", enrollStatus);
        request.setAttribute("rejectReason", rejectReason);
        request.setAttribute("eventOpenForApplication", isEventOpenForApplications(event));
        request.setAttribute("eventClosedForFeedback", isEventClosedForFeedback(event));

        String ratingFilterParam = request.getParameter("ratingFilter");
        String sortOrder = trimToNull(request.getParameter("sortOrder"));
        Integer ratingFilter = null;

        if (ratingFilterParam != null && !ratingFilterParam.isEmpty()) {
            try {
                ratingFilter = Integer.parseInt(ratingFilterParam);
            } catch (NumberFormatException ignored) {
            }
        }

        if (sortOrder == null) {
            sortOrder = "newest";
        }

        List<EventComment> comments = commentDAO.getCommentsByEventId(eventId, ratingFilter, sortOrder);
        Double avgRating = commentDAO.getAverageRating(eventId);
        boolean canComment = userId != null && commentDAO.canComment(eventId, userId);

        request.setAttribute("comments", comments);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("canComment", canComment);
        request.setAttribute("ratingFilter", ratingFilter);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("/WEB-INF/views/event-detail.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        if (userId == null || !"Volunteer".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer eventId = parseEventId(request.getParameter("eventId"));
        if (eventId == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        EventView event = eventDAO.getEventById(eventId);
        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        EventRegistration latestRegistration = regDAO.getLatestRegistration(eventId, userId);

        if ("comment".equals(action)) {
            String comment = trimToNull(request.getParameter("comment"));
            Integer rating = parseEventId(request.getParameter("rating"));
            if (comment != null && rating != null && commentDAO.canComment(eventId, userId)) {
                commentDAO.addComment(eventId, userId, comment, rating);
            }
            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId);
            return;
        }

        if ("apply".equals(action)) {
            if (!isEventOpenForApplications(event)) {
                redirectToEvent(response, request, eventId, "error=event_not_open");
                return;
            }
            if (isEventFull(event)) {
                redirectToEvent(response, request, eventId, "error=event_full");
                return;
            }

            String applicationReason = trimToNull(request.getParameter("applicationReason"));
            String relevantExperience = trimToNull(request.getParameter("relevantExperience"));
            String commitmentLevel = trimToNull(request.getParameter("commitmentLevel"));
            String availabilityNote = trimToNull(request.getParameter("availabilityNote"));

            if (applicationReason == null || relevantExperience == null
                    || commitmentLevel == null || availabilityNote == null) {
                redirectToEvent(response, request, eventId, "error=missing_application_fields");
                return;
            }

            if (!regDAO.canApply(eventId, userId)) {
                redirectToEvent(response, request, eventId, "error=already_applied");
                return;
            }

            boolean applied = regDAO.applyToEvent(
                    eventId,
                    userId,
                    applicationReason,
                    relevantExperience,
                    commitmentLevel,
                    availabilityNote
            );
            redirectToEvent(response, request, eventId, applied ? "success=applied" : "error=apply_failed");
            return;
        }

        if ("accept_invitation".equals(action)) {
            if (latestRegistration == null || !"Invited".equals(latestRegistration.getStatus())) {
                redirectToEvent(response, request, eventId, "error=invitation_not_found");
                return;
            }
            if (isEventFull(event)) {
                redirectToEvent(response, request, eventId, "error=event_full");
                return;
            }
            boolean accepted = regDAO.acceptInvitation(latestRegistration.getRegistrationId());
            redirectToEvent(response, request, eventId,
                    accepted ? "success=invitation_accepted" : "error=invitation_accept_failed");
            return;
        }

        if ("decline_invitation".equals(action)) {
            if (latestRegistration == null || !"Invited".equals(latestRegistration.getStatus())) {
                redirectToEvent(response, request, eventId, "error=invitation_not_found");
                return;
            }
            boolean declined = regDAO.declineInvitation(latestRegistration.getRegistrationId());
            redirectToEvent(response, request, eventId,
                    declined ? "success=invitation_declined" : "error=invitation_decline_failed");
            return;
        }

        if ("cancel".equals(action)) {
            if (latestRegistration == null) {
                redirectToEvent(response, request, eventId, "error=registration_not_found");
                return;
            }
            boolean removable = "Pending".equals(latestRegistration.getStatus())
                    || "Approved".equals(latestRegistration.getStatus());
            if (!removable) {
                redirectToEvent(response, request, eventId, "error=invalid_action");
                return;
            }

            boolean deleted = regDAO.deleteRegistration(latestRegistration.getRegistrationId());
            redirectToEvent(response, request, eventId, deleted ? "success=cancelled" : "error=cancel_failed");
            return;
        }

        redirectToEvent(response, request, eventId, "error=invalid_action");
    }

    private Integer parseEventId(String rawValue) {
        try {
            return Integer.parseInt(rawValue);
        } catch (Exception ex) {
            return null;
        }
    }

    private void redirectToEvent(HttpServletResponse response, HttpServletRequest request,
                                 int eventId, String query) throws IOException {
        response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&" + query);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private boolean isEventOpenForApplications(EventView event) {
        if (event == null) {
            return false;
        }
        if (!"Approved".equalsIgnoreCase(event.getStatus())) {
            return false;
        }
        if (event.getEndDate() == null) {
            return true;
        }
        return !event.getEndDate().toLocalDate().isBefore(LocalDate.now());
    }

    private boolean isEventClosedForFeedback(EventView event) {
        if (event == null) {
            return false;
        }
        if ("Closed".equalsIgnoreCase(event.getStatus())) {
            return true;
        }
        return event.getEndDate() != null && event.getEndDate().toLocalDate().isBefore(LocalDate.now());
    }

    private boolean isEventFull(EventView event) {
        return event != null
                && event.getMaxVolunteers() != null
                && event.getMaxVolunteers() > 0
                && event.getCurrentVolunteers() != null
                && event.getCurrentVolunteers() >= event.getMaxVolunteers();
    }

    private long countByStatus(List<Map<String, Object>> registrations, String status) {
        return registrations.stream()
                .filter(row -> status.equals(row.get("status")))
                .count();
    }

    private long countActiveMembers(int eventId, List<Map<String, Object>> volunteers) {
        Set<Integer> memberIds = new HashSet<>();

        for (Map<String, Object> volunteer : volunteers) {
            if (!"Approved".equals(volunteer.get("status"))) {
                continue;
            }
            Integer volunteerId = (Integer) volunteer.get("volunteerId");
            if (volunteerId != null) {
                memberIds.add(volunteerId);
            }
        }

        DAO.EventCoordinatorDAO coordDAO = new DAO.EventCoordinatorDAO();
        for (Entity.EventCoordinator coordinator : coordDAO.getActiveCoordinatorsByEvent(eventId)) {
            if (coordinator.getCoordinatorId() != null) {
                memberIds.add(coordinator.getCoordinatorId());
            }
        }

        return memberIds.size();
    }
}
