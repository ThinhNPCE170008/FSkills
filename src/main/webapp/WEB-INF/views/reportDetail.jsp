<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Report Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                font-family: 'Inter', sans-serif;
            }

            .container-fluid {
                width: 100%;
                padding-left: 0;
                padding-right: 0;
                margin-left: 0;
            }

            .report-card {
                background: white;
                border-radius: 16px;
                padding: 2rem;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }

            .report-card:hover {
                transform: translateY(-5px);
            }

            .badge-comment {
                background-color: #3b82f6;
                font-size: 0.9rem;
                padding: 0.5rem 1rem;
                border-radius: 20px;
            }

            .badge-material {
                background-color: #8b5cf6;
                font-size: 0.9rem;
                padding: 0.5rem 1rem;
                border-radius: 20px;
            }

            .header-title {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                color: #1e293b;
                font-weight: 700;
            }

            .detail-label {
                color: #64748b;
                font-weight: 600;
                font-size: 0.85rem;
                text-transform: uppercase;
            }

            .detail-value {
                color: #1e293b;
                font-weight: 500;
                font-size: 1.1rem;
            }

            .detail-value a {
                color: #1e40af;
                text-decoration: none;
                transition: color 0.2s ease;
            }

            .detail-value a:hover {
                color: #3b82f6;
                text-decoration: underline;
            }

            .back-button {
                background-color: #e2e8f0;
                color: #1e293b;
                font-weight: 500;
                padding: 0.5rem 1.5rem;
                border-radius: 8px;
                text-decoration: none;
                transition: background-color 0.2s ease, transform 0.2s ease;
            }

            .back-button:hover {
                background-color: #3b82f6;
                color: white;
                transform: translateY(-2px);
            }

            .back-button i {
                margin-right: 0.3rem;
            }

            .header-section {
                background: #f1f5f9;
                padding: 1.5rem;
                border-radius: 12px;
                margin-bottom: 2rem;
            }

            .detail-section {
                padding: 1rem 0;
                border-bottom: 1px solid #e2e8f0;
            }

            .detail-section:last-child {
                border-bottom: none;
            }

            .grid-container {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 2rem;
            }

            .full-width-section {
                grid-column: 1 / -1;
            }

            .report-detail-text {
                color: #1e293b;
                font-size: 0.95rem;
                line-height: 1.6;
                background: #f9fafb;
                padding: 1rem;
                border-radius: 8px;
                border: 1px solid #e5e7eb;
            }

            @media (max-width: 768px) {
                .report-card {
                    padding: 1.5rem;
                }

                .grid-container {
                    grid-template-columns: 1fr;
                    gap: 1.5rem;
                }

                .detail-value {
                    font-size: 1rem;
                }

                .header-section {
                    padding: 1rem;
                }

                .report-detail-text {
                    font-size: 0.95rem;
                }
            }
        </style>
    </head>
    <body class="min-h-screen">
        <jsp:include page="/layout/sidebar_admin.jsp"/>

        <div class="container-fluid flex px-4">
            <div class="container py-10">
                <div class="report-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="header-title text-2xl">
                            <span class="text-3xl">📄</span> Report Details
                        </h4>
                        <a href="${pageContext.request.contextPath}/admin/report" class="back-button">
                            <i class="fas fa-arrow-left"></i> Back to Reports
                        </a>
                    </div>

                    <!-- Header Section -->
                    <div class="header-section">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <c:choose>
                                <c:when test="${not empty report.commentId}">
                                    <span class="badge badge-comment text-white">🗨️ Comment</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-material text-white">🎬 Material</span>
                                </c:otherwise>
                            </c:choose>
                            <span class="text-muted font-medium">
                                <fmt:formatDate value="${report.reportDate}" pattern="dd MMM yyyy, HH:mm"/>
                            </span>
                        </div>
                        <div class="detail-label">Report ID: ${report.reportId}</div>
                    </div>

                    <!-- Main Content -->
                    <div class="grid-container">
                        <!-- Left Column -->
                        <div>
                            <div class="detail-section">
                                <div class="detail-label">Content</div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${not empty report.commentId}">
                                            <a href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${report.materialId.module.course.courseID}&moduleID=${report.materialId.module.moduleID}&materialID=${report.materialId.materialId}">
                                                ${report.commentId.commentContent}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${report.materialId.module.course.courseID}&moduleID=${report.materialId.module.moduleID}&materialID=${report.materialId.materialId}">
                                                ${report.materialId.materialName}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="detail-section">
                                <div class="detail-label">Course</div>
                                <div class="detail-value">
                                    <small class="text-muted">By <strong>${report.materialId.module.course.user.userName}</strong></small>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column -->
                        <div>
                            <div class="detail-section">
                                <div class="detail-label">Reason</div>
                                <div class="detail-value">${report.reportCategoryId.reportCategoryName}</div>
                            </div>

                            <div class="detail-section">
                                <div class="detail-label">Created By</div>
                                <div class="detail-value">
                                    ${report.userId.userName}
                                    <br>
                                    <small class="text-muted">(${report.userId.displayName})</small>
                                </div>
                            </div>
                        </div>
                        <div class="detail-section full-width-section">
                            <div class="detail-label">Report Detail</div>
                            <div class="report-detail-text">
                                ${report.reportDetail}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>