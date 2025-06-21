/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.CourseDAO;
import dao.NotificationDAO;
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
import model.Course;
import model.Role;
import model.User;

/**
 *
 * @author NgoThinh1902
 */
@WebServlet(name="InstructorCourseServlet", urlPatterns={"/instructor/courses"})
public class InstructorCourseServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet InstructorCourseServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InstructorCourseServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String contextPath = request.getContextPath();
        HttpSession session = request.getSession();

        NotificationDAO notiDAO = new NotificationDAO();
        UserDAO udao = new UserDAO();
        CourseDAO cdao = new CourseDAO();

        User acc = (User) session.getAttribute("user");
        if (acc == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        if (acc.getRole() != Role.INSTRUCTOR) {
            response.sendRedirect(contextPath + "/homePage_Guest.jsp");
            return;
        }

        String action = (String) request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                request.setAttribute("listCourse", list);
                request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                break;
        }
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        CourseDAO cdao = new CourseDAO();
        UserDAO udao = new UserDAO();

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String action = request.getParameter("action");

            if (action.equalsIgnoreCase("create")) {
                int userID = Integer.parseInt(request.getParameter("userID"));

                String courseName = request.getParameter("courseName");
                String courseCategory = request.getParameter("courseCategory");
                int originalPrice = Integer.parseInt(request.getParameter("originalPrice"));
                int salePrice = Integer.parseInt(request.getParameter("salePrice"));
                String courseImageLocation = request.getParameter("courseImageLocation");
                int isSale = request.getParameter("isSale") != null ? 1 : 0;

                if (courseName == null || courseCategory == null) {
                    courseName = "";
                    courseCategory = "";
                }
                courseName = courseName.trim();
                courseCategory = courseCategory.trim();

                if (courseName.isEmpty() || courseCategory.isEmpty()) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name or Course Category is required.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.length() > 30 || courseCategory.length() > 30) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name or Course Category must not exceed 30 characters.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.contains("  ") || courseCategory.contains("  ")) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name or Course Category must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.matches(".*\\d.*") || courseCategory.matches(".*\\d.*")) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name or Course Category must not contain numbers.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (salePrice >= originalPrice) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Sale price is higher than original price!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                int insert = cdao.insertCourse(courseName, courseCategory, userID, salePrice, originalPrice, isSale, courseImageLocation);

                if (insert > 0) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("success", "Course created successfully!!!");
                    request.setAttribute("listCourse", list);
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                } else {
                    request.setAttribute("err", "Create failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                }
            } else if (action.equalsIgnoreCase("update")) {
                int userID = Integer.parseInt(request.getParameter("userID"));

                int courseID = Integer.parseInt(request.getParameter("courseID"));
                String courseName = request.getParameter("courseName");
                String courseCategory = request.getParameter("courseCategory");
                int originalPrice = Integer.parseInt(request.getParameter("originalPrice"));
                int salePrice = Integer.parseInt(request.getParameter("salePrice"));
                String courseImageLocation = request.getParameter("courseImageLocation");
                int isSale = request.getParameter("isSale") != null ? 1 : 0;

                if (courseName == null || courseCategory == null) {
                    courseName = "";
                    courseCategory = "";
                }
                courseName = courseName.trim();
                courseCategory = courseCategory.trim();

                if (courseName.isEmpty() || courseCategory.isEmpty()) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Update failed: Course Name or Course Category is required.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.length() > 30 || courseCategory.length() > 30) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Update failed: Course Name or Course Category must not exceed 30 characters.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.contains("  ") || courseCategory.contains("  ")) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Update failed: Course Name or Course Category must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.matches(".*\\d.*") || courseCategory.matches(".*\\d.*")) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Update failed: Course Name or Course Category must not contain numbers.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (salePrice >= originalPrice) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Update failed: Sale price is higher than original price!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                int update = cdao.updateCourse(courseID, courseName, courseCategory, salePrice, originalPrice, isSale, courseImageLocation);

                if (update > 0) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("success", "Course updated successfully!!!");
                    request.setAttribute("listCourse", list);
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                } else {
                    request.setAttribute("err", "Update failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                }
            } else if (action.equalsIgnoreCase("delete")) {
                int userID = Integer.parseInt(request.getParameter("userID"));
                int courseID = Integer.parseInt(request.getParameter("courseID"));

                int onGoingLearner = cdao.onGoingLearner(courseID);

                if (onGoingLearner > 0) {
                    List<Course> list = cdao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Cannot delete course: Students are still enrolled.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                } else {
                    int delete = cdao.checkStatus(courseID);

                    if (delete > 0) {
                        List<Course> list = cdao.getCourseByUserID(userID);

                        request.setAttribute("success", "Course deleted successfully!!!");
                        request.setAttribute("listCourse", list);
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    } else {
                        request.setAttribute("err", "Delete failed: Unknown error!");
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    }
                }
            }
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
