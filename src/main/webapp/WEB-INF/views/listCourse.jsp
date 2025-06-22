<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>List Course | F-Skill</title>
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
<jsp:include page="/layout/headerInstructor.jsp"/>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <a href="${pageContext.request.contextPath}/instructor" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back
        </a>

        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createCourseModal">
            <i class="fas fa-plus"></i> Create New Course
        </button>
    </div>

    <c:choose>
        <c:when test="${empty listCourse}">
            <div class="alert alert-warning text-center">No courses available.</div>
        </c:when>
        <c:otherwise>
            <table class="table table-bordered table-hover shadow-sm bg-white rounded">
                <thead>
                <tr>
                    <th>Image</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Instructor</th>
                    <th>Status</th>
                    <th>Published</th>
                    <th>Last Update</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="c" items="${listCourse}">
                    <tr>
                        <td>
                            <img src="${c.courseImageLocation}" class="course-image" alt="Course Image">
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${c.courseID}"
                               class="text-decoration-none link-hover">
                                    ${c.courseName}
                            </a>
                        </td>
                        <td>${c.courseCategory}</td>
                        <td>${c.user.displayName}</td>
                        <td>
                                        <span class="badge
                                            ${c.approveStatus == 1 ? 'badge-approved' : 'badge-pending'}">
                                                ${c.approveStatus == 1 ? 'Approved' : 'Pending'}
                                        </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty c.publicDate}">
                                    <fmt:formatDate value="${c.publicDate}" pattern="ss:mm:HH dd-MM-yyyy"/>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty c.courseLastUpdate}">
                                    <fmt:formatDate value="${c.courseLastUpdate}" pattern="ss:mm:HH dd-MM-yyyy"/>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${c.isSale == 1}">
                                    <c:choose>
                                        <c:when test="${c.salePrice == 0}">
                                            <span class="price-sale text-success fw-bold">Free</span><br>
                                        </c:when>
                                        <c:otherwise>
                                                        <span class="price-sale">
                                                            <fmt:formatNumber value="${c.salePrice}" pattern="#,##0"/> VND
                                                        </span><br>
                                        </c:otherwise>
                                    </c:choose>

                                    <span class="price-original text-decoration-line-through text-muted">
                                                    <fmt:formatNumber value="${c.originalPrice}" pattern="#,##0"/> VND
                                                </span>
                                </c:when>

                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${c.originalPrice == 0}">
                                            <span class="text-success fw-bold">Free</span>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${c.originalPrice}" pattern="#,##0"/> VND
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="d-flex flex-column gap-1">
                            <button class="btn btn-sm btn-warning" data-bs-toggle="modal"
                                    data-bs-target="#updateModal${c.courseID}">
                                <i class="fas fa-edit"></i>
                            </button>

                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                    data-bs-target="#deleteModal${c.courseID}">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
<jsp:include page="/layout/footerInstructor.jsp"/>

