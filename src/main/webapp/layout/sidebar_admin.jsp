<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${sessionScope.user == null}">
    <c:redirect url="login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Sidebar</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome CDN -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
        }

        /* CSS cho sidebar */
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

        /* ?n v?n b?n khi thu g?n */
        .sidebar-container .sidebar-logo span,
        .sidebar-container .nav-link span,
        .sidebar-container .user-info span {
            opacity: 0;
            visibility: hidden;
            white-space: nowrap;
            transition: opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
        }

        /* Hi?n th? v?n b?n khi m? r?ng */
        .sidebar-container:hover .sidebar-logo span,
        .sidebar-container:hover .nav-link span,
        .sidebar-container:hover .user-info span {
            opacity: 1;
            visibility: visible;
        }

        /* C?n ch?nh bi?u t??ng */
        .sidebar-container .nav-link i {
            min-width: 24px;
            text-align: center;
            margin-right: 8px;
        }

        /* ?i?u ch?nh l? body */
        body {
            margin-left: 60px;
            transition: margin-left 0.3s ease-in-out;
        }

        /* ?i?u ch?nh l? main khi sidebar m? r?ng */
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
<div class="sidebar-container bg-white border-r border-gray-200 shadow-xl rounded-r-lg p-3">
    <!-- Logo Section -->
    <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="flex items-center mb-6 text-decoration-none sidebar-logo text-gray-800" aria-label="F-SKILL Home">
        <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class="w-15 h-15 mr-2 rounded-md" loading="lazy"/>
        <span class="text-xl font-extrabold whitespace-nowrap">F-SKILL</span>
    </a>
        <!-- Avatar v� Th�ng tin ng??i d�ng -->
        <div class="flex flex-col items-center mb-6 pb-4 border-b border-gray-200">
            <div class="w-16 h-16 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 text-xl font-semibold border-2 border-indigo-500 shadow-md">
                <c:choose>
                    <c:when test="${not empty sessionScope.user.avatar}">
                        <img src="${pageContext.request.contextPath}/${sessionScope.user.avatar}" alt="Admin Avatar" class="rounded-full w-16 h-16 object-cover" loading="lazy">
                    </c:when>
                    <c:otherwise>
                        AD
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="user-info text-center mt-2">
                <span class="block text-gray-800 font-medium">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.displayName}">
                            <c:out value="${sessionScope.user.displayName}"/>
                        </c:when>
                        <c:otherwise>
                            Admin User
                        </c:otherwise>
                    </c:choose>
                </span>
            <span class="block text-sm text-gray-500">Admin</span>
        </div>

        <ul class="flex flex-col space-y-2">
            <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/adminDashboard" aria-label="Dashboard"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
            <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/bills" aria-label="Bills"><i class="fas fa-receipt"></i> <span>Bills</span></a></li>
            <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/voucherList" aria-label="Company"><i class="fas fa-building"></i> <span>Company</span></a></li>
            <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/admin/announcement" aria-label="Announcements"><i class="fas fa-bullhorn"></i> <span>Announcements</span></a></li>
            <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/manageDegree" aria-label="Manage Degree"><i class="fas fa-graduation-cap"></i> <span>Manage Degree</span></a></li>
            <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/alluser" aria-label="Manage Accounts"><i class="fas fa-users"></i> <span>Manage Accounts</span></a></li>
            <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/report" aria-label="Report"><i class="fas fa-chart-bar"></i> <span>Report</span></a></li>
            <div class="flex flex-col mt-6 pt-5 border-t border-gray-200">
                <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/learner/profile" aria-label="Profile"><i class="fas fa-user-circle"></i> <span>Profile</span></a></li>
                <li><a class="nav-link flex items-center text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 p-2 rounded-md transition-colors duration-200" href="${pageContext.request.contextPath}/logout" aria-label="Logout"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
            </div>
        </ul>
    </div>

    <!-- Sidebar menu -->
    <ul class="nav nav-pills flex-column">
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/admin"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/bills"><i class="bi bi-receipt"></i> <span>Bills</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/voucherList"><i class="bi bi-building"></i> <span>Company</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/manageDegree"><i class="bi bi-mortarboard"></i> <span>Manage Degree</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/alluser"><i class="bi bi-people"></i> <span>Manage Account</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/report"><i class="bi bi-bar-chart"></i> <span>Report</span></a></li>
               <div  class="d-flex flex-column mb-4 pt-5 border-top">
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/editProfile"><i class="bi bi-person"></i> <span>Profile</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a></li>
               </div>
    </ul>
</div>
</body>
</html>
