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
import java.util.List;
import model.Announcement;
import model.User;

/**
 *
 * @author Hua Khanh Duy - CE180230 - SE1814
 */
@MultipartConfig
@WebServlet(name = "AnnouncementDetails", urlPatterns = {"/Announcement"})
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
        User user= (User) session.getAttribute("user");
        AnnouncementDAO announcementDAO = new AnnouncementDAO();

        if (action == null) {
            action = "listAnnouncement";
        }
        if (action.equalsIgnoreCase("listAnnouncement")) {
            List<Announcement> listAnnouncement = announcementDAO.getAll();
            request.setAttribute("AccountInfo", user);
            request.setAttribute("listAnnouncement", listAnnouncement);
            request.getRequestDispatcher("WEB-INF/views/announcement.jsp").forward(request, response);
        } else if (action.equalsIgnoreCase("details")) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idRaw);
                Announcement ann = announcementDAO.getAnnouncementById(id);
                request.setAttribute("dataAnn", ann);
                request.getRequestDispatcher("WEB-INF/views/announcementDetails.jsp").forward(request, response);
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
            String UserIDStr = request.getParameter("userId");
            String announcementTitle = request.getParameter("announcementTitle");
            String announcementText = request.getParameter("announcementText");
            String takeDownDate = request.getParameter("takeDownDate");
            // Nhận file
            Part filePart = request.getPart("announcementImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String imagePath;
            if (fileName == null || fileName.isEmpty()) {
                // Gán chuỗi mặc định
                imagePath = "No Image";
                // Lưu vào DB hoặc dùng xử lý tiếp theo
            } else {
                // Lưu file vào thư mục trên server
                String uploadPath = getServletContext().getRealPath("") + File.separator + "imageUpload";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                filePart.write(uploadPath + File.separator + fileName);

                // Lưu tên file hoặc đường dẫn vào DB nếu cần
                imagePath = "imageUpload/" + fileName;
            }

            try {
                int UserID = Integer.parseInt(UserIDStr);
                int res = AnnounDAO.insert(announcementTitle, announcementText, takeDownDate, imagePath, UserID);

                if (res == 1) {
                    response.sendRedirect("Announcement");
                } else {
                    request.setAttribute("err", "<p>Create failed</p>");
                    request.getRequestDispatcher("fail12.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("err", "<p>Create failed</p>");
                request.getRequestDispatcher("fail23.jsp").forward(request, response);
            }
        } else if (action.equalsIgnoreCase("edit")) {
            try {
                String announcementId = request.getParameter("announcementId");
                String announcementTitle = request.getParameter("announcementTitle");
                String announcementText = request.getParameter("announcementText");
                String rawDate = request.getParameter("takeDownDate");
                String formattedDate = rawDate != null ? rawDate.replace("T", " ") + ":00" : null;

                Part filePart = request.getPart("announcementImage");
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

                boolean res = AnnounDAO.update(announcementTitle, announcementText, formattedDate, imagePath, announcementId);

                if (res) {
                    response.sendRedirect("Announcement");
                } else {
                    response.sendRedirect("failqq.jsp");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("failbb.jsp");
            }
        } else if (action.equalsIgnoreCase("delete")) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idRaw);
                if (AnnounDAO.delete(id) == 1) {
                    response.sendRedirect("Announcement");
                } else {
                    response.sendRedirect("failss.jsp");
                }
            } catch (Exception e) {
                PrintWriter out = response.getWriter();
                out.print(e.getMessage());
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
