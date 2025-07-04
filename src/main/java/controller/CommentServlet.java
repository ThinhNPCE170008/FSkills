package controller;

import dao.CommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Comment;
import model.User;

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

        String redirectUrl = request.getParameter("redirectUrl");

        if (redirectUrl == null || redirectUrl.isEmpty()) {
            String courseID = request.getParameter("courseID");
            String moduleID = request.getParameter("moduleID");
            String materialID = request.getParameter("materialID");

            if (courseID != null && moduleID != null && materialID != null) {
                redirectUrl = request.getContextPath() + "/learner/course/module/material"
                        + "?courseID=" + courseID
                        + "&moduleID=" + moduleID
                        + "&materialID=" + materialID;
            } else {
                redirectUrl = request.getContextPath() + "/home";
            }
        }

        request.setAttribute("redirectUrl", redirectUrl);

        switch (action) {
            case "editForm":
                showEditForm(request, response);
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
            String courseID = request.getParameter("courseID");
            String moduleID = request.getParameter("moduleID");
            String materialID = request.getParameter("materialID");

            if (courseID != null && moduleID != null && materialID != null) {
                redirectUrl = request.getContextPath() + "/learner/course/module/material"
                        + "?courseID=" + courseID
                        + "&moduleID=" + moduleID
                        + "&materialID=" + materialID;
            } else {
                redirectUrl = request.getContextPath() + "/home";
            }
        }

        request.setAttribute("redirectUrl", redirectUrl);

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

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        int commentId = parseInt(request.getParameter("commentId"));
        int courseID = parseInt(request.getParameter("courseID"));
        int moduleID = parseInt(request.getParameter("moduleID"));
        int materialID = parseInt(request.getParameter("materialID"));

        Comment commentToEdit = commentDAO.getCommentById(commentId);

        if (commentToEdit != null && currentUser != null && commentToEdit.getUserId() == currentUser.getUserId()) {
            request.setAttribute("commentToEdit", commentToEdit);
        } else {
            String redirectUrl = (String) request.getAttribute("redirectUrl");
            if (redirectUrl != null) {
                response.sendRedirect(redirectUrl);
                return;
            }
        }

        List<Comment> comments = commentDAO.getCommentsByMaterialId(materialID);
        request.setAttribute("comments", comments);
        request.setAttribute("courseID", courseID);
        request.setAttribute("moduleID", moduleID);
        request.setAttribute("materialID", materialID);

        request.getRequestDispatcher("/WEB-INF/views/learnerMaterialView.jsp")
                .forward(request, response);
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