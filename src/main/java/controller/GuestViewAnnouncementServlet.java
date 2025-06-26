/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AnnouncementDAO;
import model.Announcement;
import java.io.IOException;
// import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GuestViewAnnouncementServlet", urlPatterns = {"/guest/announcements", "/guest/announcement-detail"})
public class GuestViewAnnouncementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        try {
            AnnouncementDAO annDAO = new AnnouncementDAO();

            if ("/guest/announcements".equals(path)) {
                List<Announcement> announcements;
                String searchQuery = request.getParameter("search");

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    announcements = annDAO.searchAnnouncements(searchQuery.trim());
                } else {
                    announcements = annDAO.getAll();
                }

                request.setAttribute("announcements", announcements);
                request.getRequestDispatcher("/globalAnn.jsp").forward(request, response);
            } else if ("/guest/announcement-detail".equals(path)) {
                // Xử lý hiển thị chi tiết thông báo
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    try {
                        int announcementId = Integer.parseInt(idParam);
                        Announcement announcement = annDAO.getAnnouncementById(announcementId);
                        if (announcement != null) {
                            request.setAttribute("announcement", announcement);
                            request.getRequestDispatcher("/globalAnnDetail.jsp").forward(request, response);
                        } else {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Announcement not found.");
                        }
                    } catch (NumberFormatException e) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid announcement ID format.");
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Announcement ID is required.");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found.");
            }

        } catch (Exception e) {
            e.printStackTrace(); 
            throw new ServletException("An application error occurred while processing announcement requests.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for displaying guest announcements.";
    }
}