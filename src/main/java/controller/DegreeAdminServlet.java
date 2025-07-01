package controller;

import dao.DegreeDAO;
import dao.NotificationDAO;
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
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.List;
import model.Degree;
import model.User;

/**
 *
 * @author Hua Khanh Duy - CE180230 - SE1814
 */
@MultipartConfig
@WebServlet(name = "DegreeAdmin", urlPatterns = {"/admin/degree"})
public class DegreeAdminServlet extends HttpServlet {

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
            out.println("<title>Servlet DegreeAdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DegreeAdminServlet at " + request.getContextPath() + "</h1>");
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
        DegreeDAO degreeDAO = new DegreeDAO();
        if (action == null) {
            action = "listDegree";
        }
        if (action.equalsIgnoreCase("listDegree")) {
            List<Degree> listDegree = degreeDAO.getAll();
            request.setAttribute("user", user);
            request.setAttribute("listDegree", listDegree);
            request.getRequestDispatcher("/WEB-INF/views/degreeAdmin.jsp").forward(request, response);
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
        NotificationDAO notiDAO = new NotificationDAO();
        if (action.equalsIgnoreCase("delete")) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idRaw);
                if (degreeDAO.delete(id) == 1) {
                    response.sendRedirect("degree");
                } else {
                    response.sendRedirect("failss.jsp");
                }
            } catch (Exception e) {
                PrintWriter out = response.getWriter();
                out.print(e.getMessage());
            }
        } else if (action.equalsIgnoreCase("approve")) {
            try {
                String statusParam = request.getParameter("status");
                int status = Integer.parseInt(statusParam);
                String degree = request.getParameter("degreeId");
                int degreeId = Integer.parseInt(degree);

                String id = request.getParameter("senderId");
                int userId = Integer.parseInt(id);
                String sender = request.getParameter("sender");
                String type = "toUser";
                String link = request.getParameter("link");
                String accept = "Your degree has been approved.";
                String reject = "Your degree has been rejected.";

                String notiMess = "";
                if (status == 1) {
                    notiMess = accept;
                } else if (status == 2) {
                    notiMess = reject;
                }
                int res = notiDAO.sendNofication(userId, sender, link, notiMess, type);
                boolean r = degreeDAO.approve(status, degreeId);
                if (r == true) {
                    response.sendRedirect("degree");
                } else {
                    response.sendRedirect("failqq.jsp");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("failbc.jsp");
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
