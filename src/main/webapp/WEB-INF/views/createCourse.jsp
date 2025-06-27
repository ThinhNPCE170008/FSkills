<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Create Course | F-Skill</title>
        <meta charset="UTF-8">

        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }

            .table th, .table td {
                vertical-align: middle;
                text-align: center;
            }

            .course-image {
                width: 80px;
                height: 60px;
                object-fit: cover;
                border-radius: 5px;
            }

            .table thead {
                background-color: #4f46e5;
                color: white;
            }

            .badge-pending {
                background-color: #ffc107;
            }

            .badge-approved {
                background-color: #198754;
            }

            .price-original {
                color: #999;
                text-decoration: line-through;
            }

            .price-sale {
                color: #dc3545;
                font-weight: bold;
            }

            h2 {
                color: #343a40;
                margin-bottom: 25px;
            }

            .link-hover:hover {
                color: #0d6efd;
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/layout/sidebar_user.jsp"/>

        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="${pageContext.request.contextPath}/instructor/courses?action=list" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>
            <h2 class="mb-4">Create Course</h2>
            <form id="createCourseForm" action="${pageContext.request.contextPath}/instructor/courses?action=create" method="POST">
                <input type="hidden" name="userID" value="${user.userId}" />

                <div class="mb-3">
                    <label for="courseName" class="form-label">Course Name</label>
                    <input type="text" class="form-control" id="courseName" name="courseName" maxlength="30" required>
                </div>

                <div class="mb-3">
                    <label for="category_id" class="form-label">Category</label>
                    <select class="form-select" id="category_id" name="category_id" required>
                        <option value="">-- Select Category --</option>
                        <c:forEach var="cat" items="${listCategory}">
                            <option value="${cat.id}">${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="originalPrice" class="form-label">Original Price (VND)</label>
                    <input type="number" class="form-control" id="originalPrice" name="originalPrice" min="0" max="10000000" required>
                </div>

                <div class="mb-3">
                    <label for="salePrice" class="form-label">Sale Price (VND)</label>
                    <input type="number" class="form-control" id="salePrice" name="salePrice" min="0" max="10000000" required>
                </div>

                <div class="mb-3">
                    <label for="courseImageLocation" class="form-label">Course Image URL</label>
                    <input type="url" class="form-control" id="courseImageLocation" name="courseImageLocation" required>
                </div>

                <div class="mb-3">
                    <label for="courseSummary" class="form-label">Summary</label>
                    <input type="text" class="form-control" id="courseSummary" name="courseSummary" maxlength="255">
                </div>

                <div class="mb-3">
                    <label for="courseHighlight" class="form-label">Highlight</label>
                    <textarea class="form-control" id="courseHighlight" name="courseHighlight" rows="4"></textarea>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" id="isSale" name="isSale" value="1">
                    <label class="form-check-label" for="isSale">On Sale</label>
                </div>

                <button type="submit" class="btn btn-success">Create Course</button>
            </form>
        </div>

        <!-- Toast -->
        <div id="jsToast" class="toast align-items-center text-white bg-danger border-0 position-fixed bottom-0 end-0 m-3 d-none" role="alert">
            <div class="d-flex">
                <div class="toast-body" id="jsToastMessage"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.getElementById("createCourseForm");

                form.addEventListener("submit", function (e) {
                    const nameInput = document.getElementById("courseName");
                    const categorySelect = document.getElementById("category_id");
                    const originalPriceInput = document.getElementById("originalPrice");
                    const salePriceInput = document.getElementById("salePrice");

                    const name = nameInput.value.trim();
                    const category = categorySelect.value;
                    const originalPrice = parseFloat(originalPriceInput.value);
                    const salePrice = parseFloat(salePriceInput.value);

                    const regexValid = /^(?!.*\d)(?!.* {2,}).+$/u;

                    if (!name) {
                        showJsToast("Course Name is required.");
                        nameInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (name.length > 30 || !regexValid.test(name)) {
                        showJsToast("Invalid Course Name.");
                        nameInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (!category) {
                        showJsToast("Category is required.");
                        categorySelect.focus();
                        e.preventDefault();
                        return;
                    }

                    if (isNaN(originalPrice) || originalPrice < 0 || originalPrice > 10000000) {
                        showJsToast("Original Price must be between 0 and 10,000,000.");
                        originalPriceInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (isNaN(salePrice) || salePrice < 0 || salePrice > 10000000) {
                        showJsToast("Sale Price must be between 0 and 10,000,000.");
                        salePriceInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (salePrice >= originalPrice) {
                        showJsToast("Sale Price cannot be greater than or equal to the Original Price.");
                        salePriceInput.focus();
                        e.preventDefault();
                        return;
                    }

                    nameInput.value = name;
                });

                function showJsToast(message) {
                    const toastEl = document.getElementById('jsToast');
                    const toastMsg = document.getElementById('jsToastMessage');
                    toastMsg.innerHTML = message;
                    toastEl.classList.remove('d-none');
                    const toast = new bootstrap.Toast(toastEl);
                    toast.show();
                }
            });
        </script>

        <!-- Message -->
        <c:if test="${not empty success || not empty err}">
            <c:choose>
                <c:when test="${not empty success}">
                    <c:set var="toastMessage" value="${success}"/>
                    <c:set var="toastClass" value="text-bg-success"/>
                </c:when>
                <c:when test="${not empty err}">
                    <c:set var="toastMessage" value="${err}"/>
                    <c:set var="toastClass" value="text-bg-danger"/>
                </c:when>
            </c:choose>

            <div class="toast-container position-fixed bottom-0 end-0 p-3">
                <div id="serverToast" class="toast align-items-center ${toastClass} border-0" role="alert" aria-live="assertive"
                     aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body">
                            ${toastMessage}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                                aria-label="Close"></button>
                    </div>
                </div>
            </div>
        </c:if>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const toastEl = document.getElementById('serverToast');
                if (toastEl) {
                    const bsToast = new bootstrap.Toast(toastEl, {delay: 3000});
                    bsToast.show();
                }
            });
        </script>

        <jsp:include page="/layout/footer.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
