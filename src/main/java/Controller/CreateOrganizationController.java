package Controller;

import DAO.OrganizationDAO;
import Entity.Organization;
import Entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "CreateOrganizationController", urlPatterns = {"/create-organization"})
public class CreateOrganizationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        /* =========================
           1. Check login session
        ========================= */
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Bạn chưa đăng nhập");
            return;
        }

        User user = (User) session.getAttribute("USER");

        /* =========================
           2. Get & validate input
        ========================= */
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String website = request.getParameter("website");

        if (name == null || name.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tên tổ chức không được để trống");
            return;
        }

        /* =========================
           3. Build entity
        ========================= */
        Organization org = new Organization();
        org.setName(name.trim());
        org.setDescription(description);
        org.setPhone(phone);
        org.setEmail(email);
        org.setAddress(address);
        org.setWebsite(website);

        /* =========================
           4. Call DAO
        ========================= */
        OrganizationDAO dao = new OrganizationDAO();
        boolean success = dao.createOrganization(org, user.getUserId());

        /* =========================
           5. Response
        ========================= */
        if (success) {
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().println("Tạo tổ chức thành công");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Tạo tổ chức thất bại");
        }
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method GET không được hỗ trợ");
    }
}
