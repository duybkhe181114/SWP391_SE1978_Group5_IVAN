package Controller;

import DAO.EventRegistrationDAO;
import DAO.EventCoordinatorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "CoordinatorActionController", urlPatterns = {"/coordinator/manage-action"})
public class CoordinatorActionController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer coordinatorId = (Integer) request.getSession().getAttribute("userId");
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");
        String currentTab = request.getParameter("tab"); // Để redirect về đúng tab đang mở

        try {
            EventRegistrationDAO regDAO = new EventRegistrationDAO();

            if ("approve".equals(action)) {
                int regId = Integer.parseInt(request.getParameter("registrationId"));
                regDAO.approveVolunteer(regId, coordinatorId);
            }
            else if ("reject".equals(action)) {
                int regId = Integer.parseInt(request.getParameter("registrationId"));
                String reviewNote = request.getParameter("reviewNote");
                regDAO.rejectVolunteer(regId, coordinatorId, reviewNote);
            }
            else if ("kick".equals(action)) {
                int regId = Integer.parseInt(request.getParameter("registrationId"));
                String kickReason = request.getParameter("kickReason");
                regDAO.rejectVolunteer(regId, coordinatorId, "Kicked by Coordinator: " + kickReason);
            }
            else if ("manual_add".equals(action)) {
                String email = request.getParameter("email");
                EventCoordinatorDAO coordDAO = new EventCoordinatorDAO();
                int[] volunteer = coordDAO.findVolunteerByEmail(email);

                if (volunteer == null) {
                    response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + "&tab=manual&error=" + URLEncoder.encode("User not found!", "UTF-8"));
                    return;
                }
                boolean canApply = regDAO.canApply(eventId, volunteer[0]);
                if (canApply) {
                    regDAO.applyToEvent(eventId, volunteer[0]);
                }
            }

            response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId + (currentTab != null ? "&tab=" + currentTab : ""));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
