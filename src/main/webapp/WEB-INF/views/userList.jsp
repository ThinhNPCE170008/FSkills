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

        .action-btn-info { color: #2563eb; } /* blue-600 */
        .action-btn-info:hover { background-color: #dbeafe; } /* blue-100 */

        .action-btn-ban { color: #f59e0b; } /* yellow-600 */
        .action-btn-ban:hover { background-color: #fef3c7; } /* yellow-100 */

        .action-btn-unban { color: #10b981; } /* green-600 */
        .action-btn-unban:hover { background-color: #d1fae5; } /* green-100 */

        .action-btn-delete { color: #ef4444; } /* red-600 */
        .action-btn-delete:hover { background-color: #fee2e2; } /* red-100 */

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
    </style>
</head>
<body class="flex flex-col h-screen font-inter bg-[#f0f2f5] text-gray-800">
    <button class="sidebar-toggle hidden md:hidden">
        <i class="bi bi-list text-lg"></i>
    </button>

    <jsp:include page="/layout/header_admin.jsp" />

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
                    <form action="alluser" method="get" class="flex-grow flex gap-3">
                        <input type="text" id="searchName" name="searchName" placeholder="Search by User Name..." value="${param.searchName}"
                               class="flex-grow p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary transition duration-200">
                        <button type="submit" class="btn btn-primary bg-primary text-white py-3 px-5 rounded-lg hover:bg-primary-dark transition duration-200">
                            <i class="fas fa-search mr-2"></i>Search
                        </button>
                        <button type="button" class="btn btn-secondary bg-gray-200 text-gray-700 py-3 px-5 rounded-lg hover:bg-gray-300 transition duration-200" onclick="window.location.href='alluser'">
                            Show All
                        </button>
                    </form>
                </div>

                <div class="table-wrapper overflow-x-auto bg-white rounded-lg shadow-sm">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <c:if test="${not empty listUsers}">
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
                            <c:forEach var="u" items="${listUsers}">
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
                                                <i class="fas fa-eye"></i> <%-- Thay SVG bằng Font Awesome icon --%>
                                            </button>
                                        </form>

                                        <form action="banAccountServlet" method="post" class="inline-block mx-1">
                                            <input type="hidden" name="characterName" value="${u.userName}">
                                            <input type="hidden" name="originalSearchName" value="${param.searchName}">
                                            <c:choose>
                                                <c:when test="${u.ban == 'NORMAL'}">
                                                    <button type="submit" class="action-btn text-yellow-600 hover:bg-yellow-100" title="Ban User">
                                                        <i class="fas fa-user-slash"></i> <%-- Thay SVG bằng Font Awesome icon --%>
                                                    </button>
                                                </c:when>
                                                <c:when test="${u.ban == 'BANNED'}">
                                                    <button type="submit" class="action-btn text-green-600 hover:bg-green-100" title="Unban User">
                                                        <i class="fas fa-user-check"></i> <%-- Thay SVG bằng Font Awesome icon --%>
                                                    </button>
                                                </c:when>
                                            </c:choose>
                                        </form>

                                        <form action="deleteAcc" method="post" onsubmit="return confirm('Are you sure you want to delete this account? This action cannot be undone.');" class="inline-block mx-1">
                                            <input type="hidden" name="deleteName" value="${u.userName}">
                                            <input type="hidden" name="originalSearchName" value="${param.searchName}">
                                            <button type="submit" class="action-btn text-red-600 hover:bg-red-100" title="Delete User">
                                                <i class="fas fa-trash-alt"></i> <%-- Thay SVG bằng Font Awesome icon --%>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listUsers}">
                                <tr>
                                    <td colspan="7" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                        <c:choose>
                                            <c:when test="${not empty param.searchName}">
                                                No user found with username: '${param.searchName}'.
                                            </c:when>
                                            <c:otherwise>
                                                There are no users to display.
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <c:if test="${not empty listUsers}">
                    <div class="pagination-container flex justify-end items-center mt-6">
                        <a href="#" class="disabled text-gray-400 cursor-not-allowed py-2 px-3 rounded-md">&laquo;</a>
                        <a href="#" class="active bg-primary text-white py-2 px-3 rounded-md font-medium shadow-md">1</a>
                        <a href="#" class="py-2 px-3 rounded-md text-gray-500 hover:bg-gray-200">2</a>
                        <a href="#" class="py-2 px-3 rounded-md text-gray-500 hover:bg-gray-200">3</a>
                        <span class="py-2 px-3 text-gray-500">...</span>
                        <a href="#" class="py-2 px-3 rounded-md text-gray-500 hover:bg-gray-200">10</a>
                        <a href="#" class="text-gray-500 hover:bg-gray-200 py-2 px-3 rounded-md">&raquo;</a>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script>
        // Script để ẩn/hiện thông báo (copy từ announcement.jsp)
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
    </script>
</body>
</html>
