<%@page import="model.Degree" %>
<%@page import="java.util.List" %>
<%@page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="login"/>
</c:if>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Quản Trị F-SKILL</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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

        <div class="flex flex-grow">
            <jsp:include page="/layout/sidebar_admin.jsp"/>
            <main class="flex-grow p-6 bg-[#DFEBF6] rounded-tl-lg overflow-y-auto">
                <!-- Degree Table Section -->
                <div class="bg-white p-4 rounded shadow-sm">
                    <c:choose>
                        <c:when test="${not empty listDegree}">
                            <div class="text-center my-4">
                                <h2 class="fw-bold text-uppercase text-primary border-bottom pb-2 d-inline-block">All
                                    Degree</h2>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-striped table-hover align-middle text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Link</th>
                                            <th>Submit Date</th>
                                            <th>Image</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="deg" items="${listDegree}">
                                            <tr>
                                                <td>${deg.degreeId}</td>
                                                <td>${deg.userId.displayName}</td>
                                                <td>
                                                    <a href="${deg.link}" target="_blank" rel="noopener noreferrer">
                                                        ${deg.link}
                                                    </a>
                                                </td>

                                                <td>
                                                    <fmt:formatDate value="${deg.submitDate}" pattern="HH:mm dd/MM/yyyy" />
                                                </td>

                                                <td>
                                                    <img src="${pageContext.request.contextPath}/${deg.image}" 
                                                         alt="Degree Image" 
                                                         class="rounded shadow-sm"
                                                         style="max-height: 80px; object-fit: cover; cursor: pointer;"
                                                         data-bs-toggle="modal" 
                                                         data-bs-target="#zoomImageModal${deg.degreeId}" 
                                                         loading="lazy" />
                                                </td>

                                                <td class="py-3 px-4 border-b">
                                                    <c:choose>
                                                        <c:when test="${deg.status == 0}">
                                                            <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Processing</span>
                                                        </c:when>
                                                        <c:when test="${deg.status == 1}">
                                                            <span class="badge bg-success px-3 py-2 rounded-pill">Accepted</span>
                                                        </c:when>
                                                        <c:when test="${deg.status == 2}">
                                                            <span class="badge bg-danger px-3 py-2 rounded-pill">Rejected</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>

                                                <td class="py-3 px-4 border-b text-center">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div class="d-flex gap-2">
                                                            <button class="btn btn-outline-info btn-sm" type="button"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#viewModal${deg.degreeId}">
                                                                <i class="fas fa-eye"></i>
                                                            </button>

                                                            <c:if test="${deg.status == 1 || deg.status == 2}">
                                                                <button class="btn btn-danger btn-sm trash" type="button"
                                                                        data-bs-toggle="modal"
                                                                        data-bs-target="#deleteModal${deg.degreeId}">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </c:if>
                                                        </div>

                                                        <c:if test="${deg.status == 0}">
                                                            <button class="btn btn-success btn-sm fw-bold px-3 shadow" type="button"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#approveModal${deg.degreeId}">
                                                                <i class="fas fa-check-circle me-1"></i> Approve
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning text-center">
                                No data found.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
        <c:forEach var="deg" items="${listDegree}"> 
            <!-- Delete Modal -->
            <div class="modal fade" id="deleteModal${deg.degreeId}" tabindex="-1" aria-labelledby="deleteModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteModalLabel">Confirm Delete Degree</h5>

                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="POST" action="${pageContext.request.contextPath}/admin/degree?action=delete">
                            <input type="hidden" name="action" value="delete">

                            <div class="modal-body">
                                <input type="hidden" name="id" value="${deg.degreeId}">
                                <p>Are you sure you want to delete this degree?</p>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Back</button>
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <script>
                document.addEventListener('click', function (event) {
                    const modals = document.querySelectorAll('.modal.show');

                    modals.forEach(function (modal) {
                        if (!modal.contains(event.target)) {
                            const modalInstance = bootstrap.Modal.getInstance(modal);
                            if (modalInstance) {
                                modalInstance.hide();
                            }
                        }
                    });
                });
            </script>

            <div class="modal fade" id="approveModal${deg.degreeId}" tabindex="-1" aria-labelledby="approveModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content shadow-lg rounded-4">
                        <div class="modal-header bg-primary text-white text-center">
                            <h5 class="modal-title" id="approveModalLabel">Approve Degree - ID: ${deg.degreeId}</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                        </div>
                        <form method="POST" action="${pageContext.request.contextPath}/admin/degree?action=approve" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="status" id="statusField${deg.degreeId}" value="">
                            <input type="hidden" name="userAvatar" value="${deg.userId.avatar}">
                            <input type="hidden" name="userId" value="${deg.userId.userId}">

                            <div class="modal-body">
                                <div class="mb-3 row">
                                    <div class="col-md-2">
                                        <label for="degreeId" class="form-label fw-bold">ID</label>
                                        <input type="text" class="form-control" name="degreeId" required readonly
                                               value="${deg.degreeId}">
                                    </div>
                                    <div class="col-md-10">
                                        <label for="degreeLink" class="form-label fw-bold">Link of Degree</label>
                                        <input type="text" class="form-control" name="degreeLink" required value="${deg.link}">
                                    </div>
                                </div>

                                <div class="col-md-12 mb-3">
                                    <label class="form-label fw-bold">Image</label>
                                    <div class="mt-2">
                                        <c:choose>
                                            <c:when test="${not empty deg.image}">
                                                <img src="${pageContext.request.contextPath}/${deg.image}" class="img-fluid rounded shadow-sm"
                                                     style="max-width: 300px; max-height: 300px; object-fit: cover; cursor: pointer;"
                                                     data-bs-toggle="modal" data-bs-target="#zoomImageModal${deg.degreeId}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <p>No image available</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-danger"
                                        onclick="submitFormWithStatus${deg.degreeId}(2)">Reject
                                </button>
                                <button type="button" class="btn btn-primary"
                                        onclick="submitFormWithStatus${deg.degreeId}(1)">Accept
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>


            <script>
                function submitFormWithStatus${deg.degreeId}(value) {
                    document.getElementById("statusField${deg.degreeId}").value = value;
                    document.querySelector("#approveModal${deg.degreeId} form").submit();
                }
            </script>

            <!-- View Detail Modal -->
            <div class="modal fade" id="viewModal${deg.degreeId}" tabindex="-1" aria-labelledby="viewModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content shadow-lg rounded-4">
                        <div class="modal-header bg-info text-white text-center">
                            <h5 class="modal-title" id="viewModalLabel">View Detail - ID: ${deg.degreeId}</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                        </div>

                        <div class="modal-body">
                            <div class="mb-3 row">
                                <div class="col-md-2">
                                    <label class="form-label fw-bold">ID</label>
                                    <input type="text" class="form-control" value="${deg.degreeId}" readonly>
                                </div>
                                <div class="col-md-10">
                                    <label class="form-label fw-bold">Link of Degree</label>
                                    <input type="text" class="form-control" value="${deg.link}" readonly>
                                </div>
                            </div>

                            <div class="col-md-12 mb-3">
                                <label class="form-label fw-bold">Current Image</label><br>

                                <c:choose>
                                    <c:when test="${not empty deg.image}">
                                        <!-- Image with Zoom Modal Trigger -->
                                        <img src="${pageContext.request.contextPath}/${deg.image}" alt="Image" class="img-fluid rounded shadow-sm"
                                             style="max-width: 300px; max-height: 300px; object-fit: cover; cursor: pointer;"
                                             data-bs-toggle="modal" data-bs-target="#zoomImageModal${deg.degreeId}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <p>No image available</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Zoom Image Modal -->
            <div class="modal fade" id="zoomImageModal${deg.degreeId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content bg-transparent border-0">
                        <div class="modal-body text-center">
                            <img src="${pageContext.request.contextPath}/${deg.image}" alt="Zoomed Image" class="img-fluid rounded shadow"
                                 style="max-height: 90vh;">
                        </div>
                    </div>
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

            </script>
        </c:forEach>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    </body>
</html>