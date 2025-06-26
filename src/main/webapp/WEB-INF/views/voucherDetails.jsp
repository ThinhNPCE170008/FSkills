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
                background-color: #f0f2f5;
                margin: 0;
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar styles */
            .sidebar-container {
                width: 100px;
                transition: width 0.3s ease-in-out;
                overflow-x: hidden;
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                z-index: 1000;
                background-color: #ffffff;
                box-shadow: 2px 0 5px rgba(0,0,0,0.1);
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

            /* Main content area */
            .main-content {
                margin-left: 100px;
                flex-grow: 1;
                transition: margin-left 0.3s ease-in-out;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .sidebar-container:hover ~ .main-content {
                margin-left: 250px;
            }

            /* Hide sidebar on mobile */
            @media (max-width: 768px) {
                .sidebar-container {
                    width: 0;
                    left: -60px;
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

            /* Form container */
            .container {
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                padding: 25px;
                width: 100%;
                max-width: 900px; /* Tăng max-width để chứa 2 cột */
                box-sizing: border-box;
                margin-bottom: 20px;
            }
            
            /* Header for title and button */
            .header-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 8px;
                border-bottom: 2px solid #e0e0e0; /* Border màu xám nhạt hơn */
            }
            
            /* Tiêu đề */
            .header-container h2 {
                color: #333;
                margin: 0;
                font-size: 1.5em;
                font-weight: 700; /* Đậm hơn */
                flex-grow: 1;
                text-align: center; /* Tiêu đề vẫn ở giữa */
            }

            /* Nút Return */
            .return-button {
                padding: 9px 18px;
                background-color: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: background-color 0.3s ease;
                font-size: 0.9em;
                white-space: nowrap;
                order: -1; /* Đẩy nút về bên trái trong flexbox */
                margin-right: auto; /* Đẩy nút sang trái hết mức có thể */
            }
            .return-button:hover {
                background-color: #0056b3;
            }
            
            /* Container cho các trường nhập liệu */
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr; /* Chia thành 2 cột bằng nhau */
                gap: 20px; /* Khoảng cách giữa các cột và hàng */
            }
            
            /* Form group style (cần thiết cho box input) */
            .form-group {
                margin-bottom: 15px; /* Giảm margin-bottom vì đã có gap */
            }
            
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 600; /* Đậm hơn */
                color: #4a5568; /* Màu xám đậm hơn */
            }
            
            /* Input box style */
            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group input[type="datetime-local"],
            .form-group select {
                width: 100%;
                padding: 10px 15px; /* Tăng padding để trông dày dặn hơn */
                border: 1px solid #d1d5db; /* Viền màu xám */
                border-radius: 8px; /* Bo góc nhiều hơn */
                box-sizing: border-box;
                font-size: 1em;
                background-color: #f9fafb; /* Nền xám nhạt */
                transition: all 0.2s ease-in-out;
                box-shadow: inset 0 1px 2px rgba(0,0,0,0.05); /* Thêm box shadow nhẹ */
            }
            
            .form-group input[type="text"]:focus,
            .form-group input[type="number"]:focus,
            .form-group input[type="datetime-local"]:focus,
            .form-group select:focus {
                border-color: #4c51bf; /* Màu xanh tím khi focus */
                background-color: #ffffff; /* Nền trắng khi focus */
                box-shadow: 0 0 0 3px rgba(76, 81, 191, 0.2); /* Ring shadow */
                outline: none;
            }

            /* Button group */
            .button-group {
                text-align: center;
                margin-top: 20px;
                grid-column: 1 / -1; /* Mở rộng qua 2 cột */
            }

            .save-button, .cancel-button {
                padding: 10px 24px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 1em;
                font-weight: 600;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }
            .save-button {
                background-color: #10b981; /* Màu xanh lá cây */
                color: white;
                margin-right: 10px;
            }
            .save-button:hover {
                background-color: #059669;
                transform: translateY(-2px);
            }
            .cancel-button {
                background-color: #6b7280; /* Màu xám */
                color: white;
            }
            .cancel-button:hover {
                background-color: #4b5563;
                transform: translateY(-2px);
            }

            .error-message {
                color: #ef4444;
                font-size: 0.85em;
                margin-top: 5px;
                display: block;
            }
            .global-message {
                margin-bottom: 15px;
                padding: 12px;
                border-radius: 8px;
                font-weight: 600;
                text-align: center;
                font-size: 0.95em;
            }
            .success-message {
                background-color: #d1fae5;
                color: #065f46;
            }
            .error-global-message {
                background-color: #fee2e2;
                color: #991b1b;
            }
        </style>
    </head>
    <body>
        <div class="flex flex-grow w-full">
            <jsp:include page="/layout/sidebar_admin.jsp" />

            <div class="main-content">
                <div class="container">
                    <%-- 1. Nút Return ở sát bên trái, tiêu đề ở giữa --%>
                    <div class="header-container">
                        <a href="voucherList" class="return-button">Return to Voucher List</a>
                        <h2 class="font-bold text-xl text-gray-800">
                            <c:if test="${not empty voucher && voucher.voucherID > 0}">Edit Voucher Information</c:if>
                            <c:if test="${empty voucher || voucher.voucherID == 0}">Add New Voucher</c:if>
                        </h2>
                        <%-- Thêm một div rỗng để giữ tiêu đề ở giữa --%>
                        <div></div>
                    </div>

                    <c:if test="${not empty globalMessage}">
                        <p class="global-message <c:if test="${not empty successMessage}">success-message</c:if> <c:if test="${not empty errorMessages}">error-global-message</c:if>">
                            ${globalMessage}
                        </p>
                    </c:if>

                    <form action="
                            <c:if test="${not empty voucher && voucher.voucherID > 0}">updateVoucher</c:if>
                            <c:if test="${empty voucher || voucher.voucherID == 0}">addVoucher</c:if>
                                  " method="post">
                        
                        <%-- 2. Chia 8 trường thành 2 cột --%>
                        <div class="form-grid">
                            <%-- Cột 1 --%>
                            <div class="column-1">
                                <c:if test="${not empty voucher && voucher.voucherID > 0}">
                                    <div class="form-group">
                                        <label for="voucherID">Voucher ID:</label>
                                        <input type="number" id="voucherID" name="voucherID"
                                               value="${voucher.voucherID}"
                                               readonly>
                                        <c:if test="${not empty errorMessages['voucherID']}">
                                            <span class="error-message">${errorMessages['voucherID']}</span>
                                        </c:if>
                                    </div>
                                </c:if>
                                <div class="form-group">
                                    <label for="voucherName">Voucher Name:<span style="color:red">*</span></label>
                                    <input type="text" id="voucherName" name="voucherName"
                                           value="${not empty param.voucherName ? param.voucherName : voucher.voucherName}" required>
                                    <c:if test="${not empty errorMessages['voucherName']}">
                                        <span class="error-message">${errorMessages['voucherName']}</span>
                                    </c:if>
                                </div>
                                <div class="form-group">
                                    <label for="voucherCode">Voucher Code:<span style="color:red">*</span></label>
                                    <input type="text" id="voucherCode" name="voucherCode"
                                           value="${not empty param.voucherCode ? param.voucherCode : voucher.voucherCode}" required>
                                    <c:if test="${not empty errorMessages['voucherCode']}">
                                        <span class="error-message">${errorMessages['voucherCode']}</span>
                                    </c:if>
                                </div>
                                <div class="form-group">
                                    <label for="expiredDate">Expiration Date:<span style="color:red">*</span></label>
                                    <input type="datetime-local" id="expiredDate" name="expiredDate"
                                           value="<c:if test="${not empty param.expiredDate}">${param.expiredDate}</c:if><c:if test="${empty param.expiredDate && not empty voucher.expiredDate}"><fmt:formatDate value="${voucher.expiredDate}" pattern="yyyy-MM-dd'T'HH:mm"/></c:if>" required>
                                    <c:if test="${not empty errorMessages['expiredDate']}">
                                        <span class="error-message">${errorMessages['expiredDate']}</span>
                                    </c:if>
                                </div>
                            </div>
                            
                            <%-- Cột 2 --%>
                            <div class="column-2">
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
                                    <label for="amount">Amount:<span style="color:red">*</span></label>
                                    <input type="number" id="amount" name="amount"
                                           value="${not empty param.amount ? param.amount : voucher.amount}" required>
                                    <c:if test="${not empty errorMessages['amount']}">
                                        <span class="error-message">${errorMessages['amount']}</span>
                                    </c:if>
                                </div>
                            </div>
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
            </div>
        </div>
    </body>
</html>