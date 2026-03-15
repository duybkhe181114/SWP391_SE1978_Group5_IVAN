package Controller;

import DAO.EventCoordinatorDAO;
import DAO.EventDAO;
import DAO.EventRegistrationDAO;
import DTO.EventView;
import Entity.EventCoordinator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet(urlPatterns = {
        "/organization/volunteer-pool",
        "/organization/active-team",
        "/organization/registration-log"
})
public class OrganizationEventRosterController extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final EventRegistrationDAO registrationDAO = new EventRegistrationDAO();
    private final EventCoordinatorDAO coordinatorDAO = new EventCoordinatorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

        EventView event = eventDAO.getEventById(eventId);
        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
            return;
        }

        request.setAttribute("event", event);

        String servletPath = request.getServletPath();
        if ("/organization/volunteer-pool".equals(servletPath)) {
            showVolunteerPool(request, response, eventId);
            return;
        }

        if ("/organization/active-team".equals(servletPath)) {
            showActiveTeam(request, response, eventId);
            return;
        }

        showRegistrationLog(request, response, eventId);
    }

    private void showVolunteerPool(HttpServletRequest request, HttpServletResponse response, int eventId)
            throws ServletException, IOException {

        String query = trimToNull(request.getParameter("q"));
        List<Map<String, Object>> availableVolunteers =
                registrationDAO.getAvailableVolunteersForEvent(eventId, query);

        request.setAttribute("poolQuery", query);
        request.setAttribute("availableVolunteers", availableVolunteers);
        request.getRequestDispatcher("/WEB-INF/views/organization-volunteer-pool.jsp")
                .forward(request, response);
    }

    private void showActiveTeam(HttpServletRequest request, HttpServletResponse response, int eventId)
            throws ServletException, IOException {

        String query = trimToNull(request.getParameter("q"));
        String roleFilter = trimToNull(request.getParameter("role"));

        List<Map<String, Object>> activeTeam = buildActiveTeam(eventId, query, roleFilter);

        request.setAttribute("teamQuery", query);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("activeTeam", activeTeam);
        request.getRequestDispatcher("/WEB-INF/views/organization-active-team.jsp")
                .forward(request, response);
    }

    private void showRegistrationLog(HttpServletRequest request, HttpServletResponse response, int eventId)
            throws ServletException, IOException {

        String query = trimToNull(request.getParameter("q"));
        String statusFilter = trimToNull(request.getParameter("status"));

        List<Map<String, Object>> volunteers = registrationDAO.getVolunteersByEvent(eventId);
        List<Map<String, Object>> registrationLog = new ArrayList<>();
        for (Map<String, Object> volunteer : volunteers) {
            String status = String.valueOf(volunteer.get("status"));
            if (!"Pending".equals(status) && !"Rejected".equals(status)) {
                continue;
            }

            if (statusFilter != null && !statusFilter.equalsIgnoreCase(status)) {
                continue;
            }

            if (!matchesSearch(volunteer, query)) {
                continue;
            }

            registrationLog.add(volunteer);
        }

        request.setAttribute("logQuery", query);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("registrationLog", registrationLog);
        request.getRequestDispatcher("/WEB-INF/views/organization-registration-log.jsp")
                .forward(request, response);
    }

    private boolean matchesRoleFilter(Map<String, Object> volunteer, String roleFilter) {
        if (roleFilter == null || roleFilter.isBlank()) {
            return true;
        }

        boolean isCoordinator = asInt(volunteer.get("isCoordinator")) == 1;
        if ("coordinator".equalsIgnoreCase(roleFilter)) {
            return isCoordinator;
        }
        if ("volunteer".equalsIgnoreCase(roleFilter)) {
            return !isCoordinator;
        }
        return true;
    }

    private boolean matchesSearch(Map<String, Object> volunteer, String query) {
        if (query == null || query.isBlank()) {
            return true;
        }

        String normalizedQuery = query.toLowerCase(Locale.ROOT);
        return contains(volunteer.get("fullName"), normalizedQuery)
                || contains(volunteer.get("email"), normalizedQuery)
                || contains(volunteer.get("phone"), normalizedQuery);
    }

    private boolean contains(Object value, String query) {
        return value != null && String.valueOf(value).toLowerCase(Locale.ROOT).contains(query);
    }

    private int asInt(Object value) {
        if (value instanceof Number number) {
            return number.intValue();
        }
        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception ex) {
            return 0;
        }
    }

    private List<Map<String, Object>> buildActiveTeam(int eventId, String query, String roleFilter) {
        Map<Integer, Map<String, Object>> membersByUserId = new LinkedHashMap<>();

        List<Map<String, Object>> volunteers = registrationDAO.getVolunteersByEvent(eventId);
        for (Map<String, Object> volunteer : volunteers) {
            if (!"Approved".equals(volunteer.get("status"))) {
                continue;
            }

            Integer volunteerId = (Integer) volunteer.get("volunteerId");
            if (volunteerId == null) {
                continue;
            }

            membersByUserId.put(volunteerId, new HashMap<>(volunteer));
        }

        for (EventCoordinator coordinator : coordinatorDAO.getActiveCoordinatorsByEvent(eventId)) {
            Integer coordinatorId = coordinator.getCoordinatorId();
            if (coordinatorId == null) {
                continue;
            }

            Map<String, Object> existingMember = membersByUserId.get(coordinatorId);
            if (existingMember != null) {
                existingMember.put("isCoordinator", 1);
                continue;
            }

            Map<String, Object> coordinatorMember = new HashMap<>();
            coordinatorMember.put("registrationId", null);
            coordinatorMember.put("volunteerId", coordinatorId);
            coordinatorMember.put("fullName", coordinator.getCoordinatorName());
            coordinatorMember.put("email", coordinator.getCoordinatorEmail());
            coordinatorMember.put("phone", null);
            coordinatorMember.put("status", "Approved");
            coordinatorMember.put("isCoordinator", 1);
            membersByUserId.put(coordinatorId, coordinatorMember);
        }

        List<Map<String, Object>> activeTeam = new ArrayList<>();
        for (Map<String, Object> member : membersByUserId.values()) {
            if (!matchesRoleFilter(member, roleFilter)) {
                continue;
            }

            if (!matchesSearch(member, query)) {
                continue;
            }

            activeTeam.add(member);
        }

        activeTeam.sort(Comparator
                .comparingInt((Map<String, Object> member) -> asInt(member.get("isCoordinator")))
                .reversed()
                .thenComparing(member -> safeString(member.get("fullName")).toLowerCase(Locale.ROOT))
                .thenComparing(member -> safeString(member.get("email")).toLowerCase(Locale.ROOT)));

        return activeTeam;
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }

        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String safeString(Object value) {
        return value == null ? "" : String.valueOf(value);
    }
}
