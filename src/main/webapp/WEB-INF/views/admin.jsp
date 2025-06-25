<%-- 
    Document   : admin
    Created on : May 25, 2025, 12:58:45 PM
    Author     : DELL
--%>

<%@page import="model.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%
    User acc = (User) session.getAttribute("user");
    if (acc == null) {
        response.sendRedirect("login");
        return;
    }
%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Quản Trị F-SKILL</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css"/>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f0f2f5; /* Màu nền tổng thể */
            }
            /* Hiệu ứng hover cho các mục menu */
            .nav-item:hover .nav-icon,
            .nav-item:hover .nav-text {
                color: white; /* Đảo ngược màu chữ và icon thành trắng khi hover */
            }
            .nav-item:hover {
                background-color: #000; /* Đổi màu nền thành đen khi hover */
            }
            /* Style cho thanh cuộn */
            ::-webkit-scrollbar {
                width: 8px;
            }
            ::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 10px;
            }
            ::-webkit-scrollbar-thumb {
                background: #888;
                border-radius: 10px;
            }
            ::-webkit-scrollbar-thumb:hover {
                background: #555;
                border-radius: 10px;
            }
        </style>
    </head>
    <body class="flex flex-col h-screen">
        <header class="bg-white shadow-md p-4 flex items-center justify-between rounded-b-lg">
            <div class="flex items-center space-x-2">
                <%-- Đã sửa đường dẫn ảnh logo.png --%>
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="F-SKILL Logo" class=" w-20 h-15" />
                <span class="text-2xl font-bold text-gray-800"></span>
            </div>

            <div class="relative flex-grow mx-4 max-w-md">
                <input type="text" placeholder="Tìm kiếm..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500">
                <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>

            <div class="flex items-center space-x-4">
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
        </header>

        <div class="flex flex-grow">
            <aside class="w-64 bg-white p-4 shadow-lg flex flex-col rounded-tr-lg rounded-br-lg overflow-y-auto">
                <div class="flex items-center space-x-3 mb-8 p-2">
                    <div class="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 text-xl font-semibold">
                        <%-- Có thể đặt ảnh đại diện admin tại đây --%>
                    </div>
                    <div>
                        <%-- Hiển thị tên người dùng đã đăng nhập, ví dụ từ session --%>
                        <p class="font-semibold text-gray-800">
                            <%=acc.getDisplayName()%>
                        </p>
                        <p class="text-sm text-gray-500">Hi Admin</p>
                    </div>
                </div>

                <nav class="flex-grow">
                    <ul>
                        <li class="mb-2">
                            <%-- Thêm URL cho Dashboard --%>
                            <a href="${pageContext.request.contextPath}/admin" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-tachometer-alt nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Dashboard</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <%-- Liên kết đến trang quản lý Bills --%>
                            <a href="${pageContext.request.contextPath}/admin/bills" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-file-invoice-dollar nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Bills</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <%-- Liên kết đến trang quản lý Announcement --%>
                            <a href="${pageContext.request.contextPath}/admin/announcement" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-bullhorn nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Announcement</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <%-- Liên kết đến trang quản lý Course --%>
                            <a href="${pageContext.request.contextPath}/admin/degree" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-file-invoice-dollar nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Manage Degrees</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <%-- Liên kết đến trang quản lý Company --%>
                            <a href="${pageContext.request.contextPath}/voucherList" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-building nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Company</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <%-- Liên kết đến trang Manage Account --%>
                            <a href="${pageContext.request.contextPath}/alluser" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-users-cog nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Manage Account</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <%-- Liên kết đến trang Report --%>
                            <a href="${pageContext.request.contextPath}/admin/reports" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-chart-line nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Report</span>
                            </a>
                        </li>
                    </ul>
                </nav>

                <div class="mt-auto">
                    <ul>
                        <li class="mb-2">
                            <%-- Liên kết đến trang Profile --%>
                            <a href="${pageContext.request.contextPath}/learner/profile" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-user-circle nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Profile</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <%-- Liên kết đến trang Setting --%>
                            <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-cog nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Setting</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <%-- Liên kết đăng xuất --%>
                            <a href="${pageContext.request.contextPath}/logout" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-sign-out-alt nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Đăng xuất</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </aside>

            <main class="flex-grow p-6 bg-[#DFEBF6] rounded-tl-lg overflow-y-auto">
                <div class="bg-white p-6 rounded-lg shadow-md">
                    <h2 class="text-xl font-semibold mb-4 text-gray-800">Tạo Thông Báo Công Khai</h2>
                    <div class="flex items-center space-x-4 mb-4">
                        <input type="text" placeholder="Viết một thông báo công khai..." class="flex-grow p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <button class="bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors duration-200">
                            Tạo
                        </button>
                        <button id="upload-file-btn" class="bg-gray-200 text-gray-700 px-4 py-3 rounded-lg font-semibold hover:bg-gray-300 transition-colors duration-200">
                            <i class="fas fa-plus"></i>
                        </button>
                        <input type="file" id="file-input" class="hidden">
                        <button id="upload-image-btn" class="bg-gray-200 text-gray-700 px-4 py-3 rounded-lg font-semibold hover:bg-gray-300 transition-colors duration-200">
                            <i class="fas fa-image"></i>
                        </button>
                        <input type="file" id="image-input" accept="image/*" class="hidden">
                    </div>
                    <div class="mt-8 p-4 bg-gray-50 border border-gray-200 rounded-lg text-gray-600">
                        <p>Chào mừng bạn đến với bảng điều khiển quản trị! Tại đây bạn có thể quản lý các hóa đơn, thông báo, tài khoản người dùng và xem báo cáo.</p>
                    </div>
                </div>
            </main>
        </div>

        <script>
            // Lấy các phần tử cần thiết
            const notificationBell = document.getElementById('notification-bell');
            const notificationPopup = document.getElementById('notification-popup');
            const uploadFileBtn = document.getElementById('upload-file-btn');
            const fileInput = document.getElementById('file-input');
            const uploadImageBtn = document.getElementById('upload-image-btn');
            const imageInput = document.getElementById('image-input');

            // Chuyển đổi trạng thái hiển thị popup thông báo khi click vào chuông
            notificationBell.addEventListener('click', (event) => {
                event.stopPropagation(); // Ngăn chặn sự kiện click lan truyền ra ngoài
                notificationPopup.classList.toggle('hidden');
            });

            // Ẩn popup thông báo khi click ra ngoài
            document.addEventListener('click', (event) => {
                if (!notificationBell.contains(event.target) && !notificationPopup.contains(event.target)) {
                    notificationPopup.classList.add('hidden');
                }
            });

            // Xử lý sự kiện click cho nút upload file (+)
            uploadFileBtn.addEventListener('click', () => {
                fileInput.click(); // Kích hoạt input file ẩn
            });

            // Xử lý sự kiện khi file được chọn
            fileInput.addEventListener('change', (event) => {
                const file = event.target.files[0];
                if (file) {
                    // Ở đây bạn có thể thêm logic để tải file lên server
                    console.log('Tệp đã chọn:', file.name);
                    // Hiển thị thông báo hoặc xử lý file
                    showMessage(`Đã chọn tệp: ${file.name}`);
                }
            });

            // Xử lý sự kiện click cho nút upload ảnh (biểu tượng ảnh)
            uploadImageBtn.addEventListener('click', () => {
                imageInput.click(); // Kích hoạt input ảnh ẩn
            });

            // Xử lý sự kiện khi ảnh được chọn
            imageInput.addEventListener('change', (event) => {
                const file = event.target.files[0];
                if (file) {
                    // Ở đây bạn có thể thêm logic để tải ảnh lên server
                    console.log('Ảnh đã chọn:', file.name);
                    // Hiển thị thông báo hoặc xử lý ảnh
                    showMessage(`Đã chọn ảnh: ${file.name}`);
                }
            });

            // Hàm hiển thị thông báo tùy chỉnh (thay thế alert)
            function showMessage(message) {
                const messageBox = document.createElement('div');
                messageBox.className = 'fixed bottom-4 right-4 bg-blue-600 text-white px-6 py-3 rounded-lg shadow-lg z-50 transition-opacity duration-300 ease-out';
                messageBox.textContent = message;
                document.body.appendChild(messageBox);

                setTimeout(() => {
                    messageBox.classList.add('opacity-0');
                    messageBox.addEventListener('transitionend', () => messageBox.remove());
                }, 3000); // Ẩn sau 3 giây
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>
