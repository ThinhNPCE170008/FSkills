package controller;

import dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Course;

/**
 * Servlet implementation class DetailCourseServlet
 */
@WebServlet(name = "DetailCourseServlet", urlPatterns = {"/courseDetail"}) // Updated URL pattern
public class DetailCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public DetailCourseServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseIDParam = request.getParameter("id"); // Updated parameter name
        int courseID = 0;
        if (courseIDParam != null && !courseIDParam.isEmpty()) {
            try {
                courseID = Integer.parseInt(courseIDParam);
            } catch (NumberFormatException e) {
                // Handle invalid courseID parameter (e.g., redirect or display an error page)
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/AllCourses"); // Redirect to all courses page as fallback
                return;
            }
        } else {
            // Handle case where courseID is not provided
            response.sendRedirect(request.getContextPath() + "/AllCourses"); // Redirect to all courses page
            return;
        }

        CourseDAO courseDAO = new CourseDAO();
        Course course = courseDAO.getCourseByCourseID(courseID);

        if (course != null) {
            List<String> highlights = courseDAO.getCourseHighlights(courseID);
            List<CourseDAO.CourseSection> curriculum = courseDAO.getCourseCurriculum(courseID);
            double averageRating = courseDAO.getAverageCourseRating(courseID);
            int ratingCount = courseDAO.getCourseRatingCount(courseID);
            List<Course> relatedCourses = courseDAO.getRelatedCourses(courseID, course.getCourseCategory(), 3);

            request.setAttribute("course", course);
            request.setAttribute("highlights", highlights);
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("ratingCount", ratingCount);
            request.setAttribute("relatedCourses", relatedCourses);

            request.getRequestDispatcher("/WEB-INF/views/courseDetail.jsp").forward(request, response);
        } else {
            // Handle case where course is not found
            response.sendRedirect(request.getContextPath() + "/AllCourses"); // Redirect to all courses page with a potential error message
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // You can add logic for handling POST requests here if needed,
        // for example, for enrolling in the course.
        doGet(request, response);
    }
}