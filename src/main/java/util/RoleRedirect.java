package util;

import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import model.User;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class RoleRedirect {
    public static void redirect(User user, HttpServletResponse response) throws IOException {
        switch (user.getRole()) {
            case ADMIN:
                response.sendRedirect("admin");
                break;
            case INSTRUCTOR:
                response.sendRedirect("instructor");
                break;
            case LEARNER:
                response.sendRedirect("learner/profile");
                break;
            default:
                response.sendRedirect("defaultPage.jsp");
        }
    }
}
