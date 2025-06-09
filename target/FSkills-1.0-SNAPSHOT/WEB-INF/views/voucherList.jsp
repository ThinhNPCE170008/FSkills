<%-- 
    Document   : voucherList
    Created on : Jun 1, 2025, 5:32:27 PM
    Author     : DELL
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách Vouchers</title>
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
                max-width: 900px;
                box-sizing: border-box;
                margin-top: 20px;
            }
            h2 {
                color: #333;
                text-align: center;
                margin-bottom: 25px;
                border-bottom: 2px solid #007bff;
                padding-bottom: 10px;
            }
            .search-add-section {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .search-bar {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }
            .search-bar input[type="text"] {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
                margin-right: 10px;
                width: 200px;
            }
            .search-bar button {
                padding: 8px 15px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            .search-bar button:hover {
                background-color: #0056b3;
            }
            /* Style cho nút "Tất cả Vouchers" */
            .search-bar .reset-button {
                background-color: #6c757d; /* Màu xám */
                color: white;
                margin-left: 10px; /* Khoảng cách với nút tìm kiếm */
            }
            .search-bar .reset-button:hover {
                background-color: #5a6268;
            }

            .add-button {
                padding: 10px 20px;
                background-color: #28a745;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
                text-decoration: none;
                display: inline-block;
                margin-bottom: 10px;
            }
            .add-button:hover {
                background-color: #218838;
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
                background-color: #f2f2f2;
                color: #333;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            tr:hover {
                background-color: #f1f1f1;
            }
            .actions {
                white-space: nowrap;
            }
            .actions a {
                margin-right: 8px;
                text-decoration: none;
                padding: 5px 10px;
                border-radius: 4px;
            }
            .actions a.edit {
                background-color: #ffc107;
                color: black;
            }
            .actions a.edit:hover {
                background-color: #e0a800;
            }
            .actions button {
                padding: 5px 10px;
                background-color: #dc3545;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            .actions button:hover {
                background-color: #c82333;
            }
            .no-vouchers {
                text-align: center;
                color: #666;
                margin-top: 30px;
            }
            /* Giữ lại style cơ bản cho global-message nếu bạn muốn, nhưng không còn success/error colors */
            .global-message {
                margin-bottom: 20px;
                padding: 10px;
                border-radius: 5px;
                font-weight: bold;
                text-align: center;
                background-color: #e2e3e5;
                color: #383d41;
                border: 1px solid #d6d8db;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>List of Vouchers</h2>

            <c:if test="${not empty globalMessage}">
                <p class="global-message">
                    ${globalMessage}
                </p>
            </c:if>

            <div class="search-add-section">
                <div class="search-bar">
                    <form action="voucherList" method="get">
                        <input type="text" name="searchTerm" placeholder="Search Voucher" value="${param.searchTerm}">
                        <button type="submit">Search</button>
                        <button type="button" class="reset-button" onclick="window.location.href = 'voucherList'">All voucher</button>
                    </form>
                </div>
                <div>
                    <a href="addVoucherForm" class="add-button">Add new voucher</a>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty voucherList}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Expiration Date</th>
                                <th>Sale Type</th>
                                <th>Sale Amount</th>
                                <th>Minimum Price</th>
                                <th>Course ID</th>
                                <th>Amount</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="voucher" items="${voucherList}">
                                <tr>
                                    <td>${voucher.voucherID}</td>
                                    <td>${voucher.expiredDate}</td>
                                    <td>${voucher.saleType}</td>
                                    <td>${voucher.saleAmount}</td>
                                    <td>${voucher.minPrice}</td>
                                    <td>${voucher.courseID}</td>
                                    <td>${voucher.amount}</td>
                                    <td class="actions">
                                        <a href="editVoucher?voucherID=${voucher.voucherID}" class="edit">Edit</a>
                                        <form action="deleteVoucher" method="post" style="display:inline-block;">
                                            <input type="hidden" name="voucherID" value="${voucher.voucherID}">
                                            <button type="submit" onclick="return confirm('Do you sure to delete ${voucher.voucherID} ?');">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="no-vouchers">Do not found any vouchers.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>