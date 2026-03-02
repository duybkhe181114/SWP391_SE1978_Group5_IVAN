package Controller;

import DAO.EventDAO;
import DTO.EventView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AllEventsController", urlPatterns = {"/events"})
public class AllEventsController extends HttpServlet {
    private EventDAO eventDAO = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 6;
        if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
        String keyword = request.getParameter("search");
        String location = request.getParameter("location");
        String sortBy = request.getParameter("sortBy");

        List<EventView> events = eventDAO.searchEvents(keyword, location, sortBy, page, pageSize);
        request.setAttribute("currentPage", page);
        request.setAttribute("events", events);
        request.getRequestDispatcher("/WEB-INF/views/all-events.jsp").forward(request, response);
    }
}