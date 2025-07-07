/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CommentDAO;
import dao.CourseDAO;
import dao.EnrollDAO;
import dao.MaterialDAO;
import dao.ModuleDAO;
import dao.ReportCategoryDAO;
import dao.ReportDAO;
import dao.StudyDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import model.Comment;
import model.Course;
import model.Degree;
import model.Material;
import model.Report;
import model.ReportCategory;
import model.User;

/**
 *
 * @author Hua Khanh Duy - CE180230 - SE1814
 */
@WebServlet(name = "report", urlPatterns = {"/report"})
public class ReportServlet extends HttpServlet {

    private String getStackTraceAsString(Exception e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

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
            out.println("<title>Servlet ReportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReportServlet at " + request.getContextPath() + "</h1>");
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
        ReportDAO reDao = new ReportDAO();
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (action == null) {
            action = "list";
        }

        if(action.equalsIgnoreCase("list")){
            List<Report> listReport = reDao.getReportByUserId(user.getUserId());
            request.setAttribute("listReport", listReport);
            request.getRequestDispatcher("/WEB-INF/views/reportHistory.jsp").forward(request, response);
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
        CommentDAO commentDAO = new CommentDAO();
        CourseDAO couDAO = new CourseDAO();
        EnrollDAO eDAO = new EnrollDAO();
        ModuleDAO molDAO = new ModuleDAO();
        MaterialDAO matDAO = new MaterialDAO();
        StudyDAO stuDAO = new StudyDAO();

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        ReportDAO reDao = new ReportDAO();

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Course course;
        Material currentMaterial;
        List<model.Module> moduleList;
        HashMap<Integer, List<Material>> mapOfModuleIdToMaterialList = new HashMap<>();
        HashMap<Integer, Boolean> mapOfMaterialIdToStudyStatus = new HashMap<>();

        String courseParam = request.getParameter("courseId");
        String moduleParam = request.getParameter("moduleId");
        String materialParam = request.getParameter("materialId");

        try {
            int courseID = Integer.parseInt(courseParam);
            int moduleID = Integer.parseInt(moduleParam);
            int materialID = Integer.parseInt(materialParam);

            if (!eDAO.checkEnrollment(user.getUserId(), courseID)) {
                response.sendRedirect(request.getContextPath() + "/courseDetail?courseID=" + courseID + "&message=not_enrolled");
                return;
            }
            ReportCategoryDAO reportCategoryDAO = new ReportCategoryDAO();
            List<ReportCategory> listReportCate = reportCategoryDAO.getAll();

            course = couDAO.getCourseByCourseID(courseID);
            moduleList = molDAO.getAllModuleByCourseID(courseID);
            currentMaterial = matDAO.getMaterialById(materialID);

            if (currentMaterial != null) {
                if (currentMaterial.getMaterialFile() == null) {
                    request.setAttribute("MaterialPath", currentMaterial.getMaterialUrl());
                } else {
                    request.setAttribute("MaterialPath", currentMaterial.getPdfDataURI());
                }
            }

            for (model.Module mol : moduleList) {
                List<Material> matList = matDAO.getAllMaterial(courseID, mol.getModuleID());
                mapOfModuleIdToMaterialList.put(mol.getModuleID(), matList);
                for (Material mat : matList) {
                    mapOfMaterialIdToStudyStatus.put(mat.getMaterialId(), stuDAO.checkStudy(user.getUserId(), mat.getMaterialId()));
                }
            }

            List<Comment> comments = commentDAO.getCommentsByMaterialId(materialID);
            request.setAttribute("comments", comments);

            String commentIdToEditParam = request.getParameter("commentIdToEdit");
            if (commentIdToEditParam != null && !commentIdToEditParam.isEmpty()) {
                try {
                    int commentIdToEdit = Integer.parseInt(commentIdToEditParam);
                    Comment commentToEdit = commentDAO.getCommentById(commentIdToEdit);

                    if (commentToEdit != null && user.getUserId() == commentToEdit.getUserId()) {
                        request.setAttribute("commentToEdit", commentToEdit);
                        System.out.println("DEBUG (LearnerMaterialServlet): commentToEdit set for ID: " + commentIdToEdit);
                    } else {
                        System.out.println("DEBUG (LearnerMaterialServlet): User " + user.getUserId() + " not authorized or comment " + commentIdToEdit + " not found for editing.");
                    }
                } catch (NumberFormatException e) {
                    System.err.println("ERROR (LearnerMaterialServlet): Invalid commentIdToEdit parameter: " + commentIdToEditParam);
                }
            } else {
                System.out.println("DEBUG (LearnerMaterialServlet): No commentIdToEdit parameter found in request.");
            }

            if (action.equalsIgnoreCase("reportMaterial")) {
                try {
                    String categoryIdStr = request.getParameter("categorySelection");
                    int categoryId = Integer.parseInt(categoryIdStr);
                    String materialIdStr = request.getParameter("materialId");
                    int materialId = Integer.parseInt(materialIdStr);
                    String id = request.getParameter("userId");
                    int userId = Integer.parseInt(id);

                    String reportDetail = request.getParameter("reportDetail");

                    if (reportDetail == null || reportDetail.trim().isEmpty() || reportDetail.matches(".*\\s{2,}.*")) {
                        reportDetail = "No Data";
                    }

                    int result = reDao.createReportMaterial(reportDetail, userId, materialId, categoryId);

                    if (result == 1) {
                        request.setAttribute("listReportCategory", listReportCate);
                        request.setAttribute("Course", course);
                        request.setAttribute("ModuleList", moduleList);
                        request.setAttribute("Material", currentMaterial);
                        request.setAttribute("MaterialMap", mapOfModuleIdToMaterialList);
                        request.setAttribute("StudyMap", mapOfMaterialIdToStudyStatus);
                        request.setAttribute("CurrentMaterialID", materialID);
                        request.setAttribute("CurrentModuleID", moduleID);
                        request.setAttribute("User", user);
                        request.setAttribute("success", "Report sended successfully!!!");
                        request.getRequestDispatcher("/WEB-INF/views/learnerMaterialView.jsp").forward(request, response);
                    } else {
                        request.setAttribute("listReportCategory", listReportCate);
                        request.setAttribute("Course", course);
                        request.setAttribute("ModuleList", moduleList);
                        request.setAttribute("Material", currentMaterial);
                        request.setAttribute("MaterialMap", mapOfModuleIdToMaterialList);
                        request.setAttribute("StudyMap", mapOfMaterialIdToStudyStatus);
                        request.setAttribute("CurrentMaterialID", materialID);
                        request.setAttribute("CurrentModuleID", moduleID);
                        request.setAttribute("User", user);
                        request.setAttribute("err", "Send failed: Unknown error!");
                        request.getRequestDispatcher("/WEB-INF/views/learnerMaterialView.jsp").forward(request, response);

                    }

                } catch (Exception e) {
                    request.setAttribute("listReportCategory", listReportCate);
                    request.setAttribute("Course", course);
                    request.setAttribute("ModuleList", moduleList);
                    request.setAttribute("Material", currentMaterial);
                    request.setAttribute("MaterialMap", mapOfModuleIdToMaterialList);
                    request.setAttribute("StudyMap", mapOfMaterialIdToStudyStatus);
                    request.setAttribute("CurrentMaterialID", materialID);
                    request.setAttribute("CurrentModuleID", moduleID);
                    request.setAttribute("User", user);
                    request.setAttribute("err", "Send failed: Unknown error!!!");
                    request.getRequestDispatcher("/WEB-INF/views/learnerMaterialView.jsp").forward(request, response);

                }

            } else if (action.equalsIgnoreCase("reportComment")) {
                try {
                    String categoryIdStr = request.getParameter("categorySelection");
                    int categoryId = Integer.parseInt(categoryIdStr);
                    String commentIdStr = request.getParameter("commentId");
                    int commentId = Integer.parseInt(commentIdStr);
                    String materialIdStr = request.getParameter("materialId");
                    int materialId = Integer.parseInt(materialIdStr);
                    String id = request.getParameter("userId");
                    int userId = Integer.parseInt(id);

                    String reportDetail = request.getParameter("reportDetail");

                    if (reportDetail == null || reportDetail.trim().isEmpty() || reportDetail.matches(".*\\s{2,}.*")) {
                        reportDetail = "No Data";
                    }

                    int result = reDao.createReportComment(reportDetail, userId, materialId, commentId, categoryId);

                    if (result == 1) {
                        request.setAttribute("listReportCategory", listReportCate);
                        request.setAttribute("Course", course);
                        request.setAttribute("ModuleList", moduleList);
                        request.setAttribute("Material", currentMaterial);
                        request.setAttribute("MaterialMap", mapOfModuleIdToMaterialList);
                        request.setAttribute("StudyMap", mapOfMaterialIdToStudyStatus);
                        request.setAttribute("CurrentMaterialID", materialID);
                        request.setAttribute("CurrentModuleID", moduleID);
                        request.setAttribute("User", user);
                        request.setAttribute("success", "Report sended successfully!!!");
                        request.getRequestDispatcher("/WEB-INF/views/learnerMaterialView.jsp").forward(request, response);
                    } else {
                        request.setAttribute("listReportCategory", listReportCate);
                        request.setAttribute("Course", course);
                        request.setAttribute("ModuleList", moduleList);
                        request.setAttribute("Material", currentMaterial);
                        request.setAttribute("MaterialMap", mapOfModuleIdToMaterialList);
                        request.setAttribute("StudyMap", mapOfMaterialIdToStudyStatus);
                        request.setAttribute("CurrentMaterialID", materialID);
                        request.setAttribute("CurrentModuleID", moduleID);
                        request.setAttribute("User", user);
                        request.setAttribute("err", "Send failed: Unknown error!");
                        request.getRequestDispatcher("/WEB-INF/views/learnerMaterialView.jsp").forward(request, response);
                    }

                } catch (Exception e) {
                    String errorMsg = "ERROR (LearnerMaterialServlet): Cannot convert attribute into Integer or missing parameter: " + e.getMessage();
                    e.printStackTrace(); // Vẫn in log ra console

                    request.setAttribute("errorMessage", errorMsg);
                    request.setAttribute("stackTrace", getStackTraceAsString(e));

                    request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                }

            }
        } catch (Exception e) {
            String errorMsg = "ERROR (LearnerMaterialServlet): Cannot convert attribute into Integer or missing parameter: " + e.getMessage();
            e.printStackTrace(); // Vẫn in log ra console

            request.setAttribute("errorMessage", errorMsg);
            request.setAttribute("stackTrace", getStackTraceAsString(e));

            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
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
