<%--
    Document   : userDetails
    Created on : May 23, 2025, 2:53:00 PM
    Author     : DELL
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
    <head>
        <title>User Details</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f7f6;
                margin: 0;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
                min-height: 100vh;
            }
            .container {
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 30px;
                width: 100%;
                max-width: 600px;
                box-sizing: border-box;
                margin-top: 20px;
            }
            h2 {
                color: #333;
                text-align: center;
                margin-bottom: 25px;
                border-bottom: 2px solid #007bff;
                padding-bottom: 10px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            h2 span {
                flex-grow: 1;
                text-align: center;
            }
            .edit-button, .save-button, .cancel-button {
                padding: 8px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 0.9em;
                transition: background-color 0.3s ease;
            }
            .edit-button {
                background-color: #6c757d;
                color: white;
                /* Thêm vào để hiển thị nút "Edit" khi không ở chế độ chỉnh sửa */
                <c:if test="${editMode == true}">display: none;</c:if>
            }
            .edit-button:hover {
                background-color: #5a6268;
            }
            .save-button {
                background-color: #28a745;
                color: white;
                margin-right: 10px;
            }
            .save-button:hover {
                background-color: #218838;
            }
            .cancel-button {
                background-color: #dc3545;
                color: white;
            }
            .cancel-button:hover {
                background-color: #c82333;
            }

            .detail-item {
                display: flex;
                margin-bottom: 15px;
                align-items: baseline;
                padding-bottom: 5px;
                border-bottom: 1px dashed #eee;
            }
            .detail-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }
            .detail-label {
                font-weight: bold;
                color: #555;
                flex: 0 0 150px;
            }
            .detail-value {
                color: #000;
                flex: 1;
                display: block;
            }
            .detail-input {
                flex: 1;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 1em;
            }

            /* Ẩn input/select khi không ở chế độ chỉnh sửa */
            <c:if test="${editMode != true}">
                .detail-input {
                    display: none;
                }
            </c:if>
            /* Hiển thị input/select khi ở chế độ chỉnh sửa */
            <c:if test="${editMode == true}">
                .detail-value {
                    display: none;
                }
            </c:if>
            /* Luôn hiển thị username và reports */
            #displayUsername, #displayUserCreateDate, #displayReports, #displayRole {
                display: block !important;
            }

            /* Style cho lỗi */
            .error-message {
                color: red;
                font-size: 0.9em;
                margin-left: 10px;
                display: block; /* Luôn hiển thị nếu có nội dung */
                margin-top: 5px;
            }
            .global-message {
                margin-bottom: 20px;
                padding: 10px;
                border-radius: 5px;
                font-weight: bold;
                text-align: center;
            }
            .success-message {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .error-global-message {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .return-link {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 20px;
                background-color: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: background-color 0.3s ease;
            }
            .return-link:hover {
                background-color: #0056b3;
            }
            .no-user-found {
                text-align: center;
                color: #dc3545;
                font-weight: bold;
                margin-top: 20px;
            }
            .button-group {
                text-align: center;
                margin-top: 20px;
                /* Ẩn/hiển thị dựa trên editMode */
                <c:if test="${editMode != true}">display: none;</c:if>
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>
                <span>User Information Detail</span>
                <%-- start here --%>
                <button type="button" class="edit-button" id="editButton"
                        onclick="window.location.href = 'aboutInform?userInform=${requestScope.currentUsername != null ? requestScope.currentUsername : param.userInform}&editMode=true'">Edit</button>
            </h2>

            <c:if test="${not empty globalMessage}">
                <p class="global-message <c:if test="${not empty successMessage}">success-message</c:if> <c:if test="${not empty errorMessages}">error-global-message</c:if>">
                    ${globalMessage}
                </p>
            </c:if>

            <c:choose>
                <c:when test="${not empty allInform}">
                    <c:forEach var="user" items="${allInform}" begin="0" end="0">
                        <form action="updateUserServlet" method="POST">

                            <div class="detail-item">
                                <span class="detail-label">Username:</span>
                                <span class="detail-value" id="displayUsername">${user.userName}</span>
                                <input type="hidden" name="userName" value="${user.userName}">
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">Display Name:<span style="color:red">*</span></span>
                                <span class="detail-value" id="displayDisplayName">${user.displayName}</span>
                                <input type="text" id="inputDisplayName" name="displayName" class="detail-input" value="${param.displayName != null ? param.displayName : user.displayName}" required>
                                <c:if test="${not empty errorMessages['displayName']}">
                                    <span class="error-message">${errorMessages['displayName']}</span>
                                </c:if>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">Email:<span style="color:red">*</span></span>
                                <span class="detail-value" id="displayEmail">${user.email}</span>
                                <input type="email" id="inputEmail" name="email" class="detail-input" value="${param.email != null ? param.email : user.email}" required>
                                <c:if test="${not empty errorMessages['email']}">
                                    <span class="error-message">${errorMessages['email']}</span>
                                </c:if>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">Role:</span>
                                <span class="detail-value" id="displayRole">${user.role}</span>
                                <input type="hidden" name="role" value="${user.role}">
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">Ban Status:</span>
                                <span class="detail-value" id="displayBanStatus">${user.ban}</span>
                                <select id="inputBanStatus" name="ban" class="detail-input">
                                    <option value="NORMAL" <c:if test="${(param.ban != null && param.ban == 'NORMAL') || (param.ban == null && user.ban == 'NORMAL')}">selected</c:if>>NORMAL</option>
                                    <option value="BANNED" <c:if test="${(param.ban != null && param.ban == 'BANNED') || (param.ban == null && user.ban == 'BANNED')}">selected</c:if>>BANNED</option>
                                </select>
                                <c:if test="${not empty errorMessages['ban']}">
                                    <span class="error-message">${errorMessages['ban']}</span>
                                </c:if>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">Reports:</span>
                                <span class="detail-value" id="displayReports">${user.reports}</span>
                                <input type="hidden" name="reports" value="${user.reports}">
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">Date Of Birth:</span>
                                <span class="detail-value" id="displayDateOfBirth">
                                    <fmt:formatDate value="${user.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                </span>
                                <input type="date" id="inputDateOfBirth" name="dateOfBirth" class="detail-input"
                                        value="<c:if test="${param.dateOfBirth != null}">${param.dateOfBirth}</c:if><c:if test="${param.dateOfBirth == null && not empty user.dateOfBirth}">${user.dateOfBirth.toString().substring(0, 10)}</c:if>">
                                <c:if test="${not empty errorMessages['dateOfBirth']}">
                                    <span class="error-message">${errorMessages['dateOfBirth']}</span>
                                </c:if>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">User Create Date:</span>
                                <span class="detail-value" id="displayUserCreateDate">
                                    <fmt:formatDate value="${user.userCreateDate}" pattern="HH:mm dd/MM/yyyy"/>
                                </span>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">Phone Number</span>
                                <span class="detail-value" id="displayPhone">${user.phone}</span>
                                <input type="text" id="inputPhone" name="phone" class="detail-input" value="${param.phone != null ? param.phone : user.phone}">
                                <c:if test="${not empty errorMessages['phone']}">
                                    <span class="error-message">${errorMessages['phone']}</span>
                                </c:if>
                            </div>

                            <div class="detail-item">
                                <span class="detail-label">Info:</span>
                                <span class="detail-value" id="displayInfo">${user.info}</span>
                                <textarea id="inputInfo" name="info" class="detail-input" rows="3">${param.info != null ? param.info : user.info}</textarea>
                                <c:if test="${not empty errorMessages['info']}">
                                    <span class="error-message">${errorMessages['info']}</span>
                                </c:if>
                            </div>

                            <div class="button-group" id="editButtonGroup">
                                <button type="submit" class="save-button">Save</button>
                                <button type="button" class="cancel-button"
                                        onclick="window.location.href = 'aboutInform?userInform=${currentUsername != null ? currentUsername : param.userInform}'">Cancel</button>
                            </div>
                        </form>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="no-user-found">User information not found.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <a href="alluser" class="return-link">Return to User List</a>

    </body>
</html>