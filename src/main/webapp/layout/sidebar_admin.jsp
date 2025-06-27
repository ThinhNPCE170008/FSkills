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
      <c:if test="${sessionScope.user.role eq 'ADMIN'}">
        <a href="${pageContext.request.contextPath}/admin"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="${pageContext.request.contextPath}/bills"><i class="bi bi-receipt"></i> <span>Bills</span></a>
        <a href="${pageContext.request.contextPath}/voucherList"><i class="bi bi-ticket-perforated"></i> <span>Voucher</span></a>
        <a href="${pageContext.request.contextPath}/admin/announcement"><i class="bi bi-megaphone"></i> <span>Announcements</span></a>
        <a href="${pageContext.request.contextPath}/admin/degree"><i class="bi bi-mortarboard"></i> <span>Manage Degree</span></a>
        <a href="${pageContext.request.contextPath}/alluser"><i class="bi bi-people"></i> <span>Manage Accounts</span></a>
        <a href="${pageContext.request.contextPath}/report"><i class="bi bi-bar-chart"></i> <span>Report</span></a>
        <div class="divider"></div>
        <a href="${pageContext.request.contextPath}/editProfile" class="user-profile">
          <c:choose>
            <c:when test="${not empty sessionScope.user.avatar}">
              <img src="${pageContext.request.contextPath}/${sessionScope.user.avatar}" alt="Admin Avatar" class="avatar-img small-avatar">
            </c:when>
            <c:otherwise>
              <img src="https://placehold.co/80x80/cccccc/333333?text=Admin" alt="Default Admin Avatar" class="avatar-img small-avatar">
            </c:otherwise>
          </c:choose>
          <span class="user-profile-name">${sessionScope.user.displayName}</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
      </c:if>
    </nav>
  </div>
</div>
