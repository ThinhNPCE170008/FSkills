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
@WebServlet(name = "Degree", urlPatterns = {"/instructor/profile/degree"})
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
        User user = (User) session.getAttribute("user");
        DegreeDAO degreeDAO = new DegreeDAO();
        if (action == null) {
            action = "listDegree";
        }
        if (action.equalsIgnoreCase("listDegree")) {
            List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
            request.setAttribute("user", user);
            request.setAttribute("listDegree", listDegree);
            request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (action.equalsIgnoreCase("create")) {
            try {
                String id = request.getParameter("userId");
                int userId = Integer.parseInt(id);
                String degreeLink = request.getParameter("degreeLink");

                if (degreeLink == null || degreeLink.trim().isEmpty() || degreeLink.matches(".*\\s{2,}.*")) {
                    request.setAttribute("err", "Degree link must not be empty and must not contain spaces.");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                    return;
                }

                if (!degreeLink.startsWith("http://") && !degreeLink.startsWith("https://")) {
                    request.setAttribute("err", "Degree must start with http:// or https:// !!");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);

                    return;
                }

                // Nhận file
                Part filePart = request.getPart("degreeImage");
                InputStream imageInputStream = null;
                if (filePart != null && filePart.getSize() > 0) {
                    imageInputStream = filePart.getInputStream();  // Lấy dữ liệu nhị phân
                }
                int res = degreeDAO.insert(userId, imageInputStream, degreeLink);

                if (res == 1) {
                    request.setAttribute("success", "Degree submitted successfully!");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                } else {
                    request.setAttribute("err", "<p>Create failed!</p>");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("err", "<p>Error submit!!!</p>");
                List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                request.setAttribute("listDegree", listDegree);
                request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                return;
            }
        } else if (action.equalsIgnoreCase("delete")) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idRaw);
                if (degreeDAO.delete(id) == 1) {
                    request.setAttribute("success", "Degree deleted successfully!");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                } else {
                    request.setAttribute("err", "Failed to delete degree!");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("err", "Error failed to delete degree!");
                List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                request.setAttribute("listDegree", listDegree);
                request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                return;
            }
        } else if (action.equalsIgnoreCase("edit")) {
            try {
                String degreeLink = request.getParameter("degreeLink");
                if (degreeLink == null || degreeLink.trim().isEmpty() || degreeLink.matches(".*\\s{2,}.*")) {
                    request.setAttribute("err", "Degree link must not be empty and must not contain spaces.");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                    return;
                }

                if (!degreeLink.startsWith("http://") && !degreeLink.startsWith("https://")) {
                    request.setAttribute("err", "Degree must start with http:// or https:// !!");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                    return;
                }
                String degreeId = request.getParameter("degreeId");

                String keepOldImage = request.getParameter("keepOldImage"); // "true" hoặc "false"
                Part filePart = request.getPart("degreeImage");

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

                boolean res = degreeDAO.update(imageInputStream, degreeLink, degreeId, updateImage);

                if (res) {
                    request.setAttribute("success", "Degree edited successfully!");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);

                } else {
                    request.setAttribute("err", "Failed to edit degree!");
                    List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                    request.setAttribute("listDegree", listDegree);
                    request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("err", "Error failed to delete degree!");
                List<Degree> listDegree = (List<Degree>) degreeDAO.getDegreeById(user.getUserId());
                request.setAttribute("listDegree", listDegree);
                request.getRequestDispatcher("/WEB-INF/views/degree.jsp").forward(request, response);
                return;
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
