<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Report History</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .status-live {
                color: green;
                font-weight: bold;
            }
        </style>
    </head>
    <body class="bg-light">
        <jsp:include page="/layout/sidebar_user.jsp"/>
        
        <div class="container my-5">
            <h2 class="mb-3">Thanks for reporting</h2>
            <p>Any member of the FSkills community can flag content to us that they believe violates our Community Guidelines. When something is flagged, it's not automatically taken down. Flagged content is reviewed in line with the following guidelines:</p>
            <ul>
                <li>Content that violates our Community Guidelines is removed from FSkills.</li>
                <li>Content that may not be appropriate for all younger audiences may be age-restricted.</li>
                <li>Reports filed for content that has been deleted by the creator cannot be shown.</li>
            </ul>

            <hr>

            <h5 class="mt-4">Your reports</h5>
            <table class="table table-bordered table-hover mt-3">
                <thead class="table-secondary">
                    <tr>
                        <th>Type</th>
                        <th>Content</th>
                        <th>Reporting reason</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="report" items="${listReport}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty report.commentId}">
                                        🗨️ Comment
                                    </c:when>
                                    <c:otherwise>
                                        🎬 Material
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty report.commentId}">
                                        <a href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${report.materialId.module.course.courseID}&moduleID=${report.materialId.module.moduleID}&materialID=${report.materialId.materialId}">
                                            ${report.commentId.commentContent}
                                        </a><br>
                                        <small>${report.materialId.module.course.user.userName}</small>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${report.materialId.module.course.courseID}&moduleID=${report.materialId.module.moduleID}&materialID=${report.materialId.materialId}">
                                            ${report.materialId.materialName}
                                        </a><br>
                                        <small>${report.materialId.module.course.user.userName}</small>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                ${report.reportCategoryId.reportCategoryName}<br>
                                <small><fmt:formatDate value="${report.reportDate}" pattern="d MMM yyyy"/></small>
                            </td>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

    </body>
</html>
