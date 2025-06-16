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
                <button onclick="history.back()" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back
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
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
