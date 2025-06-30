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
import java.io.InputStream;
import java.util.List;
import model.Announcement;
import model.User;

/**
 *
 * @author Hua Khanh Duy - CE180230 - SE1814
 */
@MultipartConfig
@WebServlet(name = "Announcement", urlPatterns = {"/admin/announcement"})
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
        User user = (User) session.getAttribute("user");
        AnnouncementDAO announcementDAO = new AnnouncementDAO();

        if (action == null) {
            action = "listAnnouncement";
        }
        if (action.equalsIgnoreCase("listAnnouncement")) {
            List<Announcement> listAnnouncement = announcementDAO.getAll();
            request.setAttribute("AccountInfo", user);
            request.setAttribute("listAnnouncement", listAnnouncement);
            request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
        } else if (action.equalsIgnoreCase("details")) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idRaw);
                Announcement ann = announcementDAO.getAnnouncementById(id);
                request.setAttribute("dataAnn", ann);
                request.getRequestDispatcher("/WEB-INF/views/announcementDetails.jsp").forward(request, response);
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
            if (announcementTitle.trim() == null || announcementTitle.trim().isEmpty() || announcementTitle.matches(".*\\s{2,}.*")) {
                List<Announcement> listAnnouncement = AnnounDAO.getAll();
                request.setAttribute("listAnnouncement", listAnnouncement);
                request.setAttribute("err", "Title must not contain consecutive spaces!");
                request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                return;
            }

            if (announcementTitle.length() > 255) {
                List<Announcement> listAnnouncement = AnnounDAO.getAll();
                request.setAttribute("listAnnouncement", listAnnouncement);
                request.setAttribute("err", "Title cannot exceed 255 letters.");
                request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                return;
            }

            String announcementText = request.getParameter("announcementText");

            if (announcementText == null || announcementText.trim().isEmpty() || announcementText.contains("  ") || announcementText.matches(".*\\s{2,}.*")) {
                List<Announcement> listAnnouncement = AnnounDAO.getAll();
                request.setAttribute("listAnnouncement", listAnnouncement);
                request.setAttribute("err", "Content must not be empty or contain consecutive spaces!");
                request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                return;
            }

            String takeDownDate = request.getParameter("takeDownDate");
            // Nhận file
            Part filePart = request.getPart("announcementImage");
            InputStream imageInputStream = null;
            if (filePart != null && filePart.getSize() > 0) {
                imageInputStream = filePart.getInputStream();  // Lấy dữ liệu nhị phân
            }
            try {
                int UserID = Integer.parseInt(UserIDStr);
                int res = AnnounDAO.insert(announcementTitle, announcementText, takeDownDate, imageInputStream, UserID);

                if (res == 1) {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("success", "Announcement created successfully!!!");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                } else {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("err", "Create failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                }
            } catch (Exception e) {
                List<Announcement> listAnnouncement = AnnounDAO.getAll();
                request.setAttribute("listAnnouncement", listAnnouncement);
                request.setAttribute("err", "<p>Create failed!</p>");
                request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
            }
        } else if (action.equalsIgnoreCase("edit")) {
            try {
                String announcementId = request.getParameter("announcementId");
                String announcementTitle = request.getParameter("announcementTitle");

                if (announcementTitle.trim() == null || announcementTitle.trim().isEmpty()|| announcementTitle.matches(".*\\s{2,}.*")) {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("err", "Title must not contain consecutive spaces.");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                    return;
                }

                if (announcementTitle.length() > 255) {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("err", "Title cannot exceed 255 letters.");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                    return;
                }
                String announcementText = request.getParameter("announcementText");

                if (announcementText == null || announcementText.trim().isEmpty() || announcementText.contains("  ") || announcementText.matches(".*\\s{2,}.*")) {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("err", "Content must not be empty or contain consecutive spaces!");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                    return;
                }

                String rawDate = request.getParameter("takeDownDate");
                String formattedDate = rawDate != null ? rawDate.replace("T", " ") + ":00" : null;
                String keepOldImage = request.getParameter("keepOldImage"); // "true" hoặc "false"
                Part filePart = request.getPart("announcementImage");

                InputStream imageInputStream = null;
                boolean updateImage = false;

                if (filePart != null && filePart.getSize() > 0) {
                    // Có ảnh mới được upload
                    imageInputStream = filePart.getInputStream();
                    updateImage = true;
                } else if ("false".equalsIgnoreCase(keepOldImage)) {
                    // Người dùng xóa ảnh cũ
                    updateImage = true;
                    imageInputStream = null;
                } else {
                    // Người dùng giữ ảnh cũ, không update ảnh
                    updateImage = false;
                    imageInputStream = null;
                }

                boolean res = AnnounDAO.update(announcementTitle, announcementText, formattedDate, imageInputStream, announcementId, updateImage);

                if (res) {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("success", "Announcement edited successfully!!!");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                } else {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("err", "Edit failed: Unknown error!");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                }
            } catch (Exception e) {
                List<Announcement> listAnnouncement = AnnounDAO.getAll();
                request.setAttribute("listAnnouncement", listAnnouncement);
                request.setAttribute("err", "Create failed!");
                request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
            }
        } else if (action.equalsIgnoreCase("delete")) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idRaw);
                if (AnnounDAO.delete(id) == 1) {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("success", "Announcement deleted successfully!!!");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                } else {
                    List<Announcement> listAnnouncement = AnnounDAO.getAll();
                    request.setAttribute("listAnnouncement", listAnnouncement);
                    request.setAttribute("err", "Delete failed!");
                    request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
                }
            } catch (Exception e) {
                List<Announcement> listAnnouncement = AnnounDAO.getAll();
                request.setAttribute("listAnnouncement", listAnnouncement);
                request.setAttribute("err", "Delete failed!");
                request.getRequestDispatcher("/WEB-INF/views/announcement.jsp").forward(request, response);
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
