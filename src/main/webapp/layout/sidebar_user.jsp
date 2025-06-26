<%@page import="model.Notification"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%

    User acc = (User) session.getAttribute("user");
    if (acc == null) {
        response.sendRedirect("login");
        return;
    }

    List<Notification> listNotification = (List<Notification>) request.getAttribute("listNotification");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title></title>

        <!-- Tailwind CSS CDN -->
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Font Awesome cho nhi?u lo?i bi?u t??ng hi?n ??i -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

        <style>
            body {
                font-family: 'Inter', sans-serif;
            }

            .sidebar-container {
                width: 100px;
                transition: width 0.3s ease-in-out;
                overflow-x: hidden;
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                z-index: 1000;
            }

            .sidebar-container:hover {
                width: 250px;
            }

            .sidebar-container .sidebar-logo span,
            .sidebar-container .nav-link span,
            .sidebar-container .user-info span {
                opacity: 0;
                visibility: hidden;
                white-space: nowrap;
                transition: opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
            }

            .sidebar-container:hover .sidebar-logo span,
            .sidebar-container:hover .nav-link span,
            .sidebar-container:hover .user-info span {
                opacity: 1;
                visibility: visible;
            }

            .sidebar-container .nav-link i {
                min-width: 24px;
                text-align: center;
                margin-right: 8px;
            }

            body {
                margin-left: 60px;
                transition: margin-left 0.3s ease-in-out;
            }

            .sidebar-container:hover ~ main {
                margin-left: 250px;
            }

            main {
                transition: margin-left 0.3s ease-in-out;
                padding: 1.5rem;
            }

            @media (max-width: 768px) {
                .sidebar-container {
                    width: 0;
                    left: -60px;
                }
                .sidebar-container:hover {
                    width: 0;
                }
                body {
                    margin-left: 0;
                }
                .sidebar-container:hover ~ main {
                    margin-left: 0;
                }
            }
        </style>
    </head>
    <body>

        <!-- Sidebar Container -->
        <div class="sidebar-container bg-white border-r border-gray-200 shadow-xl rounded-r-lg p-3 sm:w-60 md:w-60 lg:w-60 xl:w-60">

            <!-- Logo Section -->
            <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="flex items-center mb-6 text-decoration-none sidebar-logo text-gray-800">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class="w-15 h-15 mr-2 rounded-md"/>
                <span class="text-xl font-extrabold whitespace-nowrap"></span>
            </a>

            <!--Avatar-->
            <c:choose>
                <c:when test="${not empty user.avatar}">
                    <img src="${user.avatar}" alt="User Avatar" class="rounded-circle mb-2" style="width: 60px; height: 60px;">
                </c:when>
                <c:otherwise>
                    <img src="https://placehold.co/80x80/cccccc/333333?text=User" alt="Default Avatar" class="rounded-circle mb-2" style="width: 60px; height: 60px;">
                </c:otherwise>
            </c:choose>
            <ul class="flex flex-col space-y-2 p-1">
                <c:if test="${user.role == null}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> <span>Home</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="fas fa-book"></i> <span>All Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/globalAnn.jsp"><i class="fas fa-bullhorn"></i> <span>Announcements</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/#"><i class="fas fa-shopping-cart"></i> <span>Cart</span></a></li>
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> <span>Sign In / Up</span></a></li>
                    </div>
                </c:if>

                <c:if test="${user.role == 'LEARNER'}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/homePage_Guest.jsp"><i class="fas fa-home"></i> <span>Home</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="fas fa-book"></i> <span>All Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="#"><i class="fas fa-graduation-cap"></i> <span>My Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/globalAnn.jsp"><i class="fas fa-bullhorn"></i> <span>Announcements</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/Cart"><i class="fas fa-shopping-cart"></i> <span>Cart</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="notifications.jsp"><i class="fas fa-bell"></i> <span>Notifications</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/Degree"><i class="fas fa-graduation-cap"></i> <span>Degree</span></a></li>
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/learner/profile"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                    </div>
                </c:if>

                <c:if test="${user.role == 'INSTRUCTOR'}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/instructor"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/instructor/courses?action=list"><i class="fas fa-laptop-code"></i> <span>Manage Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="analytics.jsp"><i class="fas fa-chart-line"></i> <span>Analytics</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="feedback.jsp"><i class="fas fa-comment-dots"></i> <span>Feedback</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="notifications.jsp"><i class="fas fa-bell"></i> <span>Notifications</span></a></li>
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/instructor/profile"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                    </div>
                </c:if>
            </ul>
        </div>
    </body>
</html>