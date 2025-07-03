/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CourseDAO;
import dao.EnrollDAO;
import dao.MaterialDAO;
import dao.ModuleDAO;
import dao.StudyDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import model.Course;
import model.Module;
import model.Material;
import model.User;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
@WebServlet(name = "LearnerViewCourseContent", urlPatterns = {"/learner/course"})
public class LearnerViewCourseContentServlet extends HttpServlet {

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
            out.println("<title>Servlet LearnerViewCourseContent</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LearnerViewCourseContent at " + request.getContextPath() + "</h1>");
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
        User user = (User) session.getAttribute("user");
        EnrollDAO eDAO = new EnrollDAO();
        StudyDAO sDAO = new StudyDAO();
        CourseDAO couDAO = new CourseDAO();
        ModuleDAO molDAO = new ModuleDAO();
        MaterialDAO matDAO = new MaterialDAO();
        List<Module> molList;
        List<Material> matList;
        HashMap<Integer, List<Material>> mapOfModuleIdToMaterialList = new HashMap<>();
        HashMap<Integer, Boolean> mapOfMaterialIdToStudyStatus = new HashMap<>();
        HashMap<Integer, Boolean> mapOfModuleIdToTotalStudiedCount = new HashMap<>();
        Course cou;
        int progress;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            String courseParam = request.getParameter("courseID");
            try {
                int courseID = Integer.parseInt(courseParam);
                if (eDAO.checkEnrollment(user.getUserId(), courseID)) {
                    progress = sDAO.returnStudyProgress(user.getUserId(), courseID);
                    cou = couDAO.getCourseByCourseID(courseID);
                    molList = molDAO.getAllModuleByCourseID(courseID);
                    for (Module mol : molList){
                        matList = matDAO.getAllMaterial(courseID, mol.getModuleID());
                        mapOfModuleIdToMaterialList.put(mol.getModuleID(), matList);
                        mapOfModuleIdToTotalStudiedCount.put(mol.getModuleID(), sDAO.returnTotalStudy(user.getUserId(), mol.getModuleID(), matList.size()));
                        for (Material mat : matList){
                            mapOfMaterialIdToStudyStatus.put(mat.getMaterialId(), sDAO.checkStudy(user.getUserId(), mat.getMaterialId()));
                        }
                    }
                    request.setAttribute("Course", cou);
                    request.setAttribute("ModuleList", molDAO.getAllModuleByCourseID(courseID));
                    request.setAttribute("User", user);
                    request.setAttribute("progress", progress);
                    request.setAttribute("matMap", mapOfModuleIdToMaterialList); // key: moduleID, value: List<Material>
                    request.setAttribute("studyMap", mapOfMaterialIdToStudyStatus); // key: materialID, value: boolean
                    request.setAttribute("totalStudyMap", mapOfModuleIdToTotalStudiedCount); // key: moduleID, value: boolean
                    request.getRequestDispatcher("/WEB-INF/views/learnerCourseContentView.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/courseDetail?id=" + courseID);
                }
            } catch (Exception E) {
                System.out.println("Can't convert attribute into Interger");
            }
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
