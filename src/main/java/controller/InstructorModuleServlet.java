/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import dao.CourseDAO;
import dao.ModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Course;
import model.Module;
import model.Role;
import model.User;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
@WebServlet(name = "InstructorModuleServlet", urlPatterns = {"/instructor/courses/modules"})
public class InstructorModuleServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet InstructorModuleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InstructorModuleServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contextPath = request.getContextPath();
        HttpSession session = request.getSession();

        ModuleDAO mdao = new ModuleDAO();
        CourseDAO cdao = new CourseDAO();
        Course course = null;

        User acc = (User) session.getAttribute("user");
        if (acc == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        if (acc.getRole() != Role.INSTRUCTOR) {
            response.sendRedirect(contextPath + "/homePage_Guest.jsp");
            return;
        }

        String courseIdParam = request.getParameter("courseId");
        int courseId = -1;

        try {
            courseId = Integer.parseInt(courseIdParam);
            course = cdao.getCourseByCourseID(courseId);
            session.setAttribute("course", course);

            if (course == null) {
                response.sendRedirect(contextPath + "/instructor/courses");
                return;
            }

            String action = (String) request.getParameter("action");
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    List<Module> list = mdao.getAllModuleByCourseID(courseId);

                    request.setAttribute("listModule", list);
                    // request.setAttribute("courseDetails", course);
                    request.getRequestDispatcher("/WEB-INF/views/listModule.jsp").forward(request, response);
                default:
            }
            // Sau đó bạn có thể dùng courseId để query dữ liệu từ DB
            // Ví dụ:
            // Course course = courseDAO.getCourseById(courseId);
            // request.setAttribute("course", course);
        } catch (NumberFormatException e) {

        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CourseDAO cdao = new CourseDAO();
        ModuleDAO mdao = new ModuleDAO();
        Course course = null;
        Module module = null;

        int courseID = Integer.parseInt(request.getParameter("courseID"));
        course = cdao.getCourseByCourseID(courseID);

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String action = request.getParameter("action");

            if (action.equalsIgnoreCase("create")) {
                course = cdao.getCourseByCourseID(courseID);

                String moduleName = request.getParameter("moduleName");
                module = new Module(moduleName, course);

                int insert = mdao.insertModule(module);

                if (insert > 0) {
                    List<Module> list = mdao.getAllModuleByCourseID(courseID);

                    request.setAttribute("listModule", list);
                    request.getRequestDispatcher("/WEB-INF/views/listModule.jsp").forward(request, response);
                } else {
                    request.setAttribute("err", "Create failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/listModule.jsp").forward(request, response);
                }
            } else if (action.equalsIgnoreCase("update")) {
                int moduleID = Integer.parseInt(request.getParameter("moduleID"));
                String moduleName = request.getParameter("moduleName");

                int update = mdao.updateModule(moduleID, moduleName);

                if (update > 0) {
                    List<Module> list = mdao.getAllModuleByCourseID(courseID);

                    request.setAttribute("listModule", list);
                    request.getRequestDispatcher("/WEB-INF/views/listModule.jsp").forward(request, response);
                } else {
                    request.setAttribute("err", "Update failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/listModule.jsp").forward(request, response);
                }
            } else if (action.equalsIgnoreCase("delete")) {
                int moduleID = Integer.parseInt(request.getParameter("moduleID"));

                int delete = mdao.deleteModule(moduleID);

                if (delete > 0) {
                    List<Module> list = mdao.getAllModuleByCourseID(courseID);

                    request.setAttribute("listModule", list);
                    request.getRequestDispatcher("/WEB-INF/views/listModule.jsp").forward(request, response);
                } else {
                    request.setAttribute("err", "Delete failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/listModule.jsp").forward(request, response);
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
