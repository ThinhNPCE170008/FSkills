<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Material Details | F-Skill</title>
        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

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
                white-space: pre-line;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/layout/headerInstructor.jsp"/>

        <div class="container py-5">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="instructor">Home</a></li>
                    <li class="breadcrumb-item"><a href="managemodule?id=${course.courseID}">${course.courseName}</a></li>
                    <li class="breadcrumb-item"><a href="InstructorMaterial?moduleId=${module.moduleID}&courseId=${course.courseID}">${module.moduleName}</a></li>
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
                        <div class="info-block">
                            <div class="info-label">Material Name</div>
                            <div class="info-value">${material.materialName}</div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="info-block">
                            <div class="info-label">Material Type</div>
                            <div class="info-value text-capitalize">
                                <i class="bi bi-${material.type eq 'video' ? 'camera-video-fill' : material.type eq 'pdf' ? 'file-earmark-pdf' : 'link-45deg'} material-type-icon me-2"></i>
                                ${material.type}
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${material.type eq 'video'}">
                    <div class="section-title">Video Preview</div>
                    <video class="rounded w-100 mb-3" controls>
                        <source src="${pageContext.request.contextPath}/${material.materialLocation}" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                    <div class="info-block">
                        <div class="info-label">Video Duration</div>
                        <div class="info-value">${material.time}</div>
                    </div>
                </c:if>

                <c:if test="${material.type eq 'pdf'}">
                    <div class="info-block">
                        <div class="info-label">Document</div>
                        <div class="info-value">
                            <a href="${pageContext.request.contextPath}/${material.materialLocation}" class="btn btn-outline-primary" target="_blank">
                                <i class="bi bi-file-earmark-pdf"></i> View Document
                            </a>
                        </div>
                    </div>
                </c:if>

                <c:if test="${material.type eq 'link'}">
                    <div class="info-block">
                        <div class="info-label">Material Link</div>
                        <div class="info-value">
                            <a href="${material.materialLocation}" class="text-decoration-underline text-primary" target="_blank">
                                ${material.materialLocation}
                            </a>
                        </div>
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-6">
                        <div class="info-block">
                            <div class="info-label">Display Order</div>
                            <div class="info-value">${material.materialOrder}</div>
                        </div>
                    </div>
                </div>

                <div class="section-title">Description</div>
                <div class="description-box">
                    <c:out value="${material.materialDescription}" default="No description provided."/>
                </div>

                <div class="text-center mt-4">
                    <a href="InstructorMaterial?courseId=${course.courseID}&moduleId=${module.moduleID}" class="btn btn-secondary btn-back">
                        <i class="bi bi-arrow-left-circle"></i> Back
                    </a>
                </div>
            </div>
        </div>

    </body>
</html>
