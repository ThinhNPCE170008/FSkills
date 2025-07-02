package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import util.SendEmail;

/**
 * @author NgoThinh1902
 */
@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/verifyemail"})
public class VerifyEmailServlet extends HttpServlet {

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
            out.println("<title>Servlet VerifyEmailServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VerifyEmailServlet at " + request.getContextPath() + "</h1>");
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
        UserDAO userDao = new UserDAO();

        int userId = Integer.parseInt(request.getParameter("userID"));

        String token = UUID.randomUUID().toString();
        Timestamp createdAt = Timestamp.from(Instant.now());
        Timestamp expiresAt = Timestamp.from(Instant.now().plus(5, ChronoUnit.MINUTES));

        User user = userDao.getByUserID(userId);
        String email = user.getEmail();

        userDao.saveTokenVerifyEmail(user.getUserId(), token, createdAt, expiresAt);

        SendEmail se = new SendEmail();
        String title = "FSkills - Verify Email";
        String verifyLink = "http://localhost:8080/FSkills/verifiedemail?token=" + token;
        String message = "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "    <meta charset='UTF-8'>"
                + "    <style>"
                + "        .btn {"
                + "            display: inline-block;"
                + "            padding: 10px 20px;"
                + "            background-color: #0d6efd;"
                + "            color: white;"
                + "            text-decoration: none;"
                + "            border-radius: 5px;"
                + "        }"
                + "        .btn:hover { background-color: #0b5ed7; }"
                + "    </style>"
                + "</head>"
                + "<body>"
                + "    <h2>Verify your FSkills account email</h2>"
                + "    <p>Thank you for signing up! To complete your registration, please verify your email address.</p>"
                + "    <p>Click the button below to verify your email:</p>"
                + "    <p><a style=\"color: #ffffff\" class='btn' href='" + verifyLink + "'>Verify Email</a></p>"
                + "    <p>If you did not sign up for an account, please ignore this email.</p>"
                + "    <p style='margin-top: 20px; font-size: 0.9em;'>This link will expire in 30 minutes for security reasons.</p>"
                + "    <hr/>"
                + "    <p style='font-size: 0.8em;'>FSkills Support Team</p>"
                + "</body>"
                + "</html>";

        boolean isSend = se.sendByEmail(email, message, title);

        if (isSend) {
            request.setAttribute("success", "Sent Successfully: Please check your email.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("err", "Send Failed: Unknown");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
