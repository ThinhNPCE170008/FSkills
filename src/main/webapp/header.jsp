<%--
  Created by IntelliJ IDEA.
  User: NgoThinh1902
  Date: 6/18/2025
  Time: 1:32 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Additional custom styles */
        .hero-gradient {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
        }

        .card-hover {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card-hover:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        }
    </style>
</head>
<body>
<header class="bg-white sticky top-0 z-50 header-shadow">
    <div class="container mx-auto px-4">
        <div class="flex items-center justify-between h-20 px-6">
            <div class="flex items-center space-x-2">
                <img src="img/logo.png" alt="F-SKILL Logo" class=" w-20 h-15" />
            </div>

            <nav class="hidden lg:flex items-center space-x-8">
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Dashboard</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">My Courses</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Analytics</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Feedback</a>
                <a href="editProfile" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Profile</a>
            </nav>

            <div class="relative flex items-center space-x-4">
                <div class="relative">
                    <c:set var="user" value="${sessionScope.user}" />
                    <button class="flex items-center space-x-2 focus:outline-none">
                        <img src="${user.avatar}" alt="Instructor Avatar" class="w-10 h-10 rounded-full border-2 border-indigo-200">
                        <span class="hidden md:inline font-medium text-gray-700">${user.displayName}</span>
                        <i class="fas fa-chevron-down text-gray-500 text-xs"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
    </div>
</header>
</body>
</html>