<!-- Create Course Modal -->
<div class="modal fade" id="createCourseModal" tabindex="-1" aria-labelledby="createCourseModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form id="createCourseForm" action="${pageContext.request.contextPath}/instructor/courses?action=create" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="createCourseModalLabel">Create New Course</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="userID" value="${user.userId}"/>

                    <div class="mb-3">
                        <label for="courseName" class="form-label">Course Name</label>
                        <input type="text" class="form-control" id="courseName" name="courseName" maxlength="30"
                               required>
                    </div>

                    <div class="mb-3">
                        <label for="courseCategory" class="form-label">Category</label>
                        <input type="text" class="form-control" id="courseCategory" name="courseCategory" required>
                    </div>

                    <div class="mb-3">
                        <label for="originalPrice" class="form-label">Original Price (VND)</label>
                        <input type="number" class="form-control" id="originalPrice" name="originalPrice" min="0"
                               max="10000000" required>
                    </div>

                    <div class="mb-3">
                        <label for="salePrice" class="form-label">Sale Price (VND)</label>
                        <input type="number" class="form-control" id="salePrice" name="salePrice" min="0" max="10000000"
                               required>
                    </div>

                    <div class="mb-3">
                        <label for="courseImageLocation" class="form-label">Course Image URL</label>
                        <input type="url" class="form-control" id="courseImageLocation" name="courseImageLocation"
                               placeholder="https://example.com/image.jpg" required>
                    </div>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="isSale" name="isSale" value="1">
                        <label class="form-check-label" for="isSale">
                            On Sale
                        </label>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Create Course</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<c:forEach var="course" items="${listCourse}">

    <!-- Update Modal -->
    <div class="modal fade" id="updateModal${course.courseID}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <form id="updateCourseForm${course.courseID}" action="${pageContext.request.contextPath}/instructor/courses?action=update" method="POST"
                  class="modal-content bg-white">
                <div class="modal-header">
                    <h5 class="modal-title">Update Course</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="courseID" value="${course.courseID}"/>
                    <input type="hidden" name="userID" value="${user.userId}"/>

                    <div class="mb-3">
                        <label class="form-label">Course Name</label>
                        <input type="text" name="courseName" id="updateCourseName${course.courseID}"
                               value="${course.courseName}" class="form-control" maxlength="30" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <input type="text" name="courseCategory" id="updateCourseCategory${course.courseID}"
                               value="${course.courseCategory}" class="form-control" maxlength="30" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Original Price</label>
                        <input type="number" name="originalPrice" value="${course.originalPrice}" class="form-control"
                               id="updateOriginalPrice${course.courseID}" min="0" max="10000000" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Sale Price</label>
                        <input type="number" name="salePrice" value="${course.salePrice}" class="form-control"
                               id="updateSalePrice${course.courseID}" min="0" max="10000000" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Image URL</label>
                        <input type="url" name="courseImageLocation" value="${course.courseImageLocation}"
                               class="form-control" required>
                    </div>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="isSale${course.courseID}" name="isSale"
                               value="1"
                            ${course.isSale == 1 ? 'checked' : ''}>
                        <label class="form-check-label" for="isSale${course.courseID}">
                            On Sale
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Save changes</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal${course.courseID}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/instructor/courses?action=delete" method="POST" class="modal-content bg-white">
                <div class="modal-header">
                    <h5 class="modal-title text-danger">Delete Course</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="userID" value="${user.userId}"/>
                    <input type="hidden" name="courseID" value="${course.courseID}"/>
                    <p>Are you sure you want to delete <strong>${course.courseName}</strong>?</p>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-danger">Yes, Delete</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</c:forEach>


<div id="jsToast"
     class="toast align-items-center text-white bg-danger border-0 position-fixed bottom-0 end-0 m-3 d-none"
     role="alert">
    <div class="d-flex">
        <div class="toast-body" id="jsToastMessage">
            <!-- Error content will be inserted using JS -->
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
    </div>
</div>

