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
import model.PasswordResetToken;

/**
 *
 * @author NgoThinh1902
 */
@WebServlet(name = "ChangePassword", urlPatterns = {"/changepassword"})
public class ChangePassword extends HttpServlet {

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
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet changePassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet changePassword at " + request.getContextPath() + "</h1>");
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
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token does not exist.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UserDAO userDao = new UserDAO();
        PasswordResetToken resetToken = userDao.findValidTokenForgotPassword(token);

        if (resetToken == null) {
            request.setAttribute("err", "Token has expired or is invalid.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Token hợp lệ → hiển thị form đổi mật khẩu
        request.setAttribute("token", token);
        request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
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
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String token = request.getParameter("token");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (newPassword.length() < 8) {
                request.setAttribute("err", "Password must be at least 8 characters.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
                return;
            }

            if (!newPassword.matches(".*[a-z].*") || !newPassword.matches(".*[A-Z].*")) {
                request.setAttribute("err", "Password must contain both uppercase and lowercase letters.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
                return;
            }

            if (!newPassword.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
                request.setAttribute("err", "Password must include at least one special character.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("err", "Passwords do not match.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
                return;
            }

            UserDAO userDao = new UserDAO();
            PasswordResetToken resetToken = userDao.findValidTokenForgotPassword(token);

            if (resetToken == null) {
                request.setAttribute("err", "Token has expired or is invalid.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            int update = userDao.updatePasswordAfterForgot(resetToken.getUserId(), newPassword);

            if (update > 0) {
                userDao.deleteTokenForgotPassword(resetToken.getUserId());
                request.setAttribute("success", "Password changed successfully. You can now login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("err", "Send Failed: Unknown");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
