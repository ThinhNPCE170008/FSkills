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

                        <!-- nút report của DUY -->   
                        <button class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#reportCommentModal">
                            <i class="fa-solid fa-flag me-1"></i> Report
                        </button>
                        <!-- nút report của DUY -->
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

<!-- 🔷 Modal Báo Cáo Comment -->
<div class="modal fade" id="reportCommentModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 report-modal">

            <form method="POST" action="${pageContext.request.contextPath}/report"
                  onsubmit="return validateReportForm();">
                <input type="hidden" name="action" value="reportComment">
                <input type="hidden" name="courseId" value="${Course.courseID}">
                <input type="hidden" name="moduleId" value="${CurrentModuleID}">

                <c:forEach var="comment" items="${comments}">
                    <input type="hidden" name="commentId" value="${comment.commentId}">
                </c:forEach>
                <input type="hidden" name="materialId" value="${CurrentMaterialID}"/>
                <input type="hidden" name="userId" value="${sessionScope.user.userId}">

                <!-- Step 1 -->
                <div id="reportStep1Comment">
                    <div class="modal-header border-0">
                        <h4 class="modal-title flex-grow-1 text-center fw-semibold m-0">Report</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <h6 class="fw-bold">What's going on?</h6>
                        <p class="text-muted small">We'll check for all Community Guidelines, so don't worry about making the perfect choice.</p>

                        <c:forEach var="cate" items="${listReportCategory}">
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio"
                                       name="categorySelection"
                                       id="commentCate${cate.reportCategoryId}"
                                       value="${cate.reportCategoryId}" required>
                                <label class="form-check-label" for="commentCate${cate.reportCategoryId}">
                                    ${cate.reportCategoryName}
                                </label>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-dark w-100 rounded-pill" id="nextStepComment" disabled>Next</button>
                    </div>
                </div>

                <!-- Step 2 -->
                <div id="reportStep2Comment" style="display: none;">
                    <div class="modal-header border-0 d-flex align-items-center justify-content-between">
                        <button type="button" class="btn btn-outline-secondary btn-sm me-2 px-3 py-2 rounded-pill" id="backStepComment">
                            ← Back
                        </button>
                        <h4 class="modal-title mx-auto fw-semibold m-0 position-absolute start-50 translate-middle-x">Report</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <input type="hidden" name="categoryId" id="selectedCategoryIdComment" />

                    <div class="modal-body">
                        <h6 class="fw-bold">Want to tell us more? It's optional</h6>
                        <p class="text-muted small">Sharing a few details can help us understand the issue. Please don't include personal info or questions.</p>
                        <textarea name="reportDetail" class="form-control" rows="6" placeholder="Add details..."></textarea>
                    </div>

                    <div class="modal-footer border-0">
                        <button type="submit" class="btn btn-dark w-100 rounded-pill">Report</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Script JS xử lý riêng cho modal comment -->
<script>
    function validateReportForm() {
        const selectedInput = document.getElementById("selectedCategoryIdComment");
        if (!selectedInput.value) {
            alert("Please select a report reason.");
            return false;
        }
        return true;
    }

    document.addEventListener("DOMContentLoaded", function () {
        const radios = document.querySelectorAll('#reportCommentModal input[name="categorySelection"]');
        const nextBtn = document.getElementById("nextStepComment");
        const backBtn = document.getElementById("backStepComment");
        const selectedInput = document.getElementById("selectedCategoryIdComment");

        const step1 = document.getElementById("reportStep1Comment");
        const step2 = document.getElementById("reportStep2Comment");

        radios.forEach(radio => {
            radio.addEventListener("change", () => {
                nextBtn.disabled = false;
                selectedInput.value = radio.value;
            });
        });

        nextBtn.addEventListener("click", () => {
            step1.style.display = "none";
            step2.style.display = "block";
        });

        backBtn.addEventListener("click", () => {
            step2.style.display = "none";
            step1.style.display = "block";
        });
    });
</script>

