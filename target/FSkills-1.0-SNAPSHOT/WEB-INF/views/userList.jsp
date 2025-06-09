<%-- 
    Document   : userList
    Created on : May 21, 2025, 4:13:05 PM
    Author     : DELL
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>List of all users</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f4f7f6;
            }
            .container {
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 30px;
                max-width: 900px;
                margin: 20px auto;
            }
            h2 {
                color: #333;
                text-align: center;
                margin-bottom: 25px;
                border-bottom: 2px solid #007bff;
                padding-bottom: 10px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #007bff;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            .search-form {
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .search-form input[type="text"] {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
                flex-grow: 1;
            }
            .search-form button {
                padding: 8px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 0.9em;
                transition: background-color 0.3s ease;
            }
            .search-form button[type="submit"] {
                background-color: #007bff;
                color: white;
            }
            .search-form button[type="submit"]:hover {
                background-color: #0056b3;
            }
            .search-form button[type="button"] {
                background-color: #6c757d;
                color: white;
            }
            .search-form button[type="button"]:hover {
                background-color: #5a6268;
            }
            /* Lỗi thông báo từ request */
            .error-message { 
                color: red; 
                font-weight: bold; 
                margin-top: 10px; 
            }
            .action-button {
                padding: 5px 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.8em;
                transition: background-color 0.3s ease;
            }
            .action-button.info {
                background-color: #17a2b8;
                color: white;
            }
            .action-button.info:hover {
                background-color: #138496;
            }
            .action-button.ban-unban {
                background-color: #ffc107;
                color: black;
            } /* Màu vàng cho Ban/Unban */
            .action-button.ban-unban:hover {
                background-color: #e0a800;
            }
            .action-button.delete {
                background-color: #dc3545;
                color: white;
            } /* Màu đỏ cho Delete */
            .action-button.delete:hover {
                background-color: #c82333;
            }
            /* Style cho thông báo chung từ session hoặc request */
            .global-message {
                margin-top: 15px;
                padding: 10px;
                border-radius: 5px;
                font-weight: bold;
                text-align: center;
                background-color: #e2e3e5; /* Màu nền mặc định */
                color: #383d41; /* Màu chữ mặc định */
                border: 1px solid #d6d8db;
            }
            .global-message.success-message {
                background-color: #d4edda; /* Xanh lá nhạt */
                color: #155724; /* Xanh lá đậm */
                border: 1px solid #c3e6cb;
            }
            .global-message.error-message-style { /* Đổi tên để tránh trùng với .error-message ban đầu */
                background-color: #f8d7da; /* Đỏ nhạt */
                color: #721c24; /* Đỏ đậm */
                border: 1px solid #f5c6cb;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a class="nav-link active" href="adminDashboard">Return</a>
            <h2>All users</h2>

            <c:if test="${not empty sessionScope.deleteComplete}">
                <p class="global-message 
                    <c:if test="${sessionScope.deleteComplete.contains('successful')}">success-message</c:if>
                    <c:if test="${sessionScope.deleteComplete.contains('failed') || sessionScope.deleteComplete.contains('error')}">error-message-style</c:if>">
                    ${sessionScope.deleteComplete}
                </p>
                <%-- Xóa thông báo khỏi session sau khi hiển thị --%>
                <c:remove var="deleteComplete" scope="session"/>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <p class="global-message error-message-style">${errorMessage}</p>
            </c:if>

            <div class="search-form">
                <form action="alluser" method="get" style="display: flex; flex-grow: 1; gap: 10px; align-items: center;">
                    <label for="searchName">Search by User Name:</label>
                    <input type="text" id="searchName" name="searchName" value="${param.searchName != null ? param.searchName : ''}">
                    <button type="submit">Search</button>
                    <button type="button" onclick="window.location.href = 'alluser'">All users</button>
                </form>
            </div>
            
            <table border="1" cellpadding="5" cellspacing="0">
                <c:if test="${not empty listUsers}">
                    <tr>
                        <th>ID</th>
                        <th>UserName</th>
                        <th>DisplayName</th>
                        <th>Role</th>
                        <th>Ban</th>
                        <th>Reports</th>
                        <th>Admin's Function</th>
                    </tr>
                </c:if>

                <c:forEach var="u" items="${listUsers}">
                    <tr>
                        <td>${u.userId}</td>
                        <td>${u.userName}</td>
                        <td>${u.displayName}</td>
                        <td>${u.role}</td>
                        <td>${u.ban}</td>
                        <td>${u.reports}</td>
                        <td>
                            <form action="aboutInform" method="get" style="display: inline-block; margin-right: 5px;">
                                <input type="hidden" name="userInform" value="${u.userName}">
                                <button type="submit" class="action-button info">All information</button>
                            </form>
                            <form action="banAccountServlet" method="post" style="display: inline-block; margin-right: 5px;">
                                <input type="hidden" name="characterName" value="${u.userName}">
                                <input type="hidden" name="originalSearchName" value="${param.searchName != null ? param.searchName : ''}">
                                <button type="submit" class="action-button ban-unban">
                                    <c:choose>
                                        <c:when test="${u.ban == 'NORMAL'}">
                                            Ban
                                        </c:when>
                                        <c:when test="${u.ban == 'BANNED'}">
                                            Unban
                                        </c:when>
                                        <c:otherwise>
                                            Change Status
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </form>
                            <form action="deleteAcc" method="post" style="display: inline-block; margin-right: 5px;">
                                <input type="hidden" name="deleteName" value="${u.userName}">
                                <input type="hidden" name="originalSearchName" value="${param.searchName != null ? param.searchName : ''}">
                                <button type="submit" class="action-button delete"
                                                onclick="return confirm('Are you sure to delete this account ?');">
                                    Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listUsers && not empty param.searchName}">
                    <tr>
                        <td colspan="7" style="text-align: center; color: #666; padding: 20px;">No user found with username: '${param.searchName}'.</td>
                    </tr>
                </c:if>
            </table>
        </div>
    </body>
</html>
