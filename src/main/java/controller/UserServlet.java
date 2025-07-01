///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
package controller;

import dao.UserDAO;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Role;

import model.User;

@WebServlet(name = "UserServlet", urlPatterns = {"/alluser"})
public class UserServlet extends HttpServlet {

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

        List<User> userList = null;
        String searchName = request.getParameter("searchName");
        String roleFilter = request.getParameter("roleFilter");

        UserDAO u = new UserDAO();

        try {
            if (roleFilter == null || (!"Learner".equals(roleFilter) && !"Instructor".equals(roleFilter))) {
                roleFilter = "Learner";
            }

            if ("Instructor".equals(roleFilter)) {
                if (searchName != null && !searchName.trim().isEmpty()) {
                    userList = u.searchInstructorsByName(searchName.trim());
                } else {
                    userList = u.getAllInstructors();
                }
                request.setAttribute("listInstructors", userList);
                request.setAttribute("listLearners", null); // làm cho listLearners null cho khoi hien
            } else { // "Learner"
                if (searchName != null && !searchName.trim().isEmpty()) {
                    userList = u.searchLearnersByName(searchName.trim());
                } else {
                    userList = u.getAllLearners();
                }
                request.setAttribute("listLearners", userList);
                request.setAttribute("listInstructors", null);
            }

            request.setAttribute("paramSearchName", searchName);
            request.setAttribute("paramRoleFilter", roleFilter);

            request.getRequestDispatcher("/WEB-INF/views/userList.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(UserServlet.class.getName()).log(Level.SEVERE, "SQL's Error.", ex);
            request.setAttribute("errorMessage", "Error!!!");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(UserServlet.class.getName()).log(Level.SEVERE, "An unexpected error occurred.", ex);
            request.setAttribute("errorMessage", "Error!!!.");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
        }
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

//    @Override
//    public String getServletInfo() {
//        return "User Management Servlet";
//    }
}
