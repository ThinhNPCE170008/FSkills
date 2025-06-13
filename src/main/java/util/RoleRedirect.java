/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;

/**
 *
 * @author NgoThinh1902
 */
public class RoleRedirect {
    public static void redirect(User user, HttpServletResponse response) throws IOException {
        switch (user.getRole()) {
            case ADMIN:
                response.sendRedirect("adminDashboard");
                break;
            case INSTRUCTOR:
                response.sendRedirect("instructorPage");
                break;
            case LEARNER:
                response.sendRedirect("learnerHome");
                break;
            default:
                response.sendRedirect("defaultPage.jsp");
        }
    }
}
