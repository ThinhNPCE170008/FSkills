package controller;

import dao.CommentDAO;
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
import java.util.HashMap;
import java.util.List;
import model.Comment;
import model.Course;
import model.Material;
import model.Module;
import model.User;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
@WebServlet(name = "LearnerMaterialServlet", urlPatterns = {"/learner/course/module/material"})
public class LearnerMaterialServlet extends HttpServlet {

    private final CommentDAO commentDAO = new CommentDAO();
    private final CourseDAO couDAO = new CourseDAO();
    private final EnrollDAO eDAO = new EnrollDAO();
    private final ModuleDAO molDAO = new ModuleDAO();
    private final MaterialDAO matDAO = new MaterialDAO();
    private final StudyDAO stuDAO = new StudyDAO();

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
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LearnerMaterialServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LearnerMaterialServlet at " + request.getContextPath() + "</h1>");
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

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Course course;
        Material currentMaterial;
        List<Module> moduleList;
        HashMap<Integer, List<Material>> mapOfModuleIdToMaterialList = new HashMap<>();
        HashMap<Integer, Boolean> mapOfMaterialIdToStudyStatus = new HashMap<>();
        
        String courseParam = request.getParameter("courseID");
        String moduleParam = request.getParameter("moduleID");
        String materialParam = request.getParameter("materialID");

        try {
            int courseID = Integer.parseInt(courseParam);
            int moduleID = Integer.parseInt(moduleParam);
            int materialID = Integer.parseInt(materialParam);

            if (!eDAO.checkEnrollment(user.getUserId(), courseID)) {
                response.sendRedirect(request.getContextPath() + "/courseDetail?courseID=" + courseID + "&message=not_enrolled");
                return; 
            }

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
            
            for (Module mol : moduleList) {
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

            request.setAttribute("Course", course);
            request.setAttribute("ModuleList", moduleList);
            request.setAttribute("Material", currentMaterial);
            request.setAttribute("MaterialMap", mapOfModuleIdToMaterialList);
            request.setAttribute("StudyMap", mapOfMaterialIdToStudyStatus);
            request.setAttribute("CurrentMaterialID", materialID);
            request.setAttribute("CurrentModuleID", moduleID);
            request.setAttribute("User", user); 
            request.getRequestDispatcher("/WEB-INF/views/learnerMaterialView.jsp").forward(request, response);

        } catch (NumberFormatException E) {
            System.out.println("ERROR (LearnerMaterialServlet): Cannot convert attribute into Integer or missing parameter: " + E.getMessage());
            E.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/errorPage.jsp"); 
        } catch (Exception E) {
            System.out.println("ERROR (LearnerMaterialServlet): An unexpected error occurred: " + E.getMessage());
            E.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/errorPage.jsp");
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("completeMaterial");
        int matID;
        int molID;
        int couID;

        if (action != null && action.equals("complete")) { 
            try {
                matID = Integer.parseInt(request.getParameter("materialID"));
                molID = Integer.parseInt(request.getParameter("moduleID"));
                couID = Integer.parseInt(request.getParameter("courseID"));                              
                if (stuDAO.addLearnerStudyCompletion(user.getUserId(), matID) != 0) {
                    response.sendRedirect(request.getContextPath() + "/learner/course/module/material?courseID=" + couID + "&moduleID=" + molID + "&materialID=" + matID);
                } else {
                    System.out.println("DEBUG (LearnerMaterialServlet): Failed to add study completion for material " + matID + " by user " + user.getUserId());
                    response.sendRedirect(request.getContextPath() + "/learner/course/module/material?courseID=" + couID + "&moduleID=" + molID + "&materialID=" + matID + "&status=failed");
                }
            } catch (NumberFormatException E) {
                System.out.println("ERROR (LearnerMaterialServlet): Can't convert parameter into Integer for POST: " + E.getMessage());
                E.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/errorPage.jsp");
            } catch (Exception E) {
                System.out.println("ERROR (LearnerMaterialServlet): An unexpected error occurred in POST: " + E.getMessage());
                E.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/errorPage.jsp");
            }
        } else {
            String currentCourseID = request.getParameter("courseID");
            String currentModuleID = request.getParameter("moduleID");
            String currentMaterialID = request.getParameter("materialID");
            String redirectBackUrl = request.getContextPath() + "/learner/course/module/material"
                                    + "?courseID=" + (currentCourseID != null ? currentCourseID : "")
                                    + "&moduleID=" + (currentModuleID != null ? currentModuleID : "")
                                    + "&materialID=" + (currentMaterialID != null ? currentMaterialID : "");
            response.sendRedirect(redirectBackUrl);
        }
    }


    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Learner Material Servlet handles displaying material content and related functionalities.";
    }// </editor-fold>

}