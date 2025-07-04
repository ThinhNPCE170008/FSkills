///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller;
//
//import dao.CourseDAO;
//import dao.EnrollDAO;
//import dao.MaterialDAO;
//import dao.ModuleDAO;
//import dao.StudyDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.util.HashMap;
//import java.util.List;
//import model.Course;
//import model.Material;
//import model.Module;
//import model.User;
//
///**
// *
// * @author CE191059 Phuong Gia Lac
// */
//@WebServlet(name = "LearnerMaterialServlet", urlPatterns = {"/learner/course/module/material"})
//public class LearnerMaterialServlet extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try ( PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet LearnerMaterialServlet</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet LearnerMaterialServlet at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        User user = (User) session.getAttribute("user");
//        if (user == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//        } else {
//            EnrollDAO eDAO = new EnrollDAO();
//            ModuleDAO molDAO = new ModuleDAO();
//            CourseDAO couDAO = new CourseDAO();
//            MaterialDAO matDAO = new MaterialDAO();
//            StudyDAO stuDAO = new StudyDAO();
//            Course course;
//            Material currentMaterial;
//            List<Module> moduleList;
//            String courseParam = request.getParameter("courseID");
//            String moduleParam = request.getParameter("moduleID");
//            String materialParam = request.getParameter("materialID");
//            String materialURL;
//            HashMap<Integer, List<Material>> mapOfModuleIdToMaterialList = new HashMap<>();
//            HashMap<Integer, Boolean> mapOfMaterialIdToStudyStatus = new HashMap<>();
//            List<Material> matList;
//            try {
//                int courseID = Integer.parseInt(courseParam);
//                int moduleID = Integer.parseInt(moduleParam);
//                int materialID = Integer.parseInt(materialParam);
//                if (eDAO.checkEnrollment(user.getUserId(), courseID)) {
//                    course = couDAO.getCourseByCourseID(courseID);
//                    moduleList = molDAO.getAllModuleByCourseID(courseID);
//                    currentMaterial = matDAO.getMaterialById(materialID);
//                    materialURL = currentMaterial.getMaterialLocation();
//                    for (Module mol : moduleList){
//                        matList = matDAO.getAllMaterial(courseID, mol.getModuleID());
//                        mapOfModuleIdToMaterialList.put(mol.getModuleID(), matList);
//                        for (Material mat : matList){
//                            mapOfMaterialIdToStudyStatus.put(mat.getMaterialId(), stuDAO.checkStudy(user.getUserId(), mat.getMaterialId()));
//                        }
//                    }
//                    request.setAttribute("Course", course);
//                    request.setAttribute("ModuleList", moduleList);
//                    request.setAttribute("Material", currentMaterial);
//                    request.setAttribute("MaterialPath", materialURL); // computed URL for iframe or download
//                    request.setAttribute("MaterialMap", mapOfModuleIdToMaterialList); // Map<Integer, List<Material>>
//                    request.setAttribute("StudyMap", mapOfMaterialIdToStudyStatus); // Map<Integer, Boolean>
//                    request.setAttribute("CurrentMaterialID", materialID);
//                    request.setAttribute("CurrentModuleID", moduleID);
//                    request.setAttribute("User", user);
//                    request.getRequestDispatcher("/WEB-INF/views/learnerMaterialView.jsp").forward(request, response);
//                }
//            } catch (Exception E) {
//                System.out.println("Can't convert attribute into Interger");
//            }
//        }
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        User user = (User) session.getAttribute("user");
//        String action = request.getParameter("completeMaterial");
//        StudyDAO stuDAO = new StudyDAO();
//        int matID;
//        int molID;
//        int couID;
//        if (action != null) {
//            try {
//                matID = Integer.parseInt(request.getParameter("materialID"));
//                molID = Integer.parseInt(request.getParameter("moduleID"));
//                couID = Integer.parseInt(request.getParameter("courseID"));
//                if (stuDAO.addLearnerStudyCompletion(user.getUserId(), matID) != 0) {
//                    response.sendRedirect(request.getContextPath() + "/learner/course/module/material?courseID=" + couID + "&moduleID=" + molID + "&materialID=" + matID);
//                }
//            } catch (Exception E) {
//                System.out.println("Can't convert parameter into Integer");
//            }
//        }
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
