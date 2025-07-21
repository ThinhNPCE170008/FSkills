<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Account Banned</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
</head>
<body class="bg-light d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="text-center">
        <h1 class="text-danger mb-3">Your account has been banned</h1>
        <p class="mb-4">Please contact the administrator for more information.</p>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary">Log out</a>
    </div>
</body>
</html>
