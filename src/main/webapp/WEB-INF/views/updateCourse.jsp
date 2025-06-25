<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
    <head>
        <title>Update Course | F-Skill</title>
        <meta charset="UTF-8">

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body>
        <jsp:include page="/layout/sidebar_user.jsp"/>

        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="${pageContext.request.contextPath}/instructor/courses?action=list" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>

            <h2 class="mb-4">Update Course</h2>
            <form id="updateCourseForm${listCourse.courseID}" action="${pageContext.request.contextPath}/instructor/courses?action=update" method="POST">
                <input type="hidden" name="courseID" value="${listCourse.courseID}"/>
                <input type="hidden" name="userID" value="${user.userId}"/>

                <div class="mb-3">
                    <label class="form-label">Course Name</label>
                    <input type="text" name="courseName" id="updateCourseName${listCourse.courseID}"
                           value="${listCourse.courseName}" class="form-control" maxlength="30" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Category</label>
                    <select class="form-select" id="updateCourseCategory${listCourse.courseID}" name="category_id" required>
                        <option value="">-- Select Category --</option>
                        <c:forEach var="cat" items="${listCategory}">
                            <option value="${cat.id}" ${cat.id == listCourse.category.id ? 'selected' : ''}>
                                ${cat.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Original Price</label>
                    <input type="number" name="originalPrice" id="updateOriginalPrice${listCourse.courseID}"
                           value="${listCourse.originalPrice}" class="form-control" min="0" max="10000000" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Sale Price</label>
                    <input type="number" name="salePrice" id="updateSalePrice${listCourse.courseID}"
                           value="${listCourse.salePrice}" class="form-control" min="0" max="10000000" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Image URL</label>
                    <input type="url" name="courseImageLocation" value="${listCourse.courseImageLocation}"
                           class="form-control" required>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="isSale" value="1"
                           ${listCourse.isSale == 1 ? 'checked' : ''}>
                    <label class="form-check-label">On Sale</label>
                </div>

                <button type="submit" class="btn btn-primary">Save changes</button>
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
                const courseID = "${listCourse.courseID}";
                const form = document.getElementById("updateCourseForm" + courseID);
                const nameInput = document.getElementById("updateCourseName" + courseID);
                const categoryInput = document.getElementById("updateCourseCategory" + courseID);
                const originalPriceInput = document.getElementById("updateOriginalPrice" + courseID);
                const salePriceInput = document.getElementById("updateSalePrice" + courseID);

                const regexValid = /^(?!.*\d)(?!.* {2,}).+$/u;

                form.addEventListener("submit", function (e) {
                    const name = nameInput.value.trim();
                    const category = categoryInput.value;
                    const originalPrice = parseInt(originalPriceInput.value);
                    const salePrice = parseInt(salePriceInput.value);

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
                        categoryInput.focus();
                        e.preventDefault();
                        return;
                    }

                    // Check Prices
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
                        showJsToast("Sale Price cannot be greater than or equal to Original Price.");
                        salePriceInput.focus();
                        e.preventDefault();
                        return;
                    }

                    nameInput.value = name;
                });

                function showJsToast(message) {
                    const toastEl = document.getElementById("jsToast");
                    const toastMsg = document.getElementById("jsToastMessage");
                    toastMsg.innerHTML = message;
                    toastEl.classList.remove("d-none");
                    new bootstrap.Toast(toastEl).show();
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
