<%--
    Document   : voucherDetails
    Created on : Jun 1, 2025, 5:34:00 PM
    Author     : DELL
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>
            <c:if test="${not empty voucher && voucher.voucherID > 0}">Edit Voucher</c:if>
            <c:if test="${empty voucher || voucher.voucherID == 0}">Add New Voucher</c:if>
        </title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <style>
            /* Global styles for Inter font and background */
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
                width: 100px;
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
                width: 250px;
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

            /* Apply margin-left to the main content area */
            .main-content {
                margin-left: 100px; /* Initial margin for collapsed sidebar */
                flex-grow: 1; /* Allow main content to take remaining space */
                transition: margin-left 0.3s ease-in-out;
                padding: 20px; /* Consistent padding */
                display: flex; /* Use flex to align content within main-content */
                flex-direction: column; /* Stack items vertically */
                align-items: center; /* Center horizontally */
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

            /* Voucher Details Specific Styles (Adjusted for consistency) */
            .container {
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 25px; /* Consistent padding */
                width: 100%;
                max-width: 600px; /* Adjusted max-width */
                box-sizing: border-box;
                margin-bottom: 20px; /* Space from bottom if content below */
                margin-top: 0; /* Reset margin-top from original */
            }
            h2 {
                color: #333;
                text-align: center;
                margin-bottom: 20px; /* Consistent margin */
                border-bottom: 2px solid #007bff;
                padding-bottom: 8px; /* Consistent padding */
                display: flex; /* Allow content inside h2 to be flexed */
                justify-content: center; /* Center the title, no edit button here */
                align-items: center;
                font-size: 1.5em;
            }
            h2 span {
                flex-grow: 1;
                text-align: center;
            }

            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #555;
            }
            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group input[type="datetime-local"],
            .form-group select {
                width: 100%; /* Make input/select fill the width */
                padding: 8px 12px; /* Consistent padding for box style */
                border: 1px solid #e0e0e0; /* Subtle border for box style */
                border-radius: 5px; /* Rounded corners for box style */
                box-sizing: border-box;
                font-size: 1em;
                background-color: #ffffff; /* White background for input fields */
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }
            .form-group input[type="text"]:focus,
            .form-group input[type="number"]:focus,
            .form-group input[type="datetime-local"]:focus,
            .form-group select:focus {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
                outline: none;
            }

            .button-group {
                text-align: center;
                margin-top: 20px;
            }
            .save-button, .cancel-button {
                padding: 9px 18px; /* Consistent padding */
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 0.9em; /* Consistent font size */
                transition: background-color 0.3s ease;
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
                background-color: #6c757d;
                color: white;
            }
            .cancel-button:hover {
                background-color: #5a6268;
            }

            .error-message {
                color: red;
                font-size: 0.85em; /* Consistent font size */
                margin-top: 5px;
                display: block;
            }
            .global-message {
                margin-bottom: 15px; /* Consistent margin */
                padding: 8px; /* Consistent padding */
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
                margin-top: 15px; /* Consistent margin */
                padding: 9px 18px; /* Consistent padding */
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
        </style>
    </head>
    <body>
        <div class="flex flex-grow w-full">
            <jsp:include page="/layout/sidebar_admin.jsp" />

            <div class="main-content">
                <div class="container">
                    <h2>
                        <c:if test="${not empty voucher && voucher.voucherID > 0}">Edit Voucher Information</c:if>
                        <c:if test="${empty voucher || voucher.voucherID == 0}">Add New Voucher</c:if>
                    </h2>

                    <c:if test="${not empty globalMessage}">
                        <p class="global-message <c:if test="${not empty successMessage}">success-message</c:if> <c:if test="${not empty errorMessages}">error-global-message</c:if>">
                            ${globalMessage}
                        </p>
                    </c:if>

                    <form action="
                            <c:if test="${not empty voucher && voucher.voucherID > 0}">updateVoucher</c:if>
                            <c:if test="${empty voucher || voucher.voucherID == 0}">addVoucher</c:if>
                                " method="post">
                        <%-- Chỉ hiển thị Voucher ID nếu đang ở chế độ chỉnh sửa (voucher tồn tại và voucherID > 0) --%>
                        <c:if test="${not empty voucher && voucher.voucherID > 0}">
                            <div class="form-group">
                                <label for="voucherID">Voucher ID:</label>
                                <%-- Dùng readonly để không cho người dùng sửa ID --%>
                                <input type="number" id="voucherID" name="voucherID"
                                       value="${voucher.voucherID}"
                                       readonly>
                                <c:if test="${not empty errorMessages['voucherID']}">
                                    <span class="error-message">${errorMessages['voucherID']}</span>
                                </c:if>
                            </div>
                        </c:if>

                        <div class="form-group">
                            <label for="expiredDate">Expiration Date:<span style="color:red">*</span></label>
                            <input type="datetime-local" id="expiredDate" name="expiredDate"
                                   value="<c:if test="${not empty param.expiredDate}">${param.expiredDate}</c:if><c:if test="${empty param.expiredDate && not empty voucher.expiredDate}"><fmt:formatDate value="${voucher.expiredDate}" pattern="yyyy-MM-dd'T'HH:mm"/></c:if>" required>
                            <c:if test="${not empty errorMessages['expiredDate']}">
                                <span class="error-message">${errorMessages['expiredDate']}</span>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="saleType">Sale Type:<span style="color:red">*</span></label>
                            <select id="saleType" name="saleType" required>
                                <option value="">-- Select Type --</option>
                                <option value="PERCENT" <c:if test="${(not empty param.saleType && param.saleType eq 'PERCENT') || (empty param.saleType && not empty voucher.saleType && voucher.saleType eq 'PERCENT')}">selected</c:if>>Percentage (%)</option>
                                <option value="FIXED" <c:if test="${(not empty param.saleType && param.saleType eq 'FIXED') || (empty param.saleType && not empty voucher.saleType && voucher.saleType eq 'FIXED')}">selected</c:if>>Fixed Value</option>
                            </select>
                            <c:if test="${not empty errorMessages['saleType']}">
                                <span class="error-message">${errorMessages['saleType']}</span>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="saleAmount">Sale Amount:<span style="color:red">*</span></label>
                            <input type="number" id="saleAmount" name="saleAmount"
                                   value="${not empty param.saleAmount ? param.saleAmount : voucher.saleAmount}" required>
                            <c:if test="${not empty errorMessages['saleAmount']}">
                                <span class="error-message">${errorMessages['saleAmount']}</span>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="minPrice">Minimum Applicable Price:<span style="color:red">*</span></label>
                            <input type="number" id="minPrice" name="minPrice"
                                   value="${not empty param.minPrice ? param.minPrice : voucher.minPrice}" required>
                            <c:if test="${not empty errorMessages['minPrice']}">
                                <span class="error-message">${errorMessages['minPrice']}</span>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="courseID">Course ID:<span style="color:red">*</span></label>
                            <input type="number" id="courseID" name="courseID"
                                   value="${not empty param.courseID ? param.courseID : voucher.courseID}" required>
                            <c:if test="${not empty errorMessages['courseID']}">
                                <span class="error-message">${errorMessages['courseID']}</span>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="amount">Amount:<span style="color:red">*</span></label>
                            <input type="number" id="amount" name="amount"
                                   value="${not empty param.amount ? param.amount : voucher.amount}" required>
                            <c:if test="${not empty errorMessages['amount']}">
                                <span class="error-message">${errorMessages['amount']}</span>
                            </c:if>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="save-button">
                                <c:if test="${not empty voucher && voucher.voucherID > 0}">Update</c:if>
                                <c:if test="${empty voucher || voucher.voucherID == 0}">Add New</c:if>
                            </button>
                            <button type="button" class="cancel-button" onclick="window.location.href = 'voucherList'">Cancel</button>
                        </div>
                    </form>
                </div>
                <a href="voucherList" class="return-link">Return to Voucher List</a>
            </div>
        </div>
    </body>
</html>