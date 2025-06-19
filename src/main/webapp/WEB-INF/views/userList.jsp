<%--
    Document   : userList
    Created on : Jun 10, 2025
    Author     : Dell
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Account List</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #6b7280;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --light-grey: #f9fafb;
            --grey-border: #e5e7eb;
            --text-dark: #111827;
            --text-light: #6b7280;
            --sidebar-width: 250px; /* Định nghĩa chiều rộng sidebar */
        }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0; /* Loại bỏ padding ở đây vì container chính sẽ quản lý */
            color: var(--text-dark);
            display: flex; /* Dùng Flexbox cho body để chứa sidebar và main content */
            min-height: 100vh; /* Đảm bảo chiều cao tối thiểu là 100% viewport */
        }

        /* Styles for the main content area (excluding sidebar) */
        .main-content-wrapper {
            flex-grow: 1; /* Cho phép phần nội dung chính chiếm hết không gian còn lại */
            padding: 20px; /* Padding cho toàn bộ khu vực nội dung chính */
            box-sizing: border-box; /* Tính padding vào kích thước */
            display: flex; /* Dùng flexbox để căn giữa page-container */
            justify-content: center; /* Căn giữa theo chiều ngang */
            align-items: flex-start; /* Căn trên đầu theo chiều dọc */
        }

        .page-container {
            width: 100%; /* Chiếm toàn bộ chiều rộng của main-content-wrapper */
            max-width: 1200px;
            /* margin: 20px auto;  Loại bỏ margin tự động vì đã căn giữa bằng flexbox */
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(17, 24, 39, 0.05);
            padding: 32px;
            box-sizing: border-box; /* Đảm bảo padding không làm tăng kích thước vượt quá max-width */
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--grey-border);
        }

        .page-header h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .return-link {
            text-decoration: none;
            color: var(--secondary-color);
            font-weight: 500;
            padding: 8px 12px;
            border-radius: 8px;
            transition: background-color 0.2s ease;
        }
        .return-link:hover {
            background-color: var(--light-grey);
        }

        .search-form {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-form input[type="text"] {
            padding: 10px 14px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            min-width: 250px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .search-form input[type="text"]:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.2);
        }

        .btn {
            padding: 10px 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.2s ease, box-shadow 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        .btn-primary:hover {
            background-color: #4338ca;
        }

        .btn-secondary {
            background-color: #e5e7eb;
            color: #374151;
        }
        .btn-secondary:hover {
            background-color: #d1d5db;
        }

        /* Message styles */
        .message {
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
            text-align: center;
        }
        .message-success {
            background-color: #d1fae5;
            color: #065f46;
        }
        .message-error {
            background-color: #fee2e2;
            color: #991b1b;
        }

        /* Table styles */
        .table-wrapper {
            width: 100%;
            overflow-x: auto; /* For responsiveness */
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 16px;
            text-align: left;
            border-bottom: 1px solid var(--grey-border);
            vertical-align: middle;
        }

        th {
            background-color: var(--light-grey);
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-light);
        }

        tr:last-child td {
            border-bottom: none;
        }

        .actions-cell form {
            display: inline-block;
            margin-right: 8px;
        }

        .action-btn {
            background-color: transparent;
            border: none;
            cursor: pointer;
            padding: 6px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.2s ease;
        }
        .action-btn svg {
            width: 20px;
            height: 20px;
        }

        .action-btn-info { color: #2563eb; }
        .action-btn-info:hover { background-color: #dbeafe; }

        .action-btn-ban { color: var(--warning-color); }
        .action-btn-ban:hover { background-color: #fef3c7; }

        .action-btn-unban { color: var(--success-color); }
        .action-btn-unban:hover { background-color: #d1fae5; }

        .action-btn-delete { color: var(--danger-color); }
        .action-btn-delete:hover { background-color: #fee2e2; }

        .no-results td {
            text-align: center;
            color: var(--text-light);
            padding: 40px;
            font-size: 16px;
        }

        /* Pagination styles */
        .pagination-container {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-top: 24px;
        }

        .pagination-container a, .pagination-container span {
            text-decoration: none;
            color: var(--text-light);
            padding: 8px 14px;
            margin: 0 2px;
            border-radius: 6px;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .pagination-container a:hover {
            background-color: #e5e7eb;
            color: var(--text-dark);
        }

        .pagination-container .active {
            background-color: var(--primary-color);
            color: white;
            font-weight: 500;
            box-shadow: 0 2px 4px rgba(79, 70, 229, 0.2);
        }

        .pagination-container .disabled {
            color: #d1d5db;
            cursor: not-allowed;
        }

        /* Responsive adjustments for overall layout */
        @media (max-width: 768px) {
            body {
                flex-direction: column; /* Stack sidebar and main content vertically */
            }
            .sidebar { /* Assuming sidebar.jsp's root element has .sidebar class */
                width: 100% !important; /* Sidebar takes full width on small screens */
                height: auto;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                flex-direction: row; /* Make sidebar items horizontal */
                justify-content: space-around;
                padding: 10px 0;
            }
            .sidebar ul { /* Adjust sidebar menu for horizontal layout */
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
            }
            .sidebar ul li {
                width: auto;
            }
            .sidebar ul li a {
                padding: 10px 15px;
                font-size: 0.9em;
            }
            .main-content-wrapper {
                padding: 15px; /* Adjust padding for smaller screens */
            }
            .page-container {
                margin: 0; /* Remove top/bottom margin */
                padding: 20px; /* Adjust padding for smaller screens */
                box-shadow: none; /* Remove shadow to reduce visual clutter */
                border-radius: 0;
            }
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .header-actions {
                width: 100%;
                justify-content: flex-end;
            }
            .search-form {
                flex-direction: column;
                align-items: stretch;
            }
            .search-form input[type="text"] {
                min-width: unset;
                width: 100%;
            }
            .search-form .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/sidebar.jsp"/>

    <div class="main-content-wrapper">
        <div class="page-container">
            <div class="page-header">
                <h2>Account List</h2>
                <div class="header-actions">
                    <a href="adminDashboard" class="return-link">Return to Dashboard</a>
                </div>
            </div>

            <c:if test="${not empty sessionScope.deleteComplete}">
                <p class="message ${sessionScope.deleteComplete.contains('successful') ? 'message-success' : 'message-error'}">
                    ${sessionScope.deleteComplete}
                </p>
                <c:remove var="deleteComplete" scope="session"/>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <p class="message message-error">${errorMessage}</p>
            </c:if>

            <div class="search-form" style="margin-bottom: 24px;">
                <form action="alluser" method="get" style="display: flex; flex-grow: 1; gap: 10px;">
                    <input type="text" id="searchName" name="searchName" placeholder="Search by User Name..." value="${param.searchName}">
                    <button type="submit" class="btn btn-primary">Search</button>
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='alluser'">Show All</button>
                </form>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <c:if test="${not empty listUsers}">
                            <tr>
                                <th>ID</th>
                                <th>UserName</th>
                                <th>DisplayName</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Reports</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </c:if>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${listUsers}">
                            <tr>
                                <td>${u.userId}</td>
                                <td><strong>${u.userName}</strong></td>
                                <td>${u.displayName}</td>
                                <td>${u.role}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.ban == 'BANNED'}">
                                            <span style="color: var(--danger-color); font-weight: 500;">Banned</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--success-color); font-weight: 500;">Normal</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${u.reports}</td>
                                <td class="actions-cell" style="text-align: center;">
                                    <form action="aboutInform" method="get">
                                        <input type="hidden" name="userInform" value="${u.userName}">
                                        <button type="submit" class="action-btn action-btn-info" title="View All Information">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z" /><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /></svg>
                                        </button>
                                    </form>

                                    <form action="banAccountServlet" method="post">
                                        <input type="hidden" name="characterName" value="${u.userName}">
                                        <input type="hidden" name="originalSearchName" value="${param.searchName}">
                                        <c:choose>
                                            <c:when test="${u.ban == 'NORMAL'}">
                                                <button type="submit" class="action-btn action-btn-ban" title="Ban User">
                                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" /></svg>
                                                </button>
                                            </c:when>
                                            <c:when test="${u.ban == 'BANNED'}">
                                                <button type="submit" class="action-btn action-btn-unban" title="Unban User">
                                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>
                                                </button>
                                            </c:when>
                                        </c:choose>
                                    </form>

                                    <form action="deleteAcc" method="post" onsubmit="return confirm('Are you sure you want to delete this account? This action cannot be undone.');">
                                        <input type="hidden" name="deleteName" value="${u.userName}">
                                        <input type="hidden" name="originalSearchName" value="${param.searchName}">
                                        <button type="submit" class="action-btn action-btn-delete" title="Delete User">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.134-2.09-2.134H8.09a2.09 2.09 0 00-2.09 2.134v.916m7.5 0a48.667 48.667 0 00-7.5 0" /></svg>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty listUsers}">
                            <tr class="no-results">
                                <td colspan="7">
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
                <div class="pagination-container">
                    <a href="#" class="disabled">&laquo;</a>
                    <a href="#" class="active">1</a>
                    <a href="#">2</a>
                    <a href="#">3</a>
                    <span>...</span>
                    <a href="#">10</a>
                    <a href="#">&raquo;</a>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>