package controller;

import dao.CourseDAO;
import dao.NotificationDAO;
import dao.UserDAO;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;
import java.util.regex.Pattern;

import model.Course;
import model.Notification;
import model.Role;
import model.User;

/**
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
@WebServlet(name = "InstructorDashboardServlet", urlPatterns = {"/instructor"})
public class InstructorDashboardServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet InstructorDashboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InstructorDashboardServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contextPath = request.getContextPath(); // Context Root (FSkills)
        HttpSession session = request.getSession();

        NotificationDAO notiDAO = new NotificationDAO();
        UserDAO udao = new UserDAO();
        CourseDAO cdao = new CourseDAO();

        User acc = (User) session.getAttribute("user");
        if (acc == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        if (acc.getRole() != Role.INSTRUCTOR) {
            response.sendRedirect(contextPath + "/homePage_Guest.jsp");
            return;
        }

        int totalCourses = cdao.countCoursesByUserID(acc.getUserId());
        int totalLearners = cdao.countLearnersByUserID(acc.getUserId());
        double totalRating = cdao.getAverageRatingByUserID(acc.getUserId());

        List<Course> listLittle = cdao.get3CourseByUserID(acc.getUserId());

        request.setAttribute("listLittle", listLittle);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("totalLearners", totalLearners);
        request.setAttribute("totalRating", totalRating);
        request.getRequestDispatcher("/Notification").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
