<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

<div class="sidebar">
  <div class="sidebar-content">
    <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="logo-link">
      <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class="logo-img">
    </a>


    <!-- Navigation Links -->
    <nav class="sidebar-nav">
      <c:if test="${sessionScope.user.role eq 'LEARNER'}">
        <a href="${pageContext.request.contextPath}/homePage_Guest.jsp"><i class="bi bi-house-door"></i> <span>Home</span></a>
        <a href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="bi bi-book"></i> <span>All Courses</span></a>
        <a href="#"><i class="bi bi-mortarboard"></i> <span>My Courses</span></a>
        <a href="#"><i class="bi bi-cart"></i> <span>Cart</span></a>

        <a href="${pageContext.request.contextPath}/announcements"><i class="bi bi-megaphone"></i> <span>Announcements</span></a>
        <a href="${pageContext.request.contextPath}/feedback"><i class="bi bi-chat-dots"></i> <span>Feedback</span></a>
        <div class="divider"></div>
        <a href="${pageContext.request.contextPath}/learner/profile" class="user-profile">
          <c:choose>
            <c:when test="${not empty sessionScope.user.avatar}">
              <img src="${sessionScope.user.imageDataURI}" alt="User Avatar" class="avatar-img small-avatar">
            </c:when>
            <c:otherwise>
              <img src="https://placehold.co/80x80/cccccc/333333?text=User" alt="Default Avatar" class="avatar-img small-avatar">
            </c:otherwise>
          </c:choose>
          <span class="user-profile-name">${sessionScope.user.displayName}</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
      </c:if>

      <c:if test="${sessionScope.user.role eq 'INSTRUCTOR'}">
        <a href="${pageContext.request.contextPath}/instructor"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="${pageContext.request.contextPath}/instructor/courses?action=list"><i class="bi bi-laptop"></i> <span>Manage Courses</span></a>
        <a href="analytics.jsp"><i class="bi bi-graph-up"></i> <span>Analytics</span></a>
        <a href="${pageContext.request.contextPath}/feedback"><i class="bi bi-chat-dots"></i> <span>Feedback</span></a>
        <a href="${pageContext.request.contextPath}/announcements"><i class="bi bi-megaphone"></i> <span>Announcements</span></a>

        <div class="divider"></div>
        <a href="${pageContext.request.contextPath}/instructor/profile" class="user-profile">
          <c:choose>
            <c:when test="${not empty sessionScope.user.avatar}">
              <img src="${sessionScope.user.imageDataURI}" alt="User Avatar" class="avatar-img small-avatar">
            </c:when>
            <c:otherwise>
              <img src="https://placehold.co/80x80/cccccc/333333?text=User" alt="Default Avatar" class="avatar-img small-avatar">
            </c:otherwise>
          </c:choose>
          <span class="user-profile-name">${sessionScope.user.displayName}</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
      </c:if>

      <c:if test="${empty sessionScope.user.role}">
        <a href="${pageContext.request.contextPath}/homePage_Guest.jsp"><i class="bi bi-house-door"></i> <span>Home</span></a>
        <a href="${pageContext.request.contextPath}/AllCourses.jsp"><i class="bi bi-book"></i> <span>All Courses</span></a>

        <a href="${pageContext.request.contextPath}/announcements"><i class="bi bi-megaphone"></i> <span>Announcements</span></a>

        <div class="divider"></div>
        <c:if test="${not empty sessionScope.user}">
          <a href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
        </c:if>
      </c:if>
    </nav>
  </div>
</div>