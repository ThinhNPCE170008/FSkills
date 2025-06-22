<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />


    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#0284c7',
                    },
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                    }
                }
            }
        };
    </script>

    <style>
        /* Sidebar co/giãn khi hover */
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

        /* ?n text khi sidebar nh? */
        .sidebar-container .nav-link span,
        .sidebar-container .user-info {
            display: none;
        }

        .sidebar-container:hover .nav-link span,
        .sidebar-container:hover .user-info {
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
<body class="font-sans">

<!-- Sidebar -->
<div class="sidebar-container border-end p-3">
    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="d-flex align-items-center mb-4 text-decoration-none">
        <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class="me-2" style="height: 40px;" />
        <span class="fs-5 fw-bold text-dark user-info"></span>
    </a>

    <!-- Avatar & User Info -->
    <div class="d-flex flex-column align-items-center mb-4 pb-4 border-bottom">
        <img src="https://placehold.co/80x80/cccccc/333333?text=Admin" alt="User Avatar" class="rounded-circle mb-2" style="width: 60px; height: 60px;">
        <div class="text-center user-info">
            <h6 class="mb-0 text-dark">John Doe</h6>
            <p class="text-muted small">Administrator</p>
        </div>
    </div>

    <!-- Sidebar menu -->
    <ul class="nav nav-pills flex-column">
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/adminDashboard"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/bills"><i class="bi bi-receipt"></i> <span>Bills</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/company"><i class="bi bi-building"></i> <span>Company</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/manageDegree"><i class="bi bi-mortarboard"></i> <span>Manage Degree</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/manageAccounts"><i class="bi bi-people"></i> <span>Manage Account</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/report"><i class="bi bi-bar-chart"></i> <span>Report</span></a></li>
               <div  class="d-flex flex-column mb-4 pt-5 border-top">
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/editProfile"><i class="bi bi-person"></i> <span>Profile</span></a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a></li>
               </div>
    </ul>
</div>




<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
