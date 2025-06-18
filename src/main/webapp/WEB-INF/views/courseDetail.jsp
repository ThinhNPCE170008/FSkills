<%@page import="java.util.List"%>
<%@page import="dao.CourseDAO"%>
<%@page import="model.Course"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>F-Skill | <%= request.getAttribute("course") != null ? ((Course) request.getAttribute("course")).getCourseName() : "Course Detail" %></title>

    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <script>
        // Custom configuration for Tailwind CSS
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        inter: ['Inter', 'sans-serif'],
                    },
                    colors: {
                        primary: {
                            DEFAULT: '#0284c7', // sky-600
                            light: '#03a9f4',    // sky-500
                            dark: '#075985',     // sky-800
                        },
                        secondary: '#475569', // slate-600
                    }
                }
            }
        }
    </script>

    <style>
        /* Additional styles if needed */
        .logo-img {
            max-width: 130px;
            height: auto;
            margin-right: 5px;
        }
    </style>
</head>

<body class="font-inter bg-white text-gray-800">

    <header class="bg-white/80 backdrop-blur-lg sticky top-0 z-50 shadow-sm">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between h-20">
                <div class="flex items-center space-x-2">
                   <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="flex items-center space-x-2">
                        <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class="logo-img" />
                    </a>
                    <span class="text-2xl font-bold text-gray-800"></span>
                </div>

                <nav class="hidden lg:flex items-center space-x-8">
                    <a href="${pageContext.request.contextPath}/#home" class="text-gray-600 hover:text-primary font-medium transition-colors">Home</a>
                    <a href="${pageContext.request.contextPath}/AllCourses" class="text-gray-600 hover:text-primary font-medium transition-colors">All Courses</a>
                    <a href="${pageContext.request.contextPath}/#courses" class="text-gray-600 hover:text-primary font-medium transition-colors">Courses</a>
                    <a href="${pageContext.request.contextPath}/#blog" class="text-gray-600 hover:text-primary font-medium transition-colors">Blog</a>
                </nav>

                <div class="flex items-center space-x-4">
                    <div class="hidden md:block relative">
                        <input type="search" placeholder="Search for courses..." class="w-full sm:w-48 lg:w-64 pl-4 pr-10 py-2.5 border border-gray-200 rounded-full focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all duration-300 ease-in-out">
                        <i class="fa-solid fa-magnifying-glass absolute right-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                    </div>
                    <a href="${pageContext.request.contextPath}/login" class="hidden sm:inline-block text-secondary hover:text-primary font-semibold transition-colors">Login</a>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="px-5 py-2.5 rounded-full font-semibold bg-primary text-white hover:bg-primary-dark transition-all duration-300 shadow-md hover:shadow-lg">
                        Sign Up
                    </a>
                </div>
            </div>
        </div>
    </header>

    <main class="py-16 lg:py-24 bg-gray-50">
        <div class="container mx-auto px-4">
            <% if (request.getAttribute("course") != null) {
                Course course = (Course) request.getAttribute("course");
                List<String> highlights = (List<String>) request.getAttribute("highlights");
                List<CourseDAO.CourseSection> curriculum = (List<CourseDAO.CourseSection>) request.getAttribute("curriculum");
                double averageRating = (double) request.getAttribute("averageRating");
                int ratingCount = (int) request.getAttribute("ratingCount");
                List<Course> relatedCourses = (List<Course>) request.getAttribute("relatedCourses");
            %>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="md:col-span-2 bg-white rounded-lg shadow-md p-6">
                    <h1 class="text-3xl font-bold text-primary-dark mb-4"><%= course.getCourseName() %></h1>
                    <p class="text-gray-600 mb-4">Course Category: <%= course.getCourseCategory() %></p>
                    <div class="flex items-center mb-4">
                        <span class="text-yellow-500 mr-2">
                            <% for (int i = 0; i < (int)averageRating; i++) { %>
                                <i class="fa-solid fa-star"></i>
                            <% } %>
                            <% if (averageRating % 1 != 0) { %>
                                <i class="fa-solid fa-star-half-stroke"></i>
                            <% } %>
                            <% for (int i = (int)Math.ceil(averageRating); i < 5; i++) { %>
                                <i class="fa-regular fa-star"></i>
                            <% } %>
                        </span>
                        <span class="text-gray-500">(<%= String.format("%.1f", averageRating) %>/5 - <%= ratingCount %> ratings)</span>
                    </div>
                    <img src="<%= course.getCourseImageLocation() %>" alt="Course Image" class="rounded-md mb-4 w-full">

                    <h2 class="text-xl font-semibold text-secondary mb-3">Course Highlights</h2>
                    <ul class="list-disc list-inside text-gray-600 mb-4">
                        <% if (highlights != null) {
                            for (String highlight : highlights) { %>
                                <li><%= highlight %></li>
                            <% }
                        } %>
                    </ul>

                    <h2 class="text-xl font-semibold text-secondary mb-3">Course Curriculum</h2>
                    <div class="space-y-3">
                        <% if (curriculum != null) {
                            for (CourseDAO.CourseSection section : curriculum) { %>
                                <div class="bg-gray-100 rounded-md p-3 border border-gray-200">
                                    <h3 class="font-semibold text-gray-700"><%= section.getTitle() %></h3>
                                    <p class="text-gray-600 text-sm"><%= section.getDescription() %></p>
                                </div>
                            <% }
                        } %>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-md p-6">
                    <div class="flex items-center mb-4 border-b border-gray-200 pb-4">
                        <img src="<%= course.getUser().getAvatar() != null ? course.getUser().getAvatar() : "${pageContext.request.contextPath}/img/instructor-placeholder.png" %>" alt="Instructor Avatar" class="w-16 h-16 rounded-full mr-4">
                        <div>
                            <h3 class="text-lg font-semibold text-primary-dark"><%= course.getUser().getDisplayName() %></h3>
                            <p class="text-gray-500 text-sm">Instructor</p>
                            </div>
                    </div>

                    <div class="mb-4">
                        <% if (course.getIsSale() == 1 && course.getSalePrice() > 0) { %>
                            <span class="font-bold text-xl text-primary-dark">$<%= course.getSalePrice() %></span>
                            <del class="text-gray-500 text-sm ml-2">$<%= course.getOriginalPrice() %></del>
                        <% } else { %>
                            <span class="font-bold text-xl text-primary-dark">$<%= course.getOriginalPrice() %></span>
                        <% } %>
                        <p class="text-gray-500 text-sm">One-time payment</p>
                    </div>

                    <button class="w-full py-3 rounded-full font-semibold bg-primary text-white hover:bg-primary-dark transition-all duration-300 shadow-md hover:shadow-lg mb-3">
                        Enroll Now
                    </button>
                    <button class="w-full py-3 rounded-full font-semibold bg-gray-200 text-gray-700 hover:bg-gray-300 transition-all duration-300 border border-gray-300">
                        Add to Cart
                    </button>
                </div>
            </div>

            <div class="mt-12">
                <h2 class="text-2xl font-semibold text-secondary mb-6">Related Courses</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
                    <% if (relatedCourses != null && !relatedCourses.isEmpty()) {
                        for (Course relatedCourse : relatedCourses) { %>
                            <div class="bg-white rounded-lg shadow-md p-4">
                                <h3 class="font-semibold text-gray-700 mb-2"><%= relatedCourse.getCourseName() %></h3>
                                <p class="text-gray-600 text-sm">Category: <%= relatedCourse.getCourseCategory() %></p>
                                <a href="${pageContext.request.contextPath}/courseDetail?id=<%= relatedCourse.getCourseID() %>" class="text-primary hover:text-primary-dark text-sm font-medium mt-2 inline-block">Learn More</a>
                            </div>
                        <% }
                    } else { %>
                        <p class="text-gray-500">No related courses found.</p>
                    <% } %>
                </div>
            </div>
            <% } else { %>
                <div class="bg-white rounded-lg shadow-md p-6 text-center">
                    <h2 class="text-xl font-semibold text-red-500">Course Not Found</h2>
                    <p class="text-gray-600 mt-2">The course with the specified ID does not exist.</p>
                    <a href="${pageContext.request.contextPath}/AllCourses" class="inline-block mt-4 px-4 py-2 bg-primary text-white rounded hover:bg-primary-dark">Back to All Courses</a>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="bg-slate-800 text-slate-300">
        <div class="container mx-auto px-4 pt-16 pb-8">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-12">
                <div class="lg:col-span-1">
                    <a href="#" class="flex items-center space-x-2 mb-4">
                        <img src="https://placehold.co/40x40/ffffff/0284c7?text=FS" alt="Logo" class="rounded-lg">
                        <span class="text-2xl font-bold text-white">F-Skill</span>
                    </a>
                    <p class="text-slate-400">An online learning platform that helps you access knowledge anytime, anywhere.</p>
                </div>
                <div>
                    <h4 class="font-bold text-white text-lg mb-4">Quick Links</h4>
                    <ul class="space-y-3">
                        <li><a href="#" class="hover:text-primary transition-colors">About Us</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">All Courses</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Terms of Service</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Privacy Policy</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold text-white text-lg mb-4">Contact</h4>
                    <ul class="space-y-3">
                        <li class="flex items-start space-x-3"><i class="fa-solid fa-phone mt-1 text-primary"></i><span>+62–8XXX–XXX–XX</span></li>
                        <li class="flex items-start space-x-3"><i class="fa-solid fa-envelope mt-1 text-primary"></i><span>demo@gmail.com</span></li>
                        <li class="flex items-start space-x-3"><i class="fa-solid fa-map-marker-alt mt-1 text-primary"></i><span>Khu II, Đ. 3/2, Xuân Khánh, Ninh Kiều, Cần Thơ</span></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold text-white text-lg mb-4">Follow Us</h4>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
</body>

</html>