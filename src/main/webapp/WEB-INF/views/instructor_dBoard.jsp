
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

    <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
        }

        .header-shadow {
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
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

        .btn-primary-gradient {
            background-image: linear-gradient(to right, #4f46e5, #6366f1);
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(99, 102, 241, 0.2);
        }

        .btn-primary-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 10px rgba(99, 102, 241, 0.3);
        }

        .stat-card i {
            transition: transform 0.3s ease;
        }

        .stat-card:hover i {
            transform: scale(1.1);
        }

        .animate-dropdown {
            opacity: 0;
            transform: translateY(-10px);
            transition: opacity 0.2s ease, transform 0.2s ease;
            visibility: hidden;
            pointer-events: none;
        }

        .dropdown-open {
            opacity: 1 !important;
            transform: translateY(0) !important;
            visibility: visible !important;
            pointer-events: auto !important;
        }
    </style>
</head>

<body class="bg-gray-50">
<!-- ======================= Header ======================= -->
<header class="bg-white sticky top-0 z-50 header-shadow">
    <div class="container mx-auto px-4">
        <div class="flex items-center justify-between h-20 px-6">
            <div class="flex items-center space-x-2">
                <img src="img/logo.png" alt="F-SKILL Logo" class=" w-20 h-15"/>
            </div>

            <nav class="hidden lg:flex items-center space-x-8">
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Dashboard</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">My Courses</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Analytics</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Feedback</a>
                <a href="editProfile"
                   class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Profile</a>
            </nav>

            <div class="relative flex items-center space-x-4">
                <button id="notificationBtn"
                        class="text-gray-600 hover:text-indigo-600 focus:outline-none text-xl relative">
                    <i class="fas fa-bell"></i>
                    <% if (listNotification != null && !listNotification.isEmpty()) {%>
                    <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full px-1.5 py-0.5">
                                <%= listNotification.size()%>
                            </span>
                    <% } %>
                </button>

                <!-- Dropdown -->
                <div id="notificationDropdown"
                     class="hidden absolute top-full right-0 mt-2 w-[400px] bg-white border rounded-xl shadow-xl z-50">
                    <!-- Header -->
                    <div class="flex items-center justify-between px-4 py-3 border-b">
                        <span class="text-lg font-semibold text-gray-800">Notifications</span>
                        <i class="fas fa-cog text-gray-500 hover:text-indigo-500 cursor-pointer"></i>
                    </div>

                    <!-- Danh sách thông báo -->
                    <ul class="max-h-96 overflow-y-auto divide-y divide-gray-200">
                        <%
                            if (listNotification != null) {
                                for (Notification n : listNotification) {
                        %>
                        <a href="<%= n.getLink()%>" class="block">
                            <li class="flex items-start px-4 py-3 hover:bg-gray-50 cursor-pointer">
                                <img src="#" class="w-10 h-10 rounded-full mr-3 mt-1" alt="avatar">
                                <div class="flex-1">
                                    <p class="text-sm text-gray-800 font-semibold"><%= n.getNotificationMessage()%>
                                    </p>
                                    <span class="text-xs text-gray-500"><%= n.getNotificationDate()%></span>
                                </div>
                            </li>
                        </a>

                        <%
                            }
                        } else {
                        %>
                        <div class="alert alert-warning text-center">
                            No data found.
                        </div>
                        <%
                            }
                        %>

                    </ul>
                    <div class="px-4 py-2 text-center text-sm text-indigo-600 hover:underline cursor-pointer border-t">
                        View all notifications
                    </div>
                </div>
                <div class="relative">
                    <c:set var="user" value="${sessionScope.user}"/>
                    <!-- Button trigger -->
                    <button id="userMenuBtn" class="flex items-center space-x-2 focus:outline-none">
                        <img src="${user.avatar}" alt="Instructor Avatar"
                             class="w-10 h-10 rounded-full border-2 border-indigo-200">
                        <span class="hidden md:inline font-medium text-gray-700">${user.displayName}</span>
                        <i class="fas fa-chevron-down text-gray-500 text-xs"></i>
                    </button>

                    <!-- Dropdown -->
                    <div id="userDropdownMenu"
                         class="animate-dropdown absolute right-0 mt-2 w-48 bg-white border rounded-xl shadow-lg z-50 transition-all duration-200 ease-in-out">
                        <ul class="py-2 text-sm text-gray-700">
                            <li><a href="editProfile" class="block px-4 py-2 hover:bg-gray-100">Manage Profile</a></li>
                            <li>
                                <hr class="my-1 border-gray-200">
                            </li>
                            <li><a href="logout" class="block px-4 py-2 text-red-600 hover:bg-gray-100">Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <script>
                const bellBtn = document.getElementById('notificationBtn');
                const dropdown = document.getElementById('notificationDropdown');

                bellBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    if (dropdown.style.display === 'block') {
                        dropdown.style.display = 'none';
                    } else {
                        dropdown.style.display = 'block';
                    }
                });

                document.addEventListener('click', function () {
                    dropdown.style.display = 'none';
                });
            </script>


        </div>
    </div>
    </div>
</header>

<!-- ======================= Main Content ======================= -->
<main class="container mx-auto px-4 py-8 md:py-12">
    <section id="dashboard" class="mb-12">
        <h1 class="text-3xl md:text-4xl font-bold text-gray-800 mb-2">Welcome Back, ${user.displayName}</h1>
        <p class="text-gray-500 text-lg">Here's your teaching dashboard for today.</p>
    </section>

    <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
        <div class="stat-card card p-6 flex items-center space-x-4">
            <div class="bg-indigo-100 p-4 rounded-full">
                <i class="fas fa-book-open text-2xl text-indigo-600"></i>
            </div>
            <div>
                <p class="text-gray-500">Total Courses</p>
                <p class="text-3xl font-bold text-gray-800">${totalCourses}</p>
            </div>
        </div>
        <div class="stat-card card p-6 flex items-center space-x-4">
            <div class="bg-green-100 p-4 rounded-full">
                <i class="fas fa-users text-2xl text-green-600"></i>
            </div>
            <div>
                <p class="text-gray-500">Total Learners</p>
                <p class="text-3xl font-bold text-gray-800">${totalLearners}</p>
            </div>
        </div>
        <div class="stat-card card p-6 flex items-center space-x-4">
            <div class="bg-yellow-100 p-4 rounded-full">
                <i class="fas fa-star text-2xl text-yellow-500"></i>
            </div>
            <div>
                <p class="text-gray-500">Average Rating</p>
                <p class="text-3xl font-bold text-gray-800">Coming Soon</p>
            </div>
        </div>
        <div class="stat-card card p-6 flex items-center space-x-4">
            <div class="bg-red-100 p-4 rounded-full">
                <i class="fas fa-comments text-2xl text-red-500"></i>
            </div>
            <div>
                <p class="text-gray-500">Pending Feedback</p>
                <p class="text-3xl font-bold text-gray-800">Coming Soon</p>
            </div>
        </div>
    </section>

    <section id="my-courses">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl md:text-3xl font-bold text-gray-800">My Courses</h2>
            <a href="instructor/courses" class="text-indigo-600 font-semibold hover:underline">View All</a>
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
                            <span><i class="fas fa-users mr-1.5"></i> Enrolled: 0</span>
                            <span><i class="fas fa-calendar-alt mr-1.5"></i> <fmt:formatDate
                                    value="${course.publicDate}" pattern="dd MMM yyyy"/></span>
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

<jsp:include page="/layout/footerInstructor.jsp"/>
</body>
</html>
