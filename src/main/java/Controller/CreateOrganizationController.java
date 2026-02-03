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

        protected void processRequest(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession(false);

            // Kiểm tra login
            if (session == null || session.getAttribute("USER") == null) {
                response.sendRedirect("login.jsp"); // Chưa login → redirect login
                return;
            }

            User user = (User) session.getAttribute("USER");

            // Kiểm tra phương thức
            String method = request.getMethod();

            if ("GET".equalsIgnoreCase(method)) {
                // GET → hiển thị form
                request.getRequestDispatcher("RegisterOrganizations.jsp")
                        .forward(request, response);

            } else if ("POST".equalsIgnoreCase(method)) {
                // POST → xử lý tạo tổ chức
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

                Organization org = new Organization();
                org.setName(name.trim());
                org.setDescription(description);
                org.setPhone(phone);
                org.setEmail(email);
                org.setAddress(address);
                org.setWebsite(website);

                OrganizationDAO dao = new OrganizationDAO();
                boolean success = dao.createOrganization(org, user.getUserId());

                if (success) {
                    response.setStatus(HttpServletResponse.SC_CREATED);
                    response.getWriter().println("Tạo tổ chức thành công");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Tạo tổ chức thất bại");
                }

            } else {
                // Các method khác → 405
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method " + method + " không được hỗ trợ");
            }
        }

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            processRequest(request, response);
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            processRequest(request, response);
        }
    }

