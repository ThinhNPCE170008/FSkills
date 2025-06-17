<%--
  Created by IntelliJ IDEA.
  User: NgoThinh1902
  Date: 6/18/2025
  Time: 1:05 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="model.Course" %>
<%@page import="model.Module" %>
<%@page import="model.User" %>

<%
    Course course = (Course) request.getAttribute("course");
    List<Module> modules = (List<Module>) request.getAttribute("modules");
    User instructor = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Course Details | F-Skill</title>
    <link rel="icon" href="img/favicon_io/favicon.ico">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
</head>
<body class="bg-gray-50 font-sans">
<!-- Header giống instructor_dBoard -->
<jsp:include page="../../header.jsp"/>

<main class="container mx-auto px-4 py-10">
    <!-- Course Info -->
    <div class="bg-white rounded-xl shadow-lg p-8 mb-12">
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between">
            <div>
                <h1 class="text-3xl font-bold text-gray-800 mb-2">${course.courseName}</h1>
                <p class="text-gray-600 mb-1">Category: <span class="font-semibold">${course.courseCategory}</span></p>
                <p class="text-gray-600 mb-1">Instructor: <span class="font-semibold">${course.user.displayName}</span>
                </p>
                <p class="text-gray-600">
                    Last Updated:
                    <fmt:formatDate value="${course.courseLastUpdate}" pattern="dd MMM yyyy"/>
                </p>
            </div>
            <div class="mt-6 md:mt-0">
                <img src="${course.courseImageLocation}" class="w-64 h-40 object-cover rounded-md shadow"
                     alt="Course Image">
            </div>
        </div>
    </div>

    <!-- Module List (carousel) -->
    <div class="mb-10">
        <h2 class="text-2xl font-bold text-gray-800 mb-4">Modules</h2>
        <div class="overflow-x-auto">
            <div class="flex space-x-6 pb-4">
                <c:forEach var="m" items="${modules}">
                    <div class="min-w-[260px] bg-white rounded-lg shadow-md p-5 hover:shadow-xl transition">
                        <h3 class="text-lg font-semibold text-indigo-700 mb-2">${m.moduleName}</h3>
                        <p class="text-sm text-gray-500">
                            Last Update:
                            <fmt:formatDate value="${m.moduleLastUpdate}" pattern="dd MMM yyyy"/>
                        </p>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="text-center">
        <a href="instructor?action=list" class="text-indigo-600 hover:underline font-medium">
            &larr; Back to Course List
        </a>
    </div>
</main>

<!-- Footer -->
<jsp:include page="footer.jsp"/>
</body>
</html>