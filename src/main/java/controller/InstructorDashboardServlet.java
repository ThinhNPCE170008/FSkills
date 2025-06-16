/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CourseDAO;
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
@WebServlet(name = "InstructorDashboardServlet", urlPatterns = {"/instructor"})
public class InstructorDashboardServlet extends HttpServlet {

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
            out.println("<title>Servlet InstructorDashboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InstructorDashboardServlet at " + request.getContextPath() + "</h1>");
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
        UserDAO udao = new UserDAO();
        CourseDAO cdao = new CourseDAO();

        User acc = (User) session.getAttribute("user");
        if (acc == null) {
            response.sendRedirect("login");
            return;
        }

        if (acc.getRole() != Role.INSTRUCTOR) {
            response.sendRedirect("login");
            return;
        }

        String action = (String) request.getParameter("action");
        if (action == null) {
            action = "default";
        }

        switch (action) {
            case "list":
                List<Course> list = cdao.getCourseByUserID(acc.getUserId());

                request.setAttribute("listCourse", list);
                request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                break;
            default:
                int totalCourses = cdao.countCoursesByUserID(acc.getUserId());
                List<Course> listLittle = cdao.get3CourseByUserID(acc.getUserId());

                request.setAttribute("listLittle", listLittle);
                request.setAttribute("totalCourses", totalCourses);
                request.getRequestDispatcher("/WEB-INF/views/instructor_dBoard.jsp").forward(request, response);
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

                int insert = cdao.insertCourse(courseName, courseCategory, userID, salePrice, originalPrice, isSale, courseImageLocation);
                if (insert > 0) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

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

                int update = cdao.updateCourse(courseID, courseName, courseCategory, salePrice, originalPrice, isSale, courseImageLocation);
                if (update > 0) {
                    User acc = udao.getByUserID(userID);
                    List<Course> list = cdao.getCourseByUserID(acc.getUserId());

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
                    int delete = cdao.deleteCourse(courseID);

                    if (delete > 0) {
                        List<Course> list = cdao.getCourseByUserID(userID);

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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
