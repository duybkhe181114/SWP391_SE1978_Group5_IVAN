package Controller;

import DAO.EventReportDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class AdminEventReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        EventReportDAO dao = new EventReportDAO();
        String keyword = req.getParameter("q");
        String status  = req.getParameter("status");

        req.setAttribute("eventReports",  dao.getEventReports(keyword, status));
        req.setAttribute("impactReports", dao.getImpactReports());
        req.setAttribute("summaryStats",  dao.getSummaryStats());

        req.getRequestDispatcher("/WEB-INF/views/admin-event-reports.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer adminId = (Integer) req.getSession().getAttribute("userId");
        if (adminId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        int    eventId       = Integer.parseInt(req.getParameter("eventId"));
        String summary       = req.getParameter("summary");
        int    peopleImpacted= Integer.parseInt(req.getParameter("peopleImpacted"));
        String fundsStr      = req.getParameter("fundsRaised");
        BigDecimal funds     = (fundsStr != null && !fundsStr.isBlank()) ? new BigDecimal(fundsStr) : null;

        boolean ok = new EventReportDAO().createImpactReport(eventId, adminId, summary, peopleImpacted, funds);
        resp.sendRedirect(req.getContextPath() + "/admin/event-reports?tab=impact&" + (ok ? "success=1" : "error=1"));
    }
}
