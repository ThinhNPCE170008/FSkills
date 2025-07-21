<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/transition.css">
<script src="${pageContext.request.contextPath}/js/transition.js"></script>

<header style="background-color: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.05); padding: 1rem 1.5rem; position: fixed; top: 0; left: 80px; right: 0; z-index: 1001; border-radius: 12px; transition: left 0.3s ease, width 0.3s ease;">
    <div style="max-width: 100%; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; border-radius: 8px;" class="header-container">
        <div style="white-space: nowrap; overflow: hidden; position: relative; width: 100%;" class="header-text">
            <div style="display: inline-block; padding-left: 100%; animation: scroll 10s linear infinite;" class="scrolling-text">
                <p style="margin: 0; font-weight: 600; color: #111; text-shadow: 1px 1px 2px rgba(0,0,0,0.1);">
                    Hi <span style="color: #2563eb; font-weight: 700; font-size: 0.875rem; text-shadow: 0 1px 1px rgba(0,0,0,0.1);" class="user-name">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.displayName}">
                                ${sessionScope.user.displayName}
                                <c:if test="${sessionScope.user.role eq 'INSTRUCTOR'}">
                                    <span class="instructor-indicator" style="display:none;"></span>
                                </c:if>
                            </c:when>
                            <c:when test="${not empty sessionScope.adminUser.displayName}">
                                ${sessionScope.adminUser.displayName}
                                <span class="admin-indicator" style="display:none;"></span>
                            </c:when>
                            <c:otherwise>
                                Guest
                            </c:otherwise>
                        </c:choose>
                    </span> - <span style="color: #16a34a; font-weight: 500">Welcome to FSkills</span>
                </p>
            </div>
        </div>

        <c:if test="${empty sessionScope.user}">
            <div class="auth-buttons" style="display: flex; gap: 10px; margin-left: 20px;">
                <a href="${pageContext.request.contextPath}/login" style="text-decoration: none; color: #475569; font-weight: 600; transition: color 0.3s ease; padding: 8px 12px; white-space: nowrap;">Log In</a>
                <a href="${pageContext.request.contextPath}/signup.jsp" style="text-decoration: none; background-color: #0284c7; color: white; font-weight: 600; padding: 8px 16px; border-radius: 20px; transition: background-color 0.3s ease; white-space: nowrap; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">Sign Up</a>
            </div>
        </c:if>
    </div>
</header>

<style>
    @keyframes scroll {
        0% { transform: translateX(-100%); }
        100% { transform: translateX(0); }
    }

    @media (min-width: 640px) {
        .user-name {
            font-size: 1rem !important;
        }
        .scrolling-text p {
            font-size: 1rem;
        }
    }

    /* Spacing for content below header */
    .main, 
    .main-content, 
    .admin-content, 
    .profile-edit-container {
        margin-top: 60px !important; /* Same as profile page */
        padding-top: 20px !important; /* Additional padding for better spacing */
    }

    /* Instructor and learner role specific spacing */
    body.instructor-role .main,
    body.instructor-role .main-content,
    body.instructor-role .profile-edit-container,
    body.learner-role .main,
    body.learner-role .main-content,
    body.learner-role .profile-edit-container {
        margin-top: 60px !important; /* Same as profile page */
    }

    /* Admin role specific spacing */
    body.admin-role .main,
    body.admin-role .main-content,
    body.admin-role .admin-content,
    main.flex-grow {
        margin-top: 60px !important; /* Same as profile page */
    }

    /* Responsive adjustments for smaller screens */
    @media (max-width: 768px) {
        header {
            left: 0 !important; /* Start with no left margin on small screens */
            width: calc(100% - 16px) !important; /* Full width minus margins */
        }
    }
</style>