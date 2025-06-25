<%--
  Created by IntelliJ IDEA.
  User: Hongt
  Date: 15/06/2025
  Time: 01:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Error</title>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
</head>
<body>
<h1>Error</h1>
<p>${error}</p>
<a href="javascript:history.back()">Go Back</a>
</body>
</html>