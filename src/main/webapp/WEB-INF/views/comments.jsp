<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Comments Section -->
<div class="comment-section">
    <h3>Comments</h3>

    <form action="${pageContext.request.contextPath}/comments" method="post">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="courseID" value="${param.courseID}">
        <input type="hidden" name="moduleID" value="${param.moduleID}">
        <input type="hidden" name="materialID" value="${param.materialID}">
        <textarea name="commentContent" rows="3" placeholder="Write your comment..." required></textarea><br>
        <button type="submit">Post</button>
    </form>

    <hr>

    <c:forEach var="comment" items="${comments}">
        <div class="comment">
            <strong>${comment.user.displayName}</strong>
            <span><fmt:formatDate value="${comment.commentDate}" pattern="dd/MM/yyyy HH:mm" /></span>
            <div>
                <c:choose>
                    <c:when test="${commentToEdit != null && commentToEdit.commentId == comment.commentId}">
                        <form action="${pageContext.request.contextPath}/comments" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="commentId" value="${comment.commentId}">
                            <input type="hidden" name="courseID" value="${param.courseID}">
                            <input type="hidden" name="moduleID" value="${param.moduleID}">
                            <input type="hidden" name="materialID" value="${param.materialID}">
                            <textarea name="commentContent" required>${comment.commentContent}</textarea>
                            <button type="submit">Save</button>
                            <a href="${pageContext.request.contextPath}/comments?courseID=${param.courseID}&moduleID=${param.moduleID}&materialID=${param.materialID}">Cancel</a>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p>${comment.commentContent}</p>
                        <a href="${pageContext.request.contextPath}/comments?action=editForm&commentId=${comment.commentId}&courseID=${param.courseID}&moduleID=${param.moduleID}&materialID=${param.materialID}">Edit</a>
                        <a href="${pageContext.request.contextPath}/comments?action=delete&commentId=${comment.commentId}&courseID=${param.courseID}&moduleID=${param.moduleID}&materialID=${param.materialID}"
                           onclick="return confirm('Delete this comment?');">Delete</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <hr>
    </c:forEach>

    <c:if test="${empty comments}">
        <p>No comments yet. Be the first!</p>
    </c:if>
</div>

</div>

<style>
    .comment-section {
        width: 80%;
        margin: 20px auto;
        border: 1px solid #eee;
        padding: 15px;
        border-radius: 8px;
        background-color: #f9f9f9;
    }
    .comment-header {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
    }
    .comment-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        margin-right: 10px;
        object-fit: cover;
    }
    .comment-author-info {
        display: flex;
        flex-direction: column;
    }
    .comment-author-name {
        font-weight: bold;
        color: #333;
    }
    .comment-time {
        font-size: 0.8em;
        color: #888;
    }
    .comment-content {
        margin-bottom: 10px;
        line-height: 1.5;
        word-wrap: break-word;
    }
    .comment-actions {
        font-size: 0.9em;
    }
    .comment-actions a {
        margin-right: 10px;
        color: #007bff;
        text-decoration: none;
    }
    .comment-actions a:hover {
        text-decoration: underline;
    }
    .add-comment-form, .edit-comment-form {
        margin-top: 20px;
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        background-color: #fff;
    }
    .add-comment-form textarea, .edit-comment-form textarea {
        width: calc(100% - 20px);
        padding: 10px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        resize: vertical;
    }
    .add-comment-form button, .edit-comment-form button {
        padding: 8px 15px;
        background-color: #28a745;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    .add-comment-form button:hover, .edit-comment-form button:hover {
        background-color: #218838;
    }
    .comment-separator {
        border-top: 1px solid #eee;
        margin: 15px 0;
    }
</style>
