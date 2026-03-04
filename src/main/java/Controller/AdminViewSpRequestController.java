package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewSpRequestAdmin")
public class AdminViewSpRequestController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        SupportRequestDAO dao = new SupportRequestDAO();

        // Admin xem tất cả
        List<SupportRequest> list = dao.getALLSPRForAdmin();

        request.setAttribute("requestList", list);

        request.getRequestDispatcher("/WEB-INF/views/admin-SupportRequestList.jsp")
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}