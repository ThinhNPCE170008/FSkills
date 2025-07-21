/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CourseDAO;
import dao.EnrollDAO;
import dao.StudyDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.Enroll;
import model.User;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
@WebServlet(name = "LearnerCourseListServlet", urlPatterns = {"/learner/courselist"})
public class LearnerCourseListServlet extends HttpServlet {

    private EnrollDAO enrollDAO;
    private StudyDAO studyDAO;
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        enrollDAO = new EnrollDAO();
        studyDAO = new StudyDAO();
        courseDAO = new CourseDAO();
    }

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
            out.println("<title>Servlet LearnerCourseListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LearnerCourseListServlet at " + request.getContextPath() + "</h1>");
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
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        if (null == role) {
            response.sendRedirect(request.getContextPath() + "/homePage_Guest.jsp");
        } else {
            switch (role) {
                case "LEARNER":
                    int userID = user.getUserId();
                    List<Enroll> enrollments = enrollDAO.getEnrolledCourse(userID);
                    List<Course> inProgressCourses = new ArrayList<>();
                    List<Course> completedCourses = new ArrayList<>();
                    List<Course> availableCourses = new ArrayList<>();
                    List<Integer> progressList = new ArrayList<>();

                    // Categorize enrolled courses
                    for (Enroll enrollment : enrollments) {
                        Course course = courseDAO.getCourseByCourseID(enrollment.getCourseID());
                        if (course != null) {
                            if (enrollment.getCompleteDate() == null && enrollment.getEnrollDate() != null) {
                                // In Progress: completeDate is null, enrollDate is not null
                                inProgressCourses.add(course);
                                int progress = studyDAO.returnStudyProgress(userID, enrollment.getCourseID());
                                progressList.add(progress);
                            } else if (enrollment.getCompleteDate() != null && enrollment.getEnrollDate() != null) {
                                // Completed: both dates are not null
                                completedCourses.add(course);
                            } else if (enrollment.getCompleteDate() == null && enrollment.getEnrollDate() == null) {
                                // Available to Enroll: both dates are null
                                availableCourses.add(course);
                            }
                        }
                    }

                    request.setAttribute("inProgressCourses", inProgressCourses);
                    request.setAttribute("completedCourses", completedCourses);
                    request.setAttribute("availableCourses", availableCourses);
                    request.setAttribute("progressList", progressList);

                    request.getRequestDispatcher("/WEB-INF/views/learnerCourseList.jsp").forward(request, response);
                    break;
                case "INSTRUCTOR":
                    response.sendRedirect(request.getContextPath() + "/instructor");
                    break;
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/homePage_Guest.jsp");
                    break;
            }
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
        processRequest(request, response);
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
