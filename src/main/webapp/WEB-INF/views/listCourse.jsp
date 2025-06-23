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

            .link-hover {
                color: inherit;
                text-decoration: none;
                transition: color 0.2s ease;
            }

            .link-hover:hover {
                color: #0d6efd;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/layout/sidebar_user.jsp"/>

        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="${pageContext.request.contextPath}/instructor" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back
                </a>

                <a href="${pageContext.request.contextPath}/instructor/courses?action=create" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Create New Course
                </a>
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
                                           class="link-hover">
                                            ${c.courseName}
                                        </a>
                                    </td>
                                    <td>${c.category.name}</td>
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
                                                <fmt:formatDate value="${c.publicDate}" pattern="HH:mm dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty c.courseLastUpdate}">
                                                <fmt:formatDate value="${c.courseLastUpdate}" pattern="HH:mm dd/MM/yyyy"/>
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
                                        <a href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${c.courseID}"
                                           class="btn btn-sm btn-info text-white">
                                            <i class="fas fa-eye"></i>
                                        </a>

                                        <a href="${pageContext.request.contextPath}/instructor/courses?action=update&courseID=${c.courseID}" class="btn btn-warning btn-sm">
                                            <i class="fas fa-edit"></i>
                                        </a>

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
        <jsp:include page="/layout/footer.jsp"/>

        <c:forEach var="course" items="${listCourse}">
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
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>

        <script>
            function showJsToast(message, type = 'danger') {
                const toastEl = document.getElementById('jsToast');
                const toastMsg = document.getElementById('jsToastMessage');

                toastMsg.innerHTML = message;

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
