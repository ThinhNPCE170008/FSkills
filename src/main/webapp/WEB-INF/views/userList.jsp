<%--
    Document   : userList
    Created on : May 23, 2025, 2:53:00 PM
    Author     : DELL
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Quản Trị F-SKILL - Quản lý Người dùng</title>

        <link rel="icon" type="image/png" href="https://placehold.co/32x32/0284c7/ffffff?text=FS">

        <script src="https://cdn.tailwindcss.com"></script>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        fontFamily: {
                            inter: ['Inter', 'sans-serif'],
                        },
                        colors: {
                            primary: {
                                DEFAULT: '#0284c7',
                                light: '#03a9f4',
                                dark: '#075985',
                            },
                            secondary: '#475569',
                        }
                    }
                }
            }
        </script>

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f0f2f5;
            }

            /* Style cho thanh cuộn */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 10px;
            }

            ::-webkit-scrollbar-thumb {
                background: #888;
                border-radius: 10px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: #555;
                border-radius: 10px;
            }

            .nav-item:hover .nav-icon,
            .nav-item:hover .nav-text {
                color: white;
            }

            .nav-item:hover {
                background-color: #000; /* Đổi màu nền thành đen khi hover */
            }

            .sidebar-container {
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
            /* Button toggle cho mobile */
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
            @media (max-width: 768px) {
                .sidebar-container {
                    transform: translateX(-100%);
                }
                .sidebar-container.active {
                    transform: translateX(0);
                }
            }

            .page-container {
            }

            .table-wrapper {
                width: 100%;
                overflow-x: auto; /* For responsiveness */
            }

            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 0.875rem; /* text-sm */
                color: #1f2937; /* text-gray-800 */
            }

            th, td {
                padding: 1rem; /* p-4 */
                text-align: left;
                border-bottom: 1px solid #e5e7eb; /* border-gray-200 */
                vertical-align: middle;
            }

            th {
                background-color: #f9fafb; /* bg-gray-100 */
                font-size: 0.75rem; /* text-xs */
                font-weight: 500; /* font-medium */
                text-transform: uppercase;
                letter-spacing: 0.05em; /* tracking-wider */
                color: #6b7280; /* text-gray-600 */
            }

            tr:last-child td {
                border-bottom: none;
            }

            .actions-cell form {
                display: inline-block;
                margin-right: 0.5rem; /* mr-2 */
            }

            .action-btn {
                background-color: transparent;
                border: none;
                cursor: pointer;
                padding: 0.5rem; /* p-2 */
                border-radius: 0.375rem; /* rounded-md */
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: background-color 0.2s ease;
            }
            .action-btn svg {
                width: 1.25rem; /* w-5 */
                height: 1.25rem; /* h-5 */
            }

            .action-btn-info {
                color: #2563eb;
            } /* blue-600 */
            .action-btn-info:hover {
                background-color: #dbeafe;
            } /* blue-100 */

            .action-btn-ban {
                color: #f59e0b;
            } /* yellow-600 */
            .action-btn-ban:hover {
                background-color: #fef3c7;
            } /* yellow-100 */

            .action-btn-unban {
                color: #10b981;
            } /* green-600 */
            .action-btn-unban:hover {
                background-color: #d1fae5;
            } /* green-100 */

            .action-btn-delete {
                color: #ef4444;
            } /* red-600 */
            .action-btn-delete:hover {
                background-color: #fee2e2;
            } /* red-100 */

            .no-results td {
                text-align: center;
                color: #6b7280; /* text-gray-500 */
                padding: 2.5rem; /* p-10 */
                font-size: 1rem; /* text-base */
            }

            /* Pagination styles */
            .pagination-container {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                margin-top: 1.5rem; /* mt-6 */
            }

            .pagination-container a, .pagination-container span {
                text-decoration: none;
                color: #6b7280; /* text-gray-500 */
                padding: 0.5rem 0.875rem; /* py-2 px-3.5 */
                margin: 0 0.125rem; /* mx-0.5 */
                border-radius: 0.375rem; /* rounded-md */
                transition: background-color 0.2s ease, color 0.2s ease;
            }

            .pagination-container a:hover {
                background-color: #e5e7eb; /* bg-gray-200 */
                color: #1f2937; /* text-gray-800 */
            }

            .pagination-container .active {
                background-color: #0284c7; /* primary color */
                color: white;
                font-weight: 500;
                box-shadow: 0 2px 4px rgba(2, 132, 199, 0.2); /* shadow-md with primary color */
            }

            .pagination-container .disabled {
                color: #d1d5db; /* text-gray-300 */
                cursor: not-allowed;
            }

            /* Styles for role filtering */
            .role-filter {
                margin-bottom: 1.5rem; /* mb-6 */
                display: flex;
                align-items: center;
                gap: 1rem; /* space-x-4 */
            }
            .role-filter label {
                font-weight: 500; /* font-medium */
                color: #1f2937; /* text-gray-800 */
            }
            .role-filter input[type="radio"] {
                margin-right: 0.25rem; /* mr-1 */
            }

            /* Hide specific lists by default */
            .instructor-table-wrapper {
                display: none;
            }
        </style>
    </head>
    <body class="flex flex-col h-screen font-inter bg-[#f0f2f5] text-gray-800">
        <button class="sidebar-toggle hidden md:hidden">
            <i class="bi bi-list text-lg"></i>
        </button>

        <header class="bg-white shadow-md p-4 flex items-center justify-between rounded-b-lg">
            <div class="flex items-center space-x-2">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class=" w-20 h-15"/>
                <span class="text-2xl font-bold text-gray-800"></span>
            </div>

            <div class="relative flex-grow mx-4 max-w-md">
                <input type="text" placeholder="Tìm kiếm..."
                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-primary">
                <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>

            <div class="flex items-center space-x-4">
                <div class="relative cursor-pointer" id="notification-bell">
                    <i class="fas fa-bell text-gray-600 text-xl"></i>
                    <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center">3</span>
                    <div id="notification-popup"
                         class="hidden absolute right-0 mt-2 w-72 bg-white border border-gray-200 rounded-lg shadow-lg z-10">
                        <div class="p-4 border-b border-gray-200 font-semibold text-gray-800">Thông báo mới</div>
                        <ul class="divide-y divide-gray-100">
                            <li class="p-3 hover:bg-gray-50 cursor-pointer">
                                <p class="text-sm font-medium text-gray-900">Thông báo 1: Đã có hóa đơn mới.</p>
                                <p class="text-xs text-gray-500">2 giờ trước</p>
                            </li>
                            <li class="p-3 hover:bg-gray-50 cursor-pointer">
                                <p class="text-sm font-medium text-gray-900">Thông báo 2: Cập nhật hệ thống.</p>
                                <p class="text-xs text-gray-500">Hôm qua</p>
                            </li>
                            <li class="p-3 hover:bg-gray-50 cursor-pointer">
                                <p class="text-sm font-medium text-gray-900">Thông báo 3: Lịch họp sắp tới.</p>
                                <p class="text-xs text-gray-500">3 ngày trước</p>
                            </li>
                        </ul>
                        <div class="p-3 text-center border-t border-gray-200">
                            <a href="#" class="text-blue-600 text-sm hover:underline">Xem tất cả</a>
                        </div>
                    </div>
                </div>
                <div class="flex items-center space-x-2">
                    <div class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 text-sm font-semibold">
                        <c:choose>
                            <c:when test="${not empty sessionScope.adminUser.avatar}">
                                <img src="${sessionScope.adminUser.avatar}" alt="Avatar" class="w-full h-full object-cover rounded-full">
                            </c:when>
                            <c:otherwise>
                                AD
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <%-- Hiển thị tên Admin từ session --%>
                    <span class="font-medium text-gray-700">
                        <c:choose>
                            <c:when test="${not empty sessionScope.adminUser.displayName}">
                                ${sessionScope.adminUser.displayName}
                            </c:when>
                            <c:otherwise>
                                Admin User
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </header>

        <div class="flex flex-grow">
            <jsp:include page="/layout/sidebar_admin.jsp" />

            <main class="flex-grow p-6 bg-[#DFEBF6] rounded-tl-lg overflow-y-auto">
                <div class="bg-white p-6 rounded shadow-sm">
                    <div class="page-header flex justify-between items-center mb-6 pb-4 border-b border-gray-200">
                        <h2 class="text-2xl font-bold text-gray-800 m-0">Account List</h2>
                        <div class="header-actions flex gap-3">
                            <a href="${pageContext.request.contextPath}/admin" class="text-gray-600 font-medium py-2 px-3 rounded-md hover:bg-gray-100 transition duration-200">
                                Return to Dashboard
                            </a>
                        </div>
                    </div>

                    <c:if test="${not empty sessionScope.deleteComplete}">
                        <p class="message ${sessionScope.deleteComplete.contains('successful') ? 'message-success bg-green-100 text-green-800' : 'message-error bg-red-100 text-red-800'} p-3 rounded-lg mb-4 text-center">
                            ${sessionScope.deleteComplete}
                        </p>
                        <c:remove var="deleteComplete" scope="session"/>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <p class="message message-error bg-red-100 text-red-800 p-3 rounded-lg mb-4 text-center">${errorMessage}</p>
                    </c:if>

                    <div class="search-form flex items-center gap-3 mb-6">
                        <form action="alluser" method="get" class="flex-grow flex gap-3" id="searchForm"> <%-- THÊM ID CHO FORM --%>
                            <input type="text" id="searchName" name="searchName" placeholder="Search by User Name..." value="${param.searchName}"
                                   class="flex-grow p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary transition duration-200">
                            <button type="submit" class="btn btn-primary bg-primary text-white py-3 px-5 rounded-lg hover:bg-primary-dark transition duration-200">
                                <i class="fas fa-search mr-2"></i>Search
                            </button>
                            <button type="button" class="btn btn-secondary bg-gray-200 text-gray-700 py-3 px-5 rounded-lg hover:bg-gray-300 transition duration-200" onclick="window.location.href = 'alluser'">
                                Show All
                            </button>
                            <%-- INPUT HIDDEN ĐỂ LƯU TRỮ ROLE ĐƯỢC CHỌN HIỆN TẠI --%>
                            <input type="hidden" name="roleFilter" id="currentRoleFilter" value="${param.roleFilter != null ? param.roleFilter : 'Learner'}">
                        </form>
                    </div>

                    <%-- Role Selection Radios --%>
                    <div class="role-filter mb-6">
                        <label class="block text-sm font-medium text-gray-700">Filter by Role:</label>
                        <div class="flex items-center gap-4">
                            <input type="radio" id="filterLearner" name="roleFilter" value="Learner" checked onchange="toggleUserLists()">
                            <label for="filterLearner" class="text-gray-800 font-medium cursor-pointer">Learner</label>

                            <input type="radio" id="filterInstructor" name="roleFilter" value="Instructor" onchange="toggleUserLists()">
                            <label for="filterInstructor" class="text-gray-800 font-medium cursor-pointer">Instructor</label>
                        </div>
                    </div>

                    <%-- Learner List Section --%>
                    <div id="learnerTable" class="table-wrapper overflow-x-auto bg-white rounded-lg shadow-sm">
                        <h3 class="text-xl font-semibold text-gray-800 p-4 border-b border-gray-200">Learner Accounts</h3>
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <c:if test="${not empty listLearners}"> <%-- Use listLearners for Learner data --%>
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">UserName</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">DisplayName</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Reports</th>
                                        <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                    </tr>
                                </c:if>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="u" items="${listLearners}"> <%-- Iterate over Learner list --%>
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${u.userId}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><strong>${u.userName}</strong></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${u.displayName}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${u.role}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm">
                                            <c:choose>
                                                <c:when test="${u.ban == 'BANNED'}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">Banned</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Normal</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${u.reports}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium text-center">
                                            <form action="aboutInform" method="get" class="inline-block mx-1">
                                                <input type="hidden" name="userInform" value="${u.userName}">
                                                <button type="submit" class="action-btn text-blue-600 hover:bg-blue-100" title="View All Information">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </form>

                                            <form action="banAccountServlet" method="post" class="inline-block mx-1">
                                                <input type="hidden" name="characterName" value="${u.userName}">
                                                <input type="hidden" name="originalSearchName" value="${param.searchName}">
                                                <c:choose>
                                                    <c:when test="${u.ban == 'NORMAL'}">
                                                        <button type="submit" class="action-btn text-yellow-600 hover:bg-yellow-100" title="Ban User">
                                                            <i class="fas fa-user-slash"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${u.ban == 'BANNED'}">
                                                        <button type="submit" class="action-btn text-green-600 hover:bg-green-100" title="Unban User">
                                                            <i class="fas fa-user-check"></i>
                                                        </button>
                                                    </c:when>
                                                </c:choose>
                                            </form>

                                            <form action="deleteAcc" method="post" onsubmit="return confirm('Are you sure you want to delete this account? This action cannot be undone.');" class="inline-block mx-1">
                                                <input type="hidden" name="deleteName" value="${u.userName}">
                                                <input type="hidden" name="originalSearchName" value="${param.searchName}">
                                                <button type="submit" class="action-btn text-red-600 hover:bg-red-100" title="Delete User">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty listLearners}"> <%-- Check if Learner list is empty --%>
                                    <tr>
                                        <td colspan="7" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                            <c:choose>
                                                <c:when test="${not empty param.searchName}">
                                                    No learner found with username: '${param.searchName}'.
                                                </c:when>
                                                <c:otherwise>
                                                    There are no learners to display.
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <%-- Instructor List Section (Hidden by Default) --%>
                    <div id="instructorTable" class="table-wrapper instructor-table-wrapper overflow-x-auto bg-white rounded-lg shadow-sm">
                        <h3 class="text-xl font-semibold text-gray-800 p-4 border-b border-gray-200">Instructor Accounts</h3>
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <c:if test="${not empty listInstructors}"> <%-- Use listInstructors for Instructor data --%>
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">UserName</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">DisplayName</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Reports</th>
                                        <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                    </tr>
                                </c:if>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="u" items="${listInstructors}"> <%-- Iterate over Instructor list --%>
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${u.userId}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><strong>${u.userName}</strong></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${u.displayName}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${u.role}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm">
                                            <c:choose>
                                                <c:when test="${u.ban == 'BANNED'}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">Banned</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Normal</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${u.reports}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium text-center">
                                            <form action="aboutInform" method="get" class="inline-block mx-1">
                                                <input type="hidden" name="userInform" value="${u.userName}">
                                                <button type="submit" class="action-btn text-blue-600 hover:bg-blue-100" title="View All Information">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </form>

                                            <form action="banAccountServlet" method="post" class="inline-block mx-1">
                                                <input type="hidden" name="characterName" value="${u.userName}">
                                                <input type="hidden" name="originalSearchName" value="${param.searchName}">
                                                <c:choose>
                                                    <c:when test="${u.ban == 'NORMAL'}">
                                                        <button type="submit" class="action-btn text-yellow-600 hover:bg-yellow-100" title="Ban User">
                                                            <i class="fas fa-user-slash"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${u.ban == 'BANNED'}">
                                                        <button type="submit" class="action-btn text-green-600 hover:bg-green-100" title="Unban User">
                                                            <i class="fas fa-user-check"></i>
                                                        </button>
                                                    </c:when>
                                                </c:choose>
                                            </form>

                                            <form action="deleteAcc" method="post" onsubmit="return confirm('Are you sure you want to delete this account? This action cannot be undone.');" class="inline-block mx-1">
                                                <input type="hidden" name="deleteName" value="${u.userName}">
                                                <input type="hidden" name="originalSearchName" value="${param.searchName}">
                                                <button type="submit" class="action-btn text-red-600 hover:bg-red-100" title="Delete User">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty listInstructors}"> <%-- Check if Instructor list is empty --%>
                                    <tr>
                                        <td colspan="7" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                            <c:choose>
                                                <c:when test="${not empty param.searchName}">
                                                    No instructor found with username: '${param.searchName}'.
                                                </c:when>
                                                <c:otherwise>
                                                    There are no instructors to display.
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <%-- Pagination for current active list --%>
                    <div id="paginationContainer" class="pagination-container flex justify-end items-center mt-6">
                        <%-- This pagination should ideally be dynamically updated based on the visible list and its data --%>
                        <a href="#" class="disabled text-gray-400 cursor-not-allowed py-2 px-3 rounded-md">&laquo;</a>
                        <a href="#" class="active bg-primary text-white py-2 px-3 rounded-md font-medium shadow-md">1</a>
                        <a href="#" class="py-2 px-3 rounded-md text-gray-500 hover:bg-gray-200">2</a>
                        <a href="#" class="py-2 px-3 rounded-md text-gray-500 hover:bg-gray-200">3</a>
                        <span class="py-2 px-3 text-gray-500">...</span>
                        <a href="#" class="py-2 px-3 rounded-md text-gray-500 hover:bg-gray-200">10</a>
                        <a href="#" class="text-gray-500 hover:bg-gray-200 py-2 px-3 rounded-md">&raquo;</a>
                    </div>

                </div>
            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
        <script>
                                                const notificationBell = document.getElementById('notification-bell');
                                                const notificationPopup = document.getElementById('notification-popup');

                                                notificationBell.addEventListener('click', (event) => {
                                                    event.stopPropagation();
                                                    notificationPopup.classList.toggle('hidden');
                                                });

                                                document.addEventListener('click', (event) => {
                                                    if (!notificationBell.contains(event.target) && !notificationPopup.contains(event.target)) {
                                                        notificationPopup.classList.add('hidden');
                                                    }
                                                });

                                                document.querySelector('.sidebar-toggle').addEventListener('click', () => {
                                                    document.querySelector('.sidebar-container').classList.toggle('active');
                                                });

                                                // --- JavaScript for Role Filtering ---
                                                // --- JavaScript for Role Filtering ---
                                                function toggleUserLists() {
                                                    const learnerRadio = document.getElementById('filterLearner');
                                                    const instructorRadio = document.getElementById('filterInstructor');
                                                    const searchForm = document.getElementById('searchForm');
                                                    const currentRoleFilterInput = document.getElementById('currentRoleFilter');

                                                    let selectedRole = '';
                                                    if (learnerRadio.checked) {
                                                        selectedRole = 'Learner';
                                                    } else if (instructorRadio.checked) {
                                                        selectedRole = 'Instructor';
                                                    }

                                                    // Cập nhật giá trị của input hidden roleFilter trong form
                                                    currentRoleFilterInput.value = selectedRole;

                                                    // Gửi form để tải lại dữ liệu với cả searchName và roleFilter
                                                    searchForm.submit();
                                                }

