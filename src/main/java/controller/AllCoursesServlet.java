package controller;

import dao.CategoryDAO;
import dao.CourseDAO;
import model.Category;
import model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name="AllCoursesServlet",urlPatterns = {"/AllCourses"})
public class AllCoursesServlet extends HttpServlet {
    private static final int COURSES_PER_PAGE = 12;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String pageParam = request.getParameter("page");
        
        // Clean and validate parameters
        if (search != null) {
            search = search.trim();
            if (search.isEmpty()) {
                search = null;
            }
        }
        
        if (category != null) {
            category = category.trim();
            if (category.isEmpty() || "all".equals(category)) {
                category = null;
            }
        }
        
        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        
        // Initialize DAOs
        CourseDAO courseDAO = new CourseDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        // Get courses based on search and filter criteria
        List<Course> courseList;
        int totalCourses;
        
        if (search != null && category != null) {
            // Both search and category filter
            courseList = courseDAO.searchAndFilterCourses(search, category, currentPage, COURSES_PER_PAGE);
            totalCourses = courseDAO.getSearchAndFilterCoursesCount(search, category);
        } else if (search != null) {
            // Only search
            courseList = courseDAO.searchCourses(search, currentPage, COURSES_PER_PAGE);
            totalCourses = courseDAO.getSearchCoursesCount(search);
        } else if (category != null) {
            // Only category filter
            courseList = courseDAO.getCoursesByCategory(category, currentPage, COURSES_PER_PAGE);
            totalCourses = courseDAO.getCoursesByCategoryCount(category);
        } else {
            // No filters, get all courses
            courseList = courseDAO.getAllCourses(currentPage, COURSES_PER_PAGE);
            totalCourses = courseDAO.getTotalCoursesCount();
        }
        
        // Calculate pagination
        int totalPages = (int) Math.ceil((double) totalCourses / COURSES_PER_PAGE);
        if (totalPages == 0) {
            totalPages = 1;
        }
        
        // Get all categories for dropdown
        List<Category> categories = categoryDAO.getAllCategory();
        
        // Set attributes for JSP
        request.setAttribute("courseList", courseList);
        request.setAttribute("categories", categories);
        request.setAttribute("currentSearch", search);
        request.setAttribute("currentCategory", category);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalCourses", totalCourses);
        
        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/courseListLearner.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}