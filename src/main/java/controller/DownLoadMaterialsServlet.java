/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.MaterialDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Material;

/**
 *
 * @author Hua Khanh Duy - CE180230 - SE1814
 */
@WebServlet(name = "DownLoadMaterials", urlPatterns = {"/downloadmaterial"})
public class DownLoadMaterialsServlet extends HttpServlet {

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
            out.println("<title>Servlet DownLoadMaterialsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DownLoadMaterialsServlet at " + request.getContextPath() + "</h1>");
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
        MaterialDAO materialDAO = new MaterialDAO();
        int materialId = Integer.parseInt(request.getParameter("id"));
        Material material = materialDAO.getMaterialById(materialId);

        if (material == null || material.getMaterialFile() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

// ✅ Dùng tên gốc đã lưu khi upload
        String fileName = material.getFileName(); // ví dụ: "Unit1-Intro.pdf"

// Xác định MIME type (tự động hoặc theo phần mở rộng)
        String mimeType = getServletContext().getMimeType(fileName);
        if (mimeType == null) {
            mimeType = "application/octet-stream"; // fallback
        }
        response.setContentType(mimeType);

// ✅ Cho phép hiển thị trực tiếp trong trình duyệt (hoặc tải xuống nếu muốn)
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");

// Ghi nội dung file ra output stream
        response.setContentLength(material.getMaterialFile().length);
        ServletOutputStream out = response.getOutputStream();
        out.write(material.getMaterialFile());
        out.flush();
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
        protected void doPost
        (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            processRequest(request, response);
        }

        /**
         * Returns a short description of the servlet.
         *
         * @return a String containing servlet description
         */
        @Override
        public String getServletInfo
        
            () {
        return "Short description";
        }// </editor-fold>

    }
