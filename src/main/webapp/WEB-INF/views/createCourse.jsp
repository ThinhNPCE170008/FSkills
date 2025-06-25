<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Create Course | F-Skill</title>
        <meta charset="UTF-8">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
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
                    <input type="text" class="form-control" id="courseName" name="courseName" required>
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
                    <label for="originalPrice" class="form-label">Original Price (Thousand VND)</label>
                    <input type="number" class="form-control" id="originalPrice" name="originalPrice" min="0" max="10000" required>
                </div>

                <div class="mb-3">
                    <label for="salePrice" class="form-label">Sale Price (Thousand VND)</label>
                    <input type="number" class="form-control" id="salePrice" name="salePrice" min="0" max="10000" required>
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

        <jsp:include page="/layout/footer.jsp"/>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.getElementById("createCourseForm");

                form.addEventListener("submit", function (e) {
                    const nameInput = document.getElementById("courseName");
                    const categorySelect = document.getElementById("category_id");
                    const originalPriceInput = document.getElementById("originalPrice");
                    const salePriceInput = document.getElementById("salePrice");
                    const summaryInput = document.getElementById("courseSummary");
                    const highlightInput = document.getElementById("courseHighlight");

                    const name = nameInput.value.trim();
                    const category = categorySelect.value;
                    const originalPrice = parseFloat(originalPriceInput.value);
                    const salePrice = parseFloat(salePriceInput.value);
                    const summary = summaryInput.value.trim();
                    const highlight = highlightInput.value.trim();

                    const regexValid = /^(?!.*\d)(?!.* {2,}).+$/u;
                    const spaceOnlyRegex = /^(?!.* {2,}).+$/u;

                    if (!name) {
                        showJsToast("Course Name is required.");
                        nameInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (name.length > 30) {
                        showJsToast("Course name cannot be longer than 30 characters.");
                        nameInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (!regexValid.test(name)) {
                        showJsToast("Course name does not contain numbers or spaces.");
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

                    if (isNaN(originalPrice) || originalPrice < 0 || originalPrice > 10000) {
                        showJsToast("Original Price must be between 0 and 10,000,000.");
                        originalPriceInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (isNaN(salePrice) || salePrice < 0 || salePrice > 10000) {
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

                    if (summary && !spaceOnlyRegex.test(summary)) {
                        showJsToast("Summary must not contain consecutive spaces.");
                        summaryInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (highlight && !spaceOnlyRegex.test(highlight)) {
                        showJsToast("Highlight must not contain consecutive spaces.");
                        highlightInput.focus();
                        e.preventDefault();
                        return;
                    }

                    nameInput.value = name;
                    summaryInput.value = summary;
                    highlightInput.value = highlight;
                });
            });
        </script>

        <jsp:include page="/layout/toast.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