<%--        Check Create Input--%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // ======= Form Validation cho CREATE =======
        const createForm = document.getElementById("createCourseForm");
        if (createForm) {
            createForm.addEventListener("submit", function (e) {
                const nameInput = document.getElementById("courseName");
                const categoryInput = document.getElementById("courseCategory");
                const originalPriceInput = document.getElementById("originalPrice");
                const salePriceInput = document.getElementById("salePrice");

                const name = nameInput.value.trim();
                const category = categoryInput.value.trim();
                const regexValid = /^(?!.*\d)(?!.* {2,}).+$/u;

                // Check Course Name
                if (name.length === 0) {
                    showJsToast("Course Name is required.");
                    nameInput.focus();
                    e.preventDefault();
                    return;
                }
                if (name.length > 30) {
                    showJsToast("Course Name must not exceed 30 characters.");
                    nameInput.focus();
                    e.preventDefault();
                    return;
                }
                if (!regexValid.test(name)) {
                    showJsToast("Course Name is invalid.<br>- Only letters allowed.<br>- No extra spaces.");
                    nameInput.focus();
                    e.preventDefault();
                    return;
                }

                // Check Category
                if (category.length === 0) {
                    showJsToast("Category is required.");
                    categoryInput.focus();
                    e.preventDefault();
                    return;
                }
                if (category.length > 30) {
                    showJsToast("Category must not exceed 30 characters.");
                    categoryInput.focus();
                    e.preventDefault();
                    return;
                }
                if (!regexValid.test(category)) {
                    showJsToast("Category is invalid.<br>- Only letters allowed.<br>- No extra spaces.");
                    categoryInput.focus();
                    e.preventDefault();
                    return;
                }

                // Check Price
                const originalPrice = parseFloat(originalPriceInput.value);
                const salePrice = parseFloat(salePriceInput.value);

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
                    showJsToast("Sale Price cannot be greater than Original Price.");
                    salePriceInput.focus();
                    e.preventDefault();
                    return;
                }

                nameInput.value = name;
                categoryInput.value = category;
            });
        }

        // ======= Form Validation cho tất cả UPDATE FORMs =======
        document.querySelectorAll("form[id^='updateCourseForm']").forEach(function (form) {
            form.addEventListener("submit", function (e) {
                const courseID = form.id.replace("updateCourseForm", "");
                const nameInput = document.getElementById("updateCourseName" + courseID);
                const categoryInput = document.getElementById("updateCourseCategory" + courseID);
                const originalPriceInput = document.getElementById("updateOriginalPrice" + courseID);
                const salePriceInput = document.getElementById("updateSalePrice" + courseID);

                const name = nameInput.value.trim();
                const category = categoryInput.value.trim();
                const originalPrice = parseInt(originalPriceInput.value);
                const salePrice = parseInt(salePriceInput.value);
                const regexValid = /^(?!.*\d)(?!.* {2,}).+$/u;

                // Check Course Name
                if (name.length === 0) {
                    showJsToast("Course Name is required.");
                    nameInput.focus();
                    e.preventDefault();
                    return;
                }
                if (name.length > 30) {
                    showJsToast("Course Name must not exceed 30 characters.");
                    nameInput.focus();
                    e.preventDefault();
                    return;
                }
                if (!regexValid.test(name)) {
                    showJsToast("Course Name is invalid.<br>- Only letters allowed.<br>- No extra spaces.");
                    nameInput.focus();
                    e.preventDefault();
                    return;
                }

                // Check Category
                if (category.length === 0) {
                    showJsToast("Category is required.");
                    categoryInput.focus();
                    e.preventDefault();
                    return;
                }
                if (category.length > 30) {
                    showJsToast("Category must not exceed 30 characters.");
                    categoryInput.focus();
                    e.preventDefault();
                    return;
                }
                if (!regexValid.test(category)) {
                    showJsToast("Category is invalid.<br>- Only letters allowed.<br>- No extra spaces.");
                    categoryInput.focus();
                    e.preventDefault();
                    return;
                }

                // Check Price
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
                    showJsToast("Sale Price cannot be greater than Original Price.");
                    salePriceInput.focus();
                    e.preventDefault();
                    return;
                }

                nameInput.value = name;
                categoryInput.value = category;
            });
        });

        // ======= Show Toast if available =======
        const toastEl = document.querySelector('.toast');
        if (toastEl) {
            const bsToast = new bootstrap.Toast(toastEl, {delay: 3000});
            bsToast.show();
        }
    });
</script>

<script>
    function showJsToast(message, type = 'danger') {
        const toastEl = document.getElementById('jsToast');
        const toastMsg = document.getElementById('jsToastMessage');

        toastMsg.innerHTML = message; // dùng innerHTML để hỗ trợ <br>

        toastEl.classList.remove('d-none', 'bg-danger', 'bg-success', 'bg-warning', 'bg-info');
        toastEl.classList.add('bg-' + type);

        const bsToast = new bootstrap.Toast(toastEl, {delay: 4000});
        bsToast.show();
    }
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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
