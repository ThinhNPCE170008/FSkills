<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Details</title>

        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <style>
            /* Global styles for Inter font and background */
            html, body {
                overflow-x: hidden;
            }
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f0f2f5; /* Adjusted to match other admin pages */
            }

            /* Adjust body margin and main content area for sidebar */
            body {
                margin: 0; /* Reset default body margin */
                display: flex; /* Use flexbox for main layout */
                min-height: 100vh;
                background-color: #f0f2f5; /* Unified background */
            }

            /* Sidebar styles from sidebar_admin.jsp's original <style> block */
            .sidebar-container {
                width: 80px;
                transition: width 0.3s ease-in-out;
                overflow-x: hidden;
                position: fixed; /* Keep it fixed */
                top: 0;
                left: 0;
                height: 100vh;
                z-index: 1000;
                background-color: #ffffff; /* Example sidebar background */
                box-shadow: 2px 0 5px rgba(0,0,0,0.1); /* Optional shadow */
            }

            .sidebar-container:hover {
                width: 200px;
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

            .main-content {
                margin-left: 80px;
                flex-grow: 1;
                transition: margin-left 0.3s ease-in-out;
                padding: 20px 10px;
                display: flex;
                flex-direction: column;
                align-items: center;
                overflow-x: hidden;
            }


            /* Adjust main content margin when sidebar expands */
            .sidebar-container:hover ~ .main-content {
                margin-left: 250px;
            }

            /* Hide sidebar on mobile */
            @media (max-width: 768px) {
                .sidebar-container {
                    width: 0;
                    left: -60px; /* Hide completely */
                }
                .sidebar-container:hover {
                    width: 0;
                }
                .main-content {
                    margin-left: 0;
                }
                .sidebar-container:hover ~ .main-content {
                    margin-left: 0;
                }
            }

            .container {
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 25px;
                width: 100%;
                max-width: 100%;
                box-sizing: border-box;
                margin-bottom: 20px;
            }

            h2 {
                color: #333;
                text-align: center;
                margin-bottom: 20px; /* Reduced margin */
                border-bottom: 2px solid #007bff;
                padding-bottom: 8px; /* Reduced padding */
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 1.5em; /* Adjust font size if desired */
            }
            h2 span {
                flex-grow: 1;
                text-align: center;
            }
            .edit-button, .save-button, .cancel-button {
                padding: 7px 12px; /* Reduced padding */
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 0.85em; /* Slightly smaller font */
                transition: background-color 0.3s ease;
            }
            .edit-button {
                background-color: #6c757d;
                color: white;
                <c:if test="${editMode == true}">display: none;</c:if>
                }
                .edit-button:hover {
                    background-color: #5a6268;
                }
                .save-button {
                    background-color: #28a745;
                    color: white;
                    margin-right: 8px; /* Reduced margin */
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

                /* Grid layout for detail items to create two columns */
                .detail-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr; /* Two equal columns */
                    gap: 15px 30px; /* Gap between rows and columns */
                }

                .detail-item {
                    display: flex;
                    flex-direction: column; /* Stack label and value vertically within each grid item */
                    margin-bottom: 0; /* Remove individual item margin, let grid gap handle it */
                    padding-bottom: 0;
                    border-bottom: none; /* Remove individual item border */
                }
                /* Remove the dashed border from previous iteration if it exists */
                .detail-grid > div {
                    padding-bottom: 0; /* Remove padding from bottom of grid item */
                    border-bottom: none; /* Remove border from grid item */
                }

                .detail-label {
                    font-weight: bold;
                    color: #555;
                    margin-bottom: 5px; /* Space between label and value/input box */
                    flex: none; /* Do not grow/shrink */
                    width: auto; /* Allow label to take natural width */
                }
                .detail-value, .detail-input {
                    color: #000;
                    flex: 1; /* Take remaining space */
                    display: block;
                    min-width: 0;
                    width: 100%; /* Ensure input/value fills its container */

                    /* New styles for box effect */
                    background-color: #f8f8f8; /* Light background for the box */
                    border: 1px solid #e0e0e0; /* Subtle border */
                    border-radius: 5px; /* Rounded corners */
                    padding: 8px 12px; /* Inner padding for the box */
                    box-sizing: border-box; /* Include padding in width calculation */
                    line-height: 1.4; /* Improve readability */
                }
                .detail-input {
                    background-color: #ffffff; /* White background for input fields */
                    border-color: #ccc; /* Slightly darker border for input */
                    padding: 7px 10px; /* Slightly adjusted padding for input */
                    font-size: 0.95em; /* Slightly smaller font */
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
            /* Luôn hiển thị username, user create date, role, reports and ensure they get the box style */
            #displayUsername, #displayUserCreateDate, #displayReports, #displayRole {
                display: block !important; /* Override display: none if editMode is true */
                background-color: #f8f8f8;
                border: 1px solid #e0e0e0;
                border-radius: 5px;
                padding: 8px 12px;
                box-sizing: border-box;
                line-height: 1.4;
                color: #333;
                font-weight: normal;
            }
            /* Specific styling for the label of non-editable fields */
            .detail-item.non-editable .detail-label {
                font-weight: bold;
                color: #555;
            }


            /* Style cho lỗi */
            .error-message {
                color: red;
                font-size: 0.85em; /* Smaller error message font */
                margin-left: 0;
                display: block;
                margin-top: 3px; /* Reduced margin */
            }
            .global-message {
                margin-bottom: 15px; /* Reduced margin */
                padding: 8px; /* Reduced padding */
                border-radius: 5px;
                font-weight: bold;
                text-align: center;
                font-size: 0.95em;
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
                margin-top: 15px; /* Reduced margin */
                padding: 9px 18px; /* Reduced padding */
                background-color: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: background-color 0.3s ease;
                font-size: 0.9em;
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
                <c:if test="${editMode != true}">display: none;</c:if>
                }

                @media (max-width: 600px) { /* Adjust breakpoint as needed */
                    .detail-grid {
                        grid-template-columns: 1fr; /* Single column layout on smaller screens */
                        gap: 15px;
                    }
                    .detail-grid > div:nth-child(odd),
                    .detail-grid > div:nth-child(even) {
                        padding-left: 0;
                        padding-right: 0;
                    }
                }
            </style>
        </head>
        <body>
        <jsp:include page="/layout/sidebar_admin.jsp" />



        <div class="flex flex-grow w-full">

            <div class="main-content px-5 py-5">
                <div class="container px-5">
                    <h2 class="flex items-center justify-between w-full gap-4 text-xl font-bold text-gray-800 mb-4">
                        <a href="alluser?roleFilter=${requestScope.currentListRoleFilter != null ? requestScope.currentListRoleFilter : 'Learner'}"
                           class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded">
                            ← User List
                        </a>

                        <span class="flex-grow text-center">User Information Detail</span>

                        <c:if test="${editMode != true}">
                            <button type="button"
                                    class="text-white text-sm font-medium rounded"
                                    style="background-color: #fd7e14; padding: 8px 16px;" id="editButton"
                                    onclick="window.location.href = 'aboutInform?userInform=${requestScope.currentUsername != null ? requestScope.currentUsername : param.userInform}&editMode=true'">
                                Edit
                            </button>
                        </c:if>

                    </h2>
                    <c:if test="${not empty globalMessage}">
                        <p class="global-message <c:if test="${not empty successMessage}">success-message</c:if> <c:if test="${not empty errorMessages}">error-global-message</c:if>">
                            ${globalMessage}
                        </p>
                    </c:if>

                    <c:choose>
                        <c:when test="${not empty allInform}">
                            <c:forEach var="user" items="${allInform}" begin="0" end="0">
                                <form id="updateUserForm" action="updateUserServlet" method="POST">
                                    <div class="detail-grid">
                                        <div class="detail-item non-editable">
                                            <span class="detail-label">Username:</span>
                                            <span class="detail-value" id="displayUsername">${user.userName}</span>
                                            <input type="hidden" name="userName" value="${user.userName}">
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Display Name:<span style="color:red">*</span></span>
                                            <span class="detail-value" id="displayDisplayName">${user.displayName}</span>
                                            <input type="text" id="inputDisplayName" name="displayName" class="detail-input" value="${param.displayName != null ? param.displayName : user.displayName}" required>

                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Email:<span style="color:red">*</span></span>
                                            <span class="detail-value" id="displayEmail">${user.email}</span>
                                            <input type="email" id="inputEmail" name="email" class="detail-input" value="${param.email != null ? param.email : user.email}" required>
                                            <c:if test="${not empty errorMessages['email']}">
                                                <span class="error-message">${errorMessages['email']}</span>
                                            </c:if>
                                        </div>
                                        <div class="detail-item non-editable">
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
                                        <div class="detail-item non-editable">
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
                                        <div class="detail-item non-editable">
                                            <span class="detail-label">User Create Date:</span>
                                            <span class="detail-value" id="displayUserCreateDate">
                                                <fmt:formatDate value="${user.userCreateDate}" pattern="HH:mm dd/MM/yyyy"/>
                                            </span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Phone Number</span>
                                            <span class="detail-value" id="displayPhone">${user.phone}</span>
                                            <input type="text" id="inputPhone" name="phone" class="detail-input" value="${param.phone != null ? param.phone : user.phone}" required>
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
                                    </div> <%-- End detail-grid --%>

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
            </div>
        </div>

        <jsp:include page="/layout/toast.jsp" />
        <%-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script> --%>
    </body>

</html>
