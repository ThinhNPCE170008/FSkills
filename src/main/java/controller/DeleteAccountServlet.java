/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name="deleteAccountServlet", urlPatterns={"/deleteAcc"})
public class DeleteAccountServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(DeleteAccountServlet.class.getName());

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet deleteAccountServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet deleteAccountServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/alluser");
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String deleteName = request.getParameter("deleteName");
        String originalSearchName = request.getParameter("originalSearchName");
        // Lấy tham số roleFilter từ hidden input của form
        String currentListRoleFilter = request.getParameter("currentListRoleFilter"); 
        
        UserDAO userDAO = new UserDAO();
        boolean success = false;

        String redirectUrl = request.getContextPath() + "/alluser";

        // Xây dựng URL chuyển hướng, thêm searchName nếu có
        if (originalSearchName != null && !originalSearchName.isEmpty()) {
            redirectUrl += "?searchName=" + originalSearchName;
        }

        // Thêm roleFilter vào URL chuyển hướng, kiểm tra nếu đã có tham số khác
        if (currentListRoleFilter != null && !currentListRoleFilter.isEmpty()) {
            if (redirectUrl.contains("?")) {
                redirectUrl += "&roleFilter=" + currentListRoleFilter;
            } else {
                redirectUrl += "?roleFilter=" + currentListRoleFilter;
            }
        }

        if (deleteName != null && !deleteName.isEmpty()) {
            try {
                success = userDAO.deleteAccount(deleteName);
                if (success) {
                    request.getSession().setAttribute("deleteComplete", "Delete this account successful");
                    response.sendRedirect(redirectUrl); // Chuyển hướng với URL đã sửa đổi
                } else {
                    request.setAttribute("errorMessage", "Delete operation failed. Account not found or processing error.");
                    request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Database error deleting account for user: " + deleteName, ex);
                request.setAttribute("errorMessage", "Database error: " + ex.getMessage());
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Unexpected error deleting account for user: " + deleteName, ex);
                request.setAttribute("errorMessage", "An unexpected error occurred.");
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Account name not provided for deletion.");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for deleting user accounts.";
    }
}