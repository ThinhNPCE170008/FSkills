<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="../img/favicon_io/favicon.ico">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
        }

        .header-shadow {
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .card {
            background-color: white;
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
        }

        .btn-primary-gradient {
            background-image: linear-gradient(to right, #4f46e5, #6366f1);
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(99, 102, 241, 0.2);
        }

        .btn-primary-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 10px rgba(99, 102, 241, 0.3);
        }

        .stat-card i {
            transition: transform 0.3s ease;
        }

        .stat-card:hover i {
            transform: scale(1.1);
        }

        @keyframes fadeInDropdown {
            0% {
                opacity: 0;
                transform: translateY(-10px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-enter {
            animation: fadeInDropdown 0.2s ease-out forwards;
        }
    </style>
</head>
<body>
<header class="bg-white sticky top-0 z-50 header-shadow">
    <div class="container mx-auto px-4">
        <div class="flex items-center justify-between h-20 px-6">
            <div class="flex items-center space-x-2">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class=" w-20 h-15"/>
            </div>

            <nav class="hidden lg:flex items-center space-x-8">
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Dashboard</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">My Courses</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Analytics</a>
                <a href="#" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Feedback</a>
                <a href="editProfile"
                   class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Profile</a>
            </nav>

            <div class="relative flex items-center space-x-4">
                <c:set var="user" value="${sessionScope.user}"/>
                <div class="relative">
                    <button id="userDropdownBtn" class="flex items-center gap-2 focus:outline-none">
                        <img src="${user.avatar}" alt="Instructor Avatar"
                             class="w-10 h-10 rounded-full border-2 border-indigo-200">
                        <span class="hidden md:inline font-medium text-gray-700">${user.displayName}</span>
                        <i class="fas fa-chevron-down text-gray-500 text-xs"></i>
                    </button>

                    <div id="userDropdownMenu"
                         class="absolute right-0 mt-2 w-44 bg-white border border-gray-200 rounded-md shadow-lg py-2 z-50 hidden">
                        <a href="editProfile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Manage
                            Profile</a>
                        <a href="logout" class="block px-4 py-2 text-sm text-red-600 hover:bg-red-50">Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</header>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const toggleBtn = document.getElementById("userDropdownBtn");
        const dropdownMenu = document.getElementById("userDropdownMenu");

        toggleBtn.addEventListener("click", function (e) {
            e.stopPropagation();
            if (dropdownMenu.classList.contains("hidden")) {
                dropdownMenu.classList.remove("hidden");
                dropdownMenu.classList.add("dropdown-enter");
            } else {
                dropdownMenu.classList.add("hidden");
                dropdownMenu.classList.remove("dropdown-enter");
            }
        });

        document.addEventListener("click", function (e) {
            if (!dropdownMenu.classList.contains("hidden")) {
                dropdownMenu.classList.add("hidden");
                dropdownMenu.classList.remove("dropdown-enter");
            }
        });
    });
</script>
</body>
</html>
