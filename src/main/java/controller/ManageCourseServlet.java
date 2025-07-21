package controller;

import dao.CourseDAO;
import dao.ModuleDAO;
import dao.MaterialDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageCourseServlet", urlPatterns = {"/admin/ManageCourse"})
public class ManageCourseServlet extends HttpServlet {
    private CourseDAO courseDAO;
    private ModuleDAO moduleDAO;
    private MaterialDAO materialDAO;

    @Override
    public void init() throws ServletException {
        try {
            courseDAO = new CourseDAO();
            moduleDAO = new ModuleDAO();
            materialDAO = new MaterialDAO();
        } catch (Exception e) {
            throw new ServletException("Error initializing DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = 10;

        try {
            if (action != null && action.equals("detail")) {
                int courseID = Integer.parseInt(request.getParameter("id"));
                Course course = courseDAO.getCourseByCourseIDAdmin(courseID);
                if (course != null) {
                    request.setAttribute("course", course);
                    request.getRequestDispatcher("/WEB-INF/views/courseDetailAdmin.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("error", "Course not found.");
                }
            } else if (action != null && action.equals("approve")) {
                int courseID = Integer.parseInt(request.getParameter("id"));
                int status = Integer.parseInt(request.getParameter("status"));
                boolean success = courseDAO.updateCourseStatus(courseID, status);
                if (success) {
                    request.setAttribute("message", "Course status updated successfully.");
                } else {
                    request.setAttribute("error", "Failed to update course status.");
                }
            }

            loadCoursesAndForward(request, response, page, pageSize);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID format.");
            loadCoursesAndForward(request, response, page, pageSize);
        } catch (Exception e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            loadCoursesAndForward(request, response, page, pageSize);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = 10;
        int courseID = request.getParameter("courseID") != null ? Integer.parseInt(request.getParameter("courseID")) : 0;

        try {
            if (action == null) {
                loadCoursesAndForward(request, response, page, pageSize);
                return;
            }

            switch (action) {
                case "delete":
                    handleDeleteCourse(request, page, pageSize);
                    break;
                case "deleteModule":
                    handleDeleteModule(request, response, courseID, page, pageSize);
                    break;
                case "deleteMaterialAdmin":
                    handleDeleteMaterial(request, response, courseID, page, pageSize);
                    break;
                case "updateStatus":
                    handleStatusUpdate(request, page, pageSize);
                    break;
                default:
                    request.setAttribute("error", "Invalid action specified.");
            }

            loadCoursesAndForward(request, response, page, pageSize);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID format.");
            loadCoursesAndForward(request, response, page, pageSize);
        } catch (Exception e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            loadCoursesAndForward(request, response, page, pageSize);
        }
    }

    private void handleDeleteCourse(HttpServletRequest request, int page, int pageSize) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        int result = courseDAO.deleteCourseAdmin(id);

        if (result > 0) {
            request.setAttribute("message", "Course deleted successfully.");
        } else if (result == -1) {
            request.setAttribute("error", "Cannot delete course with existing enrollments.");
        } else {
            request.setAttribute("error", "Failed to delete course.");
        }
    }

    private void handleDeleteModule(HttpServletRequest request, HttpServletResponse response, int courseID, int page, int pageSize) throws Exception {
        int moduleID = Integer.parseInt(request.getParameter("moduleID"));
        int result = moduleDAO.deleteModule(moduleID);

        if (result > 0) {
            request.setAttribute("message", "Module deleted successfully.");
            redirectToCourseDetail(request, response, courseID, page, pageSize);
        } else {
            request.setAttribute("error", "Failed to delete module.");
        }
    }

    private void handleDeleteMaterial(HttpServletRequest request, HttpServletResponse response, int courseID, int page, int pageSize) throws Exception {
        int materialID = Integer.parseInt(request.getParameter("materialID"));
        int result = materialDAO.deleteMaterialAdmin(materialID);

        if (result > 0) {
            request.setAttribute("message", "Material deleted successfully.");
            redirectToCourseDetail(request, response, courseID, page, pageSize);
        } else {
            request.setAttribute("error", "Failed to delete material.");
        }
    }

    private void handleStatusUpdate(HttpServletRequest request, int page, int pageSize) throws Exception {
        int courseID = Integer.parseInt(request.getParameter("courseID"));
        int status = Integer.parseInt(request.getParameter("status"));
        boolean success = courseDAO.updateCourseStatus(courseID, status);

        if (success) {
            request.setAttribute("message", "Course status updated successfully.");
        } else {
            request.setAttribute("error", "Failed to update course status.");
        }
    }

    private void loadCoursesAndForward(HttpServletRequest request, HttpServletResponse response,
                                       int page, int pageSize) throws ServletException, IOException {
        try {
            List<Course> courses = courseDAO.getAllCoursesAdmin(page, pageSize);
            int totalCourses = courseDAO.getTotalCoursesCountAdmin();
            int totalPages = (int) Math.ceil((double) totalCourses / pageSize);

            request.setAttribute("courses", courses);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.getRequestDispatcher("/WEB-INF/views/courseManage.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading courses: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/courseManage.jsp").forward(request, response);
        }
    }

    private void redirectToCourseDetail(HttpServletRequest request, HttpServletResponse response, int courseID,
                                        int page, int pageSize) throws Exception {
        Course course = courseDAO.getCourseByCourseIDAdmin(courseID);
        if (course != null) {
            request.setAttribute("course", course);
            request.getRequestDispatcher("/WEB-INF/views/courseDetailAdmin.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Course not found.");
            loadCoursesAndForward(request, response, page, pageSize);
        }
    }
}
