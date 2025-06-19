<%-- 
    Document   : voucherDetails
    Created on : Jun 1, 2025, 5:34:00 PM
    Author     : DELL
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title><c:if test="${not empty voucher}">Edit Voucher</c:if><c:if test="${empty voucher}">Add New Voucher</c:if></title>
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
                .form-group input[type="date"],
                .form-group select {
                    width: calc(100% - 20px);
                    padding: 10px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    box-sizing: border-box;
                    font-size: 1em;
                }
                .form-group input[type="date"] {
                    padding: 8px;
                }
                .button-group {
                    text-align: center;
                    margin-top: 20px;
                }
                .save-button, .cancel-button {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    font-size: 1em;
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
                    font-size: 0.9em;
                    margin-top: 5px;
                    display: block;
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
            </style>
        </head>
        <body>
            <div class="container">
                    <h2><c:if test="${not empty voucher}">Edit Voucher Information</c:if><c:if test="${empty voucher}">Add New Voucher</c:if></h2>

            <c:if test="${not empty globalMessage}">
                <p class="global-message <c:if test="${not empty successMessage}">success-message</c:if> <c:if test="${not empty errorMessages}">error-global-message</c:if>">
                    ${globalMessage}
                </p>
            </c:if>

            <form action="<c:if test="${not empty voucher}">updateVoucher</c:if><c:if test="${empty voucher}">addVoucher</c:if>" method="post">
                <c:if test="${not empty voucher}">
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
                    <label for="expiredDate">Expiration Date:<span style="color:red">*</span></label>
                    <input type="date" id="expiredDate" name="expiredDate"
                           value="${not empty param.expiredDate ? param.expiredDate : (not empty voucher.expiredDate ? voucher.expiredDate.toString().substring(0, 10) : '')}" required>
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
                        <c:if test="${not empty voucher}">Update</c:if><c:if test="${empty voucher}">Add New</c:if>
                    </button>
                    <button type="button" class="cancel-button" onclick="window.location.href = 'voucherList'">Cancel</button>
                </div>
            </form>
        </div>
    </body>
</html>