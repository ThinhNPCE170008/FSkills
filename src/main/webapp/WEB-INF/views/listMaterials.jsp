<%-- 
    Document   : materials
    Created on : 20/06/2025, 2:36:00 PM
    Author     : Hua Khanh Duy - CE180230 - SE1814
--%>
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

        <div class="container py-2 ps-3">
            <div class="container py-2 ps-3">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/instructor">Home</a></li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${course.courseID}">${course.courseName}</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            ${module.moduleName}
                        </li>
                    </ol>


                </nav>
                <div class="text-end">
                    <a href="${pageContext.request.contextPath}/instructor/courses/modules/material?action=create&moduleId=${module.moduleID}&courseId=${course.courseID}"
                       class="btn btn-lg d-inline-flex align-items-center gap-2 px-4 py-2 rounded-pill shadow-sm fw-semibold text-white"
                       style="background: linear-gradient(135deg, #0d6efd, #0a58ca); transition: all 0.3s ease;"
                       onmouseover="this.style.background = 'linear-gradient(135deg, #0a58ca, #0d6efd)'"
                       onmouseout="this.style.background = 'linear-gradient(135deg, #0d6efd, #0a58ca)'">
                        <span>New Material</span>
                        <i class="bi bi-plus-circle fs-5"></i>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty listMaterial}">
                        <div class="alert alert-warning text-center mt-6">No material available.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-white p-5 rounded-4 shadow-lg mx-auto mt-6" style="max-width: 1500px;" >
                            <h1 class="text-center mb-4 fw-bold text-primary-emphasis display-5" style="text-shadow: 1px 1px 2px rgba(0,0,0,0.1);">
                                <i class="bi bi-journal-text me-2" style="font-size: 2rem;"></i>
                                <span style="border-bottom: 4px solid #0d6efd; padding-bottom: 6px;">All Material</span>
                            </h1>

                            <table class="table table-bordered table-hover shadow-sm bg-white rounded mt-4">
                                <thead>
                                    <tr>
                                        <th>Order</th>
                                        <th>Name</th>
                                        <th>Type</th>
                                        <th>Video</th>
                                        <th>Last Update</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="material" items="${listMaterial}">
                                        <tr>
                                            <!-- Name -->
                                            <td>${material.materialOrder}</td>
                                            <td>${material.materialName}</td>

                                            <!-- Type -->
                                            <td>${material.type}</td>

                                            <td>
                                                <c:choose>

                                                    <c:when test="${material.type == 'video' && not empty material.materialLocation}">
                                                        <a href="#" data-bs-toggle="modal" data-bs-target="#videoModal${material.materialId}">
                                                            <video class="img-fluid rounded shadow-sm d-block mx-auto" style="max-height: 160px;" muted>
                                                                <source src="${pageContext.request.contextPath}/${material.materialLocation}" type="video/mp4">

                                                                Your browser does not support the video tag.
                                                            </video>

                                                        </a>
                                                    </c:when>


                                                    <c:when test="${material.type == 'pdf' && not empty material.materialLocation}">
                                                        <a href="${material.materialLocation}" target="_blank">
                                                            ${material.materialLocation}
                                                        </a>
                                                    </c:when>


                                                    <c:when test="${material.type == 'link' && not empty material.materialLocation}">
                                                        <a href="${material.materialLocation}" target="_blank">
                                                            ${material.materialLocation}
                                                        </a>
                                                    </c:when>


                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Material not available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>


                                            <!-- Last Update -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty material.materialLastUpdate}">
                                                        <fmt:formatDate value="${material.materialLastUpdate}" pattern=" HH:mm dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Actions -->
                                            <td class="align-middle text-center">
                                                <div class="d-flex justify-content-center gap-2">
                                                    <a class="btn btn-outline-info btn-sm" type="button"
                                                       href="${pageContext.request.contextPath}/instructor/courses/modules/material?action=details&moduleId=${module.moduleID}&courseId=${course.courseID}&materialId=${material.materialId}" >
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a class="btn btn-primary btn-sm"
                                                       href="${pageContext.request.contextPath}/instructor/courses/modules/material?action=update&moduleId=${module.moduleID}&courseId=${course.courseID}&materialId=${material.materialId}">
                                                        <i class="fas fa-edit"></i>
                                                    </a>


                                                    <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                                                            data-bs-target="#deleteModal${material.materialId}">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <jsp:include page="/layout/footer.jsp"/>
        <!-- Delete Modal -->
        <c:forEach var="material" items="${listMaterial}">
            <div class="modal fade" id="deleteModal${material.materialId}" tabindex="-1" aria-labelledby="deleteModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteModalLabel">Confirm Delete Material</h5>

                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="POST" action="${pageContext.request.contextPath}/instructor/courses/modules/material?action=delete">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="moduleId" value="${module.moduleID}">
                            <input type="hidden" name="courseId" value="${course.courseID}">
                            <div class="modal-body">
                                <input type="hidden" name="id" value="${material.materialId}">
                                <p>Are you sure you want to delete this material?</p>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Back</button>
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!-- Video Modal -->                 
            <c:if test="${not empty material.materialLocation}">
                <div class="modal fade" id="videoModal${material.materialId}" tabindex="-1" aria-labelledby="videoModalLabel${material.materialId}" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="videoModalLabel${material.materialId}">${material.materialName}</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body text-center">
                                <video controls style="width: 100%; height: auto;">
                                    <source src="${material.materialLocation}" type="video/mp4">
                                    Your browser does not support the video tag.
                                </video>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>             

        </c:forEach>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>