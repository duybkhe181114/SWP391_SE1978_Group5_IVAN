package Filter;

import Entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/RegisterOrganizations.jsp", "/createorganization"})
public class CreateOrganizationAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        // Lấy user từ session
        User user = session != null ? (User) session.getAttribute("USER") : null;

        if (user == null) {
            // Chưa login → redirect về login page
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            // Đã login → tiếp tục request
            chain.doFilter(req, res);
        }
    }
}
