/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.sun.org.apache.bcel.internal.generic.AALOAD;
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
import jakarta.servlet.http.Part;
import java.io.File;
import model.Course;
import model.Module;
import model.Role;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
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
        String material = request.getParameter("materialId");
        int courseId = -1;
        int moduleId = -1;
        int materialId = -1;
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
            } else if (action.equalsIgnoreCase("update")) {
                moduleId = Integer.parseInt(module);
                materialId = Integer.parseInt(material);
                Material ma = madao.getMaterialById(materialId);
                Module mo = mdao.getModuleByID(moduleId);
                request.setAttribute("material", ma);
                request.setAttribute("module", mo);
                request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
            } else if (action.equalsIgnoreCase("details")) {
                moduleId = Integer.parseInt(module);
                materialId = Integer.parseInt(material);
                Material ma = madao.getMaterialById(materialId);
                Module mo = mdao.getModuleByID(moduleId);
                request.setAttribute("material", ma);
                request.setAttribute("module", mo);
                request.getRequestDispatcher("/WEB-INF/views/materialDetails.jsp").forward(request, response);
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
        MaterialDAO madao = new MaterialDAO();
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String action = request.getParameter("action");

            if (action.equalsIgnoreCase("create")) {
                String courseIdStr = request.getParameter("courseId");
                String moduleIdStr = request.getParameter("moduleId");
                String materialName = request.getParameter("materialName");
                String type = request.getParameter("type");
                String materialOrderStr = request.getParameter("materialOrder");
                String videoTimeStr = request.getParameter("videoTime"); // "hh:mm:ss"
                String materialDescription = request.getParameter("materialDescription");
                String materialLocation = "";
                if ("video".equals(type)) {
                    // Nhận file
                    Part filePart = request.getPart("videoFile");
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    if (fileName == null || fileName.isEmpty()) {
                        materialLocation = ""; // hoặc "No File" nếu bạn muốn
                    } else {
                        // Đường dẫn upload
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "materialUpload";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdir();
                        }

                        filePart.write(uploadPath + File.separator + fileName);
                        materialLocation = "materialUpload/" + fileName; // Đường dẫn để lưu trong DB
                    }
                } else if ("pdf".equals(type)) {
                    // Nhận file
                    Part filePart = request.getPart("docFile");
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    if (fileName == null || fileName.isEmpty()) {
                        materialLocation = "No"; // hoặc "No File" nếu bạn muốn
                    } else {
                        // Đường dẫn upload
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "materialUpload";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdir();
                        }

                        filePart.write(uploadPath + File.separator + fileName);
                        materialLocation = "materialUpload/" + fileName; // Đường dẫn để lưu trong DB
                    }
                } else if ("link".equals(type)) {
                    materialLocation = request.getParameter("materialLink");
                }

                try {
                    int moduleId = Integer.parseInt(moduleIdStr);
                    int courseId = Integer.parseInt(courseIdStr);
                    int materialOrder = Integer.parseInt(materialOrderStr);

                    MaterialDAO dao = new MaterialDAO();
                    ModuleDAO moddao = new ModuleDAO();
                    CourseDAO coudao = new CourseDAO();
                    int res = dao.insertMaterial(moduleId, materialName, type, materialOrder,
                            materialLocation, videoTimeStr, materialDescription);
                    
                    int rowmod = moddao.moduleUpdateTime(moduleId);
                    int rowcou = coudao.courseUpdateTime(courseId);
                    if (res == 1) {
                        response.sendRedirect("InstructorMaterial?moduleId=" + moduleId + "&courseId=" + courseId);
                    } else {
                        request.setAttribute("err", "<p>Create failed</p>");
                        request.getRequestDispatcher("error234.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("err", "<p>Create failed</p>");
                    request.getRequestDispatcher("error123.jsp").forward(request, response);
                }
            } else if (action.equalsIgnoreCase("delete")) {
                String idRaw = request.getParameter("id");
                String courseIdStr = request.getParameter("courseId");
                String moduleIdStr = request.getParameter("moduleId");
                int id = 0;
                try {
                    int moduleId = Integer.parseInt(moduleIdStr);
                    int courseId = Integer.parseInt(courseIdStr);
                    id = Integer.parseInt(idRaw);
                    if (madao.delete(id) == 1) {
                        response.sendRedirect("InstructorMaterial?moduleId=" + moduleId + "&courseId=" + courseId);
                    } else {
                        response.sendRedirect("failDelete.jsp");
                    }
                } catch (Exception e) {
                    PrintWriter out = response.getWriter();
                    out.print(e.getMessage());
                }
            } else if (action.equalsIgnoreCase("update")) {
                String courseIdStr = request.getParameter("courseId");
                String moduleIdStr = request.getParameter("moduleId");
                String materialIdStr = request.getParameter("materialId");
                String materialName = request.getParameter("materialName");
                String type = request.getParameter("type");
                String materialOrderStr = request.getParameter("materialOrder");
                String videoTime = request.getParameter("videoTime");
                String materialDescription = request.getParameter("materialDescription");
                String materialLocation = ""; // sẽ quyết định tùy type

                if ("video".equals(type)) {
                    Part filePart = request.getPart("videoFile");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "materialUpload";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdir();
                        }
                        filePart.write(uploadPath + File.separator + fileName);
                        materialLocation = "materialUpload/" + fileName;
                    } else {
                        materialLocation = request.getParameter("materialLocation");
                    }
                } else if ("pdf".equals(type)) {
                    Part filePart = request.getPart("docFile");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "materialUpload";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdir();
                        }
                        filePart.write(uploadPath + File.separator + fileName);
                        materialLocation = "materialUpload/" + fileName;
                    } else {
                        materialLocation = request.getParameter("materialLocation");
                    }
                } else if ("link".equals(type)) {
                    materialLocation = request.getParameter("materialLink");
                }

                try {
                    int moduleId = Integer.parseInt(moduleIdStr);
                    int courseId = Integer.parseInt(courseIdStr);
                    int materialId = Integer.parseInt(materialIdStr);
                    int materialOrder = Integer.parseInt(materialOrderStr);
                    MaterialDAO dao = new MaterialDAO();
                    ModuleDAO moddao = new ModuleDAO();
                    CourseDAO coudao = new CourseDAO();
                    boolean res = dao.update(materialName, type, materialOrder, materialLocation,
                            videoTime, materialDescription, materialId, moduleId, courseId);
                    int rowmod = moddao.moduleUpdateTime(moduleId);
                    int rowcou = coudao.courseUpdateTime(courseId);
                    if (res == true) {
                        response.sendRedirect("InstructorMaterial?moduleId=" + moduleId + "&courseId=" + courseId);
                    } else {
                        request.setAttribute("err", "<p>Create failed</p>");
                        request.getRequestDispatcher("error234.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("err", "<p>Create failed</p>");
                    request.getRequestDispatcher("error123.jsp").forward(request, response);
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
