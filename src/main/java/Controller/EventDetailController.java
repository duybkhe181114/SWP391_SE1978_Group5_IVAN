package Controller;

import DAO.EventDAO;
import DAO.EventRegistrationDAO;
import DAO.EventCommentDAO;
import DAO.EventCoordinatorDAO;
import DTO.EventView;
import Entity.EventComment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "EventDetailController", urlPatterns = {"/event/detail"})
public class EventDetailController extends HttpServlet {

    private EventDAO eventDAO = new EventDAO();
    private EventRegistrationDAO regDAO = new EventRegistrationDAO();
    private EventCommentDAO commentDAO = new EventCommentDAO();
    private EventCoordinatorDAO coordDAO = new EventCoordinatorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===============================
        // 1. Validate event id
        // ===============================
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int eventId;

        try {
            eventId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // ===============================
        // 2. Lấy thông tin event
        // ===============================
        EventView event = eventDAO.getEventById(eventId);

        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
            return;
        }

        request.setAttribute("event", event);

        // ===============================
        // 3. Lấy session
        // ===============================
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        // =====================================================
        // FLOW 1: ORGANIZATION (CHỦ EVENT)
        // =====================================================
        if ("Organization".equals(userRole) && userId != null) {

            Integer currentOrgId = eventDAO.getOrganizationIdByUserId(userId);

            if (currentOrgId != null && currentOrgId.equals(event.getOrganizationId())) {

                List<Map<String, Object>> volunteers = regDAO.getVolunteersByEvent(eventId);
                request.setAttribute("volunteers", volunteers);

                List<Entity.EventCoordinator> activeCoordinators =
                        coordDAO.getActiveCoordinatorsByOrg(currentOrgId);

                request.setAttribute("activeCoordinators", activeCoordinators);

                request.getRequestDispatcher("/WEB-INF/views/organization-event-manage.jsp")
                        .forward(request, response);

                return;
            }
        }

        // =====================================================
        // FLOW 2: COORDINATOR CỦA EVENT NÀY
        // =====================================================
        if ("Volunteer".equals(userRole) && userId != null) {
            DAO.EventCoordinatorDAO coordDAO = new DAO.EventCoordinatorDAO();
            boolean isCoordinator = coordDAO.checkIsCoordinator(eventId, userId);

            if (isCoordinator) {
                DAO.EventRegistrationDAO regDAO = new DAO.EventRegistrationDAO();
                List<Map<String, Object>> volunteers = regDAO.getVolunteersByEvent(eventId);

                // FIX LỖI: Lọc chỉ lấy Approved VÀ KHÔNG PHẢI là chính mình
                volunteers.removeIf(v -> !"Approved".equals(v.get("status")) || v.get("volunteerId").equals(userId));
                request.setAttribute("approvedVolunteers", volunteers);

                // LOAD DANH SÁCH TASK TỪ DATABASE
                DAO.TaskDAO taskDAO = new DAO.TaskDAO();
                List<Map<String, Object>> tasks = taskDAO.getTasksByEvent(eventId);
                request.setAttribute("eventTasks", tasks);

                request.getRequestDispatcher("/WEB-INF/views/coordinator-event-manage.jsp").forward(request, response);
                return;
            }
        }

        // =====================================================
        // FLOW 3: VOLUNTEER THƯỜNG / KHÁCH
        // =====================================================
        String enrollStatus = null;
        String rejectReason = null;

        if (userId != null && "Volunteer".equals(userRole)) {

            enrollStatus = eventDAO.getEnrollmentStatus(eventId, userId);

            if ("Rejected".equals(enrollStatus)) {
                rejectReason = eventDAO.getRejectReason(eventId, userId);
            }

            else if ("Approved".equals(enrollStatus)) {
                DAO.TaskDAO taskDAO = new DAO.TaskDAO();
                List<Map<String, Object>> myTasks = taskDAO.getTasksForVolunteerInEvent(eventId, userId);
                request.setAttribute("myTasks", myTasks);
            }
        }

        request.setAttribute("enrollStatus", enrollStatus);
        request.setAttribute("rejectReason", rejectReason);

        // ===============================
        // 4. Xử lý filter comment
        // ===============================
        String ratingFilterParam = request.getParameter("ratingFilter");
        String sortOrder = request.getParameter("sortOrder");

        Integer ratingFilter = null;

        if (ratingFilterParam != null && !ratingFilterParam.isEmpty()) {
            try {
                ratingFilter = Integer.parseInt(ratingFilterParam);
            } catch (NumberFormatException e) {
            }
        }

        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "newest";
        }

        // ===============================
        // 5. Lấy comment + rating
        // ===============================
        List<EventComment> comments =
                commentDAO.getCommentsByEventId(eventId, ratingFilter, sortOrder);

        Double avgRating = commentDAO.getAverageRating(eventId);

        boolean canComment =
                userId != null && commentDAO.canComment(eventId, userId);

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

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");

        // ===============================
        // Comment event
        // ===============================
        if ("comment".equals(action)) {

            String comment = request.getParameter("comment");
            int rating = Integer.parseInt(request.getParameter("rating"));

            if (commentDAO.canComment(eventId, userId)) {
                commentDAO.addComment(eventId, userId, comment, rating);
            }

            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId);
            return;
        }

        // ===============================
        // Apply event
        // ===============================
        if ("apply".equals(action)) {

            if (regDAO.canApply(eventId, userId)) {

                regDAO.applyToEvent(eventId, userId);

                response.sendRedirect(
                        request.getContextPath()
                                + "/event/detail?id=" + eventId
                                + "&success=applied"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                                + "/event/detail?id=" + eventId
                                + "&error=already_applied"
                );
            }

        }
        // ===============================
        // Cancel event
        // ===============================
        else if ("cancel".equals(action)) {

            eventDAO.cancelEnrollment(eventId, userId);

            response.sendRedirect(
                    request.getContextPath()
                            + "/event/detail?id=" + eventId
                            + "&success=cancelled"
            );
        }
    }
}