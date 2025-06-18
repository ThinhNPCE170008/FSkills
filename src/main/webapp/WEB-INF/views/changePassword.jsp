<%--
  Created by IntelliJ IDEA.
  User: Hongt
  Date: 18/06/2025
  Time: 17:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/changePassword.css">
</head>
<body>
<div class="change-password-container">
    <a href="${pageContext.request.contextPath}/editProfile" class="back-button">
        <i class="bi bi-arrow-left"></i> Back
    </a>
    <h1>Change Password</h1>
    <form action="${pageContext.request.contextPath}/changePassword" method="POST">
        <div class="form-group">
            <label for="oldPassword">Old Password</label>
            <input type="password" id="oldPassword" name="oldPassword" required>
        </div>
        <div class="form-group">
            <label for="newPassword">New Password</label>
            <input type="password" id="newPassword" name="newPassword" required>
        </div>
        <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <button type="submit">Save Change</button>
    </form>
    <c:if test="${not empty errorMessage}">
        <p class="error-message">${errorMessage}</p>
    </c:if>
    <c:if test="${not empty successMessage}">
        <p class="success-message">${successMessage}</p>
    </c:if>
</div>
<script>
    // Auto-hide messages after 3 seconds
    window.addEventListener('load', function() {
        const successMessage = document.querySelector('.success-message');
        const errorMessage = document.querySelector('.error-message');
        const messages = [successMessage, errorMessage].filter(Boolean);

        if (messages.length > 0) {
            setTimeout(function() {
                messages.forEach(function(message) {
                    message.style.display = 'none';
                });
            }, 3000);
        }
    });
</script>
</body>
</html>
