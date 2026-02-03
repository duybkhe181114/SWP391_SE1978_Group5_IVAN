package Controller;

import DAO.EventDAO;
import DAO.SupportRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EventDAO eventDAO = new EventDAO();
        SupportRequestDAO supportDAO = new SupportRequestDAO();

        request.setAttribute("events", eventDAO.getApprovedEventsForHome());
        request.setAttribute("supportRequests", supportDAO.getApprovedSupportRequests());

        // ⚠️ QUAN TRỌNG: forward đúng đường dẫn trong WEB-INF
        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
                .forward(request, response);
    }
}
