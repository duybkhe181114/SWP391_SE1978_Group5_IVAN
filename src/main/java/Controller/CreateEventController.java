package Controller;

import DAO.EventDAO;
import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

public class CreateEventController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isOrganization(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Nếu đến từ accepted-requests, load thông tin support request
        String sprIdRaw = request.getParameter("supportRequestId");
        if (sprIdRaw != null && !sprIdRaw.isEmpty()) {
            try {
                int sprId = Integer.parseInt(sprIdRaw);
                SupportRequestDAO sprDao = new SupportRequestDAO();
                SupportRequest spr = sprDao.getSPRById(sprId);
                if (spr != null) request.setAttribute("linkedSpr", spr);
            } catch (NumberFormatException ignored) {}
        }
        request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String coverImageUrl = request.getParameter("coverImageUrl");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String requiredVolunteersRaw = request.getParameter("requiredVolunteers");
            String contactName = trimToNull(request.getParameter("contactName"));
            String contactEmail = trimToNull(request.getParameter("contactEmail"));
            String contactPhone = trimToNull(request.getParameter("contactPhone"));
            String requirements = trimToNull(request.getParameter("requirements"));
            String benefits = trimToNull(request.getParameter("benefits"));
            String sprIdRaw = request.getParameter("supportRequestId");
            
            HttpSession session = request.getSession(false);
            
            if (session == null || !"Organization".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            Integer userId = (Integer) session.getAttribute("userId");
            
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Get organizationId from userId
            EventDAO dao = new EventDAO();
            Integer organizationId = dao.getOrganizationIdByUserId(userId);
            
            if (organizationId == null) {
                request.setAttribute("error", "Organization not found");
                request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
                return;
            }

            if (isBlank(title) || isBlank(description) || isBlank(location)
                    || isBlank(startDate) || isBlank(endDate) || isBlank(requiredVolunteersRaw)) {
                request.setAttribute("error", "Please fill in all required event fields.");
                request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
                return;
            }

            int requiredVolunteers;
            try {
                requiredVolunteers = Integer.parseInt(requiredVolunteersRaw);
            } catch (NumberFormatException ex) {
                request.setAttribute("error", "Volunteer limit must be a valid number.");
                request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
                return;
            }

            if (requiredVolunteers < 0) {
                request.setAttribute("error", "Volunteer limit must be 0 or greater.");
                request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
                return;
            }

            try {
                LocalDate start = LocalDate.parse(startDate);
                LocalDate end = LocalDate.parse(endDate);
                if (end.isBefore(start)) {
                    request.setAttribute("error", "End date cannot be earlier than start date.");
                    request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
                    return;
                }
            } catch (Exception ex) {
                request.setAttribute("error", "Please enter valid event dates.");
                request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
                return;
            }
            
            int eventId = dao.createEvent(title, description, location, coverImageUrl, startDate, endDate,
                                             requiredVolunteers, organizationId, contactName,
                                             contactEmail, contactPhone, requirements, benefits);

            if (eventId > 0) {
                // Link event với support request nếu có
                if (sprIdRaw != null && !sprIdRaw.isEmpty()) {
                    try { dao.linkEventToRequest(Integer.parseInt(sprIdRaw), eventId); }
                    catch (NumberFormatException ignored) {}
                }
                response.sendRedirect(request.getContextPath() + "/organization/dashboard?msg=Event created successfully. Waiting for admin approval.");
            } else {
                request.setAttribute("error", "Failed to create event");
                if (sprIdRaw != null && !sprIdRaw.isEmpty()) {
                    try {
                        SupportRequest spr = new SupportRequestDAO().getSPRById(Integer.parseInt(sprIdRaw));
                        if (spr != null) request.setAttribute("linkedSpr", spr);
                    } catch (NumberFormatException ignored) {}
                }
                request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/create-event.jsp").forward(request, response);
        }
    }

    private boolean isOrganization(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && "Organization".equalsIgnoreCase((String) session.getAttribute("userRole"));
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
