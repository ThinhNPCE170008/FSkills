<%@page import="model.Notification" %>
<%@page import="java.util.List" %>
<%@page import="model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    User acc = (User) session.getAttribute("user");
    if (acc == null) {
        response.sendRedirect("login");
        return;
    }

    List<Notification> listNotification = (List<Notification>) request.getAttribute("listNotification");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Instructor Dashboard | F-Skill</title>

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8f9fa;
                overflow-x: hidden; /* Prevent horizontal scrollbar */
            }

            /* Ensure content adapts to available space */
            .main {
                transition: margin-left 0.3s ease, width 0.3s ease;
                max-width: 100%;
                box-sizing: border-box;
            }

            .card {
                background-color: white;
                border-radius: 0.75rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
            }

            .stat-card i {
                transition: transform 0.3s ease;
            }

            .stat-card:hover i {
                transform: scale(1.1);
            }
        </style>
    </head>

    <body class="bg-gray-50">
        <jsp:include page="/layout/sidebar_user.jsp"/>
        <jsp:include page="/layout/header_user.jsp"/>
        <!-- ======================= Main Content ======================= -->
        <main class="main mx-auto px-4 py-8 md:py-12">
            <section id="dashboard" class="mb-12">
                <h1 class="text-3xl md:text-4xl font-bold text-gray-800 mb-2">Welcome Back, ${user.displayName}</h1>
                <p class="text-gray-500 text-lg">Here's your teaching dashboard for today.</p>
            </section>

            <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
                <!-- Card 1 -->
                <div class="bg-white rounded-lg shadow p-6 flex flex-col items-center justify-center text-center">
                    <div class="bg-indigo-100 p-4 rounded-full mb-3">
                        <i class="fas fa-book-open text-2xl text-indigo-600"></i>
                    </div>
                    <p class="text-gray-500 text-sm">Total Courses</p>
                    <p class="text-3xl font-bold text-gray-800">${totalCourses}</p>
                </div>

                <!-- Card 2 -->
                <div class="bg-white rounded-lg shadow p-6 flex flex-col items-center justify-center text-center">
                    <div class="bg-green-100 p-4 rounded-full mb-3">
                        <i class="fas fa-users text-2xl text-green-600"></i>
                    </div>
                    <p class="text-gray-500 text-sm">Total Learners</p>
                    <p class="text-3xl font-bold text-gray-800">${totalLearners}</p>
                </div>

                <!-- Card 3 -->
                <div class="bg-white rounded-lg shadow p-6 flex flex-col items-center justify-center text-center">
                    <div class="bg-yellow-100 p-4 rounded-full mb-3">
                        <i class="fas fa-star text-2xl text-yellow-500"></i>
                    </div>
                    <p class="text-gray-500 text-sm">Average Rating</p>
                    <p class="text-3xl font-bold text-gray-800">${totalRating}</p>
                </div>

            </section>

            <section id="my-courses">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl md:text-3xl font-bold text-gray-800">My Courses</h2>
                    <a href="${pageContext.request.contextPath}/instructor/courses"
                       class="text-indigo-600 font-semibold hover:underline">View All</a>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <c:forEach var="course" items="${listLittle}">
                        <div class="card overflow-hidden">
                            <img src="${course.courseImageLocation}" alt="Course Thumbnail" class="w-full h-48 object-cover">
                            <div class="p-6">
                                <div class="flex justify-between items-start mb-2">
                                    <h3 class="text-xl font-bold text-gray-800 leading-tight">${course.courseName}</h3>
                                    <c:choose>
                                        <c:when test="${course.approveStatus == 1}">
                                            <span class="bg-green-100 text-green-800 text-xs font-semibold px-2.5 py-0.5 rounded-full">Published</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="bg-yellow-100 text-yellow-800 text-xs font-semibold px-2.5 py-0.5 rounded-full">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="flex items-center text-sm text-gray-500 space-x-4 mb-4">
                                    <span><i class="fas fa-users mr-1.5"></i> Enrolled: ${course.totalEnrolled}</span>
                                    <span><i class="fas fa-calendar-alt mr-1.5"></i>
                                        <c:choose>
                                            <c:when test="${not empty course.publicDate}">
                                                <fmt:formatDate value="${course.publicDate}" pattern="HH:mm dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <p class="text-gray-600 mb-6 text-sm">Instructor: ${course.user.displayName}</p>

                                <div class="flex space-x-3">
                                    <a href="courseDetail?id=${course.courseID}"
                                       class="flex-1 text-center bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-lg transition-colors">Manage</a>
                                    <a href="courseStats?id=${course.courseID}"
                                       class="flex-1 text-center bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-lg transition-colors">View
                                        Stats</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </main>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const userBtn = document.getElementById("userMenuBtn");
                const dropdown = document.getElementById("userDropdownMenu");

                userBtn.addEventListener("click", function (e) {
                    e.stopPropagation();
                    dropdown.classList.toggle("dropdown-open");
                });

                window.addEventListener("click", function () {
                    dropdown.classList.remove("dropdown-open");
                });

                dropdown.addEventListener("click", function (e) {
                    e.stopPropagation();
                });
            });
        </script>

        <jsp:include page="/layout/footer.jsp"/>
    </body>
</html>
