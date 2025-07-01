<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<header class="header bg-white shadow-md p-4 rounded-b-lg">
    <div class="flex items-center justify-between">
        <%--        <div class="w-1/4">--%>
        <%--            --%>
        <%--        </div>--%>

        <div class="flex-grow flex justify-center">
            <div class="relative w-full max-w-xl">
                <input type="text" placeholder="Tìm kiếm..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500">
                <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
        </div>

        <div class="flex items-center space-x-4 w-1/4 justify-end">
            <div class="relative cursor-pointer" id="notification-bell">
                <i class="fas fa-bell text-gray-600 text-xl"></i>
                <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center">3</span>
                <div id="notification-popup" class="hidden absolute right-0 mt-2 w-72 bg-white border border-gray-200 rounded-lg shadow-lg z-10">
                    <div class="p-4 border-b border-gray-200 font-semibold text-gray-800">Thông báo mới</div>
                    <ul class="divide-y divide-gray-100">
                        <li class="p-3 hover:bg-gray-50 cursor-pointer">
                            <p class="text-sm font-medium text-gray-900">Thông báo 1: Đã có hóa đơn mới.</p>
                            <p class="text-xs text-gray-500">2 giờ trước</p>
                        </li>
                        <li class="p-3 hover:bg-gray-50 cursor-pointer">
                            <p class="text-sm font-medium text-gray-900">Thông báo 2: Cập nhật hệ thống.</p>
                            <p class="text-xs text-gray-500">Hôm qua</p>
                        </li>
                        <li class="p-3 hover:bg-gray-50 cursor-pointer">
                            <p class="text-sm font-medium text-gray-900">Thông báo 3: Lịch họp sắp tới.</p>
                            <p class="text-xs text-gray-500">3 ngày trước</p>
                        </li>
                    </ul>
                    <div class="p-3 text-center border-t border-gray-200">
                        <a href="#" class="text-blue-600 text-sm hover:underline">Xem tất cả</a>
                    </div>
                </div>
            </div>
            <%-- Phần user profile/avatar --%>
            <div class="flex items-center space-x-2">
                <div class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 text-sm font-semibold">
                    <%-- Display user avatar if available --%>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.avatar}">
                            <img src="${sessionScope.user.imageDataURI}" alt="User Avatar" class="w-8 h-8 rounded-full">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <%-- Display user name from session --%>
                <span class="font-medium text-gray-700">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.displayName}">
                            ${sessionScope.user.displayName}
                        </c:when>
                        <c:otherwise>
                            Instructor
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
    </div>
</header>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const notificationBell = document.getElementById('notification-bell');
        const notificationPopup = document.getElementById('notification-popup');

        notificationBell.addEventListener('click', function(event) {
            event.stopPropagation(); // Ngăn sự kiện click lan ra ngoài
            notificationPopup.classList.toggle('hidden');
        });

        // Close popup when clicking outside
        document.addEventListener('click', function(event) {
            if (!notificationBell.contains(event.target) && !notificationPopup.contains(event.target)) {
                notificationPopup.classList.add('hidden');
            }
        });
    });
</script>
