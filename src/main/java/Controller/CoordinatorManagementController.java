package Controller;

import DAO.CoordinatorDAO;
import DTO.CoordinatorDTO;
import Entity.Coordinator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CoordinatorManagementController",
        urlPatterns = {"/organization/coordinators"})
public class CoordinatorManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CoordinatorDAO dao = new CoordinatorDAO();
        List<Coordinator> list = dao.getAllCoordinators();

        request.setAttribute("coordinators", list);
        request.getRequestDispatcher("/org-viewCondinatorList.jsp")
                .forward(request, response);
    }
}