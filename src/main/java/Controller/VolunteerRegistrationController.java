package Controller;

import DAO.EventCoordinatorDAO;
import DAO.EventRegistrationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "VolunteerRegistrationController", urlPatterns = {"/organization/manage-registrations"})
public class VolunteerRegistrationController extends HttpServlet {

    private EventRegistrationDAO regDAO = new EventRegistrationDAO();
    private EventCoordinatorDAO coordDAO = new EventCoordinatorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");
        Integer userId = (Integer) request.getSession().getAttribute("userId"); // Org ID

        try {
            if ("approve".equals(action)) {
                int regId = Integer.parseInt(request.getParameter("registrationId"));
                regDAO.approveVolunteer(regId);

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

            }
            else if ("kick".equals(action)) {
                int regId = Integer.parseInt(request.getParameter("registrationId"));
                int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
                String kickReason = request.getParameter("kickReason");

                if (kickReason != null && !kickReason.trim().isEmpty()) {
                    coordDAO.revoke(eventId, volunteerId);
                    regDAO.rejectVolunteer(regId, userId, "Kicked: " + kickReason);
                }
            }
            else if ("assign_existing".equals(action)) {
                int coordinatorId = Integer.parseInt(request.getParameter("coordinatorId"));
                coordDAO.assign(eventId, coordinatorId, userId);
            }
            // LOGIC MỚI 2: MỜI TRỰC TIẾP QUA EMAIL
            else if ("promote_by_email".equals(action)) {
                String email = request.getParameter("email");
                int[] volunteer = coordDAO.findVolunteerByEmail(email); // Hàm cũ đại ca đã viết

                if (volunteer == null) {
                    response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&error=User+not+found");
                    return;
                } else {
                    coordDAO.promote(eventId, volunteer[0], userId);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId);
    }
}