<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Email Verification</title>
        <meta http-equiv="refresh" content="5;url=${pageContext.request.contextPath}/login">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 40px;
                background-color: #f9f9f9;
                color: #333;
                text-align: center;
            }
            .message {
                padding: 20px;
                margin: 20px auto;
                border-radius: 8px;
                width: 50%;
            }
            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            .btn {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 20px;
                text-decoration: none;
                background-color: #0d6efd;
                color: #fff;
                border-radius: 5px;
            }
            .btn:hover {
                background-color: #0b5ed7;
            }
        </style>
    </head>
    <body>

        <c:if test="${not empty success}">
            <div class="message success">
                <h2>${success}</h2>
                <p>🎉 Congratulations! Your email has been successfully verified.</p>
                <p>You can now log in to your account and start using our services.</p>
                <p>You will be redirected to the login page in 5 seconds...</p>
            </div>
        </c:if>

        <c:if test="${not empty err}">
            <div class="message error">
                <h2>${err}</h2>
                <p>⚠ Sorry, we couldn't verify your email. The link may have expired or is invalid.</p>
                <p>Please try verifying again or contact our support.</p>
            </div>
        </c:if>

        <c:if test="${empty success and empty err}">
            <div class="message">
                <h2>No verification status found.</h2>
            </div>
        </c:if>

        <a class="btn" href="${pageContext.request.contextPath}/login">Go to Login</a>

    </body>
</html>