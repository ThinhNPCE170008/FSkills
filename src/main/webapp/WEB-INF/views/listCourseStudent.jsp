<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Courses - F-Skill</title>

    <link rel="icon" type="image/png" href="https://placehold.co/32x32/0284c7/ffffff?text=FS">

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="stylesheet" href="css/main-styles.css">

    <script>
        // Cấu hình tùy chỉnh cho Tailwind CSS
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {inter: ['Inter', 'sans-serif']},
                    colors: {
                        primary: {DEFAULT: '#0284c7', light: '#03a9f4', dark: '#075985'},
                        secondary: '#475569'
                    }
                }
            }
        }
    </script>
    <style>
        .logo-img {
    max-width: 130px;
    height: auto;
    margin-right: 5px;
}
        /* CSS cho phần hero section nhỏ của trang này */
        .hero-gradient-small {
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

<body class="font-inter bg-slate-50 text-gray-800">

    <header class="bg-white/80 backdrop-blur-lg sticky top-0 z-40 shadow-sm">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between h-20">
                <a href="homePage_Guest.jsp" class="flex items-center space-x-2">
                    <img src="img/logo.png" alt="F-SKILL Logo" class="logo-img" />
                </a>

                <nav class="hidden lg:flex items-center space-x-8">
                    <a href="homePage_Guest.jsp" class="text-gray-600 hover:text-primary font-medium transition-colors">Home</a>
                    <a href="AllCourses" class="text-primary font-medium border-b-2 border-primary">All Courses</a>
                    <c:if test="${not empty currentUser}">
                        <a href="myCourse.jsp" class="text-gray-600 hover:text-primary font-medium transition-colors">My Course</a>
                    </c:if>
                </nav>

                <div class="flex items-center space-x-4">
                    <c:if test="${not empty currentUser}">
                        <a href="#" class="text-gray-600 hover:text-primary relative">
                            <i class="fas fa-shopping-cart fa-lg"></i>
                            <span class="absolute -top-2 -right-3 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">2</span>
                        </a>
                    </c:if>
                    
                    <div class="font-semibold text-secondary">
                        <c:choose>
                            <c:when test="${not empty currentUser}">
                                Hi, ${currentUser.displayName}
                            </c:when>
                            <c:otherwise>
                                Hi, Guest
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty currentUser}">
                            <a href="logout" class="px-5 py-2.5 rounded-full font-semibold bg-red-500 text-white hover:bg-red-600 transition-all duration-300 shadow-md hover:shadow-lg">
                                Logout
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="login" class="px-5 py-2.5 rounded-full font-semibold bg-primary text-white hover:bg-primary-dark transition-all duration-300 shadow-md hover:shadow-lg">
                                Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <main>
        <section class="hero-gradient-small py-12">
            <div class="container mx-auto px-4 text-center">
                <h1 class="text-4xl lg:text-5xl font-extrabold text-primary-dark">Explore Our Courses</h1>
                <p class="mt-4 text-lg text-secondary max-w-2xl mx-auto">Find the perfect course to boost your skills and achieve your goals.</p>
            </div>
        </section>

        <section class="py-16">
            <div class="container mx-auto px-4">

                <!-- Search and Filter Form -->
                <form method="GET" action="CourseListServlet" class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-12 p-6 bg-white rounded-2xl shadow">
                    <div class="md:col-span-2">
                        <label for="search" class="block text-sm font-medium text-gray-700 mb-1">Search for courses</label>
                        <div class="relative">
                            <input type="search" id="search" name="search" value="${currentSearch}" 
                                   placeholder="Enter keywords..." 
                                   class="w-full pl-4 pr-10 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none">
                            <i class="fa-solid fa-magnifying-glass absolute right-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                        </div>
                    </div>
                    <div>
                        <label for="category" class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                        <select id="category" name="category" class="w-full py-2.5 px-4 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none">
                            <option value="all">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" ${currentCategory eq cat ? 'selected' : ''}>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-transparent mb-1">Action</label>
                        <button type="submit" class="w-full px-5 py-2.5 rounded-lg font-semibold bg-primary text-white hover:bg-primary-dark transition-all duration-300 shadow-md">
                            Apply Filters
                        </button>
                    </div>
                </form>

                <!-- Course Grid -->
                <c:choose>
                    <c:when test="${empty courseList}">
                        <div class="text-center bg-white p-12 rounded-2xl shadow-md">
                            <i class="fas fa-book-open fa-4x text-gray-300 mb-4"></i>
                            <h3 class="text-2xl font-semibold text-gray-700">No Courses Found</h3>
                            <p class="text-gray-500 mt-2">Try adjusting your search criteria or browse all courses.</p>
                            <c:if test="${not empty currentSearch or (not empty currentCategory and currentCategory ne 'all')}">
                                <a href="AllCourses" class="inline-block mt-4 px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                                    View All Courses
                                </a>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
                            <c:forEach var="course" items="${courseList}">
                                <a href="courseDetail?id=${course.courseID}" class="card-hover bg-white rounded-2xl shadow-lg overflow-hidden group flex flex-col">
                                    <div class="overflow-hidden h-48">
                                        <img src="${course.courseImageLocation}" 
                                             alt="${course.courseName}" 
                                             class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                                             onerror="this.src='https://placehold.co/600x400/38bdf8/ffffff?text=Course'">
                                    </div>
                                    <div class="p-5 flex flex-col flex-grow">
                                        <p class="text-sm font-semibold text-primary mb-2">${course.courseCategory}</p>
                                        <h3 class="text-lg font-bold leading-tight text-gray-800 group-hover:text-primary-dark transition-colors flex-grow">
                                            ${course.courseName}
                                        </h3>
                                        <div class="mt-4 pt-4 border-t border-gray-100 flex items-center justify-between">
                                            <div class="flex items-center">
                                                <c:choose>
                                                    <c:when test="${not empty course.user.avatar}">
                                                        <img src="${course.user.avatar}" 
                                                             alt="${course.user.displayName}" 
                                                             class="w-8 h-8 rounded-full mr-2 object-cover"
                                                             onerror="this.src='https://i.pravatar.cc/40?u=${course.user.displayName}'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://i.pravatar.cc/40?u=${course.user.displayName}" 
                                                             alt="${course.user.displayName}" 
                                                             class="w-8 h-8 rounded-full mr-2 object-cover">
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="text-sm text-gray-600">${course.user.displayName}</span>
                                            </div>
                                            <c:choose>
                                                <c:when test="${course.isSale == 1}">
                                                    <div class="text-right">
                                                        <span class="text-lg font-bold text-primary-dark">
                                                            <fmt:formatNumber value="${course.salePrice}" type="currency" currencyCode="VND"/>
                                                        </span>
                                                        <div class="text-sm text-gray-500 line-through">
                                                            <fmt:formatNumber value="${course.originalPrice}" type="currency" currencyCode="VND"/>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:when test="${course.originalPrice == 0}">
                                                    <span class="text-lg font-bold text-green-600">Free</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-lg font-bold text-primary-dark">
                                                        <fmt:formatNumber value="${course.originalPrice}" type="currency" currencyCode="VND"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>

                        <!-- Pagination (Static for now) -->
                        <nav class="mt-16 flex items-center justify-center space-x-2" aria-label="Pagination">
                            <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 rounded-lg pointer-events-none opacity-50">
                                Previous
                            </a>
                            <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold rounded-lg bg-primary text-white pointer-events-none">
                                1
                            </a>
                            <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold rounded-lg text-gray-900 hover:bg-gray-200">
                                2
                            </a>
                            <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold rounded-lg text-gray-900 hover:bg-gray-200">
                                3
                            </a>
                            <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold rounded-lg text-gray-900 hover:bg-gray-200">
                                4
                            </a>
                            <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold rounded-lg text-gray-900 hover:bg-gray-200">
                                5
                            </a>
                            <a href="#" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 rounded-lg hover:bg-gray-200">
                                Next
                            </a>
                        </nav>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>

   <footer class="bg-slate-100 text-slate-600 border-t border-slate-200">
        <div class="container mx-auto px-4 pt-16 pb-8">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-12">
                <div class="lg:col-span-1">
                    <a href="homePage_Guest.jsp" class="flex items-center space-x-2">
                    <img src="img/logo.png" alt="F-SKILL Logo" class="logo-img" />
                </a>
                    <p class="text-slate-400">An online learning platform that helps you access knowledge anytime, anywhere.</p>
                </div>
                <div>
                    <h4 class="font-bold text-slate-700 text-lg mb-4">Quick Links</h4>
                    <ul class="space-y-3">
                        <li><a href="#" class="hover:text-primary transition-colors">About Us</a></li>
                        <li><a href="CourseListServlet" class="hover:text-primary transition-colors">All Courses</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Terms of Service</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Privacy Policy</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold text-slate-700 text-lg mb-4">Contact</h4>
                    <ul class="space-y-3">
                        <li class="flex items-start space-x-3"><i class="fa-solid fa-phone mt-1 text-primary"></i><span>+84–123–456–789</span></li>
                        <li class="flex items-start space-x-3"><i class="fa-solid fa-envelope mt-1 text-primary"></i><span>contact@fskill.com</span></li>
                        <li class="flex items-start space-x-3"><i class="fa-solid fa-map-marker-alt mt-1 text-primary"></i><span>Can Tho, Vietnam</span></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold text-slate-700 text-lg mb-4">Follow Us</h4>
                    <div class="flex space-x-4">
                        <a href="#" class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="h-10 w-10 bg-slate-700 hover:bg-primary rounded-full flex items-center justify-center transition-colors"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
            </div>

            <div class="border-t border-slate-700 pt-8 text-center text-slate-500">
                <p>© 2025 F–Skill. All rights reserved. | From Group 3 With ❤️</p>
            </div>
        </div>
    </footer>

</body>
</html>