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

<div class="container px-5 mt-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <a href="${pageContext.request.contextPath}/instructor/courses?action=list" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back
        </a>
    </div>

    <h2 class="mb-4 fw-bold fs-3">Update Course</h2>
    <form id="updateCourseForm${listCourse.courseID}" action="${pageContext.request.contextPath}/instructor/courses?action=update" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="courseID" value="${listCourse.courseID}"/>
        <input type="hidden" name="userID" value="${user.userId}"/>

        <div class="mb-3">
            <label class="form-label">Course Name</label>
            <input type="text" name="courseName" id="updateCourseName${listCourse.courseID}"
                   value="${listCourse.courseName}" class="form-control" required>
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
            <label class="form-label">Original Price (Thousand VND)</label>
            <input type="number" name="originalPrice" id="updateOriginalPrice${listCourse.courseID}"
                   value="${listCourse.originalPrice}" class="form-control" min="0" max="10000" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Sale Price (Thousand VND)</label>
            <input type="number" name="salePrice" id="updateSalePrice${listCourse.courseID}"
                   value="${listCourse.salePrice}" class="form-control" min="0" max="10000" required>
        </div>

        <div class="mb-3">
            <label for="courseImageLocation" class="form-label">Select Image</label>
            <input type="file"
                   class="form-control"
                   id="courseImageLocation"
                   name="courseImageLocation"
                   accept="image/*"
                   onchange="previewImage(event)"
                   oninvalid="this.setCustomValidity('Please select a image')"
                   oninput="this.setCustomValidity('')"
                   onblur="setNoImageIfEmpty(this)"
                   required>
            <img id="imagePreview" class="img-thumbnail mt-2" style="max-width: 300px; display: none;" />
        </div>

        <div class="mb-3">
            <label for="courseSummary" class="form-label">Summary</label>
            <input type="text" class="form-control" id="updateCourseSummary${listCourse.courseID}" name="courseSummary"
                   value="${listCourse.courseSummary}" maxlength="255">
        </div>

        <div class="mb-3">
            <label for="courseHighlight" class="form-label">Highlight</label>
            <textarea class="form-control" id="updateCourseHighlight${listCourse.courseID}"
                      name="courseHighlight" rows="4">${listCourse.courseHighlight}</textarea>
        </div>

        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="isSale" value="1"
            ${listCourse.isSale == 1 ? 'checked' : ''}>
            <label class="form-check-label">On Sale</label>
        </div>

        <button type="submit" class="btn btn-primary">Save changes</button>
    </form>
</div>

<jsp:include page="/layout/footer.jsp"/>

<script>
    function previewImage(event) {
        const fileInput = event.target;
        const preview = document.getElementById("imagePreview");

        if (fileInput.files && fileInput.files[0]) {
            const reader = new FileReader();

            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = "block";
            };

            reader.readAsDataURL(fileInput.files[0]);
        } else {
            preview.style.display = "none";
        }
    }

    function setNoImageIfEmpty(input) {
        if (!input.value) {
            document.getElementById("imagePreview").style.display = "none";
        }
    }
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const courseID = "${listCourse.courseID}";
        const form = document.getElementById("updateCourseForm" + courseID);
        const nameInput = document.getElementById("updateCourseName" + courseID);
        const categoryInput = document.getElementById("updateCourseCategory" + courseID);
        const originalPriceInput = document.getElementById("updateOriginalPrice" + courseID);
        const salePriceInput = document.getElementById("updateSalePrice" + courseID);
        const summaryInput = document.getElementById("updateCourseSummary" + courseID);
        const highlightInput = document.getElementById("updateCourseHighlight" + courseID);

        const regexValid = /^(?!.*\d)(?!.* {2,}).+$/u;
        const spaceOnlyRegex = /^(?!.* {2,}).+$/u;

        form.addEventListener("submit", function (e) {
            const name = nameInput.value.trim();
            const category = categoryInput.value;
            const originalPrice = parseInt(originalPriceInput.value);
            const salePrice = parseInt(salePriceInput.value);
            const summary = summaryInput.value.trim();
            const highlight = highlightInput.value.trim();

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
                categoryInput.focus();
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
                showJsToast("Sale Price cannot be greater than or equal to Original Price.");
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

<jsp:include page="/layout/toast.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