// Gọi hàm này khi trang tải để đảm bảo hiển thị đúng bảng ban đầu dựa trên tham số URL
                                                document.addEventListener('DOMContentLoaded', () => {
                                                    const urlParams = new URLSearchParams(window.location.search);
                                                    const roleFilter = urlParams.get('roleFilter');
                                                    const searchName = urlParams.get('searchName'); // Lấy searchName từ URL

                                                    if (roleFilter === 'Instructor') {
                                                        document.getElementById('filterInstructor').checked = true;
                                                        document.getElementById('learnerTable').style.display = 'none'; // Giữ lại logic ẩn/hiện ban đầu
                                                        document.getElementById('instructorTable').style.display = 'block';
                                                    } else { // Mặc định hoặc Learner
                                                        document.getElementById('filterLearner').checked = true;
                                                        document.getElementById('learnerTable').style.display = 'block'; // Giữ lại logic ẩn/hiện ban đầu
                                                        document.getElementById('instructorTable').style.display = 'none';
                                                    }

                                                    // Đặt giá trị searchName vào input nếu có
                                                    if (searchName) {
                                                        document.getElementById('searchName').value = searchName;
                                                    }
                                                });

// Vẫn gọi toggleUserLists khi tải trang lần đầu để đảm bảo hiển thị đúng bảng
// dựa trên trạng thái ban đầu hoặc tham số URL.
                                                window.onload = function () {
                                                    // Không cần gọi toggleUserLists() ở đây nữa vì DOMContentLoaded đã xử lý.
                                                    // Chỉ cần đảm bảo trạng thái radio và hiển thị bảng khớp với tham số URL.
                                                    const urlParams = new URLSearchParams(window.location.search);
                                                    const roleFilter = urlParams.get('roleFilter');
                                                    if (roleFilter === 'Instructor') {
                                                        document.getElementById('filterInstructor').checked = true;
                                                        document.getElementById('learnerTable').style.display = 'none';
                                                        document.getElementById('instructorTable').style.display = 'block';
                                                    } else {
                                                        document.getElementById('filterLearner').checked = true;
                                                        document.getElementById('learnerTable').style.display = 'block';
                                                        document.getElementById('instructorTable').style.display = 'none';
                                                    }
                                                };
        </script>
    </body>
</html>