/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DegreeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import model.Degree;
import model.User;

/**
 *
 * @author Hua Khanh Duy - CE180230 - SE1814
 */
@MultipartConfig
@WebServlet(name = "Degree", urlPatterns = {"/Degree"})
public class DegreeServlet extends HttpServlet {

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
            out.println("<title>Servlet DegreeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DegreeServlet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        User user= (User) session.getAttribute("user");
        DegreeDAO degreeDAO = new DegreeDAO();
        if (action == null) {
            action = "listDegree";
        }
        if (action.equalsIgnoreCase("listDegree")) {
            List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
            request.setAttribute("user", user);
            request.setAttribute("listDegree", listDegree);
            request.getRequestDispatcher("WEB-INF/views/degree.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        DegreeDAO degreeDAO = new DegreeDAO();
        if (action.equalsIgnoreCase("create")) {
            try {
                String id = request.getParameter("userId");
                int userId = Integer.parseInt(id);
                String degreeLink = request.getParameter("degreeLink");
                // Nhận file
                Part filePart = request.getPart("degreeImage");
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String imagePath;
                if (fileName == null || fileName.isEmpty()) {
                    imagePath = "No Image";
                } else {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "imageUpload";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                    imagePath = "imageUpload/" + fileName;
                }
                int res = degreeDAO.insert(userId, imagePath, degreeLink);

                if (res == 1) {
                    response.sendRedirect("Degree");
                } else {
                    request.setAttribute("err", "<p>Create failed</p>");
                    request.getRequestDispatcher("fail1.jsp").forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace(); // In lỗi chi tiết ra console
                request.setAttribute("err", "<p>Create failed</p>");
                request.getRequestDispatcher("fail2.jsp").forward(request, response);
            }
        } else if (action.equalsIgnoreCase("delete")) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idRaw);
                if (degreeDAO.delete(id) == 1) {
                    response.sendRedirect("Degree");
                } else {
                    response.sendRedirect("failss.jsp");
                }
            } catch (Exception e) {
                PrintWriter out = response.getWriter();
                out.print(e.getMessage());
            }
        } else if (action.equalsIgnoreCase("edit")) {
            try {
                String degreeLink = request.getParameter("degreeLink");
                Part filePart = request.getPart("degreeImage");
                String degreeId = request.getParameter("degreeId");
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String imagePath;

                if (fileName != null && !fileName.isEmpty()) {
                    // New image uploaded
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "imageUpload";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                    imagePath = "imageUpload/" + fileName;
                } else {
                    // Use old image path
                    imagePath = request.getParameter("oldImagePath");
                }

                boolean res = degreeDAO.update(imagePath, degreeLink, degreeId);

                if (res) {
                    response.sendRedirect("Degree");
                } else {
                    response.sendRedirect("failqq.jsp");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("failbb.jsp");
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
