package Controller;

import DAO.EventCoordinatorDAO;
import DAO.EventDAO;
import DTO.EventView;
import Entity.EventCoordinator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/organization/coordinators")
public class CoordinatorManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login + Organization role
        if (session == null || !"Organization".equalsIgnoreCase(
                (String) session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        // Get organization ID
        EventDAO eventDAO = new EventDAO();
        Integer orgId = eventDAO.getOrganizationIdByUserId(userId);

        if (orgId == null) {
            response.sendRedirect(request.getContextPath() + "/organization/dashboard?msg=Organization not found");
            return;
        }

        EventCoordinatorDAO dao = new EventCoordinatorDAO();

        // Load coordinators list
        List<EventCoordinator> coordinators = dao.getByOrganization(orgId);
        request.setAttribute("coordinators", coordinators);

        // Load events for dropdowns
        List<EventView> events = eventDAO.getEventsByOrganization(orgId);
        request.setAttribute("events", events);

        // Load active coordinators for assign dropdown
        List<EventCoordinator> activeCoordinators = dao.getActiveCoordinatorsByOrg(orgId);
        request.setAttribute("activeCoordinators", activeCoordinators);

        // Pass success/error messages
        if (request.getParameter("msg") != null) {
            request.setAttribute("msg", request.getParameter("msg"));
        }
        if (request.getParameter("error") != null) {
            request.setAttribute("error", request.getParameter("error"));
        }

        request.getRequestDispatcher("/WEB-INF/views/coordinator-management.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login + Organization role
        if (session == null || !"Organization".equalsIgnoreCase(
                (String) session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        EventCoordinatorDAO dao = new EventCoordinatorDAO();
        String redirectUrl = request.getContextPath() + "/organization/coordinators";

        try {
            switch (action) {

                case "promote" -> {
                    String email = request.getParameter("email");
                    int eventId = Integer.parseInt(request.getParameter("eventId"));

                    int[] volunteer = dao.findVolunteerByEmail(email);
                    if (volunteer == null) {
                        redirectUrl += "?error=Volunteer not found with email: " + email;
                    } else {
                        boolean ok = dao.promote(eventId, volunteer[0], userId);
                        if (ok) {
                            redirectUrl += "?msg=Volunteer promoted to Coordinator successfully!";
                        } else {
                            redirectUrl += "?error=This volunteer is already a coordinator for this event";
                        }
                    }
                }

                case "assign" -> {
                    int coordinatorId = Integer.parseInt(request.getParameter("coordinatorId"));
                    int eventId = Integer.parseInt(request.getParameter("eventId"));

                    boolean ok = dao.assign(eventId, coordinatorId, userId);
                    if (ok) {
                        redirectUrl += "?msg=Coordinator assigned to event successfully!";
                    } else {
                        redirectUrl += "?error=Coordinator is already assigned to this event";
                    }
                }

                case "revoke" -> {
                    int coordinatorId = Integer.parseInt(request.getParameter("coordinatorId"));
                    int eventId = Integer.parseInt(request.getParameter("eventId"));

                    boolean ok = dao.revoke(eventId, coordinatorId);
                    if (ok) {
                        redirectUrl += "?msg=Coordinator access revoked successfully";
                    } else {
                        redirectUrl += "?error=Failed to revoke coordinator";
                    }
                }

                case "reactivate" -> {
                    int coordinatorId = Integer.parseInt(request.getParameter("coordinatorId"));
                    int eventId = Integer.parseInt(request.getParameter("eventId"));

                    boolean ok = dao.reactivate(eventId, coordinatorId);
                    if (ok) {
                        redirectUrl += "?msg=Coordinator reactivated successfully";
                    } else {
                        redirectUrl += "?error=Failed to reactivate coordinator";
                    }
                }

                default -> redirectUrl += "?error=Invalid action";
            }
        } catch (NumberFormatException e) {
            redirectUrl += "?error=Invalid input data";
        }

        response.sendRedirect(redirectUrl);
    }
}
