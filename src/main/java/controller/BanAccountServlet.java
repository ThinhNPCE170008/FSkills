/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Role;
import model.User;

@WebServlet(name = "BanAccountServlet", urlPatterns = {"/banAccountServlet"})
public class BanAccountServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BanAccountServlet.class.getName());

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Error</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Lỗi: Servlet này không nên được truy cập trực tiếp bằng GET.</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
        response.sendRedirect(request.getContextPath() + "/alluser");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String characterName = request.getParameter("characterName");
        String originalSearchName = request.getParameter("originalSearchName"); 
        String currentListRoleFilter = request.getParameter("currentListRoleFilter"); 

        if (characterName != null && !characterName.isEmpty()) {
            UserDAO u = new UserDAO();
            boolean success = false;
            String redirectUrl = request.getContextPath() + "/alluser";
            if (originalSearchName != null && !originalSearchName.isEmpty()) {
                redirectUrl += "?searchName=" + originalSearchName;
            }
            
            if (currentListRoleFilter != null && !currentListRoleFilter.isEmpty()) {
                if (redirectUrl.contains("?")) {
                    redirectUrl += "&roleFilter=" + currentListRoleFilter;
                } else {
                    redirectUrl += "?roleFilter=" + currentListRoleFilter;
                }
            }

            try {
                success = u.banAccount(characterName);
                if (success) {
                    response.sendRedirect(redirectUrl); 
                } else {
                    request.setAttribute("errorMessage", "Error.");
                    request.getRequestDispatcher("/errorPage.jsp").forward(request, response); 
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Database error in BanAccountServlet for user: " + characterName, ex);
                request.setAttribute("errorMessage", "Error" + ex.getMessage());
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Unexpected error in BanAccountServlet for user: " + characterName, ex);
                request.setAttribute("errorMessage", "Error.");
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Error");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for ban/unban.";
    }// </editor-fold>
}