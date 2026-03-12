package Controller;

import DAO.EventDAO;
import DAO.SupportRequestDAO;
import DAO.OrganizationDAO;
import DAO.EventCoordinatorDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EventDAO eventDAO = new EventDAO();
        SupportRequestDAO supportDAO = new SupportRequestDAO();
        OrganizationDAO orgDAO = new OrganizationDAO();

        // DATA CHUNG
        request.setAttribute("events", eventDAO.getApprovedEventsForHome());
        request.setAttribute("topOrgs", orgDAO.getTopOrganizations());
        request.setAttribute("supportRequests", supportDAO.getApprovedSupportRequests());

        // LẤY SESSION USER
        HttpSession session = request.getSession(false);

        if (session != null) {

            Integer userId = (Integer) session.getAttribute("userId");
            String userRole = (String) session.getAttribute("userRole");

            // CHỈ VOLUNTEER MỚI CHECK COORDINATOR
            if (userId != null && "Volunteer".equalsIgnoreCase(userRole)) {

                EventCoordinatorDAO coordDAO = new EventCoordinatorDAO();

                List<Integer> coordinatedEventIds =
                        coordDAO.getCoordinatedEventIds(userId);

                request.setAttribute("coordinatedEventIds", coordinatedEventIds);
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
                .forward(request, response);
    }
}