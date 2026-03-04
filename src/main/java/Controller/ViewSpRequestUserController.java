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

        HttpSession session = request.getSession(false);

        // Kiểm tra login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        SupportRequestDAO dao = new SupportRequestDAO();

        // User xem TẤT CẢ request của mình (mọi trạng thái)
        List<SupportRequest> list = dao.getAllByUser(userId);

        request.setAttribute("requestList", list);

        request.getRequestDispatcher("/WEB-INF/views/my-support-requests.jsp")
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