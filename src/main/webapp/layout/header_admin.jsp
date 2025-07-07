<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<header class="bg-white shadow-md p-4 rounded-b-lg">
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
           
            <%-- Phần user profile/avatar --%>
            <div class="flex items-center space-x-2">
                <div class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 text-sm font-semibold">
                    <%-- Bạn có thể hiển thị ảnh đại diện admin ở đây nếu có --%>
                    AD
                </div>
                <%-- Hiển thị tên Admin từ session --%>
                <span class="font-medium text-gray-700">
                    <c:choose>
                        <c:when test="${not empty sessionScope.adminUser.displayName}">
                            ${sessionScope.adminUser.displayName}
                        </c:when>
                        <c:otherwise>
                            Admin User
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
    </div>
</header>