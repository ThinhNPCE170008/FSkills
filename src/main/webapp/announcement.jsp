<%-- 
    Document   : announcement
    Created on : Jun 3, 2025, 2:48:10 PM
    Author     : Duykh
--%>

<%@page import="model.Announcement"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DdOCTYPE html>
<%
    List<Announcement> listAnnouncement = (List<Announcement>) request.getAttribute("listAnnouncement");
%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
        <title>Admin F-SKILL</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
            }
        </style>
    </head>
    <body class="flex flex-col h-screen">
        <header class="bg-white shadow-md p-4 flex items-center justify-between rounded-b-lg">
            <div class="flex items-center space-x-2">
                <img src="pic/logo.png" alt="F-SKILL Logo" class=" w-20 h-15" />
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

            </div>
        </header>

        <div class="flex flex-grow">
            <aside class="w-64 bg-white p-4 shadow-lg flex flex-col rounded-tr-lg rounded-br-lg overflow-y-auto">
                <div class="flex items-center space-x-3 mb-8 p-2">
                    <div class="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center text-gray-500 text-xl font-semibold">
                    </div>
                    <div>
                        <p class="font-semibold text-gray-800">Gavano</p>
                        <p class="text-sm text-gray-500">Hi Admin</p>
                    </div>
                </div>

                <nav class="flex-grow">
                    <ul>
                        <li class="mb-2">
                            <a href="#" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-tachometer-alt nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Dashboard</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="#" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-file-invoice-dollar nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Bills</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="#" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-bullhorn nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Announcement</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="#" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-building nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Company</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="#" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-users-cog nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Manage Account</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="#" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-chart-line nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Report</span>
                            </a>
                        </li>
                    </ul>
                </nav>

                <div class="mt-auto">
                    <ul>
                        <li class="mb-2">
                            <a href="#" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-user-circle nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Profile</span>
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="#" class="nav-item flex items-center p-3 rounded-lg transition-all duration-200 hover:bg-gray-900 group">
                                <i class="fas fa-cog nav-icon text-gray-600 mr-3 text-lg group-hover:text-white"></i>
                                <span class="nav-text text-gray-800 font-medium group-hover:text-white">Setting</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </aside>

            <main class="flex-grow p-6 bg-[#DFEBF6] rounded-tl-lg overflow-y-auto">
                <div class="bg-white p-6 rounded shadow-sm">
                    <div class="col-sm-2">
                        <button type="button" class="btn btn-add btn-sm" onclick="showCreateAnnouncementPopup()">
                            <i class="fas fa-plus"></i> Tạo mới
                        </button>
                    </div>

                    <%
                        if (listAnnouncement != null && !listAnnouncement.isEmpty()) {
                    %>
                    <div class="overflow-x-auto">
                        <table class="min-w-full bg-white border border-gray-200 text-sm text-gray-800">
                            <thead class="bg-gray-100 text-gray-600 uppercase text-xs">
                                <tr>
                                    <th class="py-3 px-4 border-b text-center">#ID</th>
                                    <th class="py-3 px-4 border-b text-left">Title</th>
                                    <th class="py-3 px-4 border-b text-left">Created At</th>
                                    <th class="py-3 px-4 border-b text-left">Created By</th>
                                    <th class="py-3 px-4 border-b text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Announcement ann : listAnnouncement) {
                                %>
                                <tr class="hover:bg-gray-50">
                                    <td class="py-3 px-4 border-b text-center"><%= ann.getAnnoucementID()%></td>
                                    <td class="py-3 px-4 border-b"><%= ann.getTitle()%></td>
                                    <td class="py-3 px-4 border-b"><%= ann.getCreateDate()%></td>
                                    <td class="py-3 px-4 border-b"><%= ann.getUserId().getDisplayName()%></td>
                                    <td class="py-3 px-4 border-b text-center">
                                        <a href="#" class="btn btn-sm btn-primary me-1" title="Edit">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a href="#" class="btn btn-sm btn-danger me-1" title="Delete">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                        <a href="#" class="btn btn-sm btn-info" title="Detail">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <%
                    } else {
                    %>
                    <div class="bg-yellow-100 border border-yellow-300 text-yellow-800 px-4 py-3 rounded text-center">
                        No data found.
                    </div>
                    <%
                        }
                    %>
                </div>
            </main>
        </div>

        <div class="overlay" id="overlay"></div>

        <div class="popup create-announcement-popup" id="createAnnouncementPopup">
            <h4>Create Announcement</h4>
            <input type="text" placeholder="Enter title..." id="announcementTitle" class="popup-input" />
            <textarea placeholder="Enter content..." id="announcementContent" class="popup-textarea"></textarea>
            <div class="popup-buttons">
                <button class="popup-back-btn" onclick="closeCreateAnnouncementPopup()">Cancel</button>
                <button class="send-btn" onclick="sendCreateAnnouncement()">Create</button>
            </div>
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

            function showOverlay() {
                document.getElementById('overlay').classList.add('active');
            }
            function hideOverlay() {
                document.getElementById('overlay').classList.remove('active');
            }

            function showCreateAnnouncementPopup() {
                document.getElementById('createAnnouncementPopup').classList.add('active');
                showOverlay();
            }

            function closeCreateAnnouncementPopup() {
                document.getElementById('createAnnouncementPopup').classList.remove('active');
                hideOverlay();
            }

            function sendCreateAnnouncement() {
                const title = document.getElementById('announcementTitle').value.trim();
                const content = document.getElementById('announcementContent').value.trim();

                if (title && content) {
                    alert("Announcement has been created successfully!");
                    closeCreateAnnouncementPopup();
                    // TODO: Gửi dữ liệu tới server bằng form submit hoặc AJAX
                } else {
                    alert("Please enter both title and content before creating announcement!");
                }
            }

        </script>
    </body>
</html>
