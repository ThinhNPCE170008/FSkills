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
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.User;
import util.GoogleLogin;

/**
 *
 * @author Hua Khanh Duy - CE180230 - SE1815
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
@WebServlet(name = "Login", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        
        String code = request.getParameter("code");

        if (code != null) {
            GoogleLogin googleLogin = new GoogleLogin();
            String accessToken = googleLogin.getToken(code);
            User userGoogle = googleLogin.getUserInfo(accessToken);

            UserDAO dao = new UserDAO();
            User user = dao.findByGoogleID(userGoogle.getGoogleID());

            if (user == null) {
                user = dao.findByEmail(userGoogle.getEmail());
                if (user == null) {
                    // Tạo tài khoản mới
                    user = new User();
                    user.setDisplayName(userGoogle.getDisplayName());
                    user.setEmail(userGoogle.getEmail());
                    user.setGoogleID(userGoogle.getGoogleID());
                    user.setIsVerified(true);
                    user.setRole(false); // mặc định là user
                    dao.insertGoogle(user);
                } else {
                    // Cập nhật GoogleID nếu chưa có
                    user.setGoogleID(userGoogle.getGoogleID());
//                    dao.update(user);
                }
            }

            // Lưu user vào session và chuyển hướng
            session.setAttribute("user", user);
            response.sendRedirect("adminDashboard");
        } else {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
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
            UserDAO dao = new UserDAO();
            HttpSession session = request.getSession();

            String username = request.getParameter("username");
            String password = request.getParameter("password");

            User user = dao.verifyMD5(username, password);

            if (user != null) {
                session.setAttribute("login", user);
                response.sendRedirect("adminDashboard");
            } else {
                request.setAttribute("err", "<h1 style=\"color: red; text-align: center\">The user or password are wrong</h1>");
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
