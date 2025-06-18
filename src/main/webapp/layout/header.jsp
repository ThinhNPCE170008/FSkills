<!DOCTYPE html>
<html lang="en" class="w-full">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>F-Skill | Header</title>

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="https://placehold.co/32x32/0284c7/ffffff?text=FS">

  <!-- Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>

  <%@ page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            inter: ['Inter', 'sans-serif'],
          },
          colors: {
            primary: {
              DEFAULT: '#0284c7',
              light: '#03a9f4',
              dark: '#075985',
            },
            secondary: '#475569',
          }
        }
      }
    }
  </script>

  <style>
    .header-container {
      background: rgba(255, 255, 255, 0.8);
      backdrop-filter: blur(12px);
    }
    .nav-link {
      transition: color 0.3s ease;
    }
    .nav-link:hover {
      color: #0284c7;
    }
    .badge {
      top: -8px;
      right: -8px;
      font-size: 0.75rem;
      padding: 2px 6px;
    }
    @keyframes fade-in {
      from { opacity: 0; transform: translateY(-5px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-in {
      animation: fade-in 0.2s ease-out;
    }
  </style>
</head>

<body class="font-inter">

<header class="header-container fixed top-0 left-0 w-full z-50 shadow-sm bg-white bg-opacity-80 backdrop-blur">
  <div class="w-full px-0 mx-0">
    <div class="flex items-center justify-between h-16 px-4">
      <!-- Logo -->
      <img src="img/logo.png" href="HomePage_Guest.jsp" alt="Logo" class="w-15 h-12" />

      <!-- Navigation -->
      <nav class="flex items-center space-x-6">
        <a href="#" class="nav-link text-gray-600 font-medium">Home</a>
        <a href="#" class="nav-link text-gray-600 font-medium">My Course</a>

        <a href="#" class="nav-link text-gray-600 font-medium">All Courses</a>

        <!-- Search Bar -->
        <div class="hidden md:flex items-center relative">
          <input type="text" placeholder="Search for courses..."
                 class="w-48 lg:w-64 pl-4 pr-10 py-2 border border-gray-200 rounded-full focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none">
          <button class="absolute right-0 bg-primary text-white rounded-full p-2 hover:bg-primary-dark transition">
            <i class="bi bi-search"></i>
          </button>
        </div>

        <!-- Icons + Avatar Dropdown -->
        <div class="flex items-center space-x-4">
          <!-- Cart Icon -->
          <span class="relative text-gray-600 icon-container">
            <i class="bi bi-cart3 text-lg"></i>
            <span class="badge absolute bg-red-600 text-white rounded-full">2</span>
          </span>

          <!-- Bell Icon -->
          <span class="text-gray-600 icon-container">
            <i class="bi bi-bell text-lg"></i>
          </span>

          <!-- Avatar + Dropdown -->
          <div class="relative inline-block text-left">
            <button id="userMenuButton"
                    class="flex items-center gap-2 px-3 py-2 rounded-full hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-primary transition">
              <img src="https://placehold.co/32x32" alt="Avatar"
                   class="w-9 h-9 rounded-full object-cover border border-gray-300 shadow-sm" />
              <span class="text-gray-700 font-medium hidden sm:inline">
                <c:choose>
                  <c:when test="${not empty sessionScope.user.displayName}">
                    <c:out value="${sessionScope.user.displayName}" />
                  </c:when>
                  <c:otherwise>
                    Guest
                  </c:otherwise>
                </c:choose>
              </span>
              <i class="bi bi-caret-down-fill text-gray-500 text-sm"></i>
            </button>

            <!-- Dropdown -->
            <div id="userDropdown"
                 class="absolute right-0 mt-2 w-48 bg-white border border-gray-200 rounded-lg shadow-lg z-50 hidden animate-fade-in">
              <ul class="py-1 text-sm text-gray-700">
                <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Profile</a></li>
                <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Settings</a></li>
                <li><a href="${pageContext.request.contextPath}/Degree"
                       class="block px-4 py-2 hover:bg-gray-100 text-gray-800">Degree</a></li>
                <li><a href="${pageContext.request.contextPath}/logout"
                       class="block px-4 py-2 text-red-600 hover:bg-red-50">Logout</a></li>
              </ul>
            </div>
          </div>
        </div>
      </nav>
    </div>
  </div>
</header>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const button = document.getElementById('userMenuButton');
    const dropdown = document.getElementById('userDropdown');

    document.addEventListener('click', function (e) {
      const isClickInsideButton = button.contains(e.target);
      const isClickInsideDropdown = dropdown.contains(e.target);

      if (isClickInsideButton) {
        dropdown.classList.toggle('hidden');
      } else if (!isClickInsideDropdown) {
        dropdown.classList.add('hidden');
      }
    });
  });
</script>

</body>
</html>
