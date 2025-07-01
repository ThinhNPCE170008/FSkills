/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Role;

@WebServlet(name = "AboutInformServlet", urlPatterns = {"/aboutInform"})
public class AboutInformServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AboutInformServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        Role role = user.getRole();
        if (role != Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        request.setCharacterEncoding("UTF-8");

        String userName = request.getParameter("userInform");
        String editModeParam = request.getParameter("editMode");
        String currentListRoleFilter = request.getParameter("currentListRoleFilter");

        UserDAO userDAO = new UserDAO();
        try {
            List<User> userList = userDAO.showAllInform(userName);
            request.setAttribute("allInform", userList);

            boolean editMode = Boolean.parseBoolean(editModeParam);
            request.setAttribute("editMode", editMode);
            request.setAttribute("currentListRoleFilter", currentListRoleFilter);

            if (userList == null || userList.isEmpty()) {
                request.setAttribute("globalMessage", "Do not found any user with Username: " + userName);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in AboutInformServlet", e);
            request.setAttribute("globalMessage", "Error!!!: " + e.getMessage());
            request.setAttribute("editMode", false);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in AboutInformServlet", e);
            request.setAttribute("globalMessage", "Error!!!: " + e.getMessage());
            request.setAttribute("editMode", false);
        }

        request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        Role role = user.getRole();
        if (role != Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for displaying user details and handling edit mode.";
    }
}