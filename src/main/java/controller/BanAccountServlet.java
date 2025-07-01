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

/**
 * Servlet này xử lý việc cấm hoặc bỏ cấm tài khoản người dùng.
 */
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
            // Đây là một template lỗi, không nên được gọi trực tiếp.
            // Thay vào đó, chúng ta sẽ chuyển hướng hoặc forward đến trang JSP thích hợp.
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
        // Thông thường, thao tác Ban/Unban nên là POST để an toàn.
        // Chuyển hướng về trang danh sách user.
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String characterName = request.getParameter("characterName");
        // Lấy lại tham số searchName từ hidden input
        String originalSearchName = request.getParameter("originalSearchName"); 
        // Lấy tham số roleFilter từ hidden input của form
        String currentListRoleFilter = request.getParameter("currentListRoleFilter"); 

        if (characterName != null && !characterName.isEmpty()) {
            UserDAO u = new UserDAO();
            boolean success = false;
            String redirectUrl = request.getContextPath() + "/alluser"; // Mặc định

            // Nếu có originalSearchName, thêm nó vào URL chuyển hướng
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

            try {
                success = u.banAccount(characterName);
                if (success) {
                    // Chuyển hướng thành công về trang danh sách user (có thể kèm search term và role filter)
                    response.sendRedirect(redirectUrl); // Chuyển hướng với URL đã sửa đổi
                } else {
                    // Nếu banAccount trả về false (có lỗi xử lý DB nhưng không ném exception)
                    request.setAttribute("errorMessage", "Thao tác thất bại. Không tìm thấy tài khoản hoặc lỗi xử lý.");
                    request.getRequestDispatcher("/errorPage.jsp").forward(request, response); // Chuyển hướng tới trang lỗi
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Database error in BanAccountServlet for user: " + characterName, ex);
                request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response); // Chuyển hướng tới trang lỗi
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Unexpected error in BanAccountServlet for user: " + characterName, ex);
                request.setAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn.");
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response); // Chuyển hướng tới trang lỗi
            }
        } else {
            request.setAttribute("errorMessage", "Tên tài khoản không được cung cấp.");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet để cấm/bỏ cấm tài khoản người dùng.";
    }// </editor-fold>
}