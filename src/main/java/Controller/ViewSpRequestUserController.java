package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewSpRequestUser")
public class ViewSpRequestUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy userId từ session
        Integer userId = (Integer) request.getSession()
                .getAttribute("userId");

        SupportRequestDAO dao = new SupportRequestDAO();

        // User chỉ thấy APPROVED của mình
        List<SupportRequest> list = dao.getApprovedByUser(userId);

        request.setAttribute("requestList", list);

        request.getRequestDispatcher("/WEB-INF/views/user-SupportRequestList.jsp")
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