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

    // L?y danh s�ch th�ng b�o (m?c d� kh�ng ???c s? d?ng tr?c ti?p trong hi?n th? sidebar n�y,
    // nh?ng l� m?t th?c h�nh t?t ?? gi? l?i n?u c?n thi?t ? n?i kh�c ho?c cho c�c t�nh n?ng trong t??ng lai)
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
            /* �p d?ng ph�ng ch? Inter ?? c� giao di?n hi?n ??i */
            body {
                font-family: 'Inter', sans-serif;
            }

            /* CSS t�y ch?nh cho h�nh vi sidebar (chuy?n ??i chi?u r?ng v� kh? n?ng hi?n th? v?n b?n) */
            .sidebar-container {
                /* Chi?u r?ng ban ??u khi thu g?n */
                width: 100px;
                /* Chuy?n ??i m??t m� cho thay ??i chi?u r?ng */
                transition: width 0.3s ease-in-out;
                /* ?n n?i dung tr�n ra kh?i chi?u ngang khi thu g?n */
                overflow-x: hidden;
                /* C? ??nh v? tr� b�n tr�i c?a khung nh�n */
                position: fixed;
                top: 0;
                left: 0;
                /* Chi?u cao ??y ?? c?a khung nh�n */
                height: 100vh;
                /* ??m b?o n� n?m tr�n c�c n?i dung kh�c */
                z-index: 1000;
                /* C�c l?p Tailwind cho n?n, vi?n v� ?? b�ng ???c �p d?ng tr?c ti?p */
            }

            /* M? r?ng chi?u r?ng sidebar khi di chu?t qua */
            .sidebar-container:hover {
                width: 250px;
            }

            /* ?n c�c ph?n t? v?n b?n theo m?c ??nh ? ch? ?? thu g?n */
            .sidebar-container .sidebar-logo span,
            .sidebar-container .nav-link span,
            .sidebar-container .user-info span {
                opacity: 0; /* Ban ??u trong su?t */
                visibility: hidden; /* ?n kh?i tr�nh ??c m�n h�nh v� t??ng t�c */
                /* ??m b?o v?n b?n kh�ng b? ng?t d�ng khi sidebar m? r?ng */
                white-space: nowrap;
                /* Chuy?n ??i m??t m� cho c? ?? m? v� kh? n?ng hi?n th? */
                transition: opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
            }

            /* Hi?n th? c�c ph?n t? v?n b?n khi di chu?t qua sidebar */
            .sidebar-container:hover .sidebar-logo span,
            .sidebar-container:hover .nav-link span,
            .sidebar-container:hover .user-info span {
                opacity: 1; /* Ho�n to�n hi?n th? */
                visibility: visible; /* Hi?n th? */
            }

            /* ??m b?o c�c bi?u t??ng c� chi?u r?ng v� c?n ch?nh nh?t qu�n */
            .sidebar-container .nav-link i {
                min-width: 24px; /* Chi?u r?ng c? ??nh cho bi?u t??ng ?? tr�nh d?ch chuy?n */
                text-align: center; /* C?n gi?a bi?u t??ng trong kh�ng gian ???c ph�n b? */
                margin-right: 8px; /* Kho?ng c�ch gi?a bi?u t??ng v� v?n b?n */
            }

            /* ?i?u ch?nh l? c?a th�n trang ?? n?i dung kh�ng b? che b?i sidebar c? ??nh */
            body {
                margin-left: 60px; /* L? ban ??u cho sidebar thu g?n */
                transition: margin-left 0.3s ease-in-out; /* Chuy?n ??i m??t m� cho l? th�n trang */
            }

            /* ?i?u ch?nh l? c?a th�n trang khi sidebar m? r?ng khi di chu?t qua */
            .sidebar-container:hover ~ main {
                margin-left: 250px;
            }

            /* Ki?u d�ng c? b?n cho khu v?c n?i dung ch�nh */
            main {
                transition: margin-left 0.3s ease-in-out; /* Chuy?n ??i m??t m� cho n?i dung ch�nh */
                padding: 1.5rem; /* T?ng kho?ng ??m ?? c� giao di?n ??p h?n */
            }

            /* ?n sidebar tr�n m�n h�nh nh? (v� d?: di ??ng) ?? c� tr?i nghi?m di ??ng t?t h?n
               B?n c� th? mu?n tri?n khai m?t n�t chuy?n ??i cho di ??ng thay v� di chu?t qua */
            @media (max-width: 768px) {
                .sidebar-container {
                    width: 0; /* Thu g?n ho�n to�n tr�n m�n h�nh nh? */
                    left: -60px; /* ?n kh?i m�n h�nh */
                }
                .sidebar-container:hover {
                    width: 0; /* Gi? thu g?n khi di chu?t qua tr�n m�n h�nh nh? */
                }
                body {
                    margin-left: 0; /* Kh�ng c� l? tr�n m�n h�nh nh? */
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
            <!-- C�c li�n k?t ?i?u h??ng -->
            <ul class="flex flex-col space-y-2">
                <!-- Li�n k?t ?i?u h??ng cho kh�ch -->
                <c:if test="${sessionScope.role == null}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> <span>Home</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="fas fa-book"></i> <span>All Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/globalAnn.jsp"><i class="fas fa-bullhorn"></i> <span>Announcements</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/#"><i class="fas fa-shopping-cart"></i> <span>Cart</span></a></li>
                    <!-- D�ng ph�n c�ch -->
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> <span>Sign In / Up</span></a></li>
                    </div>
                </c:if>

                <!-- Li�n k?t ?i?u h??ng cho ng??i h?c -->
                <c:if test="${sessionScope.role == 'LEARNER'}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/homePage.jsp"><i class="fas fa-home"></i> <span>Home</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="fas fa-book"></i> <span>All Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="#"><i class="fas fa-graduation-cap"></i> <span>My Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/globalAnn.jsp"><i class="fas fa-bullhorn"></i> <span>Announcements</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="#"><i class="fas fa-shopping-cart"></i> <span>Cart</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="notifications.jsp"><i class="fas fa-bell"></i> <span>Notifications</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/Degree"><i class="fas fa-graduation-cap"></i> <span>Degree</span></a></li>
                    <!-- D�ng ph�n c�ch -->
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/editProfile"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                    </div>
                </c:if>

                <!-- Li�n k?t ?i?u h??ng cho ng??i h??ng d?n -->
                <c:if test="${sessionScope.role == 'INSTRUCTOR'}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/Instructor"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="manageCourses.jsp"><i class="fas fa-laptop-code"></i> <span>Manage Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="analytics.jsp"><i class="fas fa-chart-line"></i> <span>Analytics</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="feedback.jsp"><i class="fas fa-comment-dots"></i> <span>Feedback</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="notifications.jsp"><i class="fas fa-bell"></i> <span>Notifications</span></a></li>
                    <!-- D�ng ph�n c�ch -->
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="editProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="logout.jsp"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                    </div>
                </c:if>
            </ul>
        </div>
    </body>
</html>
