package Controller;

import DAO.EventDAO;
import DAO.EventRegistrationDAO;
import DAO.EventCommentDAO;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Validate id
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

        //Lấy event
        EventView event = eventDAO.getEventById(eventId);
        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
            return;
        }

        request.setAttribute("event", event);

        //Lấy session
        HttpSession session = request.getSession(false);
        Integer userId = null;
        String userRole = null;

        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
            userRole = (String) session.getAttribute("userRole");
        }

        //Nếu là Organization → trang quản lý
        if ("Organization".equals(userRole)) {
            EventRegistrationDAO regDAO = new EventRegistrationDAO();
            List<Map<String, Object>> volunteers = regDAO.getVolunteersByEvent(eventId);
            request.setAttribute("volunteers", volunteers);

            request.getRequestDispatcher("/WEB-INF/views/organization-event-manage.jsp").forward(request, response);
        } else {
            //Nếu là Volunteer hoặc Guest → trang detail

            String enrollStatus = null;
            String rejectReason = null;

            if (userId != null && "Volunteer".equals(userRole)) {
                enrollStatus = eventDAO.getEnrollmentStatus(eventId, userId);
                
                // Nếu bị reject, lấy lý do từ chối
                if ("Rejected".equals(enrollStatus)) {
                    rejectReason = eventDAO.getRejectReason(eventId, userId);
                }
            }

            request.setAttribute("enrollStatus", enrollStatus);
            request.setAttribute("rejectReason", rejectReason);
            
            // Lấy filter parameters
            String ratingFilterParam = request.getParameter("ratingFilter");
            String sortOrder = request.getParameter("sortOrder");
            
            Integer ratingFilter = null;
            if (ratingFilterParam != null && !ratingFilterParam.isEmpty()) {
                try {
                    ratingFilter = Integer.parseInt(ratingFilterParam);
                } catch (NumberFormatException e) {}
            }
            
            if (sortOrder == null || sortOrder.isEmpty()) {
                sortOrder = "newest";
            }
            
            // Lấy comments và rating
            List<EventComment> comments = commentDAO.getCommentsByEventId(eventId, ratingFilter, sortOrder);
            Double avgRating = commentDAO.getAverageRating(eventId);
            boolean canComment = userId != null && commentDAO.canComment(eventId, userId);
            
            request.setAttribute("comments", comments);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("canComment", canComment);
            request.setAttribute("ratingFilter", ratingFilter);
            request.setAttribute("sortOrder", sortOrder);

            request.getRequestDispatcher(
                    "/WEB-INF/views/event-detail.jsp"
            ).forward(request, response);
        }
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

        if ("comment".equals(action)) {
            String comment = request.getParameter("comment");
            int rating = Integer.parseInt(request.getParameter("rating"));
            
            if (commentDAO.canComment(eventId, userId)) {
                commentDAO.addComment(eventId, userId, comment, rating);
            }
            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId);
            return;
        }

        if ("apply".equals(action)) {

            if (regDAO.canApply(eventId, userId)) {
                regDAO.applyToEvent(eventId, userId);
                response.sendRedirect(request.getContextPath()
                        + "/event/detail?id=" + eventId + "&success=applied");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/event/detail?id=" + eventId + "&error=already_applied");
            }

        } else if ("cancel".equals(action)) {
            eventDAO.cancelEnrollment(eventId, userId);
            response.sendRedirect(request.getContextPath()
                    + "/event/detail?id=" + eventId + "&success=cancelled");
        }
    }
}