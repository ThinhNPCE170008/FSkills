package controller;

import dao.Feedback_userDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Feedback_user;
import model.User;

/**
 * Servlet to handle user feedback
 */
@WebServlet(name = "FeedbackUserServlet", urlPatterns = {"/feedback"})
public class FeedbackUserServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays the feedback form.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the feedback JSP page
        request.getRequestDispatcher("/WEB-INF/views/feedback_user.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Processes the submitted feedback.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data
        String feedbackType = request.getParameter("feedbackType");
        String feedbackContent = request.getParameter("feedbackContent");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        
        // Validate required fields
        if (feedbackContent == null || feedbackContent.trim().isEmpty()) {
            request.setAttribute("err", "Please enter your feedback content.");
            request.getRequestDispatcher("/WEB-INF/views/feedback_user.jsp").forward(request, response);
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("err", "Please enter your email address.");
            request.getRequestDispatcher("/WEB-INF/views/feedback_user.jsp").forward(request, response);
            return;
        }
        
        // Get user ID from session if available
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = 0; // Default for anonymous users
        
        if (user != null) {
            userId = user.getUserId();
            
            // If user is logged in and didn't provide name, use their display name
            if ((firstName == null || firstName.trim().isEmpty()) && 
                (lastName == null || lastName.trim().isEmpty())) {
                String[] nameParts = user.getDisplayName().split(" ", 2);
                if (nameParts.length > 0) {
                    firstName = nameParts[0];
                    if (nameParts.length > 1) {
                        lastName = nameParts[1];
                    } else {
                        lastName = "";
                    }
                }
            }
            
            // If user is logged in and didn't provide email, use their email
            if (email == null || email.trim().isEmpty()) {
                email = user.getEmail();
            }
        }
        
        // Create feedback object
        Feedback_user feedback = new Feedback_user(
                feedbackType, 
                feedbackContent, 
                firstName, 
                lastName, 
                email, 
                userId
        );
        
        // Save feedback to database
        Feedback_userDAO dao = new Feedback_userDAO();
        int result = dao.insertFeedback(feedback);
        
        if (result > 0) {
            // Success
            request.setAttribute("success", "Thank you for your feedback! We will review and respond as soon as possible.");
        } else {
            // Error
            request.setAttribute("err", "Failed to submit feedback. Please try again later.");
        }
        
        // Forward back to the feedback page
        request.getRequestDispatcher("/WEB-INF/views/feedback_user.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Feedback Servlet";
    }
}