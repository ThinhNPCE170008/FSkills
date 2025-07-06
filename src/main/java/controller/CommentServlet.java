package controller;

import dao.CommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Comment;
import model.User;
import model.Course;

@WebServlet(name = "CommentController", urlPatterns = {"/comments"})
public class CommentServlet extends HttpServlet {

    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        String courseIDParam = request.getParameter("courseID");
        String moduleIDParam = request.getParameter("moduleID");
        String materialIDParam = request.getParameter("materialID");

        String redirectUrl = request.getContextPath() + "/learner/course/module/material"
                                + "?courseID=" + (courseIDParam != null ? courseIDParam : "")
                                + "&moduleID=" + (moduleIDParam != null ? moduleIDParam : "")
                                + "&materialID=" + (materialIDParam != null ? materialIDParam : "");

        switch (action) {
            case "editForm":
                String commentId = request.getParameter("commentId");
                if (commentId != null && !commentId.isEmpty()) {
                    redirectUrl += "&commentIdToEdit=" + commentId;
                }
                response.sendRedirect(redirectUrl);
                break;
            default:
                response.sendRedirect(redirectUrl);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "add";
        }

        String redirectUrl = request.getParameter("redirectUrl");
        
        if (redirectUrl == null || redirectUrl.isEmpty()) {
            String courseIDParam = request.getParameter("courseID");
            String moduleIDParam = request.getParameter("moduleID");
            String materialIDParam = request.getParameter("materialID");
            redirectUrl = request.getContextPath() + "/learner/course/module/material"
                        + "?courseID=" + (courseIDParam != null ? courseIDParam : "")
                        + "&moduleID=" + (moduleIDParam != null ? moduleIDParam : "")
                        + "&materialID=" + (materialIDParam != null ? materialIDParam : "");
        }


        switch (action) {
            case "add":
                addComment(request, response, redirectUrl);
                break;
            case "update":
                updateComment(request, response, redirectUrl);
                break;
            case "delete":
                deleteComment(request, response, redirectUrl);
                break;
            default:
                response.sendRedirect(redirectUrl);
                break;
        }
    }

    private void addComment(HttpServletRequest request, HttpServletResponse response, String redirectUrl)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + redirectUrl);
            return;
        }

        int materialID = parseInt(request.getParameter("materialID"));
        String content = request.getParameter("commentContent");

        int userIdToAddComment = currentUser.getUserId();

        if (content != null && !content.trim().isEmpty()) {
            Comment comment = new Comment();
            comment.setUserId(userIdToAddComment);
            comment.setMaterialId(materialID);
            comment.setCommentContent(content.trim());
            commentDAO.addComment(comment);
        }
        response.sendRedirect(redirectUrl);
    }

    private void updateComment(HttpServletRequest request, HttpServletResponse response, String redirectUrl)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        int commentId = parseInt(request.getParameter("commentId"));
        String newContent = request.getParameter("commentContent");

        Comment existingComment = commentDAO.getCommentById(commentId);

        if (existingComment != null && currentUser != null && existingComment.getUserId() == currentUser.getUserId()) {
            String trimmedNewContent = (newContent != null) ? newContent.trim() : "";
            String trimmedExistingContent = (existingComment.getCommentContent() != null) ? existingComment.getCommentContent().trim() : "";

            if (trimmedNewContent.isEmpty()) {
                response.sendRedirect(redirectUrl);
                return;
            }

            boolean contentActuallyChanged = !trimmedNewContent.equals(trimmedExistingContent);

            if (contentActuallyChanged) {
                existingComment.setCommentContent(trimmedNewContent);
                existingComment.setIsEdit(true);
                commentDAO.updateComment(existingComment);
            } else {
                if (existingComment.isIsEdit()) {
                    existingComment.setIsEdit(false);
                    commentDAO.updateComment(existingComment);
                }
            }
        }
        response.sendRedirect(redirectUrl);
    }

    private void deleteComment(HttpServletRequest request, HttpServletResponse response, String redirectUrl)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        int commentId = parseInt(request.getParameter("commentId"));

        Comment commentToDelete = commentDAO.getCommentById(commentId);

        if (commentToDelete != null && currentUser != null && commentToDelete.getUserId() == currentUser.getUserId()) {
            commentDAO.deleteComment(commentId, currentUser.getUserId());
        }
        response.sendRedirect(redirectUrl);
    }

    private int parseInt(String val) {
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}