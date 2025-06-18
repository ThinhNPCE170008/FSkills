<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>F-Skill | Sidebar</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" href="https://placehold.co/32x32/0284c7/ffffff?text=FS">

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <script>
        // Custom configuration for Tailwind CSS
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        inter: ['Inter', 'sans-serif'],
                    },
                    colors: {
                        primary: {
                            DEFAULT: '#0284c7', // sky-600
                            light: '#03a9f4',   // sky-500
                            dark: '#075985',   // sky-800
                        },
                        secondary: '#475569', // slate-600
                    }
                }
            }
        }
    </script>

    <style>
        /* Sidebar-specific styles */
        .sidebar-container {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            width: 250px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            transition: transform 0.3s ease;
            overflow-y: auto;
        }
        .sidebar-container.collapsed {
            transform: translateX(-100%);
        }
        .sidebar-toggle {
            position: fixed;
            top: 1rem;
            left: 1rem;
            z-index: 1001;
            background: #0284c7;
            color: white;
            padding: 8px;
            border-radius: 50%;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        .sidebar-toggle:hover {
            background-color: #075985;
            transform: scale(1.1);
        }
        .nav-link {
            transition: color 0.3s ease, background-color 0.3s ease;
        }
        .nav-link:hover {
            color: #0284c7;
            background-color: rgba(2, 132, 199, 0.1);
        }
        .search-bar {
            position: relative;
        }
        .search-bar input {
            transition: all 0.3s ease-in-out;
        }
        .search-button {
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        .search-button:hover {
            background-color: #0284c7;
            transform: scale(1.1);
        }
        .icon-container {
            position: relative;
            transition: transform 0.3s ease, color 0.3s ease;
        }
        .icon-container:hover {
            color: #0284c7;
            transform: scale(1.1);
        }
        .badge {
            top: -8px;
            right: -8px;
            font-size: 0.75rem;
            padding: 2px 6px;
        }
        .logo-img {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-radius: 8px;
            padding: 4px;

        }
        .logo-img:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        @media (max-width: 768px) {
            .sidebar-container {
                transform: translateX(-100%);
            }
            .sidebar-container.active {
                transform: translateX(0);
            }
        }
    </style>
</head>

<body class="font-inter bg-white text-gray-800">
<!-- Sidebar Toggle Button (for mobile) -->
<button class="sidebar-toggle hidden md:hidden">
    <i class="bi bi-list text-lg"></i>
</button>

<!-- Sidebar -->
<aside class="w-64 bg-white p-4 shadow-lg flex flex-col rounded-tr-lg rounded-br-lg overflow-y-auto">
    <div class="flex items-center space-x-3 mb-8 p-2">
        <div class="w-12 h-12 bg-gray-200 rounded-full overflow-hidden flex items-center justify-center text-gray-500 text-xl font-semibold">
            <c:choose>
                <c:when test="${not empty sessionScope.user.avatar}">
                    <img src="${sessionScope.user.avatar}" alt="Avatar" class="w-full h-full object-cover">
                </c:when>
            </c:choose>
        </div>
        <div class="text-lg font-medium text-gray-800">
            <c:choose>
                <c:when test="${not empty sessionScope.user.displayName}">
                    <c:out value="${sessionScope.user.displayName}" />
                </c:when>
                <c:otherwise>
                    Guest
                </c:otherwise>
            </c:choose>
        </div>
    </div>


    <nav class="flex-grow">
        <ul>
            <li class="mb-2">
                <%-- Thêm URL cho Dashboard --%>
                <a href="${pageContext.request.contextPath}/adminDashboard" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-tachometer-alt nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Dashboard</span>
                </a>
            </li>
            <li class="mb-2">
                <%-- Liên kết đến trang quản lý Bills --%>
                <a href="${pageContext.request.contextPath}/admin/bills" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-file-invoice-dollar nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Bills</span>
                </a>
            </li>
            <li class="mb-2">
                <%-- Liên kết đến trang quản lý Announcement --%>
                <a href="${pageContext.request.contextPath}/Announcement" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-bullhorn nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Announcement</span>
                </a>
            </li>
            <li class="mb-2">
                <%-- Liên kết đến trang quản lý Course --%>
                <a href="${pageContext.request.contextPath}/DegreeAdmin" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-file-invoice-dollar nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Manage Degrees</span>
                </a>
            </li>
            <li class="mb-2">
                <%-- Liên kết đến trang quản lý Company --%>
                <a href="${pageContext.request.contextPath}/voucherList" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-building nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Company</span>
                </a>
            </li>
            <li class="mb-2">
                <%-- Liên kết đến trang Manage Account --%>
                <a href="${pageContext.request.contextPath}/alluser" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-users-cog nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Manage Account</span>
                </a>
            </li>
            <li class="mb-2">
                <%-- Liên kết đến trang Report --%>
                <a href="${pageContext.request.contextPath}/admin/reports" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-chart-line nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Report</span>
                </a>
            </li>
        </ul>
    </nav>

    <div class="mt-auto">
        <ul>
            <li class="mb-2">
                <%-- Liên kết đến trang Profile --%>
                <a href="${pageContext.request.contextPath}/admin/profile" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-user-circle nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Profile</span>
                </a>
            </li>
            <li class="mb-2">
                <%-- Liên kết đến trang Setting --%>
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-cog nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Setting</span>
                </a>
            </li>
            <li class="mb-2">
                <%-- Liên kết đăng xuất --%>
                <a href="${pageContext.request.contextPath}/logout" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                    <i class="fas fa-sign-out-alt nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                    <span class="nav-text text-gray-800 font-medium group-hover:text-white">Đăng xuất</span>
                </a>
            </li>
        </ul>
    </div>
</aside>

<script>
    // Toggle sidebar on mobile
    document.querySelector('.sidebar-toggle').addEventListener('click', () => {
        document.querySelector('.sidebar-container').classList.toggle('active');
    });
</script>
</body>
</html>