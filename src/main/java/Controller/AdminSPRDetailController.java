package Controller;

import DAO.SupportRequestDAO;
import Entity.SupportRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adminSpRequestDetail")
public class AdminSPRDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        // Không có id → quay lại list
//        if (idRaw == null || idRaw.isEmpty()) {
//            response.sendRedirect("viewSpRequestAdmin");
//            return;
//        }

        int requestId;

        try {
            requestId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect("viewSpRequestAdmin");
            return;
        }

        SupportRequestDAO dao = new SupportRequestDAO();
        SupportRequest spr = dao.getSPRById(requestId);

//        if (spr == null) {
//            response.sendRedirect("viewSpRequestAdmin");
//            return;
//        }

        request.setAttribute("requestDetail", spr);

        request.getRequestDispatcher("/WEB-INF/views/admin-support-detail.jsp")
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