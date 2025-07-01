<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<header class="header bg-white shadow-md p-4 rounded-b-lg">
    <div class="flex items-center justify-between">
        <div class="w-1/4">
            <!-- Logo removed as per requirement -->
        </div>

        <div class="flex-grow flex justify-center">
            <div class="relative w-full max-w-xl">
                <input type="text" placeholder="Tìm kiếm..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500">
                <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
        </div>

        <div class="flex items-center space-x-4 w-1/4 justify-end">
            <!-- Container bell và popup -->
            <div class="relative z-50" id="notification-bell-container">

                <!-- Đếm số lượng chưa đọc -->
                <c:set var="unreadCount" value="0" />
                <c:forEach var="noti" items="${sessionScope.listNotification}">
                    <c:if test="${not noti.status}">
                        <c:set var="unreadCount" value="${unreadCount + 1}" />
                    </c:if>
                </c:forEach>

                <!-- Icon chuông -->
                <button id="notification-bell" class="relative focus:outline-none">
                    <i class="fas fa-bell text-gray-700 text-xl"></i>
                    <c:if test="${unreadCount > 0}">
                        <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center">
                            ${unreadCount}
                        </span>
                    </c:if>
                </button>

                <!-- Popup thông báo -->
                <div id="notification-popup" class="hidden absolute right-0 mt-3 w-[380px] bg-white border border-gray-200 rounded-xl shadow-xl z-50">

                    <div class="flex justify-between items-center px-4 py-3 border-b">
                        <h3 class="font-semibold text-gray-800 text-base">Notification</h3>

                    </div>

                    <!-- Danh sách thông báo -->
                    <div id="notification-list" class="max-h-[400px] overflow-y-auto divide-y divide-gray-100">
                        <c:forEach var="noti" items="${sessionScope.listNotification}">
                            <div class="notification-item" id="noti-${noti.notificationId}">

                                <div class="flex items-start gap-3 px-4 py-3 hover:bg-gray-100 cursor-pointer notification-item
                                     <c:if test='${noti.status}'>opacity-50 text-gray-400</c:if>'
                                     id="noti-${noti.notificationId}"
                                     data-id="${noti.notificationId}"
                                     onclick="markAsRead('${noti.notificationId}')">

                                    <!-- Ảnh đại diện -->
                                    <img src="${noti.userName.imageDataURI}" class="w-10 h-10 rounded-full object-cover flex-shrink-0" alt="avatar" />

                                    <!-- Nội dung thông báo -->
                                    <div class="flex-1 text-sm">
                                        <p>
                                            <span class="font-semibold">${noti.userName.userName}</span>
                                            ${noti.notificationMessage}
                                        </p>
                                        <p class="text-xs text-gray-500 mt-1">
                                            <fmt:formatDate value="${noti.notificationDate}" pattern="HH:mm dd/MM/yyyy" />
                                        </p>
                                    </div>

                                    <!-- Dấu chấm xanh nếu chưa đọc -->
                                    <c:if test="${not noti.status}">
                                        <div class="mt-2 w-2 h-2 bg-blue-500 rounded-full"></div>
                                    </c:if>
                                </div>


                                <!-- Trường ẩn để lưu status -->
                                <input type="hidden" id="statusField${noti.notificationId}" name="status" value="${noti.status}" />
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Footer -->
                    <div class="text-center border-t py-3">
                        <button class="text-sm text-gray-600 hover:bg-gray-200 px-4 py-1 rounded-md">
                            Xem thông báo trước đó
                        </button>
                    </div>
                </div>
            </div>
            <script>
                function markAsRead(id) {
                    // Gửi request cập nhật server
                    fetch('notification', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: 'id=' + encodeURIComponent(id)
                    }).then(response => {
                        if (response.ok) {
                            // Cập nhật UI sau khi server xác nhận đã lưu
                            const input = document.getElementById("statusField" + id);
                            const item = document.getElementById("noti-" + id);

                            if (input)
                                input.value = true;
                            if (item) {
                                item.classList.add("opacity-50", "text-gray-400");
                                const dot = item.querySelector(".bg-blue-500");
                                if (dot)
                                    dot.remove();
                            }
                        }
                    });
                }
            </script>
            <%-- Phần user profile/avatar --%>
            <div class="flex items-center space-x-2">
                <div class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 text-sm font-semibold">
                    <%-- Display user avatar if available --%>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.avatar}">
                            <img src="${sessionScope.user.avatar}" alt="User Avatar" class="w-8 h-8 rounded-full">
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
    document.addEventListener('DOMContentLoaded', function () {
        const notificationBell = document.getElementById('notification-bell');
        const notificationPopup = document.getElementById('notification-popup');

        notificationBell.addEventListener('click', function () {
            notificationPopup.classList.toggle('hidden');
        });

        // Close popup when clicking outside
        document.addEventListener('click', function (event) {
            if (!notificationBell.contains(event.target) && !notificationPopup.contains(event.target)) {
                notificationPopup.classList.add('hidden');
            }
        });
    });
</script>