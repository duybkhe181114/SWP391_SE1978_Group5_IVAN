package Controller;

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int regId = Integer.parseInt(request.getParameter("registrationId"));
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");

        if ("approve".equals(action)) {
            regDAO.approveVolunteer(regId);
        } else if ("reject".equals(action)) {
            regDAO.rejectVolunteer(regId);
        }

        response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId);
    }
}