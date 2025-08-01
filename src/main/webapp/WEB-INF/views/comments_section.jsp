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
        box-sizing: border-box; 
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
        flex-shrink: 0; 
    }

    .comment-content-area {
        flex-grow: 1; 
        min-width: 0; 
        display: flex;
        flex-direction: column;
        padding-right: 15px; 
    }

    .comment-author {
        font-weight: bold;
        margin-bottom: 5px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap; 
    }

    .comment-author span {
        flex-shrink: 1;
        min-width: 0; 
    }

    .comment-author .report-comment-btn {
        margin-left: auto; 
        flex-shrink: 0; 
        margin-top: 0;
    }

    .comment-text-wrapper {
        word-wrap: break-word;
        overflow-wrap: break-word;
        word-break: break-word;
    }

    .comment-truncated-text {
        display: inline;
    }

    .comment-full-text {
        display: none;
    }

    .read-more-btn {
        background: none;
        border: none;
        color: #007bff;
        cursor: pointer;
        padding: 0;
        font-size: 0.9em;
        text-decoration: underline;
        margin-top: 5px;
        display: inline-block;
    }

    .comment-meta {
        font-size: 0.85em;
        color: #6c757d;
        margin-top: 5px;
    }

    .comment-actions {
        flex-shrink: 0; 
        display: flex;
        flex-direction: row;
        align-items: flex-start; 
        gap: 10px; 
    }

    .comment-actions button, .comment-actions a {
        white-space: nowrap; 
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
                <form id="addCommentForm" action="${pageContext.request.contextPath}/comments" method="post">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="courseID" value="${Course.courseID}"/>
                    <input type="hidden" name="moduleID" value="${CurrentModuleID}"/>
                    <input type="hidden" name="materialID" value="${CurrentMaterialID}"/>
                    <input type="hidden" name="redirectUrl" value="${materialPageUrl}" />
                    <div class="mb-3">
                        <textarea class="form-control" id="addCommentContent" name="commentContent" rows="3" placeholder="Write your comment here" required>${oldAddCommentContent}</textarea>
                        <c:if test="${not empty addCommentError}">
                            <div class="text-danger mt-1">${addCommentError}</div>
                        </c:if>
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
                        <img src="${pageContext.request.contextPath}/img/default.png" alt="Default Avatar" class="comment-avatar"/>
                    </c:otherwise>
                </c:choose>
                <div class="comment-content-area">
                    <c:if test="${comment.user != null}">
                        <p class="comment-author">
                            <span>${comment.user.displayName}</span>
                            <c:if test="${sessionScope.user != null && sessionScope.user.userId != comment.userId}">
                                <button class="btn btn-outline-danger btn-sm report-comment-btn"
                                        data-bs-toggle="modal"
                                        data-bs-target="#reportCommentModal"
                                        data-comment-id="${comment.commentId}"
                                        data-user-target="${comment.user.userId}">
                                    <i class="fa-solid fa-flag me-1"></i> Report
                                </button>
                            </c:if>
                        </p>
                    </c:if>

                    <c:choose>
                        <c:when test="${requestScope.commentToEdit != null && requestScope.commentToEdit.commentId == comment.commentId}">
                            <form action="${pageContext.request.contextPath}/comments" method="post" class="edit-comment-form">
                                <input type="hidden" name="action" value="update"/>
                                <input type="hidden" name="commentId" value="${comment.commentId}"/>
                                <input type="hidden" name="courseID" value="${Course.courseID}"/>
                                <input type="hidden" name="moduleID" value="${CurrentModuleID}"/>
                                <input type="hidden" name="materialID" value="${CurrentMaterialID}"/>
                                <input type="hidden" name="redirectUrl" value="${materialPageUrl}" /> 
                                <div class="mb-2">
                                    <textarea class="form-control" name="commentContent" rows="2" required>${(not empty oldUpdateCommentContent && requestScope.commentToEdit.commentId == comment.commentId) ? oldUpdateCommentContent : requestScope.commentToEdit.commentContent}</textarea>
                                    <c:if test="${not empty updateCommentError && requestScope.commentToEdit.commentId == comment.commentId}">
                                        <div class="text-danger mt-1">${updateCommentError}</div>
                                    </c:if>
                                </div>
                                <button type="submit" class="btn btn-sm btn-success">Save</button>
                                <a href="${materialPageUrl}" class="btn btn-sm btn-secondary">Cancel</a>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="comment-text-wrapper">
                                <c:set var="commentContent" value="${comment.commentContent}" />
                                <c:set var="commentLength" value="${fn:length(commentContent)}" />
                                <c:set var="maxLength" value="100" /> 

                                <c:if test="${commentLength > maxLength}">
                                    <span class="comment-truncated-text">
                                        ${fn:substring(commentContent, 0, maxLength)}...
                                    </span>
                                    <span class="comment-full-text" style="display: none;">
                                        ${commentContent}
                                    </span>
                                    <button class="read-more-btn" data-comment-id="${comment.commentId}">Read more</button>
                                </c:if>
                                <c:if test="${commentLength <= maxLength}">
                                    <span class="comment-text">${commentContent}</span>
                                </c:if>
                            </div>
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
                        <c:if test="${requestScope.commentToEdit == null || requestScope.commentToEdit.commentId != comment.commentId}">
                            <a href="${pageContext.request.contextPath}/comments?action=editForm&commentId=${comment.commentId}&courseID=${Course.courseID}&moduleID=${CurrentModuleID}&materialID=${CurrentMaterialID}" class="btn btn-sm btn-info text-white">Edit</a>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/comments" method="post" style="display:inline;" onsubmit="return confirm('Are you sure to delete this comment ?');">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="commentId" value="${comment.commentId}"/>
                            <input type="hidden" name="courseID" value="${Course.courseID}"/>
                            <input type="hidden" name="moduleID" value="${CurrentModuleID}"/>
                            <input type="hidden" name="materialID" value="${CurrentMaterialID}"/>
                            <input type="hidden" name="redirectUrl" value="${materialPageUrl}" /> <%-- Thêm lại redirectUrl --%>
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<div class="modal fade" id="reportCommentModal" tabindex="-1" aria-labelledby="reportCommentModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 report-modal">
            <form method="POST" action="${pageContext.request.contextPath}/report" onsubmit="return validateReportForm();">
                <input type="hidden" name="action" value="reportComment">
                <input type="hidden" name="courseId" value="${Course.courseID}">
                <input type="hidden" name="moduleId" value="${CurrentModuleID}">
                <input type="hidden" name="materialId" value="${CurrentMaterialID}"/>
                <input type="hidden" name="userId" value="${sessionScope.user.userId}">
                <input type="hidden" name="commentId" id="reportCommentId">
                <input type="hidden" name="userTargetComment" id="reportUserTargetComment">

                <div id="reportStep1Comment">
                    <div class="modal-header border-0">
                        <h4 class="modal-title flex-grow-1 text-center fw-semibold m-0" id="reportCommentModalLabel">Report</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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

<script>
    // Hàm validateReportForm và các logic liên quan đến Modal Report
    function validateReportForm() {
        const selectedInput = document.getElementById("selectedCategoryIdComment");
        if (!selectedInput || !selectedInput.value) { 
            console.log("Validation failed: No report reason selected");
            alert("Please select a report reason.");
            return false;
        }
        const commentIdInput = document.getElementById("reportCommentId"); 
        const userTargetInput = document.getElementById("reportUserTargetComment"); 

        const commentId = commentIdInput ? commentIdInput.value : 'N/A'; 
        const userTarget = userTargetInput ? userTargetInput.value : 'N/A'; 

        console.log("Submitting report - commentId:", commentId, "userTargetComment:", userTarget);
        return true;
    }

    document.addEventListener("DOMContentLoaded", function () {
        console.log("DOM loaded, initializing event listeners");

        const radios = document.querySelectorAll('#reportCommentModal input[name="categorySelection"]');
        const nextBtn = document.getElementById("nextStepComment");
        const backBtn = document.getElementById("backStepComment");
        const selectedInput = document.getElementById("selectedCategoryIdComment");
        const reportCommentIdInput = document.getElementById("reportCommentId");
        const reportUserTargetInput = document.getElementById("reportUserTargetComment");
        const step1 = document.getElementById("reportStep1Comment");
        const step2 = document.getElementById("reportStep2Comment");
        const reportModal = document.getElementById('reportCommentModal');

        // Handle report button click to set commentId and userTargetComment
        document.querySelectorAll('.report-comment-btn').forEach(button => {
            button.addEventListener('click', () => {
                const commentId = button.getAttribute('data-comment-id');
                const userTarget = button.getAttribute('data-user-target');
                console.log("Report button clicked - commentId:", commentId, "userTarget:", userTarget);
                if (reportCommentIdInput) reportCommentIdInput.value = commentId; 
                if (reportUserTargetInput) reportUserTargetInput.value = userTarget;
                console.log("Set form inputs - reportCommentId:", reportCommentIdInput ? reportCommentIdInput.value : 'N/A', "reportUserTargetComment:", reportUserTargetInput ? reportUserTargetInput.value : 'N/A');
            });
        });

        // Handle radio button selection for report category
        if (radios.length > 0) {
            radios.forEach(radio => {
                radio.addEventListener("change", () => {
                    console.log("Radio selected - categoryId:", radio.value);
                    if (nextBtn) nextBtn.disabled = false; 
                    if (selectedInput) selectedInput.value = radio.value; 
                    console.log("Updated selectedCategoryIdComment:", selectedInput ? selectedInput.value : 'N/A');
                });
            });
        }

        // Handle Next button click
        if (nextBtn) {
            nextBtn.addEventListener("click", () => {
                console.log("Next button clicked, switching to step 2");
                if (step1) step1.style.display = "none"; 
                if (step2) step2.style.display = "block";
            });
        }

        // Handle Back button click
        if (backBtn) { // Thêm kiểm tra null
            backBtn.addEventListener("click", () => {
                console.log("Back button clicked, returning to step 1");
                if (step2) step2.style.display = "none"; 
                if (step1) step1.style.display = "block";
            });
        }

        // Reset modal when closed
        if (reportModal) { 
            reportModal.addEventListener('hidden.bs.modal', () => {
                console.log("Modal closed, resetting form");
                if (step1) step1.style.display = "block";
                if (step2) step2.style.display = "none"; 
                if (nextBtn) nextBtn.disabled = true; 
                if (selectedInput) selectedInput.value = ""; 
                if (reportCommentIdInput) reportCommentIdInput.value = ""; 
                if (reportUserTargetInput) reportUserTargetInput.value = "";
                radios.forEach(radio => radio.checked = false);
                console.log("Form reset - selectedCategoryIdComment:", selectedInput ? selectedInput.value : 'N/A',
                    "reportCommentId:", reportCommentIdInput ? reportCommentIdInput.value : 'N/A',
                    "reportUserTargetComment:", reportUserTargetInput ? reportUserTargetInput.value : 'N/A');
            });
        }

        // Logic for "Read More" button 
        document.querySelectorAll('.read-more-btn').forEach(button => {
            button.addEventListener('click', function(event) {
                event.preventDefault();
                const textWrapper = this.closest('.comment-text-wrapper');
                if (textWrapper) {
                    const truncatedText = textWrapper.querySelector('.comment-truncated-text');
                    const fullText = textWrapper.querySelector('.comment-full-text');
                    if (truncatedText && fullText) {
                        // Toggle display
                        if (fullText.style.display === 'none' || fullText.style.display === '') {
                            truncatedText.style.display = 'none';
                            fullText.style.display = 'inline';
                            this.textContent = 'Compact'; 
                        } else {
                            truncatedText.style.display = 'inline';
                            fullText.style.display = 'none';
                            this.textContent = 'Read more';
                        }
                    } else {
                        console.error("Error: Truncated or full text element not found.");
                    }
                } else {
                    console.error("Error: Comment text wrapper not found.");
                }
            });
        });
    });
</script>