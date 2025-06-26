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
@WebServlet(name = "InstructorMaterial", urlPatterns = {"/instructor/courses/modules/material"})
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
        String course = request.getParameter("courseId");
        String module = request.getParameter("moduleId");
        String material = request.getParameter("materialId");
        CourseDAO cdao = new CourseDAO();
        ModuleDAO mdao = new ModuleDAO();
        MaterialDAO madao = new MaterialDAO();
        int courseId = -1;
        int moduleId = -1;
        int materialId = -1;
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String action = request.getParameter("action");

            if (action.equalsIgnoreCase("create")) {
                String courseIdStr = request.getParameter("courseId");
                String moduleIdStr = request.getParameter("moduleId");
                String materialName = request.getParameter("materialName");

                if (materialName.trim() == null || materialName.trim().isEmpty() || materialName.matches(".*\\s{2,}.*")) {
                    moduleId = Integer.parseInt(module);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material name must not contain consecutive spaces!");
                    request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
                    return;
                }

                if (materialName.length() > 255) {
                    moduleId = Integer.parseInt(module);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material name cannot exceed 255 letters!");
                    request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
                    return;
                }
                String type = request.getParameter("type");
                String materialOrderStr = request.getParameter("materialOrder");
                if (materialOrderStr == null || materialOrderStr.trim().isEmpty()) {
                    moduleId = Integer.parseInt(module);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material order must not be empty.");
                    request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
                    return;
                }

                int materialOrder;
                try {
                    materialOrder = Integer.parseInt(materialOrderStr.trim());

                    // Tùy chọn: kiểm tra số âm
                    if (materialOrder < 0) {
                        moduleId = Integer.parseInt(module);
                        Module mo = mdao.getModuleByID(moduleId);
                        request.setAttribute("module", mo);
                        request.setAttribute("err", "Material order must be a non-negative number.");
                        request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
                        return;
                    }

                } catch (NumberFormatException e) {
                    moduleId = Integer.parseInt(module);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material order must be a valid integer.");
                    request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
                    return;
                }

                String videoTimeStr = request.getParameter("videoTime");

                if (videoTimeStr == null || videoTimeStr.trim().isEmpty()) {
                    moduleId = Integer.parseInt(module);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Video time cannot empty!");
                    request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
                    return;
                }

                // Định dạng: hh:mm:ss hoặc mm:ss
                String timePattern = "^((\\d{1,2}):)?([0-5]?\\d):([0-5]\\d)$";
                if (!videoTimeStr.matches(timePattern)) {
                    moduleId = Integer.parseInt(module);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Video time must be in format hh:mm:ss or mm:ss (e.g., 01:30 or 00:05:30).");
                    request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
                    return;
                }

                String materialDescription = request.getParameter("materialDescription");
                if (materialDescription == null || materialDescription.trim().isEmpty() || materialDescription.matches(".*\\s{2,}.*")) {
                    moduleId = Integer.parseInt(module);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material description must not be empty.");
                    request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);
                    return;
                }
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
                    moduleId = Integer.parseInt(moduleIdStr);
                    courseId = Integer.parseInt(courseIdStr);

                    MaterialDAO dao = new MaterialDAO();
                    ModuleDAO moddao = new ModuleDAO();
                    CourseDAO coudao = new CourseDAO();
                    int res = dao.insertMaterial(moduleId, materialName, type, materialOrder,
                            materialLocation, videoTimeStr, materialDescription);

                    int rowmod = moddao.moduleUpdateTime(moduleId);
                    int rowcou = coudao.courseUpdateTime(courseId);
                    if (res == 1) {
                        courseId = Integer.parseInt(course);
                        moduleId = Integer.parseInt(module);
                        Module m = mdao.getModuleByID(moduleId);
                        List<Material> listMaterial = madao.getAllMaterial(courseId, moduleId);
                        request.setAttribute("module", m);
                        request.setAttribute("listMaterial", listMaterial);
                        request.setAttribute("success", "Material created successfully!");
                        request.getRequestDispatcher("/WEB-INF/views/listMaterials.jsp").forward(request, response);

                    } else {
                        moduleId = Integer.parseInt(module);
                        Module mo = mdao.getModuleByID(moduleId);
                        request.setAttribute("module", mo);
                        request.setAttribute("err", "Failed to create material!!");
                        request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);

                    }
                } catch (Exception e) {
                    moduleId = Integer.parseInt(module);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Error failed to create material!!");
                    request.getRequestDispatcher("/WEB-INF/views/createMaterials.jsp").forward(request, response);

                }
            } else if (action.equalsIgnoreCase("delete")) {
                String idRaw = request.getParameter("id");
                String courseIdStr = request.getParameter("courseId");
                String moduleIdStr = request.getParameter("moduleId");
                int id = 0;
                try {
                    moduleId = Integer.parseInt(moduleIdStr);
                    courseId = Integer.parseInt(courseIdStr);
                    id = Integer.parseInt(idRaw);
                    if (madao.delete(id) == 1) {
                        courseId = Integer.parseInt(course);
                        moduleId = Integer.parseInt(module);
                        Module m = mdao.getModuleByID(moduleId);
                        List<Material> listMaterial = madao.getAllMaterial(courseId, moduleId);
                        request.setAttribute("module", m);
                        request.setAttribute("listMaterial", listMaterial);
                        request.setAttribute("success", "Material deleted successfully!");
                        request.getRequestDispatcher("/WEB-INF/views/listMaterials.jsp").forward(request, response);
                    } else {
                        courseId = Integer.parseInt(course);
                        moduleId = Integer.parseInt(module);
                        Module m = mdao.getModuleByID(moduleId);
                        List<Material> listMaterial = madao.getAllMaterial(courseId, moduleId);
                        request.setAttribute("module", m);
                        request.setAttribute("listMaterial", listMaterial);
                        request.setAttribute("success", "Failed to delete material!");
                        request.getRequestDispatcher("/WEB-INF/views/listMaterials.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    courseId = Integer.parseInt(course);
                    moduleId = Integer.parseInt(module);
                    Module m = mdao.getModuleByID(moduleId);
                    List<Material> listMaterial = madao.getAllMaterial(courseId, moduleId);
                    request.setAttribute("module", m);
                    request.setAttribute("listMaterial", listMaterial);
                    request.setAttribute("success", "Error failed to delete material!");
                    request.getRequestDispatcher("/WEB-INF/views/listMaterials.jsp").forward(request, response);
                }
            } else if (action.equalsIgnoreCase("update")) {
                String courseIdStr = request.getParameter("courseId");
                String moduleIdStr = request.getParameter("moduleId");
                String materialIdStr = request.getParameter("materialId");
                String materialName = request.getParameter("materialName");
                if (materialName.trim() == null || materialName.trim().isEmpty()|| materialName.matches(".*\\s{2,}.*")) {
                    moduleId = Integer.parseInt(module);
                    materialId = Integer.parseInt(material);
                    Material ma = madao.getMaterialById(materialId);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("material", ma);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material name must not contain consecutive spaces!");
                    request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                    return;
                }

                if (materialName.length() > 255) {
                    moduleId = Integer.parseInt(module);
                    materialId = Integer.parseInt(material);
                    Material ma = madao.getMaterialById(materialId);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("material", ma);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material name cannot exceed 255 letters!");
                    request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                    return;
                }

                String type = request.getParameter("type");

                String materialOrderStr = request.getParameter("materialOrder");
                if (materialOrderStr == null || materialOrderStr.trim().isEmpty()) {
                    moduleId = Integer.parseInt(module);
                    materialId = Integer.parseInt(material);
                    Material ma = madao.getMaterialById(materialId);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("material", ma);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material order must not be empty.");
                    request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                    return;
                }
                int materialOrder;
                try {
                    materialOrder = Integer.parseInt(materialOrderStr.trim());

                    // Tùy chọn: kiểm tra số âm
                    if (materialOrder < 0) {
                        moduleId = Integer.parseInt(module);
                        materialId = Integer.parseInt(material);
                        Material ma = madao.getMaterialById(materialId);
                        Module mo = mdao.getModuleByID(moduleId);
                        request.setAttribute("material", ma);
                        request.setAttribute("module", mo);
                        request.setAttribute("err", "Material order must be a non-negative number.");
                        request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    moduleId = Integer.parseInt(module);
                    materialId = Integer.parseInt(material);
                    Material ma = madao.getMaterialById(materialId);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("material", ma);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material order must be a valid integer.");
                    request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                    return;
                }

                String videoTime = request.getParameter("videoTime");
                if ("00:00:00".equals(videoTime) || videoTime == null || videoTime.trim().isEmpty()) {
                    moduleId = Integer.parseInt(module);
                    materialId = Integer.parseInt(material);
                    Material ma = madao.getMaterialById(materialId);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("material", ma);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Video time cannot empty!");
                    request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                    return;
                }
                // Định dạng: hh:mm:ss hoặc mm:ss
                String timePattern = "^((\\d{1,2}):)?([0-5]?\\d):([0-5]\\d)$";
                if (!videoTime.matches(timePattern)) {
                    moduleId = Integer.parseInt(module);
                    materialId = Integer.parseInt(material);
                    Material ma = madao.getMaterialById(materialId);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("material", ma);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Video time must be in format hh:mm:ss or mm:ss (e.g., 01:30 or 00:05:30).");
                    request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                    return;
                }

                String materialDescription = request.getParameter("materialDescription");
                if (materialDescription == null || materialDescription.trim().isEmpty() || materialDescription.matches(".*\\s{2,}.*")) {
                    moduleId = Integer.parseInt(module);
                    materialId = Integer.parseInt(material);
                    Material ma = madao.getMaterialById(materialId);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("material", ma);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Material description must not be empty!");
                    request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                    return;
                }

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
                    moduleId = Integer.parseInt(moduleIdStr);
                    courseId = Integer.parseInt(courseIdStr);
                    materialId = Integer.parseInt(materialIdStr);
                    MaterialDAO dao = new MaterialDAO();
                    ModuleDAO moddao = new ModuleDAO();
                    CourseDAO coudao = new CourseDAO();
                    boolean res = dao.update(materialName, type, materialOrder, materialLocation,
                            videoTime, materialDescription, materialId, moduleId, courseId);
                    int rowmod = moddao.moduleUpdateTime(moduleId);
                    int rowcou = coudao.courseUpdateTime(courseId);
                    if (res == true) {
                        courseId = Integer.parseInt(course);
                        moduleId = Integer.parseInt(module);
                        Module m = mdao.getModuleByID(moduleId);
                        List<Material> listMaterial = madao.getAllMaterial(courseId, moduleId);
                        request.setAttribute("module", m);
                        request.setAttribute("listMaterial", listMaterial);
                        request.setAttribute("success", "Material updated successfully!");
                        request.getRequestDispatcher("/WEB-INF/views/listMaterials.jsp").forward(request, response);
                    } else {
                        moduleId = Integer.parseInt(module);
                        materialId = Integer.parseInt(material);
                        Material ma = madao.getMaterialById(materialId);
                        Module mo = mdao.getModuleByID(moduleId);
                        request.setAttribute("material", ma);
                        request.setAttribute("module", mo);
                        request.setAttribute("err", "Failed to update material!");
                        request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    moduleId = Integer.parseInt(module);
                    materialId = Integer.parseInt(material);
                    Material ma = madao.getMaterialById(materialId);
                    Module mo = mdao.getModuleByID(moduleId);
                    request.setAttribute("material", ma);
                    request.setAttribute("module", mo);
                    request.setAttribute("err", "Error failed to update material!");
                    request.getRequestDispatcher("/WEB-INF/views/updateMaterials.jsp").forward(request, response);

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
