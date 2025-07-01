<%@page import="dao.AnnouncementDAO" %>
<%@page import="model.Announcement" %>
<%@page import="java.util.List" %>
<%@page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Quản Trị F-SKILL</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">


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

        <jsp:include page="/layout/header_admin.jsp" />

        <div class="flex flex-grow">
            <jsp:include page="/layout/sidebar_admin.jsp"/>

            <main class="flex-grow p-6 bg-[#DFEBF6] rounded-tl-lg overflow-y-auto">
                <div class="bg-white p-6 rounded shadow-sm">
                    <div class=" text-end">
                        <button type="button"
                                class="btn btn-primary btn-lg shadow d-inline-flex align-items-center gap-2 px-4 py-2 rounded-pill"
                                data-bs-toggle="modal" data-bs-target="#createModal">
                            <i class="bi bi-plus-circle fs-5"></i>
                            <span class="fw-semibold">Submit</span>
                        </button>
                    </div>
                    <c:if test="${not empty listAnnouncement}">
                        <div class="overflow-x-auto">
                            <table class="min-w-full bg-white border border-gray-200 text-sm text-gray-800">
                                <thead class="bg-gray-100 text-gray-600 uppercase text-xs">
                                <div class="text-center my-4">
                                    <h2 class="fw-bold text-uppercase text-primary border-bottom pb-2 d-inline-block">
                                        All Announcement
                                    </h2>
                                </div>
                                <tr>
                                    <th class="py-3 px-4 border-b text-center">#ID</th>
                                    <th class="py-3 px-4 border-b text-left">Title</th>
                                    <th class="py-3 px-4 border-b text-left">Created At</th>
                                    <th class="py-3 px-4 border-b text-left">Image</th>
                                    <th class="py-3 px-4 border-b text-center">Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ann" items="${listAnnouncement}">
                                        <tr class="hover:bg-gray-50">
                                            <td class="py-3 px-4 border-b text-center">${ann.annoucementID}</td>
                                            <td class="py-3 px-4 border-b">
                                                <a href="${pageContext.request.contextPath}/admin/announcement?action=details&id=${ann.annoucementID}" class="text-decoration-none fw-semibold text-primary">
                                                    ${ann.title}
                                                </a>
                                            </td>
                                            <td class="py-3 px-4 border-b">
                                                <fmt:formatDate value="${ann.createDate}" pattern="HH:mm dd/MM/yyyy"/>
                                            </td>
                                            <td style="text-align: center; vertical-align: middle;">
                                                <c:choose>
                                                    <c:when test="${empty ann.imageDataURI}">
                                                        <span class="text-muted fst-italic">No Image</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="#" data-bs-toggle="modal" data-bs-target="#zoomImageModal${ann.annoucementID}">
                                                            <img src="${ann.imageDataURI}"
                                                                 class="rounded-3 shadow d-block mx-auto"
                                                                 style="max-height: 80px; object-fit: cover; cursor: zoom-in;" />
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="py-3 px-4 border-b text-center">
                                                <div class="d-flex justify-content-center gap-2">
                                                    <button class="btn btn-primary btn-sm edit" type="button"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#editModal${ann.annoucementID}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-danger btn-sm trash" type="button"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#deleteModal${ann.annoucementID}">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/admin/announcement?action=details&id=${ann.annoucementID}"
                                                       class="btn btn-outline-info btn-sm" title="View Details">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <c:if test="${empty listAnnouncement}">
                        <div class="bg-yellow-100 border border-yellow-300 text-yellow-800 px-4 py-3 rounded text-center">
                            No data found.
                        </div>
                    </c:if>
                </div>
            </main>
        </div>
        <!-- Create Modal -->
        <div class="modal fade" id="createModal" tabindex="-1" aria-labelledby="createModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg"> <!-- rộng hơn -->
                <div class="modal-content shadow-lg rounded-4">

                    <div class="modal-header bg-primary text-white text-center">
                        <h5 class="modal-title" id="createModalLabel">Create New Announcement</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/admin/announcement?action=create" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="create">
                        <!-- Lấy userId từ session -->
                        <c:if test="${not empty sessionScope.user}">
                            <input type="hidden" name="userId" value="${sessionScope.user.userId}">
                        </c:if>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="announcementTitle" class="form-label fw-bold">Title</label>
                                <input type="text" class="form-control" id="announcementTitle" name="announcementTitle"
                                       placeholder="Enter title..." required>
                            </div>
                            <input type="hidden" name="takeDownDate" value="2099-12-31T12:59">
                            <div class="row">
                                <div class="mb-3">
                                    <label for="announcementImage" class="form-label fw-bold">Image</label>
                                    <input type="file"
                                           class="form-control"
                                           id="announcementImage"
                                           name="announcementImage"
                                           accept="image/*"
                                           onchange="previewImg(event)">

                                    <!-- Đây là ảnh preview nằm ngay sau input -->
                                    <img id="imgPreview" class="mt-2 rounded shadow" style="max-height: 200px; display: none;" alt="Preview">
                                </div>

                            </div>
                            <div class="mb-3">
                                <label for="announcementText" class="form-label fw-bold">Content</label>
                                <textarea class="form-control" id="announcementText" name="announcementText"
                                          placeholder="Enter content of announcement..." rows="8" style="resize: vertical;"
                                          required></textarea>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Create</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
        <script>
            function previewImg(event) {
                const preview = document.getElementById('imgPreview');
                const file = event.target.files[0];

                if (file && preview) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                }
            }
        </script>


        <c:forEach var="ann" items="${listAnnouncement}">
            <!-- Edit Modal -->
            <div class="modal fade" id="editModal${ann.annoucementID}" tabindex="-1" aria-labelledby="editModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content shadow-lg rounded-4">
                        <div class="modal-header bg-primary text-white text-center">
                            <h5 class="modal-title" id="editModalLabel">Edit Announcement</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                        </div>

                        <form method="POST" action="${pageContext.request.contextPath}/admin/announcement?action=edit" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="edit">

                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="announcementId" class="form-label fw-bold">ID</label>
                                    <input type="text" class="form-control" id="announcementId" name="announcementId"
                                           required value="${ann.annoucementID}" readonly>
                                </div>
                                <div class="mb-3">
                                    <label for="announcementTitle" class="form-label fw-bold">Title</label>
                                    <input type="text" class="form-control" id="announcementTitle" name="announcementTitle"
                                           required value="${ann.title}">
                                </div>
                                <input type="hidden" name="takeDownDate" value="2099-12-31T12:59">
                                <input type="hidden" name="deleteImage" id="deleteImage${ann.annoucementID}" value="false" />
                                <input type="hidden" name="keepOldImage" id="keepOldImage${ann.annoucementID}" value="true" />
                                <div class="col-md-6 mb-3">
                                    <label for="announcementImage" class="form-label fw-bold">Image</label>
                                    <input type="file"
                                           class="form-control"
                                           id="announcementImage${ann.annoucementID}"
                                           name="announcementImage"
                                           accept="image/*"
                                           onchange="previewImage(event, '${ann.annoucementID}')" />

                                    <c:if test="${not empty ann.imageDataURI}">
                                        <div class="mt-2 position-relative" id="currentImageDiv${ann.annoucementID}">
                                            <label class="form-label fw-bold">Current Image</label><br>
                                            <img src="${ann.imageDataURI}" alt="Current Image" class="img-fluid rounded"
                                                 style="max-width: 200px; max-height: 200px; object-fit: cover;" />
                                            <button type="button"
                                                    class="btn btn-sm btn-danger rounded-circle d-flex justify-content-center align-items-center"
                                                    onclick="removeCurrentImage('${ann.annoucementID}')"
                                                    style="position: absolute;
                                                    top: 20px;
                                                    right: 5px;
                                                    left: 185px;
                                                    width: 25px;
                                                    height: 25px;
                                                    padding: 0;
                                                    font-size: 16px;
                                                    line-height: 1;
                                                    z-index: 10;
                                                    box-shadow: 0 0 4px rgba(0,0,0,0.2);">
                                                &times;
                                            </button>

                                        </div>
                                    </c:if>

                                    <div class="mt-2">
                                        <label class="form-label fw-bold">Image Preview</label><br>
                                        <img id="imagePreview${ann.annoucementID}" class="img-fluid rounded"
                                             style="max-width: 200px; max-height: 200px; object-fit: cover; display: none;" />
                                    </div>
                                </div>



                                <div class="mb-3">
                                    <label for="announcementText" class="form-label fw-bold">Content</label>
                                    <textarea class="form-control" id="announcementText" name="announcementText"
                                              rows="8" style="resize: vertical;" required>${ann.announcementText}</textarea>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">Edit</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- JavaScript for image preview -->
            <script>
                function removeCurrentImage(id) {
                    const div = document.getElementById("currentImageDiv" + id);
                    const inputDelete = document.getElementById("deleteImage" + id);
                    const inputKeep = document.getElementById("keepOldImage" + id); // Thêm dòng này

                    if (div)
                        div.style.display = "none";
                    if (inputDelete)
                        inputDelete.value = "true";
                    if (inputKeep)
                        inputKeep.value = "false"; // Cực kỳ quan trọng: cho servlet biết là không giữ ảnh
                }

                function previewImage(event, id) {
                    const input = event.target;
                    const preview = document.getElementById("imagePreview" + id);
                    const currentImageDiv = document.getElementById("currentImageDiv" + id);

                    if (input.files && input.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            preview.src = e.target.result;
                            preview.style.display = "block";
                            if (currentImageDiv)
                                currentImageDiv.style.display = "none";
                        };
                        reader.readAsDataURL(input.files[0]);
                    } else {
                        preview.style.display = "none";
                        if (currentImageDiv)
                            currentImageDiv.style.display = "block";
                    }
                }
                document.getElementById("announcementImage${ann.annoucementID}").addEventListener("change", function (event) {
                    const preview = document.getElementById("imagePreview${ann.annoucementID}");
                    const currentImageDiv = document.getElementById("currentImageDiv${ann.annoucementID}"); // Sử dụng ID cụ thể
                    const file = event.target.files[0];

                    if (file) {
                        preview.src = URL.createObjectURL(file);
                        preview.style.display = "block";
                        if (currentImageDiv) {
                            currentImageDiv.style.display = "none"; // Ẩn ảnh hiện tại
                        }
                    } else {
                        preview.style.display = "none";
                        if (currentImageDiv) {
                            currentImageDiv.style.display = "block"; // Hiển thị ảnh hiện tại nếu không có ảnh mới
                        }
                    }
                });
            </script>

            <!-- Delete Modal -->
            <div class="modal fade" id="deleteModal${ann.annoucementID}" tabindex="-1" aria-labelledby="deleteModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteModalLabel">Confirm Delete Announcement</h5>

                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="POST" action="${pageContext.request.contextPath}/admin/announcement?action=delete">
                            <input type="hidden" name="action" value="delete">

                            <div class="modal-body">
                                <input type="hidden" name="id" value="${ann.annoucementID}">
                                <p>Are you sure you want to delete this announcement?</p>
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
            <!-- Zoom Image Modal -->
            <c:if test="${ann.announcementImage != 'No Image'}">
                <div class="modal fade" id="zoomImageModal${ann.annoucementID}" tabindex="-1" aria-labelledby="zoomImageModalLabel${ann.annoucementID}" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content border-0 shadow-lg rounded-4">
                            <div class="modal-header border-0">
                                <h5 class="modal-title" id="zoomImageModalLabel${ann.annoucementID}">Image Preview</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body d-flex justify-content-center">
                                <img src="${ann.imageDataURI}" alt="Zoomed Image" class="img-fluid rounded shadow" style="max-height: 600px; object-fit: contain;">
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:forEach>
        <jsp:include page="/layout/toast.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    </body>
</html>
