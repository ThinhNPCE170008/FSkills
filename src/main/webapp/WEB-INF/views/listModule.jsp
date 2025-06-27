<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>List Module | F-Skill</title>
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
<jsp:include page="/layout/sidebar_user.jsp"/>

<div class="container py-5">
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <a href="${pageContext.request.contextPath}/instructor/courses?action=list" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModuleModal">
                <i class="fas fa-plus"></i> Create New Course
            </button>
        </div>

        <div class="info-box d-flex align-items-center gap-4 mb-4">
            <c:if test="${not empty course}">
                <img src="${course.courseImageLocation}" class="rounded me-3"
                     style="width: 160px; height: 100px; object-fit: cover;" alt="Avatar">
                <div>
                    <h5 class="mb-1"><strong>Course Name:</strong> ${course.courseName}</h5>
                    <p class="mb-0"><strong>Category:</strong> ${course.category.name}</p>
                    <p class="mb-0">
                        <strong>Status:</strong>
                        <span class="badge ${course.approveStatus == 1 ? 'badge-approved' : 'badge-pending'}">
                                ${course.approveStatus == 1 ? 'Approved' : 'Pending'}
                        </span>
                    </p>
                    <p class="mb-0">
                        <strong>Public Date:</strong>
                        <c:choose>
                            <c:when test="${not empty course.publicDate}">
                                <fmt:formatDate value="${course.publicDate}" pattern="HH:mm dd-MM-yyyy"/>
                            </c:when>
                            <c:otherwise>N/A</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty listModule}">
                <div class="alert alert-warning text-center">No courses available.</div>
            </c:when>
            <c:otherwise>
                <table class="table table-bordered table-hover shadow-sm bg-white rounded">
                    <thead>
                    <tr>
                        <th>Module Name</th>
                        <th>Module Last Update</th>
                        <th>Actions</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="module" items="${listModule}">
                        <tr>
                            <td>${module.moduleName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty module.moduleLastUpdate}">
                                        <fmt:formatDate value="${module.moduleLastUpdate}" pattern="HH:mm dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="d-flex flex-column gap-1">
                                <a href="${pageContext.request.contextPath}/instructor/courses/modules/material?moduleId=${module.moduleID}&courseId=${course.courseID}" 
                                   class="btn btn-sm btn-info text-white">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <button class="btn btn-sm btn-warning" data-bs-toggle="modal"
                                        data-bs-target="#updateModal${module.moduleID}">
                                    <i class="fas fa-edit"></i>
                                </button>

                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                        data-bs-target="#deleteModal${module.moduleID}">
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
</div>
<jsp:include page="/layout/footer.jsp" />

<!-- Create Module Modal -->
<div class="modal fade" id="createModuleModal" tabindex="-1" aria-labelledby="createModuleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form id="createModuleForm" action="${pageContext.request.contextPath}/instructor/courses/modules?action=create" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="createModuleModalLabel">Create New Module</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="courseID" value="${course.courseID}"/>

                    <div class="mb-3">
                        <label for="moduleName" class="form-label">Module Name</label>
                        <input type="text" class="form-control" id="moduleName" name="moduleName"
                               pattern="^[\p{L}\s]+$" title="Only letters and spaces are allowed" maxlength="30"
                               required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Create Module</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<c:forEach var="module" items="${listModule}">
    <!-- Update Modal -->
    <div class="modal fade" id="updateModal${module.moduleID}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <form id="updateModuleForm${module.moduleID}" action="${pageContext.request.contextPath}/instructor/courses/modules?action=update" method="POST"
                  class="modal-content bg-white">
                <div class="modal-header">
                    <h5 class="modal-title">Update Module</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="moduleID" value="${module.moduleID}"/>
                    <input type="hidden" name="courseID" value="${course.courseID}"/>

                    <div class="mb-3">
                        <label class="form-label">Module Name</label>
                        <input type="text" name="moduleName" id="updateModuleName${module.moduleID}"
                               value="${module.moduleName}" class="form-control"
                               pattern="^[\p{L}\s]+$" title="Only letters and spaces are allowed" maxlength="30"
                               required>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Save changes</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal${module.moduleID}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/instructor/courses/modules?action=delete" method="POST" class="modal-content bg-white">
                <div class="modal-header">
                    <h5 class="modal-title text-danger">Delete Module</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="moduleID" value="${module.moduleID}"/>
                    <input type="hidden" name="courseID" value="${course.courseID}"/>
                    <p>Are you sure you want to delete <strong>${module.moduleName}</strong>?</p>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-danger">Yes, Delete</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</c:forEach>

<!-- Check Create Input-->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("createModuleForm");

        form.addEventListener("submit", function (e) {
            const nameInput = document.getElementById("moduleName");
            const name = nameInput.value.trim();
            const regexValid = /^[\p{L}]+(?: [\p{L}]+)*$/u;

            if (name.length === 0 || name.length > 30 || !regexValid.test(name)) {
                alert("Invalid Module Name.\n- Only letters allowed.\n- No extra spaces.\n- Max 30 characters.");
                nameInput.focus();
                e.preventDefault();
                return;
            }
            nameInput.value = name;
        });
    });
</script>

<!-- Check Update Input-->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll("form[id^='updateModuleForm']").forEach(function (form) {
            form.addEventListener("submit", function (e) {
                const moduleID = form.id.replace("updateModuleForm", "");
                const nameInput = document.getElementById("updateModuleName" + moduleID);
                const name = nameInput.value.trim();
                const regexValid = /^[\p{L}]+(?: [\p{L}]+)*$/u;

                if (name.length === 0 || name.length > 30 || !regexValid.test(name)) {
                    alert("Invalid Module Name.\n- Only letters allowed.\n- No extra spaces.\n- Max 30 characters.");
                    nameInput.focus();
                    e.preventDefault();
                    return;
                }
                nameInput.value = name;
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

<c:if test="${not empty err}">
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div class="toast align-items-center text-bg-danger border-0 show" role="alert" aria-live="assertive"
             aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                        ${err}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                        aria-label="Close"></button>
            </div>
        </div>
    </div>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>