<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Course List | F-Skill</title>
        <meta charset="UTF-8">
        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">

        <!-- Bootstrap 5 -->
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
        </style>
    </head>
    <body>

        <div class="container py-5">
            <h2 class="text-center">Course List</h2>
            <div class="mb-3">
                <a href="instructor" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>

            <div class="d-flex justify-content-end align-items-center mb-3">
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
                                <th>Actions</th> <!-- NEW -->
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="c" items="${listCourse}">
                                <tr>
                                    <td>
                                        <img src="${c.courseImageLocation}" class="course-image" alt="Course Image">
                                    </td>
                                    <td>${c.courseName}</td>
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
                                                <fmt:formatDate value="${c.publicDate}" pattern="yyyy-MM-dd" />
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty c.courseLastUpdate}">
                                                <fmt:formatDate value="${c.courseLastUpdate}" pattern="yyyy-MM-dd" />
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${c.isSale == 1}">
                                                <span class="price-sale">
                                                    <fmt:formatNumber value="${c.salePrice}" type="currency" currencyCode="VND"/>
                                                </span><br>
                                                <span class="price-original">
                                                    <fmt:formatNumber value="${c.originalPrice}" type="currency" currencyCode="VND"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${c.originalPrice}" type="currency" currencyCode="VND"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-warning" data-bs-toggle="modal"
                                                data-bs-target="#updateModal${c.courseID}">Update</button>

                                        <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                data-bs-target="#deleteModal${c.courseID}">Delete</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Create Course Modal -->
        <div class="modal fade" id="createCourseModal" tabindex="-1" aria-labelledby="createCourseModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <form id="createCourseForm" action="instructor?action=create" method="POST">
                        <div class="modal-header">
                            <h5 class="modal-title" id="createCourseModalLabel">Create New Course</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="userID" value="${user.userId}" />

                            <div class="mb-3">
                                <label for="courseName" class="form-label">Course Name</label>
                                <input type="text" class="form-control" id="courseName" name="courseName"
                                       pattern="^[\p{L}\s]+$" title="Only letters and spaces are allowed" maxlength="30" required>
                            </div>

                            <div class="mb-3">
                                <label for="courseCategory" class="form-label">Category</label>
                                <input type="text" class="form-control" id="courseCategory" name="courseCategory"
                                       pattern="^[\p{L}\s]+$" title="Only letters and spaces are allowed" required>
                            </div>

                            <div class="mb-3">
                                <label for="originalPrice" class="form-label">Original Price (VND)</label>
                                <input type="number" class="form-control" id="originalPrice" name="originalPrice"
                                       min="0" max="10000000" required>
                            </div>

                            <div class="mb-3">
                                <label for="salePrice" class="form-label">Sale Price (VND)</label>
                                <input type="number" class="form-control" id="salePrice" name="salePrice"
                                       min="0" max="10000000" required>
                            </div>

                            <div class="mb-3">
                                <label for="courseImageLocation" class="form-label">Course Image URL</label>
                                <input type="url" class="form-control" id="courseImageLocation"
                                       name="courseImageLocation" placeholder="https://example.com/image.jpg" required>
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
                    <form id="updateCourseForm${course.courseID}" action="instructor?action=update" method="POST" class="modal-content bg-white">
                        <div class="modal-header">
                            <h5 class="modal-title">Update Course</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="courseID" value="${course.courseID}" />
                            <input type="hidden" name="userID" value="${user.userId}" />

                            <div class="mb-3">
                                <label class="form-label">Course Name</label>
                                <input type="text" name="courseName" id="updateCourseName${course.courseID}" value="${course.courseName}" class="form-control"
                                       pattern="^[\p{L}\s]+$" title="Only letters and spaces are allowed" maxlength="30" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Category</label>
                                <input type="text" name="courseCategory" id="updateCourseCategory${course.courseID}" value="${course.courseCategory}" class="form-control"
                                       pattern="^[\p{L}\s]+$" title="Only letters and spaces are allowed" maxlength="30" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Original Price</label>
                                <input type="number" name="originalPrice" value="${course.originalPrice}" class="form-control"
                                       min="0" max="10000000" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Sale Price</label>
                                <input type="number" name="salePrice" value="${course.salePrice}" class="form-control"
                                       min="0" max="10000000" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Image URL</label>
                                <input type="url" name="courseImageLocation" value="${course.courseImageLocation}" class="form-control" required>
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="isSale${course.courseID}" name="isSale" value="1"
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
                    <form action="instructor?action=delete" method="POST" class="modal-content bg-white">
                        <div class="modal-header">
                            <h5 class="modal-title text-danger">Delete Course</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="userID" value="${user.userId}" />
                            <input type="hidden" name="courseID" value="${course.courseID}" />
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

        <c:if test="${not empty err}">
            <div class="toast-container position-fixed bottom-0 end-0 p-3">
                <div class="toast align-items-center text-bg-danger border-0 show" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body">
                            ${err}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Check Create Input-->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const form = document.getElementById("createCourseForm");

                form.addEventListener("submit", function (e) {
                    const nameInput = document.getElementById("courseName");
                    const categoryInput = document.getElementById("courseCategory");

                    const name = nameInput.value.trim();
                    const category = categoryInput.value.trim();

                    const regexValid = /^[\p{L}]+(?: [\p{L}]+)*$/u;
                    // Giải thích:
                    // - bắt đầu bằng chữ
                    // - mỗi từ cách nhau đúng 1 space
                    // - không ký tự đặc biệt, không số

                    if (name.length === 0 || name.length > 30 || !regexValid.test(name)) {
                        alert("Invalid Course Name.\n- Only letters allowed.\n- No extra spaces.\n- Max 30 characters.");
                        nameInput.focus();
                        e.preventDefault();
                        return;
                    }

                    if (category.length === 0 || category.length > 30 || !regexValid.test(category)) {
                        alert("Invalid Category.\n- Only letters allowed.\n- No extra spaces.\n- Max 30 characters.");
                        categoryInput.focus();
                        e.preventDefault();
                        return;
                    }

                    // Replace original input value with trimmed version (optional but helpful)
                    nameInput.value = name;
                    categoryInput.value = category;
                });
            });
        </script>

        <!-- Check Update Input-->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Lặp qua tất cả form có id bắt đầu bằng "updateCourseForm"
                document.querySelectorAll("form[id^='updateCourseForm']").forEach(function (form) {
                    form.addEventListener("submit", function (e) {
                        const courseID = form.id.replace("updateCourseForm", "");
                        const nameInput = document.getElementById("updateCourseName" + courseID);
                        const categoryInput = document.getElementById("updateCourseCategory" + courseID);

                        const name = nameInput.value.trim();
                        const category = categoryInput.value.trim();
                        const regexValid = /^[\p{L}]+(?: [\p{L}]+)*$/u;

                        if (name.length === 0 || name.length > 30 || !regexValid.test(name)) {
                            alert("Invalid Course Name.\n- Only letters allowed.\n- No extra spaces.\n- Max 30 characters.");
                            nameInput.focus();
                            e.preventDefault();
                            return;
                        }

                        if (category.length === 0 || category.length > 30 || !regexValid.test(category)) {
                            alert("Invalid Category.\n- Only letters allowed.\n- No extra spaces.\n- Max 30 characters.");
                            categoryInput.focus();
                            e.preventDefault();
                            return;
                        }

                        nameInput.value = name;
                        categoryInput.value = category;
                    });
                });
            });
        </script>

        <!-- Error Message -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const toastEl = document.querySelector('.toast');
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
