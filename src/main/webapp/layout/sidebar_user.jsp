<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Sidebar</title>

        <!-- Bootstrap CSS & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>

        <style>
            .sidebar-container {
                width: 60px;
                transition: width 0.3s ease;
                overflow-x: hidden;
                background-color: #f8f9fa;
                height: 100vh;
                position: fixed;
                top: 0;
                left: 0;
                z-index: 1000;
            }

            .sidebar-container:hover {
                width: 250px;
            }

            .sidebar-container .sidebar-logo span,
            .sidebar-container .nav-link span {
                display: none;
            }

            .sidebar-container:hover .sidebar-logo span,
            .sidebar-container:hover .nav-link span {
                display: inline;
            }

            .sidebar-container .nav-link i {
                margin-right: 8px;
            }

            body {
                
                margin-left: 60px;
                transition: margin-left 0.3s ease;
            }

            .sidebar-container:hover ~ main {
                margin-left: 250px;
            }

            main {
                transition: margin-left 0.3s ease;
                padding: 1rem;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar-container border-end p-3">

            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="d-flex align-items-center mb-4 text-decoration-none sidebar-logo">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class="me-2" style="height: 40px;" />
            </a>
            <!--Avatar-->
            <div class="d-flex flex-column align-items-center mb-4 pb-4 border-bottom">
                <img src="https://placehold.co/80x80/cccccc/333333?text=Learner" alt="User Avatar" class="rounded-circle mb-2" style="width: 60px; height: 60px;">
            </div>


            <!-- Navigation -->
            <ul class="nav nav-pills flex-column">
                <!-- Guest -->
                <c:if test="${sessionScope.role == null}">
                    <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/home"><i class="bi bi-house"></i> <span>Home</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="bi bi-book"></i> <span>All Courses</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/globalAnn.jsp"><i class="bi bi-megaphone"></i> <span>Announcements</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/#"><i class="bi bi-cart"></i> <span>Cart</span></a></li>
                    <div  class="d-flex flex-column mb-4 pt-5 border-top">
                        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/login"><i class="bi bi-box-arrow-in-right"></i> <span>Sign In / Up</span></a></li>
                    </div>
                </c:if>

                <!-- Learner -->
                <c:if test="${sessionScope.role == 'LEARNER'}">
                    <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/homePage.jsp"><i class="bi bi-house"></i> <span>Home</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="bi bi-book"></i> <span>All Courses</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="#"><i class="bi bi-backpack"></i> <span>My Courses</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/globalAnn.jsp"><i class="bi bi-megaphone"></i> <span>Announcements</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="#"><i class="bi bi-cart"></i> <span>Cart</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="notifications.jsp"><i class="bi bi-bell"></i> <span>Notifications</span></a></li>
                     <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/Degree"><i class="bi bi-mortarboard"></i> <span>Degree</span></a></li>
                    <div  class="d-flex flex-column mb-4 pt-5 border-top">
                        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/editProfile"><i class="bi bi-person"></i> <span>Profile</span></a></li>
                        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a></li>
                    </div>
                </c:if>

                <!-- Instructor -->
                <c:if test="${sessionScope.role == 'INSTRUCTOR'}">
                    <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/Instructor"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="manageCourses.jsp"><i class="bi bi-journal-code"></i> <span>Manage Courses</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="analytics.jsp"><i class="bi bi-graph-up"></i> <span>Analytics</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="feedback.jsp"><i class="bi bi-chat-left-dots"></i> <span>Feedback</span></a></li>
                    <li class="nav-item"><a class="nav-link text-dark" href="notifications.jsp"><i class="bi bi-bell"></i> <span>Notifications</span></a></li>
                    <div  class="d-flex flex-column mb-4 pt-5 border-top">
                        <li class="nav-item"><a class="nav-link text-dark" href="editProfile.jsp"><i class="bi bi-person"></i> <span>Profile</span></a></li>                  
                        <li class="nav-item"><a class="nav-link text-dark" href="logout.jsp"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a></li>
                    </div>
                </c:if>
            </ul>
        </div>
    </body>
</html>
