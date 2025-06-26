package controller;

import dao.CourseDAO;
import model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/courseDetail")
public class CourseDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Get course ID parameter
        String courseIdParam = request.getParameter("id");

        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            response.sendRedirect("AllCourses");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdParam);

            // Get course details from database
            CourseDAO courseDAO = new CourseDAO();
            Course course = courseDAO.getCourseByCourseID(courseId);

            if (course == null) {
                response.sendRedirect("AllCourses");
                return;
            }

            // Set course attribute for JSP
            request.setAttribute("course", course);

            // Forward to course details JSP
            request.getRequestDispatcher("/WEB-INF/views/courseDetailsLearner.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("AllCourses");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
