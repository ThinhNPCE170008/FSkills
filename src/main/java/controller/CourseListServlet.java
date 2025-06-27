//
//package controller;
//
//import dao.CourseDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.util.List;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import model.Course;
//import model.User;
//
///**
// *
// * @author huy18
// */
//@WebServlet(name = "CourseListServlet", urlPatterns = {"/AllCourses"})
//public class CourseListServlet extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet CourseListServlet</title>");            
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet CourseListServlet at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        try {
//            CourseDAO courseDAO = new CourseDAO();
//
//            // Lấy tham số search và filter
//            String searchTerm = request.getParameter("search");
//            String category = request.getParameter("category");
//
//            List<Course> courseList;
//
//            // Nếu có search hoặc filter, sử dụng searchCourses
//            if ((searchTerm != null && !searchTerm.trim().isEmpty()) ||
//                    (category != null && !category.trim().isEmpty() && !category.equals("all"))) {
//                courseList = courseDAO.searchCourses(searchTerm, category);
//            } else {
//                // Nếu không có search/filter, lấy tất cả courses
//                courseList = courseDAO.getAllCourses();
//            }
//
//            // Lấy danh sách categories để hiển thị trong filter
//            List<String> categories = courseDAO.getAllCategories();
//
//            // Kiểm tra user role từ session
//            HttpSession session = request.getSession();
//            User currentUser = (User) session.getAttribute("user");
//
//            // Set attributes cho JSP
//            request.setAttribute("courseList", courseList);
//            request.setAttribute("categories", categories);
//            request.setAttribute("currentSearch", searchTerm);
//            request.setAttribute("currentCategory", category);
//            request.setAttribute("currentUser", currentUser);
//
//            // Forward đến JSP với đường dẫn chính xác
//            request.getRequestDispatcher("WEB-INF/views/listCourseStudent.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "An error occurred while loading courses: " + e.getMessage());
//            request.getRequestDispatcher("error.jsp").forward(request, response);
//        }
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // Chuyển POST request thành GET request để xử lý search
//        doGet(request, response);
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "CourseListServlet handles course listing with search and filter functionality";
//    }
//}