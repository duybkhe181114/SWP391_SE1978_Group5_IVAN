package Filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/changepassword",
        "/ChangePassword.jsp"
})
public class ChangePasswordFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        // Kiểm tra session có USER_ID chưa
        if (session == null || session.getAttribute("USER_ID") == null) {

            // Chưa login → đá về login
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Đã login → cho đi tiếp
        chain.doFilter(request, response);
    }
}
