package Controller;

import DAO.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "CoordinatorConfirmTaskController", urlPatterns = {"/coordinator/task-action"})
public class CoordinatorConfirmTaskController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer coordinatorId = (Integer) request.getSession().getAttribute("userId");
        if (coordinatorId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        String action = request.getParameter("action");

        TaskDAO taskDAO = new TaskDAO();
        String msg;

        try {
            if ("confirm".equals(action)) {
                boolean ok = taskDAO.confirmTask(taskId);
                msg = ok ? URLEncoder.encode("Task confirmed!", "UTF-8")
                         : URLEncoder.encode("Could not confirm task.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId
                        + (ok ? "&success=" : "&error=") + msg);
            } else if ("delete".equals(action)) {
                boolean ok = taskDAO.deleteTask(taskId, coordinatorId);
                msg = ok ? URLEncoder.encode("Task deleted.", "UTF-8")
                         : URLEncoder.encode("Could not delete task.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId
                        + (ok ? "&success=" : "&error=") + msg);
            } else {
                response.sendRedirect(request.getContextPath() + "/event/detail?id=" + eventId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
