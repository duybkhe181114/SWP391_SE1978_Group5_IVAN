package Controller;

import DAO.EventCoordinatorDAO;
import DAO.EventDAO;
import DAO.EventRegistrationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "VolunteerRegistrationController", urlPatterns = {"/organization/manage-registrations"})
public class VolunteerRegistrationController extends HttpServlet {

    private final EventRegistrationDAO regDAO = new EventRegistrationDAO();
    private final EventCoordinatorDAO coordDAO = new EventCoordinatorDAO();
    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");
        String returnTo = request.getParameter("returnTo");
        String userRole = (String) request.getSession().getAttribute("userRole");
        Integer userId = (Integer) request.getSession().getAttribute("userId");

        if (userId == null || !"Organization".equalsIgnoreCase(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!eventDAO.isEventOwnedByUser(eventId, userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not own this event");
            return;
        }

        try {
            if ("approve".equals(action)) {
                int regId = Integer.parseInt(request.getParameter("registrationId"));
                regDAO.approveVolunteer(regId, userId);

            } else if ("reject".equals(action)) {
                int regId = Integer.parseInt(request.getParameter("registrationId"));
                String reviewNote = request.getParameter("reviewNote");
                if (reviewNote != null && !reviewNote.trim().isEmpty()) {
                    regDAO.rejectVolunteer(regId, userId, reviewNote);
                }

            } else if ("promote".equals(action)) {
                int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
                coordDAO.promote(eventId, volunteerId, userId);

            } else if ("revoke".equals(action)) {
                int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
                coordDAO.revoke(eventId, volunteerId);

            } else if ("kick".equals(action)) {
                int regId = Integer.parseInt(request.getParameter("registrationId"));
                int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
                String kickReason = request.getParameter("kickReason");

                if (kickReason != null && !kickReason.trim().isEmpty()) {
                    coordDAO.revoke(eventId, volunteerId);
                    regDAO.rejectVolunteer(regId, userId, "Kicked: " + kickReason);
                }
            } else if ("promote_by_email".equals(action)) {
                String email = request.getParameter("email");
                int[] volunteer = coordDAO.findApprovedVolunteerByEmail(eventId, email);

                if (volunteer == null) {
                    redirectWithMessage(response, request, eventId, returnTo, "error=User+not+found");
                    return;
                }

                coordDAO.promote(eventId, volunteer[0], userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        redirectWithMessage(response, request, eventId, returnTo, null);
    }

    private void redirectWithMessage(HttpServletResponse response, HttpServletRequest request,
                                     int eventId, String returnTo, String query) throws IOException {
        String basePath = resolveReturnPath(request, eventId, returnTo);
        if (query == null || query.isBlank()) {
            response.sendRedirect(basePath);
            return;
        }
        String separator = basePath.contains("?") ? "&" : "?";
        response.sendRedirect(basePath + separator + query);
    }

    private String resolveReturnPath(HttpServletRequest request, int eventId, String returnTo) {
        String contextPath = request.getContextPath();
        if ("active-team".equalsIgnoreCase(String.valueOf(returnTo))) {
            return contextPath + "/organization/active-team?eventId=" + eventId;
        }
        if ("registration-log".equalsIgnoreCase(String.valueOf(returnTo))) {
            return contextPath + "/organization/registration-log?eventId=" + eventId;
        }
        return contextPath + "/event/detail?id=" + eventId;
    }
}
