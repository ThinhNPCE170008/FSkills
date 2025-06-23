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

    // L?y danh sách thông báo (m?c dù không ???c s? d?ng tr?c ti?p trong hi?n th? sidebar này,
    // nh?ng là m?t th?c hành t?t ?? gi? l?i n?u c?n thi?t ? n?i khác ho?c cho các tính n?ng trong t??ng lai)
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
            /* Áp d?ng phông ch? Inter ?? có giao di?n hi?n ??i */
            body {
                font-family: 'Inter', sans-serif;
            }

            /* CSS tùy ch?nh cho hành vi sidebar (chuy?n ??i chi?u r?ng và kh? n?ng hi?n th? v?n b?n) */
            .sidebar-container {
                /* Chi?u r?ng ban ??u khi thu g?n */
                width: 100px;
                /* Chuy?n ??i m??t mà cho thay ??i chi?u r?ng */
                transition: width 0.3s ease-in-out;
                /* ?n n?i dung tràn ra kh?i chi?u ngang khi thu g?n */
                overflow-x: hidden;
                /* C? ??nh v? trí bên trái c?a khung nhìn */
                position: fixed;
                top: 0;
                left: 0;
                /* Chi?u cao ??y ?? c?a khung nhìn */
                height: 100vh;
                /* ??m b?o nó n?m trên các n?i dung khác */
                z-index: 1000;
                /* Các l?p Tailwind cho n?n, vi?n và ?? bóng ???c áp d?ng tr?c ti?p */
            }

            /* M? r?ng chi?u r?ng sidebar khi di chu?t qua */
            .sidebar-container:hover {
                width: 250px;
            }

            /* ?n các ph?n t? v?n b?n theo m?c ??nh ? ch? ?? thu g?n */
            .sidebar-container .sidebar-logo span,
            .sidebar-container .nav-link span,
            .sidebar-container .user-info span {
                opacity: 0; /* Ban ??u trong su?t */
                visibility: hidden; /* ?n kh?i trình ??c màn hình và t??ng tác */
                /* ??m b?o v?n b?n không b? ng?t dòng khi sidebar m? r?ng */
                white-space: nowrap;
                /* Chuy?n ??i m??t mà cho c? ?? m? và kh? n?ng hi?n th? */
                transition: opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
            }

            /* Hi?n th? các ph?n t? v?n b?n khi di chu?t qua sidebar */
            .sidebar-container:hover .sidebar-logo span,
            .sidebar-container:hover .nav-link span,
            .sidebar-container:hover .user-info span {
                opacity: 1; /* Hoàn toàn hi?n th? */
                visibility: visible; /* Hi?n th? */
            }

            /* ??m b?o các bi?u t??ng có chi?u r?ng và c?n ch?nh nh?t quán */
            .sidebar-container .nav-link i {
                min-width: 24px; /* Chi?u r?ng c? ??nh cho bi?u t??ng ?? tránh d?ch chuy?n */
                text-align: center; /* C?n gi?a bi?u t??ng trong không gian ???c phân b? */
                margin-right: 8px; /* Kho?ng cách gi?a bi?u t??ng và v?n b?n */
            }

            /* ?i?u ch?nh l? c?a thân trang ?? n?i dung không b? che b?i sidebar c? ??nh */
            body {
                margin-left: 60px; /* L? ban ??u cho sidebar thu g?n */
                transition: margin-left 0.3s ease-in-out; /* Chuy?n ??i m??t mà cho l? thân trang */
            }

            /* ?i?u ch?nh l? c?a thân trang khi sidebar m? r?ng khi di chu?t qua */
            .sidebar-container:hover ~ main {
                margin-left: 250px;
            }

            /* Ki?u dáng c? b?n cho khu v?c n?i dung chính */
            main {
                transition: margin-left 0.3s ease-in-out; /* Chuy?n ??i m??t mà cho n?i dung chính */
                padding: 1.5rem; /* T?ng kho?ng ??m ?? có giao di?n ??p h?n */
            }

            /* ?n sidebar trên màn hình nh? (ví d?: di ??ng) ?? có tr?i nghi?m di ??ng t?t h?n
               B?n có th? mu?n tri?n khai m?t nút chuy?n ??i cho di ??ng thay vì di chu?t qua */
            @media (max-width: 768px) {
                .sidebar-container {
                    width: 0; /* Thu g?n hoàn toàn trên màn hình nh? */
                    left: -60px; /* ?n kh?i màn hình */
                }
                .sidebar-container:hover {
                    width: 0; /* Gi? thu g?n khi di chu?t qua trên màn hình nh? */
                }
                body {
                    margin-left: 0; /* Không có l? trên màn hình nh? */
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

            <!-- Avatar và Thông tin ng??i dùng -->
            <div class="flex flex-col items-center mb-6 pb-4 border-b border-gray-200">
                <!-- Hình ?nh placeholder cho avatar ng??i dùng. Thay th? b?ng URL avatar ng??i dùng th?c t?. -->
                <img src="https://placehold.co/80x80/6366f1/ffffff?text=User" alt="User Avatar" class="rounded-full w-16 h-16 mb-2 object-cover border-2 border-indigo-500 shadow-md">
                <div class="user-info text-center">
                    <span class="block text-gray-800 font-medium">${acc.username != null ? acc.username : 'Guest User'}</span>
                    <span class="block text-sm text-gray-500">${acc.role != null ? acc.role : 'Guest'}</span>
                </div>
            </div>

            <!-- Các liên k?t ?i?u h??ng -->
            <ul class="flex flex-col space-y-2">
                <!-- Liên k?t ?i?u h??ng cho khách -->
                <c:if test="${sessionScope.role == null}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> <span>Home</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="fas fa-book"></i> <span>All Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/globalAnn.jsp"><i class="fas fa-bullhorn"></i> <span>Announcements</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/#"><i class="fas fa-shopping-cart"></i> <span>Cart</span></a></li>
                    <!-- Dòng phân cách -->
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> <span>Sign In / Up</span></a></li>
                    </div>
                </c:if>

                <!-- Liên k?t ?i?u h??ng cho ng??i h?c -->
                <c:if test="${sessionScope.role == 'LEARNER'}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/homePage.jsp"><i class="fas fa-home"></i> <span>Home</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="fas fa-book"></i> <span>All Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="#"><i class="fas fa-graduation-cap"></i> <span>My Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/globalAnn.jsp"><i class="fas fa-bullhorn"></i> <span>Announcements</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="#"><i class="fas fa-shopping-cart"></i> <span>Cart</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="notifications.jsp"><i class="fas fa-bell"></i> <span>Notifications</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/Degree"><i class="fas fa-graduation-cap"></i> <span>Degree</span></a></li>
                    <!-- Dòng phân cách -->
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/editProfile"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                    </div>
                </c:if>

                <!-- Liên k?t ?i?u h??ng cho ng??i h??ng d?n -->
                <c:if test="${sessionScope.role == 'INSTRUCTOR'}">
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/Instructor"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="manageCourses.jsp"><i class="fas fa-laptop-code"></i> <span>Manage Courses</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="analytics.jsp"><i class="fas fa-chart-line"></i> <span>Analytics</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="feedback.jsp"><i class="fas fa-comment-dots"></i> <span>Feedback</span></a></li>
                    <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="notifications.jsp"><i class="fas fa-bell"></i> <span>Notifications</span></a></li>
                    <!-- Dòng phân cách -->
                    <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="editProfile.jsp"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                        <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="logout.jsp"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                    </div>
                </c:if>
            </ul>
        </div>
    </body>
</html>
