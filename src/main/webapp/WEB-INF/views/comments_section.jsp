<%--
    Document       : comments_section
    Created on : Jul 3, 2025, 7:20:26 PM
    Author         : DELL
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:url var="materialPageUrl" value="/learner/course/module/material">
    <c:param name="courseID" value="${Course.courseID}" />
    <c:param name="moduleID" value="${CurrentModuleID}" />
    <c:param name="materialID" value="${CurrentMaterialID}" />
</c:url>

<style>
    /* CSS cho phần bình luận */
    .comments-section {
        margin-top: 50px;
        padding: 0 50px;
        background-color: #f8f9fa;
        border-top: 1px solid #e9ecef;
    }
    .comment-form {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,.05);
        margin-bottom: 30px;
    }
    .comment-list {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,.05);
    }
    .comment-item {
        display: flex;
        align-items: flex-start;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #e9ecef;
    }
    .comment-item:last-child {
        border-bottom: none;
        margin-bottom: 0;
        padding-bottom: 0;
    }
    .comment-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        margin-right: 15px;
        object-fit: cover;
    }
    .comment-content-area {
        flex-grow: 1;
    }
    .comment-author {
        font-weight: bold;
        margin-bottom: 5px;
    }
    .comment-text {
        margin-bottom: 5px;
        word-wrap: break-word; /* Đảm bảo nội dung bình luận xuống dòng */
    }
    .comment-meta {
        font-size: 0.85em;
        color: #6c757d;
    }
    .comment-actions {
        margin-left: auto;
    }
    .comment-actions button {
        margin-left: 10px;
    }
    .edit-comment-form {
        margin-top: 10px;
    }
</style>

<div class="comments-section">
    <h3 class="mb-4">Comments</h3>

    <div class="comment-form">
        <c:choose>
            <c:when test="${sessionScope.user != null}">
                <form id="addCommentForm" action="${pageContext.request.contextPath}/comments" method="post" onsubmit="return validateCommentForm()">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="courseID" value="${Course.courseID}"/>
                    <input type="hidden" name="moduleID" value="${CurrentModuleID}"/>
                    <input type="hidden" name="materialID" value="${CurrentMaterialID}"/>
                    <input type="hidden" name="redirectUrl" value="${materialPageUrl}" />
                    <div class="mb-3">
                        <textarea class="form-control" id="addCommentContent" name="commentContent" rows="3" placeholder="Write your comment here" required></textarea>
                        <div id="addCommentError" class="text-danger mt-1" style="display:none;">Not null here.</div>
                    </div>
                    <button type="submit" class="btn btn-primary">Comment</button>
                </form>
            </c:when>
            <c:otherwise>
                <p>You need to <a href="${pageContext.request.contextPath}/login?redirect=${materialPageUrl}">login</a> to comment.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="comment-list">
        <c:if test="${empty comments}">
            <p>Be the first to comment !</p>
        </c:if>
        <c:forEach var="comment" items="${comments}">
            <div class="comment-item">
                <c:choose>
                    <c:when test="${comment.user.googleID != null && !comment.user.googleID.isEmpty()}">
                        <img src="${comment.user.avatarUrl}" alt="Avatar" class="comment-avatar"/>
                    </c:when>
                    <c:when test="${comment.user.avatar != null && fn:length(comment.user.avatar) > 0}">
                        <img src="${comment.user.imageDataURI}" alt="Avatar" class="comment-avatar"/>
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/img/default-avatar.png" alt="Default Avatar" class="comment-avatar"/>
                    </c:otherwise>
                </c:choose>

                <div class="comment-content-area">
                    <c:if test="${comment.user != null}">
                        <p class="comment-author">${comment.user.displayName}</p>
                    </c:if>
                    <c:choose>
                        <c:when test="${commentToEdit != null && commentToEdit.commentId == comment.commentId}">
                            <form action="${pageContext.request.contextPath}/comments" method="post" class="edit-comment-form" onsubmit="return validateEditCommentForm(this)">
                                <input type="hidden" name="action" value="update"/>
                                <input type="hidden" name="commentId" value="${comment.commentId}"/>
                                <input type="hidden" name="courseID" value="${Course.courseID}"/>
                                <input type="hidden" name="moduleID" value="${CurrentModuleID}"/>
                                <input type="hidden" name="materialID" value="${CurrentMaterialID}"/>
                                <input type="hidden" name="redirectUrl" value="${materialPageUrl}" />
                                <div class="mb-2">
                                    <textarea class="form-control" name="commentContent" rows="2" required>${comment.commentContent}</textarea>
                                    <div class="text-danger mt-1" style="display:none;">Not null here.</div>
                                </div>
                                <button type="submit" class="btn btn-sm btn-success">Save</button>
                                <a href="${materialPageUrl}" class="btn btn-sm btn-secondary">Cancel</a>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <p class="comment-text">${comment.commentContent}</p>
                            <p class="comment-meta">
                                <fmt:formatDate value="${comment.commentDate}" pattern="HH:mm dd-MM-yyyy"/>
                                <c:if test="${comment.isIsEdit()}">
                                    (Edited)
                                </c:if>
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="comment-actions">
                    <c:if test="${sessionScope.user != null && sessionScope.user.userId == comment.userId}">
                        <c:if test="${commentToEdit == null || commentToEdit.commentId != comment.commentId}">

                            <a href="${pageContext.request.contextPath}/comments?action=editForm&commentId=${comment.commentId}&courseID=${Course.courseID}&moduleID=${CurrentModuleID}&materialID=${CurrentMaterialID}&redirectUrl=${materialPageUrl}" class="btn btn-sm btn-info text-white">Edit</a>                        </c:if>

                            <form action="${pageContext.request.contextPath}/comments" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bình luận này không?');">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="commentId" value="${comment.commentId}"/>
                            <input type="hidden" name="courseID" value="${Course.courseID}"/>
                            <input type="hidden" name="moduleID" value="${CurrentModuleID}"/>
                            <input type="hidden" name="materialID" value="${CurrentMaterialID}"/>
                            <input type="hidden" name="redirectUrl" value="${materialPageUrl}" />
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>