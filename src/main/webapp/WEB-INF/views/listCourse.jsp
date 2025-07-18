<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>List Course | F-Skill</title>
        <meta charset="UTF-8">

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8f9fa;
                overflow-x: hidden; /* Prevent horizontal scrollbar */
            }

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

            /* Ensure content adapts to available space */
            .main {
                transition: margin-left 0.3s ease, width 0.3s ease;
                max-width: 100%;
                box-sizing: border-box;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/layout/sidebar_user.jsp"/>
        <jsp:include page="/layout/header.jsp"/>

        <main class="main">
            <div class="px-5 py-6">
                <nav class="text-base text-gray-500 mb-6" aria-label="Breadcrumb">
                    <ol class="list-none p-0 inline-flex space-x-2">
                        <li class="inline-flex items-center">
                            <a href="${pageContext.request.contextPath}/instructor"
                               class="text-indigo-600 hover:text-indigo-700 font-medium no-underline">Dashboard</a>
                        </li>
                        <li class="inline-flex items-center">
                            <span class="mx-2 text-gray-400">/</span>
                        </li>
                        <li class="inline-flex items-center">
                            <span class="text-gray-800 font-semibold">Manage Course</span>
                        </li>
                    </ol>
                </nav>

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
                                <c:forEach var="course" items="${listCourse}">
                                    <tr>
                                        <td>
                                            <img src="${course.imageDataURI}" class="course-image mx-auto d-block" alt="Course Image">
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${course.courseID}"
                                               class="link-hover">
                                                ${course.courseName}
                                            </a>
                                        </td>
                                        <td>${course.category.name}</td>
                                        <td>${course.user.displayName}</td>
                                        <td>
                                            <span class="
                                                  text-xs font-semibold px-2.5 py-0.5 rounded-full
                                                  ${course.approveStatus == 1 ? 'bg-green-500 text-white' 
                                                    : course.approveStatus == 3 ? 'bg-amber-400 text-white' 
                                                    : 'bg-gray-400 text-white'}">
                                                      ${course.approveStatus == 1 ? 'Approved' 
                                                        : course.approveStatus == 3 ? 'Processing' 
                                                        : 'Default'}
                                                  </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty course.publicDate}">
                                                        <span class="datetime" data-utc="${course.publicDate}Z"></span>
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty course.courseLastUpdate}">
                                                        <span class="datetime" data-utc="${course.courseLastUpdate}Z"></span>
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${course.originalPrice == 0}">
                                                        <span class="text-success fw-bold">Free</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="fw-bold fs-6">
                                                            <fmt:formatNumber value="${course.originalPrice * 1000}" pattern="#,##0"/> VND
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="d-flex justify-content-center align-items-center gap-2" style="height: 100px;">
                                                <a href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${course.courseID}"
                                                   class="btn btn-info btn-sm d-flex align-items-center justify-content-center"
                                                   style="height: 40px; width: 40px;">
                                                    <i class="fas fa-eye"></i>
                                                </a>

                                                <a href="${pageContext.request.contextPath}/instructor/courses?action=update&courseID=${course.courseID}"
                                                   class="btn btn-warning btn-sm d-flex align-items-center justify-content-center"
                                                   style="height: 40px; width: 40px;">
                                                    <i class="fas fa-edit"></i>
                                                </a>

                                                <button class="btn btn-danger btn-sm d-flex align-items-center justify-content-center"
                                                        style="height: 40px; width: 40px;"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#deleteModal${course.courseID}">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>

                                                <c:if test="${course.approveStatus == 0}">
                                                    <form action="${pageContext.request.contextPath}/instructor/courses" method="post">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="courseID" value="${course.courseID}">
                                                        <input type="hidden" name="userID" value="${course.user.userId}">
                                                        <button type="submit" class="btn btn-success btn-sm d-flex align-items-center justify-content-center"
                                                                style="height: 40px; width: 40px;">
                                                            <i class="fas fa-paper-plane"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
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

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    formatUtcToVietnamese(".datetime");
                });
            </script>

            <script>
                // Script to ensure proper sidebar hover behavior
                document.addEventListener('DOMContentLoaded', function() {
                    const sidebar = document.querySelector('.sidebar');
                    const mainContent = document.querySelector('.main');
                    const header = document.querySelector('header');

                    // Event handler functions defined outside to allow removal
                    function handleSidebarMouseEnter() {
                        const windowWidth = window.innerWidth;
                        mainContent.style.transition = 'margin-left 0.2s ease, width 0.2s ease';

                        if (windowWidth <= 768) {
                            // Mobile layout
                            mainContent.style.marginLeft = '250px';
                            if (header) {
                                header.style.left = '250px';
                                header.style.width = 'calc(100% - 266px)';
                            }
                        } else {
                            // Desktop layout
                            mainContent.style.marginLeft = '250px';
                            if (header) {
                                header.style.left = '250px';
                                header.style.width = 'calc(100% - 266px)';
                            }
                        }
                    }

                    function handleSidebarMouseLeave() {
                        const windowWidth = window.innerWidth;
                        mainContent.style.transition = 'margin-left 0.2s ease, width 0.2s ease';

                        if (windowWidth <= 768) {
                            // Mobile layout
                            mainContent.style.marginLeft = '0';
                            if (header) {
                                header.style.left = '0';
                                header.style.width = 'calc(100% - 16px)';
                            }
                        } else {
                            // Desktop layout
                            mainContent.style.marginLeft = '80px';
                            if (header) {
                                header.style.left = '80px';
                                header.style.width = 'calc(100% - 96px)';
                            }
                        }
                    }

                    // Add event listeners
                    sidebar.addEventListener('mouseenter', handleSidebarMouseEnter);
                    sidebar.addEventListener('mouseleave', handleSidebarMouseLeave);

                    // Set initial state based on window width
                    handleSidebarMouseLeave();

                    // Add resize event listener to handle window size changes
                    window.addEventListener('resize', function() {
                        // Update layout based on current sidebar state
                        if (sidebar.matches(':hover')) {
                            handleSidebarMouseEnter();
                        } else {
                            handleSidebarMouseLeave();
                        }
                    });
                });
            </script>

            <jsp:include page="/layout/toast.jsp" />
            <script src="${pageContext.request.contextPath}/layout/formatUtcToVietnamese.js"></script>
            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        </body>
    </html>
