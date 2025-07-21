package controller;

import dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;

import java.io.IOException;

/**
 * Servlet for displaying course details in admin panel including modules and materials
 * @author huy18
 */
@WebServlet(name = "CourseDetailAdminServlet", urlPatterns = {"/admin/CourseDetailAdmin"})
public class CourseDetailAdminServlet extends HttpServlet {

    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        try {
            courseDAO = new CourseDAO();
        } catch (Exception e) {
            throw new ServletException("Error initializing CourseDAO", e);
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method to display course details.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseIdParam = request.getParameter("id");

        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Course ID is required.");
            request.getRequestDispatcher("/WEB-INF/views/courseDetailAdmin.jsp").forward(request, response);
            return;
        }

        try {
            int courseID = Integer.parseInt(courseIdParam);

            // Load course with modules and materials
            Course course = courseDAO.getCourseByCourseIDAdmin(courseID);

            if (course != null) {
                request.setAttribute("course", course);
                request.getRequestDispatcher("/WEB-INF/views/courseDetailAdmin.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Course not found with ID: " + courseID);
                request.getRequestDispatcher("/WEB-INF/views/courseDetailAdmin.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid course ID format: " + courseIdParam);
            request.getRequestDispatcher("/WEB-INF/views/courseDetailAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading course details: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/courseDetailAdmin.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method - redirects to GET.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Course Detail Admin Servlet - displays course details including modules and materials";
    }
}
    