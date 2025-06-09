/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller; // Đảm bảo package đúng với cấu trúc của bạn

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
// Các import khác bạn có thể cần trong tương lai khi thêm logic xử lý dữ liệu
// import java.util.List;
// import com.mycompany.studyweb.dao.UserDAO; // Ví dụ
// import com.mycompany.studyweb.model.User; // Ví dụ
// import java.sql.SQLException;

/**
 * Servlet này xử lý yêu cầu hiển thị trang Admin Dashboard.
 * Nó có thể chịu trách nhiệm lấy các dữ liệu tổng quan cho dashboard.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/adminDashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8"); 
        request.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}