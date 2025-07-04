package controller;

import dao.Feedback_adminDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Feedback_admin;
import model.User;

/**
 * Servlet to handle admin feedback management
 */
@WebServlet(name = "FeedbackAdminServlet", urlPatterns = {"/admin/feedback"})
public class FeedbackAdminServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays the feedback management interface.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only administrators can access this page.");
            return;
        }

        // Get feedback type parameter (default to "comments")
        String feedbackType = request.getParameter("type");
        if (feedbackType == null || feedbackType.isEmpty()) {
            feedbackType = "comments";
        }

        // Get sort parameter (default to "newest")
        String sortBy = request.getParameter("sort");
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "newest";
        }

        // Get feedback data
        Feedback_adminDAO dao = new Feedback_adminDAO();
        List<Feedback_admin> feedbackList;

        if ("all".equals(feedbackType)) {
            feedbackList = dao.getAllFeedback();
        } else {
            feedbackList = dao.getFeedbackByType(feedbackType);
        }

        // Sort the feedback list based on the sortBy parameter
        if ("oldest".equals(sortBy)) {
            feedbackList.sort((a, b) -> a.getTimestamp().compareTo(b.getTimestamp()));
        } else {
            // Default to newest first
            feedbackList.sort((a, b) -> b.getTimestamp().compareTo(a.getTimestamp()));
        }

        // Set attributes for the JSP
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("activeTab", feedbackType);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("feedbackCount", feedbackList.size());

        // Forward to the feedback admin JSP page
        request.getRequestDispatcher("/WEB-INF/views/feedback_admin.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Processes feedback actions (update status, delete).
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only administrators can access this page.");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
            return;
        }

        // Process the action
        Feedback_adminDAO dao = new Feedback_adminDAO();
        int result = 0;

        // Special case for deleteAll action which doesn't require an ID
        if ("deleteAll".equals(action)) {
            result = dao.deleteAllFeedback();
            // For deleteAll, any non-negative result is considered success
            if (result >= 0) {
                // Set success message in session
                session.setAttribute("success", "All feedback deleted successfully. " + result + " records removed.");

                // Redirect back to the feedback page after successful deletion
                String redirectUrl = request.getContextPath() + "/admin/feedback";
                String type = request.getParameter("type");
                if (type != null && !type.isEmpty()) {
                    redirectUrl += "?type=" + type;
                }
                response.sendRedirect(redirectUrl);
            } else {
                // Set error message in session
                session.setAttribute("err", "Failed to delete all feedback");

                // Redirect back to the feedback page
                String redirectUrl = request.getContextPath() + "/admin/feedback";
                String type = request.getParameter("type");
                if (type != null && !type.isEmpty()) {
                    redirectUrl += "?type=" + type;
                }
                response.sendRedirect(redirectUrl);
            }
            return;
        }

        // For other actions, get feedback ID parameter
        String feedbackIdStr = request.getParameter("id");
        if (feedbackIdStr == null || feedbackIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing feedback ID parameter");
            return;
        }

        int feedbackId;
        try {
            feedbackId = Integer.parseInt(feedbackIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid feedback ID format");
            return;
        }

        // Process actions that require an ID
        switch (action) {
            case "archive":
                result = dao.updateFeedbackStatus(feedbackId, "archived");
                break;
            case "resolve":
                result = dao.updateFeedbackStatus(feedbackId, "resolved");
                break;
            case "delete":
                result = dao.deleteFeedback(feedbackId);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
                return;
        }

        // Prepare response
        if (result > 0) {
            // Success
            if ("delete".equals(action)) {
                // Set success message in session
                session.setAttribute("success", "Feedback deleted successfully");

                // Redirect back to the feedback page after successful deletion
                String redirectUrl = request.getContextPath() + "/admin/feedback";
                String type = request.getParameter("type");
                if (type != null && !type.isEmpty()) {
                    redirectUrl += "?type=" + type;
                }
                response.sendRedirect(redirectUrl);
            } else {
                // For other actions (archive, resolve), return JSON response
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Feedback " + action + "d successfully\"}");
            }
        } else {
            // Error
            // Set error message in session
            session.setAttribute("err", "Failed to " + action + " feedback");

            if ("delete".equals(action)) {
                // Redirect back to the feedback page
                String redirectUrl = request.getContextPath() + "/admin/feedback";
                String type = request.getParameter("type");
                if (type != null && !type.isEmpty()) {
                    redirectUrl += "?type=" + type;
                }
                response.sendRedirect(redirectUrl);
            } else {
                // For other actions (archive, resolve), return JSON response
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to " + action + " feedback\"}");
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
        return "Admin Feedback Management Servlet";
    }
}
