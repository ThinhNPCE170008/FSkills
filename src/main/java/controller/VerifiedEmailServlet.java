package controller;

import java.io.IOException;
import java.io.PrintWriter;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.PasswordResetToken;
import model.VerifyEmailToken;

/**
 *
 * @author NgoThinh1902
 */
@WebServlet(name = "VerifiedEmailServlet", urlPatterns = {"/verifiedemail"})
public class VerifiedEmailServlet extends HttpServlet {

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
            out.println("<title>Servlet VerifiedEmailServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VerifiedEmailServlet at " + request.getContextPath() + "</h1>");
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
        String token = request.getParameter("token");

        UserDAO userDao = new UserDAO();
        VerifyEmailToken verifyToken = userDao.findValidTokenVerifyEmail(token);

        if (verifyToken == null) {
            request.setAttribute("err", "Email authentication failed.");
            request.getRequestDispatcher("/WEB-INF/views/verifiedEmail.jsp").forward(request, response);
            return;
        }

        int update = userDao.updateIsVerified(verifyToken.getUserId());

        if (update > 0) {
            userDao.deleteTokenVerifyEmail(verifyToken.getUserId());

            request.setAttribute("success", "Email authentication successful.");
            request.getRequestDispatcher("/WEB-INF/views/verifiedEmail.jsp").forward(request, response);
        } else {
            request.setAttribute("err", "Email authentication failed.");
            request.getRequestDispatcher("/WEB-INF/views/verifiedEmail.jsp").forward(request, response);
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
        processRequest(request, response);
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
