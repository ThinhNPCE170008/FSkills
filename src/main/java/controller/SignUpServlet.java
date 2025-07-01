package controller;

import java.io.IOException;
import java.io.PrintWriter;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.MyLibrary;

/**
 *
 * @author NgoThinh1902
 */
@WebServlet(name="SignUpServlet", urlPatterns={"/signup"})
public class SignUpServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SignUpServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SignUpServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();

        UserDAO userDAO = new UserDAO();
        User newUser = null;

        if(request.getMethod().equalsIgnoreCase("POST")){
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");

            String usernamePattern = "^[a-zA-Z0-9]+$";
            if (!username.matches(usernamePattern)) {
                request.setAttribute("err", "Username must not contain Vietnamese characters or special symbols.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            if (password.length() < 8) {
                request.setAttribute("err", "Password must be at least 8 characters long.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            if (!password.matches(".*[A-Z].*")) {
                request.setAttribute("err", "Password must contain at least one uppercase letter.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            if (!password.matches(".*[a-z].*")) {
                request.setAttribute("err", "Password must contain at least one lowercase letter.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            if (!password.matches(".*\\d.*")) {
                request.setAttribute("err", "Password must contain at least one digit.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            if (!password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
                request.setAttribute("err", "Password must include at least one special character.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            if (password.matches(".*\\s.*")) {
                request.setAttribute("err", "Password must not contain any whitespace characters.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("err", "Password and Confirm Password do not match.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            if (!MyLibrary.validateEmail(email)) {
                request.setAttribute("err", "Invalid email format.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            String phonePattern = "^0[1-9](?!.*000)\\d{8}$";
            if (!phoneNumber.matches(phonePattern)) {
                request.setAttribute("err", "Invalid phone number. Must start with 0, second digit ≠ 0, 10 digits total, and no '000'.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            newUser = new User(username, email, password, phoneNumber);

            User checkUser = userDAO.getByUsername(username);
            if (checkUser != null) {
                request.setAttribute("err", "Username already exists.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            checkUser = userDAO.findByEmail(email);
            if (checkUser != null) {
                request.setAttribute("err", "Email already registered.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            int insert = userDAO.insertUser(newUser);

            if (insert > 0) {
                newUser = userDAO.getByUsername(username);
                session.setAttribute("user", newUser);
                response.sendRedirect("home.jsp");
            } else {
                request.setAttribute("err", "Create failed: Unknown error!");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
