/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CourseDAO;
import dao.MaterialDAO;
import dao.ModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Course;
import model.Module;
import model.Role;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.Material;

/**
 * @author Hua Khanh Duy - CE180230 - SE1815
 */
@MultipartConfig
@WebServlet(name = "InstructorMaterial", urlPatterns = {"/InstructorMaterial"})
public class InstructorMaterialServlet extends HttpServlet {

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
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        MaterialDAO madao = new MaterialDAO();
        ModuleDAO mdao = new ModuleDAO();
        CourseDAO cdao = new CourseDAO();

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        if (user.getRole() != Role.INSTRUCTOR) {
            response.sendRedirect("homePage_Guest.jsp");
            return;
        }
        String course = request.getParameter("courseId");
        String module = request.getParameter("moduleId");
        int courseId = -1;
        int moduleId = -1;
        try {
            String action = (String) request.getParameter("action");
            if (action == null) {
                action = "listMaterial";
            }
            if (action.equalsIgnoreCase("listMaterial")) {
                courseId = Integer.parseInt(course);
                moduleId = Integer.parseInt(module);
                Module m = mdao.getModuleByID(moduleId);
                List<Material> listMaterial = madao.getAllMaterial(courseId, moduleId);
                request.setAttribute("module", m);
                request.setAttribute("listMaterial", listMaterial);
                request.getRequestDispatcher("/WEB-INF/views/listMaterials.jsp").forward(request, response);
            } else if (action.equalsIgnoreCase("create")) {

                moduleId = Integer.parseInt(module);
                Module mo = mdao.getModuleByID(moduleId);
                request.setAttribute("module", mo);
                request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
            }
        } catch (Exception e) {
            PrintWriter out = response.getWriter();
            out.print(e.getMessage());
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
