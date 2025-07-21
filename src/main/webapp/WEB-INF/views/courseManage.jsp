<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f1f5f9;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        header {
            background-color: #ffffff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        header h1 {
            font-size: 24px;
            color: #1f2937;
            margin: 0;
        }
        main {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        main h2 {
            font-size: 20px;
            color: #374151;
            margin: 0 0 15px;
        }
        .table-container {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }
        th {
            background-color: #f9fafb;
            font-size: 12px;
            text-transform: uppercase;
            color: #6b7280;
        }
        td {
            font-size: 14px;
            color: #374151;
        }
        .course-name a {
            color: #4f46e5;
            text-decoration: none;
        }
        .course-name a:hover {
            color: #4338ca;
            text-decoration: underline;
        }
        .status {
            padding: 5px 10px;
            border-radius: 9999px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-active {
            background-color: #d1fae5;
            color: #065f46;
        }
        .status-upcoming {
            background-color: #fef3c7;
            color: #92400e;
        }
        .status-ended {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .action a.delete {
            color: #dc2626;
            text-decoration: none;
        }
        .action a.delete:hover {
            color: #b91c1c;
            text-decoration: underline;
        }
        .message, .error {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .message {
            background-color: #d1fae5;
            color: #065f46;
        }
        .error {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a {
            margin: 0 5px;
            padding: 5px 10px;
            text-decoration: none;
            color: #4f46e5;
            border: 1px solid #e5e7eb;
            border-radius: 4px;
        }
        .pagination a:hover {
            background-color: #f9fafb;
        }
        .pagination a.active {
            background-color: #4f46e5;
            color: #ffffff;
        }
        @media (max-width: 768px) {
            .hidden-mobile {
                display: none;
            }
            header h1 {
                font-size: 20px;
            }
        }
        @media (max-width: 1024px) {
            .hidden-tablet {
                display: none;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header Section -->
    <jsp:include page="/layout/sidebar_admin.jsp"/>




    <!-- Main Content Area -->
    <main>
        <h2>All Courses</h2>
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Course ID</th>
                    <th>Course Name</th>
                    <th class="hidden-mobile">Summary</th>
                    <th>Instructor</th>
                    <th class="hidden-mobile">Category</th>
                    <th class="hidden-mobile">Status</th>
                    <th class="hidden-tablet">Enrolled Students</th>
                    <th class="hidden-tablet">Start Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="course" items="${courses}">
                    <tr>
                        <td>${course.courseID}</td>
                        <td class="course-name"><a href="<c:url value='/admin/ManageCourse?action=detail&id=${course.courseID}'/>">${course.courseName}</a></td>
                        <td class="hidden-mobile">
                            <c:choose>
                                <c:when test="${not empty course.courseSummary and course.courseSummary.length() > 50}">
                                    ${course.courseSummary.substring(0, 50)}...
                                </c:when>
                                <c:when test="${not empty course.courseSummary}">
                                    ${course.courseSummary}
                                </c:when>
                                <c:otherwise>
                                    No summary available
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${course.user.displayName}</td>
                        <td class="hidden-mobile">${course.category.name}</td>
                        <td class="hidden-mobile">
                            <span class="status
                                <c:choose>
                                    <c:when test='${course.approveStatus == 1}'>status-active</c:when>
                                    <c:when test='${course.approveStatus == 3}'>status-upcoming</c:when>
                                    <c:otherwise>status-ended</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${course.approveStatus == 1}">Approved</c:when>
                                    <c:when test="${course.approveStatus == 3}">Processing</c:when>
                                    <c:when test="${course.approveStatus == 0}">Pending</c:when>
                                    <c:when test="${course.approveStatus == 2}">Rejected</c:when>
                                    <c:when test="${course.approveStatus == 4}">Hidden</c:when>
                                    <c:otherwise>Unknown</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td class="hidden-tablet">${course.totalEnrolled}</td>
                        <td class="hidden-tablet"><fmt:formatDate value="${course.publicDate}" pattern="yyyy-MM-dd"/></td>
                        <td class="action">
                            <c:choose>
                                <c:when test="${course.totalEnrolled == 0 || course.totalEnrolled == null}">
                                    <form action="<c:url value='/admin/ManageCourse'/>" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${course.courseID}"/>
                                        <input type="hidden" name="page" value="${currentPage}"/>
                                        <a href="#" class="delete" onclick="if(confirm('Are you sure you want to delete this course?')) this.parentNode.submit(); return false;">Delete</a>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #6b7280; font-style: italic;">Cannot delete (${course.totalEnrolled} students enrolled)</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <!-- Pagination -->
        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                <a href="<c:url value='/admin/ManageCourse?page=${pageNum}'/>" class="${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
            </c:forEach>
        </div>
    </main>
</div>
</body>
</html>
