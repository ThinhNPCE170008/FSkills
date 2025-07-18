<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Report List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                font-family: 'Inter', sans-serif;
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

            .table thead th {
                background: #f1f5f9;
                color: #1e293b;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85rem;
                padding: 1.2rem;
                border-bottom: 2px solid #e2e8f0;
            }

            .table tbody tr {
                transition: background 0.2s ease;
            }

            .table tbody tr:hover {
                background: #f8fafc;
            }

            .report-content a {
                color: #1e40af;
                font-weight: 500;
                text-decoration: none;
                transition: color 0.2s ease;
            }

            .report-content a:hover {
                color: #3b82f6;
                text-decoration: underline;
            }

            .report-content small {
                color: #64748b;
                font-size: 0.85rem;
            }

            .table td {
                vertical-align: middle;
                padding: 1.2rem;
                border-bottom: 1px solid #e2e8f0;
            }

            .header-title {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                color: #1e293b;
                font-weight: 700;
            }

            .container-fluid {
                width: 100%;
                padding-left: 0;
                padding-right: 0;
                margin-left: 0;
            }

            @media (max-width: 768px) {
                .report-card {
                    padding: 1.5rem;
                }

                .table {
                    font-size: 0.9rem;
                }

                .table td, .table th {
                    padding: 0.8rem;
                }
            }
        </style>
    </head>
    <body class="min-h-screen">
        <jsp:include page="/layout/sidebar_admin.jsp"/>

        <div class="container-fluid flex px-4">
            <div class="container py-10">
                <div class="text-center mb-4">
                    <h4 class="header-title text-2xl fw-bold d-inline-block">📋 Report History</h4>
                </div>


                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th style="width: 120px;">Type</th>
                                <th>Content</th>
                                <th>Reason</th>
                                <th>Created By</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${listReport}">
                                <tr>
                                    <!-- Type -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty report.commentId}">
                                                <span class="badge badge-comment text-white">🗨️ Comment</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-material text-white">🎬 Material</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Content -->
                                    <td class="report-content">
                                        <c:choose>
                                            <c:when test="${not empty report.commentId}">
                                                <a class="fw-semibold"
                                                   href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${report.materialId.module.course.courseID}&moduleID=${report.materialId.module.moduleID}&materialID=${report.materialId.materialId}">
                                                    ${report.commentId.commentContent}
                                                </a><br>
                                                <small>Course by <strong>${report.materialId.module.course.user.userName}</strong></small>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="fw-semibold"
                                                   href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${report.materialId.module.course.courseID}&moduleID=${report.materialId.module.moduleID}&materialID=${report.materialId.materialId}">
                                                    ${report.materialId.materialName}
                                                </a><br>
                                                <small>Course by <strong>${report.materialId.module.course.user.userName}</strong></small>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Reason -->
                                    <td>
                                        <div class="fw-medium">${report.reportCategoryId.reportCategoryName}</div>
                                        <small class="text-muted"><fmt:formatDate value="${report.reportDate}" pattern="dd MMM yyyy"/></small>
                                    </td>

                                    <!-- Created By -->
                                    <td>
                                        <div class="fw-medium">${report.userId.userName}</div>
                                        <small class="text-muted">(${report.userId.displayName})</small>
                                    </td>
                                    <td>
                                        <a class="btn btn-view" type="button"
                                           href="${pageContext.request.contextPath}/admin/report?action=details&id=${report.reportId}">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>