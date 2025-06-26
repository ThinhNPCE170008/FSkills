<%@page import="model.Notification"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    User acc = (User) session.getAttribute("user");
    if (acc == null) {
        response.sendRedirect("login");
        return;
    }

    List<Notification> listNotification = (List<Notification>) request.getAttribute("listNotification");
%>

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

        <header>
            <jsp:include page="/layout/sidebar_user.jsp" />
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

                    <form method="GET" action="AllCourses" class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-12 p-6 bg-white rounded-2xl shadow">
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
                                    <option value="${cat.name}" ${currentCategory eq cat.name ? 'selected' : ''}>${cat.name}</option>
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
                                            <p class="text-sm font-semibold text-primary mb-2">${course.category.name}</p>
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
                                                <div class="text-right">
                                                    <c:choose>
                                                       <c:when test="${course.originalPrice == 0}">
                                                            <span class="text-lg font-bold text-green-600">Free</span>
                                                        </c:when>
                                                            <c:when test="${course.salePrice == 0}">
                                                            <span class="text-lg font-bold text-green-600">Free</span>
                                                        </c:when>

                                                        <c:when test="${course.isSale == 1}">
                                                            <fmt:setLocale value="en_US"/>
                                                            <span class="text-lg font-bold text-primary-dark">
                                                                <fmt:formatNumber value="${course.salePrice * 1000}" pattern="#,##0"/> VND
                                                            </span>
                                                            <div class="text-sm text-gray-500 line-through">
                                                                <fmt:formatNumber value="${course.originalPrice * 1000}" pattern="#,##0"/> VND
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${course.originalPrice == 0}">
                                                            <span class="text-lg font-bold text-green-600">Free</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-lg font-bold text-primary-dark">
                                                                <fmt:formatNumber value="${course.originalPrice * 1000}" pattern="#,##0"/> VND
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>

                            <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
                            <c:set var="totalPages" value="${totalPages != null ? totalPages : 5}" /> <%-- Placeholder: totalPages should come from servlet --%>

                            <nav class="mt-16 flex items-center justify-center space-x-2" aria-label="Pagination">
                                <c:url var="prevPageUrl" value="AllCourses">
                                    <c:param name="page" value="${currentPage - 1}"/>
                                    <c:param name="search" value="${currentSearch}"/>
                                    <c:param name="category" value="${currentCategory}"/>
                                </c:url>
                                <a href="${prevPageUrl}" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 rounded-lg ${currentPage eq 1 ? 'pointer-events-none opacity-50' : 'hover:bg-gray-200'}">
                                    Previous
                                </a>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:url var="pageUrl" value="AllCourses">
                                        <c:param name="page" value="${i}"/>
                                        <c:param name="search" value="${currentSearch}"/>
                                        <c:param name="category" value="${currentCategory}"/>
                                    </c:url>
                                    <a href="${pageUrl}" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold rounded-lg
                                       ${currentPage eq i ? 'bg-primary text-white' : 'text-gray-900 hover:bg-gray-200'}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <c:url var="nextPageUrl" value="AllCourses">
                                    <c:param name="page" value="${currentPage + 1}"/>
                                    <c:param name="search" value="${currentSearch}"/>
                                    <c:param name="category" value="${currentCategory}"/>
                                </c:url>
                                <a href="${nextPageUrl}" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 rounded-lg ${currentPage eq totalPages ? 'pointer-events-none opacity-50' : 'hover:bg-gray-200'}">
                                    Next
                                </a>
                            </nav>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </main>                        <footer><jsp:include page="/layout/footer.jsp" /></footer>

    </body>
</html>
