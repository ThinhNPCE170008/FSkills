<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Material Details | F-Skill</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap JS (bundle includes Popper) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            body {
                background: linear-gradient(135deg, #f0f4ff, #f9f9f9);
                font-family: 'Segoe UI', sans-serif;
            }
            .card-custom {
                border: none;
                border-radius: 20px;
                box-shadow: 0 12px 25px rgba(0, 0, 0, 0.1);
                background-color: #ffffff;
                overflow: hidden;
            }
            .section-title {
                font-size: 1.3rem;
                font-weight: 600;
                color: #495057;
                margin-top: 1.5rem;
            }
            .info-block {
                padding: 1rem;
                border-radius: 12px;
                background-color: #f8f9fa;
                margin-bottom: 1rem;
            }
            .info-label {
                color: #6c757d;
                font-weight: 500;
                margin-bottom: 0.25rem;
            }
            .info-value {
                font-size: 1.1rem;
                font-weight: 600;
                color: #212529;
            }
            .material-type-icon {
                font-size: 1.2rem;
                color: #0d6efd;
            }
            .btn-back {
                font-size: 1rem;
                padding: 0.6rem 1.2rem;
            }
            .description-box {
                background-color: #f1f3f5;
                padding: 1rem;
                border-radius: 12px;

            }
        </style>
    </head>
    <body>
        <jsp:include page="/layout/sidebar_user.jsp"/>

        <div class="container-fluid flex px-4">
            <div class="container py-5" style="margin-left">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item inline-flex items-center"><a class="text-indigo-600 hover:text-indigo-700 font-medium no-underline" href="${pageContext.request.contextPath}/instructor">Home</a></li>
                        <li class="breadcrumb-item inline-flex items-center"><a class="text-indigo-600 hover:text-indigo-700 font-medium no-underline" href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${course.courseID}">${course.courseName}</a></li>
                        <li class="breadcrumb-item inline-flex items-center"><a class="text-indigo-600 hover:text-indigo-700 font-medium no-underline" href="${pageContext.request.contextPath}/instructor/courses/modules/material?moduleId=${module.moduleID}&courseId=${course.courseID}">${module.moduleName}</a></li>
                        <li class="breadcrumb-item active">Material Details</li>
                    </ol>
                </nav>

                <div class="card card-custom p-4">
                    <h1 class="text-center mb-4 fw-bold text-primary-emphasis display-5" style="text-shadow: 1px 1px 2px rgba(0,0,0,0.1);">
                        <i class="bi bi-journal-text me-2" style="font-size: 2rem;"></i>
                        <span style="border-bottom: 4px solid #0d6efd; padding-bottom: 6px;">Material Details</span>
                    </h1>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="section-title">Material Name</div>
                            <div class="info-block">
                                <div class="info-value">${material.materialName}</div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="section-title">Material Type</div>
                            <div class="info-block">
                                <div class="info-value text-capitalize">
                                    <i class="bi bi-${material.type eq 'video' ? 'camera-video-fill' : material.type eq 'pdf' ? 'file-earmark-pdf' : 'link-45deg'} material-type-icon me-2"></i>
                                    ${material.type}
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${material.type eq 'video'}">
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
                    </c:if>


                    <c:if test="${material.type eq 'pdf'}">
                        <div class="section-title">Document</div>
                        <div class="info-block">
                            <div class="info-value">
                                <a href="${pageContext.request.contextPath}/downloadmaterial?id=${material.materialId}"
                                   class="text-primary text-decoration-underline"
                                   target="_blank">
                                    ${material.fileName}
                                </a>
                            </div>
                        </div>
                    </c:if>


                    <c:if test="${material.type eq 'link'}">
                        <div class="section-title">Link</div>
                        <div class="info-block">
                            <div class="info-value">
                                <a href="${material.materialUrl}" 
                                   class="text-decoration-underline text-primary" target="_blank">
                                    ${material.materialUrl}
                                </a>
                            </div>
                        </div>
                    </c:if>


                    <div class="row">
                        <div class="col-md-6">
                            <div class="section-title">Display Order</div>
                            <div class="info-block">
                                <div class="info-value">${material.materialOrder}</div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="section-title">Description</div>
                        <div class="info-block">
                            <div class="fs-6 info-value" style="line-height: 1.8;">
                                <pre style="font-family: inherit; background: none; border: none; padding: 0; white-space: pre-wrap;"><c:out value="${material.materialDescription}" /></pre>

                            </div>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/instructor/courses/modules/material?courseId=${course.courseID}&moduleId=${module.moduleID}" class="btn btn-secondary btn-back">
                            <i class="bi bi-arrow-left-circle"></i> Back
                        </a>
                    </div>
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
        <jsp:include page="/layout/footer.jsp"/>
        <jsp:include page="/layout/toast.jsp"/>
    </body>
</html>
