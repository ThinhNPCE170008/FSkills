/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import model.User;
import util.SendEmail;

/**
 *
 * @author NgoThinh1902
 */
@WebServlet(name = "ForgotPassword", urlPatterns = {"/forgotpassword"})
public class ForgotPassword extends HttpServlet {

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
            out.println("<title>Servlet ForgotPassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotPassword at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String email = request.getParameter("forgotEmail");
            String contextPath = request.getContextPath();

            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("err", "Email cannot be empty.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            email = email.trim().toLowerCase();

            String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
            if (!email.matches(emailRegex)) {
                request.setAttribute("err", "Email is not in correct format.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            String[] parts = email.split("@");
            if (parts.length != 2) {
                request.setAttribute("err", "Invalid email.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            String domain = parts[1];
            Set<String> acceptedDomains = Set.of("gmail.com", "email.com");
            List<String> acceptedTLDs = List.of(".vn", ".io", ".me");

            boolean isValid = false;

            if (acceptedDomains.contains(domain)) {
                isValid = true;
            }

            for (String tld : acceptedTLDs) {
                if (domain.endsWith(tld)) {
                    isValid = true;
                    break;
                }
            }

            if ((domain.startsWith("gmail.") && !domain.equals("gmail.com"))
                    || (domain.startsWith("email.") && !domain.equals("email.com"))) {
                isValid = false;
            }

            if (!isValid) {
                request.setAttribute("err", "Emails from non-domains are accepted.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            UserDAO userDao = new UserDAO();
            User user = null;
            user = userDao.findByEmail(email);

            if (user == null) {
                request.setAttribute("success", "If your email exists in our system, a reset link has been sent.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            String token = UUID.randomUUID().toString();
            Timestamp createdAt = Timestamp.from(Instant.now());
            Timestamp expiresAt = Timestamp.from(Instant.now().plus(30, ChronoUnit.MINUTES));

            userDao.saveTokenForgotPassword(user.getUserId(), token, createdAt, expiresAt);

            SendEmail se = new SendEmail();
            String title = "FSkills - Reset Your Password";
            String resetLink = "http://localhost:8080/FSkills/changepassword?token=" + token;
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
                    + "    <h2>Reset your FSkills account password</h2>"
                    + "    <p>We received a request to reset the password for your account associated with this email.</p>"
                    + "    <p>Click the button below to reset your password:</p>"
                    + "    <p><a class='btn' href='" + resetLink + "'>Reset Password</a></p>"
                    + "    <p>If you didn’t request this, just ignore this email.</p>"
                    + "    <p style='margin-top: 20px; font-size: 0.9em;'>This link will expire in 30 minutes for security reasons.</p>"
                    + "    <hr/>"
                    + "    <p style='font-size: 0.8em;'>FSkills Support Team</p>"
                    + "</body>"
                    + "</html>";

            boolean isSend = se.sendChangePassByEmail(email, message, title);

            if (isSend) {
                request.setAttribute("success", "Sent Successfully: Please check your email.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("err", "Send Failed: Unknown");
                request.getRequestDispatcher("login.jsp").forward(request, response);
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
