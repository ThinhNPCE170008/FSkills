package controller;

import dao.CategoryDAO;
import dao.CourseDAO;
import dao.NotificationDAO;
import dao.UserDAO;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.InputStream;

import jakarta.servlet.annotation.MultipartConfig;

import java.util.List;

import model.Category;
import model.Course;
import model.Role;
import model.User;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
@MultipartConfig
@WebServlet(name = "InstructorCourseServlet", urlPatterns = {"/instructor/courses"})
public class InstructorCourseServlet extends HttpServlet {

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
            out.println("<title>Servlet InstructorCourseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InstructorCourseServlet at " + request.getContextPath() + "</h1>");
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
        String contextPath = request.getContextPath();
        HttpSession session = request.getSession();

        NotificationDAO notiDAO = new NotificationDAO();

        UserDAO uDao = new UserDAO();
        CourseDAO cDao = new CourseDAO();
        CategoryDAO catDao = new CategoryDAO();

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

        try {
            switch (action) {
                case "list":
                    List<Course> list = cDao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("listCourse", list);
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    break;
                case "create":
                    List<Category> listCatCreate = catDao.getAllCategory();

                    request.setAttribute("listCategory", listCatCreate);
                    request.getRequestDispatcher("/WEB-INF/views/createCourse.jsp").forward(request, response);
                    break;
                case "update":
                    String courseIdUpdate = request.getParameter("courseID");
                    if (courseIdUpdate == null || courseIdUpdate.isEmpty()) {
                        response.sendRedirect(contextPath + "/instructor/courses?action=list");
                        return;
                    }

                    int courseId = Integer.parseInt(courseIdUpdate);
                    List<Category> listCatUpdate = catDao.getAllCategory();
                    Course listCourseUpdate = cDao.getCourseByCourseID(courseId);

                    request.setAttribute("listCategory", listCatUpdate);
                    request.setAttribute("listCourse", listCourseUpdate);
                    request.getRequestDispatcher("/WEB-INF/views/updateCourse.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
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
        CourseDAO cDao = new CourseDAO();
        UserDAO uDao = new UserDAO();

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String action = request.getParameter("action");

            if (action.equalsIgnoreCase("create")) {
                int userID = Integer.parseInt(request.getParameter("userID"));
                String courseName = request.getParameter("courseName");
                int categoryId = Integer.parseInt(request.getParameter("category_id"));

                int originalPrice = Integer.parseInt(request.getParameter("originalPrice"));
                int salePrice = Integer.parseInt(request.getParameter("salePrice"));

                Part filePartInsert = request.getPart("courseImageLocation");
                InputStream imageInputStream = null;

                if (filePartInsert != null && filePartInsert.getSize() > 0) {
                    imageInputStream = filePartInsert.getInputStream();
                }

                int isSale = request.getParameter("isSale") != null ? 1 : 0;
                String courseSummary = request.getParameter("courseSummary");
                String courseHighlight = request.getParameter("courseHighlight");

                if (courseName == null) {
                    courseName = "";
                }

                courseName = courseName.trim();

                if (courseName.isEmpty()) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name is required.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.length() > 30) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name must not exceed 30 characters.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.contains("  ")) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.matches(".*\\d.*")) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name must not contain numbers.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (salePrice >= originalPrice) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Sale price is higher than original price!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseSummary == null || courseSummary.trim().isEmpty()) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Summary is required.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseSummary.contains("  ")) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Summary must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseHighlight == null || courseHighlight.trim().isEmpty()) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Highlight is required.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseHighlight.contains("  ")) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Highlight must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                int insert = cDao.insertCourse(courseName, categoryId, userID, salePrice, originalPrice, isSale, imageInputStream, courseSummary, courseHighlight);

                if (insert > 0) {
                    User acc = uDao.getByUserID(userID);
                    List<Course> list = cDao.getCourseByUserID(acc.getUserId());

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

                int categoryId = Integer.parseInt(request.getParameter("category_id"));
                int originalPrice = Integer.parseInt(request.getParameter("originalPrice"));
                int salePrice = Integer.parseInt(request.getParameter("salePrice"));

                Part filePartUpdate = request.getPart("courseImageLocation");
                InputStream imageInputStream = null;

                if (filePartUpdate != null && filePartUpdate.getSize() > 0) {
                    imageInputStream = filePartUpdate.getInputStream();
                } else {
                    Course existCourse = cDao.getCourseByCourseID(courseID);
                    byte[] imageBytes = existCourse.getCourseImageLocation();
                    if (imageBytes != null) {
                        imageInputStream = new ByteArrayInputStream(imageBytes);
                    }
                }

                int isSale = request.getParameter("isSale") != null ? 1 : 0;
                String courseSummary = request.getParameter("courseSummary");
                String courseHighlight = request.getParameter("courseHighlight");

                if (courseName == null) {
                    courseName = "";
                }
                courseName = courseName.trim();

                if (courseName.isEmpty()) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name is required.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.length() > 30) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name must not exceed 30 characters.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.contains("  ")) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseName.matches(".*\\d.*")) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name must not contain numbers.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (salePrice >= originalPrice) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Update failed: Sale price is higher than original price!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseSummary == null || courseSummary.trim().isEmpty()) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Summary is required.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseSummary.contains("  ")) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Summary must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseHighlight == null || courseHighlight.trim().isEmpty()) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Highlight is required.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                if (courseHighlight.contains("  ")) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Highlight must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }

                int update = cDao.updateCourse(courseID, courseName, categoryId, salePrice, originalPrice, isSale, imageInputStream, courseSummary, courseHighlight);

                if (update > 0) {
                    List<Course> list = cDao.getCourseByUserID(userID);

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

                int onGoingLearner = cDao.onGoingLearner(courseID);

                if (onGoingLearner > 0) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Cannot delete course: Students are still enrolled.");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                } else {
                    int delete = cDao.checkStatus(courseID);

                    if (delete > 0) {
                        List<Course> list = cDao.getCourseByUserID(userID);

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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
