<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Enrolled Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous">
    <link rel="stylesheet" href="/FSkills/css/sidebar.css">
    <style>
        :root {
            --background-color: #f8f9fa;
            --card-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --border-radius: 8px;
            --transition: all 0.3s ease;
        }

        .main {
            min-height: 100vh;
            padding: 2rem 3vw;
            background-color: var(--background-color);
        }

        .h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            text-align: center;
            margin: 2rem 0 1.5rem;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 2rem 0 1rem;
        }

        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .card-hover {
            transition: var(--transition);
        }

        .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .progress-bar {
            height: 6px;
            border-radius: 4px;
            background-color: #e0e0e0;
            overflow: hidden;
            margin-top: 0.5rem;
        }

        .progress-bar-fill {
            height: 100%;
            background-color: #2ecc71;
            transition: width 0.3s ease;
        }

        .course-card img {
            height: 140px;
        }

        .course-card .p-5 {
            padding: 1rem !important;
        }

        .course-card h3 {
            font-size: 1.2rem;
        }

        .course-card p {
            font-size: 0.9rem;
        }

        .course-card .w-8 {
            width: 24px;
            height: 24px;
        }

        .course-card .btn {
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }

        .course-card .btn-detail {
            background-color: #e5e7eb; /* bg-gray-200 */
            color: #1f2937; /* text-gray-800 */
            border: none;
        }

        .course-card .btn-detail:hover {
            background-color: #d1d5db; /* hover:bg-gray-300 */
        }

        .course-card .btn-resume,
        .course-card .btn-enroll,
        .course-card .btn-revisit {
            background-color: #2563eb; /* bg-blue-600 */
            color: white;
            border: none;
        }

        .course-card .btn-resume:hover,
        .course-card .btn-enroll:hover,
        .course-card .btn-revisit:hover {
            background-color: #1e40af; /* hover:bg-blue-700 */
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    <c:choose>
        <c:when test="${isAdmin}">
            <%@include file="../../layout/header.jsp" %>
            <%@include file="../../layout/sidebar_admin.jsp" %>
        </c:when>
        <c:otherwise>
            <%@include file="../../layout/header.jsp" %>
            <%@include file="../../layout/sidebar_user.jsp" %>
        </c:otherwise>
    </c:choose>

    <main class="main">
        <p class="h1">My Courses</p>

        <!-- In Progress Courses -->
        <section>
            <h2 class="section-title">In Progress Courses</h2>
            <c:choose>
                <c:when test="${empty inProgressCourses}">
                    <p class="text-center">No courses in progress.</p>
                </c:when>
                <c:otherwise>
                    <div class="course-grid">
                        <c:forEach var="course" items="${inProgressCourses}" varStatus="loop">
                            <div class="card-hover bg-white rounded-2xl shadow-lg overflow-hidden flex flex-col course-card">
                                <div class="overflow-hidden">
                                    <img src="${course.imageDataURI}"
                                         alt="${course.courseName}"
                                         class="w-full object-cover transition-transform duration-500"
                                         onerror="this.src='https://placehold.co/600x400/38bdf8/ffffff?text=Course'">
                                </div>
                                <div class="p-5 flex flex-col flex-grow">
                                    <p class="text-sm font-semibold text-primary mb-2">${course.category.name}</p>
                                    <h3 class="font-bold leading-tight text-gray-800 flex-grow">
                                        ${course.courseName}
                                    </h3>
                                    <div class="progress-bar">
                                        <div class="progress-bar-fill" style="width: ${progressList[loop.index]}%"></div>
                                    </div>
                                    <p class="text-gray-600 mt-1">${progressList[loop.index]}% Complete</p>
                                    <div class="mt-4 pt-4 border-t border-gray-100 flex items-center">
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
                                            <span class="text-gray-600">${course.user.displayName}</span>
                                        </div>
                                    </div>
                                    <div class="mt-3 d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/courseDetail?id=${course.courseID}" class="btn btn-detail">Course Detail</a>
                                        <a href="${pageContext.request.contextPath}/learner/course?courseID=${course.courseID}" class="btn btn-resume">Resume</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Available Courses -->
        <section>
            <h2 class="section-title">Courses Available to Enroll</h2>
            <c:choose>
                <c:when test="${empty availableCourses}">
                    <p class="text-center">No courses available to enroll.</p>
                </c:when>
                <c:otherwise>
                    <div class="course-grid">
                        <c:forEach var="course" items="${availableCourses}">
                            <div class="card-hover bg-white rounded-2xl shadow-lg overflow-hidden flex flex-col course-card">
                                <div class="overflow-hidden">
                                    <img src="${course.imageDataURI}"
                                         alt="${course.courseName}"
                                         class="w-full object-cover transition-transform duration-500"
                                         onerror="this.src='https://placehold.co/600x400/38bdf8/ffffff?text=Course'">
                                </div>
                                <div class="p-5 flex flex-col flex-grow">
                                    <p class="text-sm font-semibold text-primary mb-2">${course.category.name}</p>
                                    <h3 class="font-bold leading-tight text-gray-800 flex-grow">
                                        ${course.courseName}
                                    </h3>
                                    <div class="mt-4 pt-4 border-t border-gray-100 flex items-center">
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
                                            <span class="text-gray-600">${course.user.displayName}</span>
                                        </div>
                                    </div>
                                    <div class="mt-3 d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/courseDetail?id=${course.courseID}" class="btn btn-detail">Course Detail</a>
                                        <form method="POST" action="<%= request.getContextPath()%>/learner/course">
                                            <button type="submit" name="AddEnroll" value="${course.courseID}" class="btn btn-enroll">Enroll</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Completed Courses -->
        <section>
            <h2 class="section-title">Completed Courses</h2>
            <c:choose>
                <c:when test="${empty completedCourses}">
                    <p class="text-center">No courses completed.</p>
                </c:when>
                <c:otherwise>
                    <div class="course-grid">
                        <c:forEach var="course" items="${completedCourses}">
                            <div class="card-hover bg-white rounded-2xl shadow-lg overflow-hidden flex flex-col course-card">
                                <div class="overflow-hidden">
                                    <img src="${course.imageDataURI}"
                                         alt="${course.courseName}"
                                         class="w-full object-cover transition-transform duration-500"
                                         onerror="this.src='https://placehold.co/600x400/38bdf8/ffffff?text=Course'">
                                </div>
                                <div class="p-5 flex flex-col flex-grow">
                                    <p class="text-sm font-semibold text-primary mb-2">${course.category.name}</p>
                                    <h3 class="font-bold leading-tight text-gray-800 flex-grow">
                                        ${course.courseName}
                                    </h3>
                                    <p class="text-gray-600 mt-1">Completed</p>
                                    <div class="mt-4 pt-4 border-t border-gray-100 flex items-center">
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
                                            <span class="text-gray-600">${course.user.displayName}</span>
                                        </div>
                                    </div>
                                    <div class="mt-3 d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/courseDetail?id=${course.courseID}" class="btn btn-detail">Course Detail</a>
                                        <a href="${pageContext.request.contextPath}/learner/course?courseID=${course.courseID}" class="btn btn-revisit">Revisit</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
    <%@include file="../../layout/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>