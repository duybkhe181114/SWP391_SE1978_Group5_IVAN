package Controller;

import DAO.EventDAO;
import DAO.SupportRequestDAO;
import DTO.EventView;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EventDAO eventDAO = new EventDAO();
        SupportRequestDAO supportDAO = new SupportRequestDAO();

        List<EventView> events = eventDAO.getApprovedEventsForHome();

        request.setAttribute("events", events);

        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
                .forward(request, response);
    }
}
