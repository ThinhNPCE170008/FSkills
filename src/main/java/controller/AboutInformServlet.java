///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller;
//
//import dao.UserDAO;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import model.User;
//import java.io.IOException;
//import java.sql.SQLException;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//@WebServlet(name = "AboutInformServlet", urlPatterns = {"/aboutInform"})
//public class AboutInformServlet extends HttpServlet {
//
//    private static final Logger LOGGER = Logger.getLogger(AboutInformServlet.class.getName());
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        request.setCharacterEncoding("UTF-8");
//
//        String userName = request.getParameter("userInform");
//        // Lấy tham số editMode từ request
//        String editModeParam = request.getParameter("editMode");
//
//        UserDAO userDAO = new UserDAO();
//        try {
//            List<User> userList = userDAO.showAllInform(userName);
//            request.setAttribute("allInform", userList);
//
//            boolean editMode = Boolean.parseBoolean(editModeParam);
//            request.setAttribute("editMode", editMode);
//
//            if (userList == null || userList.isEmpty()) {
//                request.setAttribute("globalMessage", "Do not found any user with Username: " + userName);
//            }
//
//        } catch (SQLException e) {
//            LOGGER.log(Level.SEVERE, "Database error in AboutInformServlet", e);
//            request.setAttribute("globalMessage", "Error!!!: " + e.getMessage());
//            request.setAttribute("editMode", false);
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Unexpected error in AboutInformServlet", e);
//            request.setAttribute("globalMessage", "Error!!!: " + e.getMessage());
//            request.setAttribute("editMode", false);
//        }
//
//        request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        doGet(request, response);
//    }
//
//    @Override
//    public String getServletInfo() {
//        return "Servlet for displaying user details and handling edit mode.";
//    }
//}
