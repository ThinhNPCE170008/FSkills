/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AnnouncementDAO;
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
import java.sql.Timestamp;
import java.util.List;
import model.Announcement;
import model.User;

/**
 *
 * @author Hua Khanh Duy - CE180230 - SE1814
 */
@MultipartConfig
@WebServlet(name = "Announcement", urlPatterns = {"/Announcement"})
public class AnnouncementServlet extends HttpServlet {

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
            out.println("<title>Servlet AnnouncementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AnnouncementServlet at " + request.getContextPath() + "</h1>");
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
        List<User> acc = (List<User>) request.getAttribute("Acc");
        AnnouncementDAO announcementDAO = new AnnouncementDAO();

        if (action == null) {
            action = "listAnnouncement";
        }
        if (action.equalsIgnoreCase("listAnnouncement")) {
            List<Announcement> listAnnouncement = announcementDAO.getAll();
            request.setAttribute("AccountInfo", acc);
            request.setAttribute("listAnnouncement", listAnnouncement);
            request.getRequestDispatcher("announcement.jsp").forward(request, response);
        }else if (action.equalsIgnoreCase("update")) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idRaw);
                Announcement ann  = announcementDAO.getAnnouncementById(id);
                request.setAttribute("dataAnn", ann);
                request.getRequestDispatcher("update-product.jsp").forward(request, response);
            } catch (Exception e) {
                PrintWriter out = response.getWriter();
                out.print(e.getMessage());
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
        String action = request.getParameter("action");
        AnnouncementDAO AnnounDAO = new AnnouncementDAO();
        if (action.equalsIgnoreCase("create")) {
            String announcementTitle = request.getParameter("announcementTitle");
            String announcementText = request.getParameter("announcementText");
            String takeDownDate = request.getParameter("takeDownDate");
            String UserIDStr = "1";

            // Lấy ngày hiện tại (trong Java)
            String CreateAt = java.time.LocalDateTime.now().toString(); // hoặc format lại nếu cần

            // Nếu bạn upload ảnh (file input), bạn phải dùng request.getPart
            Part filePart = request.getPart("announcementImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Lưu file ảnh nếu cần (ví dụ lưu trong thư mục server)
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            filePart.write(uploadPath + File.separator + fileName);

            try {
                int UserID = Integer.parseInt(UserIDStr);
                int res = AnnounDAO.insert(announcementTitle, announcementText, CreateAt, takeDownDate, fileName, UserID);

                if (res == 1) {
                    response.sendRedirect("Announcement");
                } else {
                    request.setAttribute("err", "<p>Create failed</p>");
                    request.getRequestDispatcher("fail.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("err", "<p>Create failed</p>");
                request.getRequestDispatcher("create-product.jsp").forward(request, response);
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
