package Controller;

import DAO.TaskDAO;
import DAO.VolunteerProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ViewVolunteerProfileController", urlPatterns = {"/volunteer/profile"})
public class ViewVolunteerProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Bắt buộc phải đăng nhập mới được xem profile người khác
        if (request.getSession().getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing volunteer ID");
            return;
        }

        try {
            int volunteerId = Integer.parseInt(idParam);

            VolunteerProfileDAO profileDAO = new VolunteerProfileDAO();
            Map<String, Object> profile = profileDAO.getVolunteerProfile(volunteerId);
            List<String> skills = profileDAO.getVolunteerSkills(volunteerId);

            TaskDAO taskDAO = new TaskDAO();
            double impactHours = taskDAO.getTotalImpactHours(volunteerId);

            if (profile.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Volunteer not found");
                return;
            }

            request.setAttribute("vProfile", profile);
            request.setAttribute("vSkills", skills);
            request.setAttribute("vImpactHours", impactHours);

            request.getRequestDispatcher("/WEB-INF/views/volunteer-profile-readonly.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }
}