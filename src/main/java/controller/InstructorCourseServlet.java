package controller;

import dao.*;

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

import model.*;
import model.Module;

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
        ModuleDAO mDao = new ModuleDAO();
        MaterialDAO matDao = new MaterialDAO();
        NotificationDAO notiDao = new NotificationDAO();

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String action = request.getParameter("action");

            if (action.equalsIgnoreCase("create")) {
                int userID = Integer.parseInt(request.getParameter("userID"));
                String courseName = request.getParameter("courseName");
                int categoryId = Integer.parseInt(request.getParameter("category_id"));

                int originalPrice = Integer.parseInt(request.getParameter("originalPrice"));
//                int salePrice = Integer.parseInt(request.getParameter("salePrice"));

                Part filePartInsert = request.getPart("courseImageLocation");
                InputStream imageInputStream = null;

                if (filePartInsert != null && filePartInsert.getSize() > 0) {
                    imageInputStream = filePartInsert.getInputStream();
                }

//                int isSale = request.getParameter("isSale") != null ? 1 : 0;
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

                if (courseName.length() > 30 || courseName.length() < 10) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name must be between 10 and 30 characters.");
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

                if (originalPrice > 10000000) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Original Price is not greater than 10,000,000!");
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

                int insert = cDao.insertCourse(courseName, categoryId, userID, originalPrice, imageInputStream, courseSummary, courseHighlight);

                if (insert > 0) {
                    User acc = uDao.getByUserID(userID);
                    List<Course> list = cDao.getCourseByUserID(acc.getUserId());

                    request.setAttribute("success", "Course created successfully!!!");
                    request.setAttribute("listCourse", list);
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("err", "Create failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }
            } else if (action.equalsIgnoreCase("update")) {
                int userID = Integer.parseInt(request.getParameter("userID"));
                int courseID = Integer.parseInt(request.getParameter("courseID"));
                String courseName = request.getParameter("courseName");

                int categoryId = Integer.parseInt(request.getParameter("category_id"));
                int originalPrice = Integer.parseInt(request.getParameter("originalPrice"));
//                int salePrice = Integer.parseInt(request.getParameter("salePrice"));

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

//                int isSale = request.getParameter("isSale") != null ? 1 : 0;
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

                if (courseName.length() > 30 || courseName.length() < 10) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Course Name must be between 10 and 30 characters.");
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

                if (originalPrice > 10000000) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Create failed: Original Price is not greater than 10,000 (Ten million)!");
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

                int update = cDao.updateCourse(courseID, courseName, categoryId, originalPrice, imageInputStream, courseSummary, courseHighlight);

                if (update > 0) {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("success", "Course updated successfully!!!");
                    request.setAttribute("listCourse", list);
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("err", "Update failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
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
                    return;
                } else {
                    Course course = cDao.getCourseByCourseID(courseID);

                    if (course == null) {
                        request.setAttribute("err", "Delete failed: Course not exists!");
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                        return;
                    } else if (course.getApproveStatus() == 0 || course.getApproveStatus() == 2) {
                        int delete = cDao.deleteCourse(courseID);

                        if (delete > 0) {
                            List<Course> list = cDao.getCourseByUserID(userID);

                            request.setAttribute("success", "Course deleted successfully!!!");
                            request.setAttribute("listCourse", list);
                            request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                            return;
                        } else {
                            request.setAttribute("err", "Delete failed: Unknown error!");
                            request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                            return;
                        }
                    } else if (course.getApproveStatus() == 1) {
                        int status = cDao.checkStatus(courseID);

                        if (status > 0) {
                            List<Course> list = cDao.getCourseByUserID(userID);

                            request.setAttribute("success", "Course deleted successfully!!!");
                            request.setAttribute("listCourse", list);
                            request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                            return;
                        } else {
                            request.setAttribute("err", "Delete failed: Unknown error!");
                            request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                            return;
                        }
                    } else {
                        List<Course> list = cDao.getCourseByUserID(userID);

                        request.setAttribute("err", "Delete failed: The course is under approval and cannot be deleted!");
                        request.setAttribute("listCourse", list);
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                        return;
                    }
                }
            } else if (action.equalsIgnoreCase("approve")) {
                int userID = Integer.parseInt(request.getParameter("userID"));
                int courseID = Integer.parseInt(request.getParameter("courseID"));

                Course course = cDao.getCourseByCourseID(courseID);

                if (course != null) {
                    int hasModule = mDao.checkModuleByCourseID(courseID);
                    int hasMaterial = matDao.checkMaterialInCourse(courseID);

                    if (hasModule < 1 || hasMaterial < 1) {
                        List<Course> list = cDao.getCourseByUserID(userID);

                        request.setAttribute("listCourse", list);
                        request.setAttribute("err", "Submit failed: The course must have at least one data in Module and Material!");
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                        return;
                    }

                    int submit = cDao.submitCourseApprove(courseID);

                    if (submit > 0) {
                        String sender = request.getParameter("userName");
                        String displayName = request.getParameter("displayName");
                        String notiMess = displayName + "(" + sender + ") has created a new course is " + courseID;
                        String type = "addCourse";//max10
                        String link = "http://";
                        int idAdmin = 5;
                        notiDao.sendNofication(idAdmin, sender, link, notiMess, type);
                        List<Course> list = cDao.getCourseByUserID(userID);
                        request.setAttribute("success", "Submit Course successfully!!!");
                        request.setAttribute("listCourse", list);
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("err", "Submit failed: Unknown error!");
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                        return;
                    }
                } else {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Submit failed: CourseID does not exist!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                    return;
                }
            } else if (action.equalsIgnoreCase("cancel")) {
                int userID = Integer.parseInt(request.getParameter("userID"));
                int courseID = Integer.parseInt(request.getParameter("courseID"));

                Course course = cDao.getCourseByCourseID(courseID);

                if (course != null) {

                    int cancel = cDao.cancelCourseApprove(courseID);

                    if (cancel > 0) {
                        String sender = request.getParameter("userName");
                        String displayName = request.getParameter("displayName");
                        String notiMess = displayName + "(" + sender + ") has created a new course is " + courseID;
                        int deleteId = notiDao.getNotiIdByNotiMess(notiMess);
                        int row = notiDao.delete(deleteId);
                        if (row == 0) {
                            request.setAttribute("err", notiMess + deleteId);
                            request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                            return;
                        }
                        List<Course> list = cDao.getCourseByUserID(userID);
                        request.setAttribute("success", "Cancel Course successfully!!!");
                        request.setAttribute("listCourse", list);
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("err", "Cancel failed: Unknown error!");
                        request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                        return;
                    }
                } else {
                    List<Course> list = cDao.getCourseByUserID(userID);

                    request.setAttribute("listCourse", list);
                    request.setAttribute("err", "Cancel failed: CourseID does not exist!");
                    request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
                }
            } else if (action.equalsIgnoreCase("search")) {
                String inputSearch = request.getParameter("searchCourse");
                int userId = Integer.parseInt(request.getParameter("userId"));

                List<Course> listCourse;

                if(inputSearch != null && !inputSearch.trim().isEmpty()) {
                    listCourse = cDao.searchCourseByName(inputSearch.trim());
                } else {
                    listCourse = cDao.getCourseByUserID(userId);
                }

                request.setAttribute("listCourse", listCourse);
                request.getRequestDispatcher("/WEB-INF/views/listCourse.jsp").forward(request, response);
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
