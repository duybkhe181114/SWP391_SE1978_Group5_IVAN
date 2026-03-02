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
import java.util.List;
import java.util.Map;

@WebServlet(name = "EventDetailController", urlPatterns = {"/event/detail"})
public class EventDetailController extends HttpServlet {

    private EventDAO eventDAO = new EventDAO();
    private EventRegistrationDAO regDAO = new EventRegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Validate id
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

        // 2️⃣ Lấy event
        EventView event = eventDAO.getEventById(eventId);
        if (event == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found");
            return;
        }

        request.setAttribute("event", event);

        // 3️⃣ Lấy session
        HttpSession session = request.getSession(false);
        Integer userId = null;
        String userRole = null;

        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
            userRole = (String) session.getAttribute("userRole");
        }

        // 4️⃣ Nếu là Organization → trang quản lý
        if ("Organization".equals(userRole)) {
            EventRegistrationDAO regDAO = new EventRegistrationDAO();
            List<Map<String, Object>> volunteers = regDAO.getVolunteersByEvent(eventId);
            request.setAttribute("volunteers", volunteers);

            request.getRequestDispatcher("/WEB-INF/views/organization-event-manage.jsp").forward(request, response);
        } else {
            // 5️⃣ Nếu là Volunteer hoặc Guest → trang detail

            String enrollStatus = null;

            if (userId != null && "Volunteer".equals(userRole)) {
                enrollStatus = eventDAO.getEnrollmentStatus(eventId, userId);
            }

            request.setAttribute("enrollStatus", enrollStatus);

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

        if ("apply".equals(action)) {
            eventDAO.enrollEvent(eventId, userId);
            response.sendRedirect(request.getContextPath()
                    + "/event/detail?id=" + eventId + "&success=applied");

        } else if ("cancel".equals(action)) {
            eventDAO.cancelEnrollment(eventId, userId);
            response.sendRedirect(request.getContextPath()
                    + "/event/detail?id=" + eventId + "&success=cancelled");
        }
    }
}