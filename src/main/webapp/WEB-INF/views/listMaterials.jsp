<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <title>List Module | F-Skill</title>
        <meta charset="UTF-8">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">


        <!-- Bootstrap 5 JS (phải đặt cuối trang) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            .sidebar {
                width: 250px;
                position: fixed;
                height: 100%;
                background-color: #fff;
                border-right: 1px solid #dee2e6;
                z-index: 1000;
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
            .container-fluid {
                width: 100%;
                padding-left: 0;
                padding-right: 0;
                margin-left: 0;
            }

        </style>
    </head>
    <body>
        <jsp:include page="/layout/sidebar_user.jsp"/>


        <div class="container-fluid flex px-4">
            <div class="container py-10">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item inline-flex items-center"><a class="text-indigo-600 hover:text-indigo-700 font-medium no-underline" href="${pageContext.request.contextPath}/instructor">Home</a></li>
                        <li class="breadcrumb-item inline-flex items-center">
                            <a class="text-indigo-600 hover:text-indigo-700 font-medium no-underline" href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${course.courseID}">${course.courseName}</a>
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
                        <div class="bg-white p-5 rounded-4 shadow-lg mt-6" style="max-width: 1500px;" >
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
                                        <th>Materials</th>
                                        <th>Description</th>
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
                                                    <c:when test="${material.type == 'video' && not empty material.materialUrl}">
                                                        <!-- Tách videoId theo nhiều kiểu -->
                                                        <c:set var="videoId" value="" />

                                                        <!-- 1. Từ embed -->
                                                        <c:if test="${fn:contains(material.materialUrl, 'embed/')}">
                                                            <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'embed/'), '?')}" />
                                                        </c:if>

                                                        <!-- 2. Từ youtu.be/ -->
                                                        <c:if test="${empty videoId && fn:contains(material.materialUrl, 'youtu.be/')}">
                                                            <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'youtu.be/'), '?')}" />
                                                        </c:if>

                                                        <!-- ✅ 3. watch?v= (đã fix) -->
                                                        <c:if test="${empty videoId && fn:contains(material.materialUrl, 'watch?v=')}">
                                                            <c:set var="temp" value="${fn:substringAfter(material.materialUrl, 'watch?v=')}" />
                                                            <c:choose>
                                                                <c:when test="${fn:contains(temp, '&')}">
                                                                    <c:set var="videoId" value="${fn:substringBefore(temp, '&')}" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:set var="videoId" value="${temp}" />
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>

                                                        <!-- 4. Từ v= ở cuối (fallback) -->
                                                        <c:if test="${empty videoId && fn:contains(material.materialUrl, 'v=')}">
                                                            <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'v='), '&')}" />
                                                        </c:if>

                                                        <a href="#" data-bs-toggle="modal" data-bs-target="#videoModal${material.materialId}">
                                                            <img class="img-fluid rounded shadow-sm d-block mx-auto"
                                                                 style="max-height: 160px;"
                                                                 src="https://img.youtube.com/vi/${videoId}/0.jpg"
                                                                 alt="YouTube Thumbnail">
                                                        </a>
                                                    </c:when>

                                                    <c:when test="${material.type == 'pdf' && not empty material.materialFile}">
                                                        <a href="${pageContext.request.contextPath}/downloadmaterial?id=${material.materialId}"
                                                           class="text-primary text-decoration-underline"
                                                           target="_blank">
                                                            ${material.fileName}
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${material.type == 'link' && not empty material.materialUrl}">
                                                        <a href="${material.materialUrl}" target="_blank" class="text-primary text-decoration-underline">
                                                            ${material.materialUrl}
                                                        </a>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Material not available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${fn:length(material.materialDescription) > 100}">
                                                        ${fn:substring(material.materialDescription, 0, 100)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        <pre style="white-space:pre-wrap;">${material.materialDescription}</pre>
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
            <c:choose>
                <c:when test="${material.type == 'video' && not empty material.materialUrl}">
                    <%-- Trích xuất videoId từ mọi loại link YouTube --%>
                    <c:set var="videoId" value="" />

                    <c:if test="${fn:contains(material.materialUrl, 'embed/')}">
                        <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'embed/'), '?')}" />
                    </c:if>
                    <c:if test="${empty videoId && fn:contains(material.materialUrl, 'youtu.be/')}">
                        <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'youtu.be/'), '?')}" />
                    </c:if>
                    <c:if test="${empty videoId && fn:contains(material.materialUrl, 'watch?v=')}">
                        <c:set var="temp" value="${fn:substringAfter(material.materialUrl, 'watch?v=')}" />
                        <c:choose>
                            <c:when test="${fn:contains(temp, '&')}">
                                <c:set var="videoId" value="${fn:substringBefore(temp, '&')}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="videoId" value="${temp}" />
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${empty videoId && fn:contains(material.materialUrl, 'v=')}">
                        <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'v='), '&')}" />
                    </c:if>

                    <%-- Modal hiển thị video YouTube --%>
                    <div class="modal fade" id="videoModal${material.materialId}" tabindex="-1"
                         aria-labelledby="videoModalLabel${material.materialId}" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="videoModalLabel${material.materialId}">Video</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"
                                            ></button>
                                </div>
                                <div class="modal-body">
                                    <div class="ratio ratio-16x9">
                                        <iframe id="youtubeFrame${material.materialId}"
                                                src="https://www.youtube.com/embed/${videoId}"
                                                title="YouTube video" frameborder="0" allowfullscreen>
                                        </iframe>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
            </c:choose>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    // Gắn sự kiện khi bất kỳ modal nào đóng
                    document.querySelectorAll('.modal').forEach(modal => {
                        modal.addEventListener('hidden.bs.modal', function () {
                            const iframe = modal.querySelector('iframe');
                            if (iframe) {
                                const src = iframe.getAttribute('src');
                                iframe.setAttribute('src', '');   // Dừng video
                                iframe.setAttribute('src', src);  // Gán lại để giữ link
                            }
                        });
                    });
                });
            </script>
        </c:forEach>
        <jsp:include page="/layout/footer.jsp"/>
        <jsp:include page="/layout/toast.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
