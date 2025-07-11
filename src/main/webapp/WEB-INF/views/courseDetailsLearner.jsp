<%@page import="model.Notification"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
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
        <title>${course.courseName}</title>

        <!-- Tailwind CSS CDN -->
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Font Awesome cho nhi?u lo?i bi?u t??ng hi?n ??i -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

        <style>
            body {
                font-family: 'Inter', sans-serif;
            }

            .sidebar-container {
                width: 100px;
                transition: width 0.3s ease-in-out;
                overflow-x: hidden;
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                z-index: 1000;
            }

            .sidebar-container:hover {
                width: 250px;
            }

            .sidebar-container .sidebar-logo span,
            .sidebar-container .nav-link span,
            .sidebar-container .user-info span {
                opacity: 0;
                visibility: hidden;
                white-space: nowrap;
                transition: opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
            }

            .sidebar-container:hover .sidebar-logo span,
            .sidebar-container:hover .nav-link span,
            .sidebar-container:hover .user-info span {
                opacity: 1;
                visibility: visible;
            }

            .sidebar-container .nav-link i {
                min-width: 24px;
                text-align: center;
                margin-right: 8px;
            }

            body {
                margin-left: 60px;
                transition: margin-left 0.3s ease-in-out;
            }

            .sidebar-container:hover ~ main {
                margin-left: 250px;
            }

            main {
                transition: margin-left 0.3s ease-in-out;
                padding: 1.5rem;
            }

            @media (max-width: 768px) {
                .sidebar-container {
                    width: 0;
                    left: -60px;
                }
                .sidebar-container:hover {
                    width: 0;
                }
                body {
                    margin-left: 0;
                }
                .sidebar-container:hover ~ main {
                    margin-left: 0;
                }
            }
            .star-rating {
                display: inline-flex;
                flex-direction: row-reverse; /* Reverse order for better hover effect */
                font-size: 1.5rem;
                cursor: pointer;
            }

            .star-rating input {
                display: none; /* Hide radio inputs */
            }

            .star-rating label {
                color: #d1d5db; /* Gray-300 for unselected stars */
                transition: color 0.2s ease-in-out;
            }

            .star-rating input:checked ~ label,
            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #facc15; /* Yellow-400 for selected/hovered stars */
            }

            .star-rating label:hover {
                transform: scale(1.1); /* Slight scale effect on hover */
            }
        </style>
    </head>
    <body>


        <div>
            <jsp:include page="/layout/sidebar_user.jsp" />
        </div>

        <!-- Main Content -->
        <main class="ml-24 p-6">
            <div class="max-w-6xl mx-auto">
                <c:if test="${not empty course}">
                    <!-- Course Header -->
                    <div class="bg-white rounded-lg shadow-lg overflow-hidden mb-6">
                        <div class="md:flex">
                            <div class="md:w-1/2">
                                <img src="${course.courseImageLocation}"
                                     alt="${course.courseName}"
                                     class="w-full h-64 md:h-full object-cover"
                                     onerror="this.src='https://placehold.co/600x400/38bdf8/ffffff?text=Course'">
                            </div>
                            <div class="md:w-1/2 p-6">
                                <div class="mb-4">
                                    <span class="inline-block bg-blue-100 text-blue-800 text-sm font-semibold px-3 py-1 rounded-full">
                                        ${course.category.name}
                                    </span>
                                </div>
                                <h1 class="text-3xl font-bold text-gray-900 mb-4">${course.courseName}</h1>

                                <div class="flex items-center mb-4">
                                    <c:choose>
                                        <c:when test="${not empty course.user.avatar}">
                                            <img src="${course.user.avatar}"
                                                 alt="${course.user.displayName}"
                                                 class="w-12 h-12 rounded-full mr-3 object-cover"
                                                 onerror="this.src='https://i.pravatar.cc/48?u=${course.user.displayName}'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://i.pravatar.cc/48?u=${course.user.displayName}"
                                                 alt="${course.user.displayName}"
                                                 class="w-12 h-12 rounded-full mr-3 object-cover">
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <p class="text-gray-900 font-semibold">Instructor: ${course.user.displayName}</p>
                                        <p class="text-gray-600 text-sm">Course Creator</p>
                                    </div>
                                </div>

                                <div class="mb-6">
                                    <c:choose>  
                                        <c:when test="${course.salePrice == 0}">
                                            <span class="text-lg font-bold text-green-600">Free</span>
                                        </c:when>
                                        <c:when test="${course.isSale == 1}">                                     
                                            <div class="flex items-center space-x-2">
                                                <fmt:setLocale value="en_US"/>
                                                <span class="text-3xl font-bold text-green-600">
                                                    <fmt:formatNumber value="${course.salePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                                </span>
                                                <span class="text-lg text-gray-500 line-through">
                                                    <fmt:formatNumber value="${course.originalPrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                                </span>
                                            </div>
                                        </c:when>
                                        <c:when test="${course.originalPrice == 0}">
                                            <span class="text-3xl font-bold text-green-600">Free</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-3xl font-bold text-blue-600">
                                                <fmt:setLocale value="en_US"/>
                                                <fmt:formatNumber value="${course.originalPrice}" type="currency" currencySymbol="" groupingUsed="true"/> VND
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex space-x-4">
                                    <button class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg transition-colors">
                                        Enroll Now
                                    </button>
                                    <form method="POST" action="<%= request.getContextPath()%>/cart">
                                        <input type="hidden" name="CourseID" value="${course.courseID}">
                                        <button type="submit" name="CartAction" value="Add" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-3 px-6 rounded-lg transition-colors">
                                            Add to Cart
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Course Details Tabs -->
                    <div class="bg-white rounded-lg shadow-lg">
                        <div class="border-b border-gray-200">
                            <nav class="-mb-px flex space-x-8 px-6">
                                <button class="tab-button active border-b-2 border-blue-500 py-4 px-1 text-blue-600 font-medium" data-tab="overview">
                                    Overview
                                </button>
                                <button class="tab-button border-b-2 border-transparent py-4 px-1 text-gray-500 hover:text-gray-700 font-medium" data-tab="curriculum">
                                    Curriculum
                                </button>
                                <button class="tab-button border-b-2 border-transparent py-4 px-1 text-gray-500 hover:text-gray-700 font-medium" data-tab="reviews">
                                    Reviews
                                </button>
                            </nav>
                        </div>

                        <div class="p-6">
                            <!-- Overview Tab -->
                            <div id="overview" class="tab-content">
                                <h3 class="text-xl font-bold text-gray-900 mb-4">Course Summary</h3>
                                <div class="prose max-w-none">
                                    <p class="text-gray-700 leading-relaxed mb-6">
                                        ${course.courseSummary}
                                    </p>
                                </div>

                                <c:if test="${not empty course.courseHighlight}">
                                    <h3 class="text-xl font-bold text-gray-900 mb-4">Course Highlights</h3>
                                    <div class="prose max-w-none">
                                        <p class="text-gray-700 leading-relaxed">
                                            ${course.courseHighlight}
                                        </p>
                                    </div>
                                </c:if>

                                <div class="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div class="bg-gray-50 p-4 rounded-lg">
                                        <h4 class="font-semibold text-gray-900 mb-2">Course Information</h4>
                                        <ul class="space-y-2 text-sm text-gray-600">
                                            <li><strong>Category:</strong> ${course.category.name}</li>
                                            <li><strong>Instructor:</strong> ${course.user.displayName}</li>
                                            <li><strong>Last Updated:</strong>
                                                <fmt:formatDate value="${course.courseLastUpdate}" pattern="MMM dd, yyyy"/>
                                            </li>
                                            <li><strong>Published:</strong>
                                                <fmt:formatDate value="${course.publicDate}" pattern="MMM dd, yyyy"/>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Curriculum Tab -->
                            <div id="curriculum" class="tab-content hidden">
                                <h3 class="text-xl font-bold text-gray-900 mb-4">Course Curriculum</h3>
                                <p class="text-gray-600">Course curriculum will be displayed here when available.</p>
                            </div>

                            <!-- Reviews Tab -->
                            <div id="reviews" class="tab-content hidden">
                                <h3 class="text-xl font-bold text-gray-900 mb-4">Student Reviews</h3>

                                <!-- Review Submission Form -->
                                <c:if test="${studyProgress == 100 && !hasReviewed}">
                                    <div class="bg-white p-6 rounded-lg mb-6 shadow-md">
                                        <h4 class="text-lg font-semibold text-gray-900 mb-4">Submit Your Review</h4>
                                        <form method="POST" action="<%= request.getContextPath() %>/submitReview">
                                            <input type="hidden" name="courseID" value="${course.courseID}">
                                            <input type="hidden" name="userID" value="${user.userId}">
                                            <input type="hidden" name="rate" id="rating-value" value="0">
                                            <div class="mb-4">
                                                <label class="block text-sm font-medium text-gray-700 mb-2">Rating</label>
                                                <div class="star-rating">
                                                    <input type="radio" id="star5" name="star-rating" value="5" onclick="setRating(5)">
                                                    <label for="star5" class="fas fa-star"></label>
                                                    <input type="radio" id="star4" name="star-rating" value="4" onclick="setRating(4)">
                                                    <label for="star4" class="fas fa-star"></label>
                                                    <input type="radio" id="star3" name="star-rating" value="3" onclick="setRating(3)">
                                                    <label for="star3" class="fas fa-star"></label>
                                                    <input type="radio" id="star2" name="star-rating" value="2" onclick="setRating(2)">
                                                    <label for="star2" class="fas fa-star"></label>
                                                    <input type="radio" id="star1" name="star-rating" value="1" onclick="setRating(1)">
                                                    <label for="star1" class="fas fa-star"></label>
                                                </div>
                                            </div>
                                            <div class="mb-4">
                                                <label for="reviewDescription" class="block text-sm font-medium text-gray-700">Feedback</label>
                                                <textarea id="reviewDescription" name="reviewDescription" rows="4" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm" placeholder="Share your thoughts about the course..." required></textarea>
                                            </div>
                                            <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition-colors">
                                                Submit Review
                                            </button>
                                        </form>
                                    </div>
                                </c:if>

                                <!-- Display Reviews -->
                                <c:choose>
                                    <c:when test="${not empty reviewList}">
                                        <div class="space-y-6">
                                            <c:forEach var="review" items="${reviewList}">
                                                <div class="bg-white p-4 rounded-lg shadow-md">
                                                    <div class="flex items-center mb-2">
                                                        <c:choose>
                                                            <c:when test="${not empty review.user.avatarUrl || not empty review.user.avatar}">
                                                                <img src="${not empty review.user.avatarUrl ? review.user.avatarUrl : review.user.imageDataURI}" alt="${review.user.displayName}" class="w-10 h-10 rounded-full mr-3 object-cover" onerror="this.src='https://i.pravatar.cc/48?u=${review.user.displayName}'">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="https://i.pravatar.cc/48?u=${review.user.displayName}" alt="${review.user.displayName}" class="w-10 h-10 rounded-full mr-3 object-cover">
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div>
                                                            <p class="text-gray-900 font-semibold">${review.user.displayName}</p>
                                                            <div class="review-stars text-sm">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <i class="fas fa-star ${review.rate >= i ? 'text-yellow-400' : 'text-gray-300'}"></i>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <p class="text-gray-700">${review.reviewDescription}</p>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-gray-600">No reviews available for this course yet.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${empty course}">
                    <div class="bg-white rounded-lg shadow-lg p-8 text-center">
                        <i class="fas fa-exclamation-triangle fa-3x text-yellow-500 mb-4"></i>
                        <h2 class="text-2xl font-bold text-gray-900 mb-2">Course Not Found</h2>
                        <p class="text-gray-600 mb-4">The course you're looking for doesn't exist or has been removed.</p>
                        <a href="AllCourses" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                            Browse All Courses
                        </a>
                    </div>
                </c:if>
            </div>
        </main>
        <footer>
            <jsp:include page="/layout/footer.jsp" />
        </footer>

        <script>
            // Tab functionality
            document.addEventListener('DOMContentLoaded', function () {
                const tabButtons = document.querySelectorAll('.tab-button');
                const tabContents = document.querySelectorAll('.tab-content');

                tabButtons.forEach(button => {
                    button.addEventListener('click', () => {
                        const targetTab = button.getAttribute('data-tab');

                        // Remove active class from all buttons
                        tabButtons.forEach(btn => {
                            btn.classList.remove('active', 'border-blue-500', 'text-blue-600');
                            btn.classList.add('border-transparent', 'text-gray-500');
                        });

                        // Add active class to clicked button
                        button.classList.add('active', 'border-blue-500', 'text-blue-600');
                        button.classList.remove('border-transparent', 'text-gray-500');

                        // Hide all tab contents
                        tabContents.forEach(content => {
                            content.classList.add('hidden');
                        });

                        // Show target tab content
                        document.getElementById(targetTab).classList.remove('hidden');
                    });
                });
            });
            function setRating(value) {
                document.getElementById('rating-value').value = value;
            }
        </script>
    </body>
</html>
