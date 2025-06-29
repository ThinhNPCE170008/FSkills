<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en" class="w-100">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Profile - F-Skills</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <style>

        </style>
    </head>
    <body class="w-100 m-0 p-0">
        
        <div class="profile-edit-container w-100 mt-20">
            <jsp:include page="/layout/sidebar_user.jsp"/>
            <!-- Degree Table Section -->
            <div class="bg-white p-4 rounded-4 shadow-lg">
                <!-- Nút Submit Luôn Hiển Thị -->
                <div class="text-end mb-4">
                    <button type="button"
                            class="btn btn-primary btn-lg shadow d-inline-flex align-items-center gap-2 px-4 py-2 rounded-pill"
                            data-bs-toggle="modal" data-bs-target="#createModal">
                        <i class="bi bi-plus-circle fs-5"></i>
                        <span class="fw-semibold">Submit</span>
                    </button>
                </div>
                <c:choose>
                    <c:when test="${not empty listDegree}">
                        <div class="text-center my-5">
                            <a href="${pageContext.request.contextPath}/instructor/profile"
                               class="btn btn-sucess btn-lg px-4 ms-2">
                                <i class="bi bi-back"></i> Back
                            </a>
                            <h2 class="fw-bold text-uppercase text-gradient bg-gradient mb-0 display-5">
                                Your Degree
                            </h2>
                            <div class="mx-auto mt-2"
                                 style="width: 80px; height: 4px; background-color: #0d6efd; border-radius: 5px;"></div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle text-center rounded-4 overflow-hidden shadow-sm">
                                <thead class="table-light">
                                    <tr class="align-middle">
                                        <th>ID</th>
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
                                            <td class="fw-semibold">${deg.degreeId}</td>
                                            <td>
                                                <a href="${deg.link}" target="_blank"
                                                   class="text-decoration-none text-primary fw-medium">
                                                    <i class="bi bi-link-45deg"></i> ${deg.link}
                                                </a>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${deg.submitDate}" pattern="HH:mm dd/MM/yyyy"/>
                                            </td>
                                            <td style="text-align: center; vertical-align: middle;">
                                                <c:choose>
                                                    <c:when test="${empty deg.imageDataURI}">
                                                        <span class="text-muted fst-italic">No Image</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="#" data-bs-toggle="modal" data-bs-target="#zoomImageModal${deg.degreeId}">
                                                            <img src="${deg.imageDataURI}"
                                                                 class="rounded-3 shadow d-block mx-auto"
                                                                 style="max-height: 80px; object-fit: cover; cursor: zoom-in;" />
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${deg.status == 0}">
                                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">
                                                            <i class="bi bi-clock-history me-1"></i>Processing
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${deg.status == 1}">
                                                        <span class="badge bg-success px-3 py-2 rounded-pill">
                                                            <i class="bi bi-check-circle-fill me-1"></i>Accepted
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger px-3 py-2 rounded-pill">
                                                            <i class="bi bi-x-circle-fill me-1"></i>Rejected
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-center gap-2">
                                                    <button class="btn btn-outline-info btn-sm" type="button"
                                                            data-bs-placement="top" title="View"
                                                            data-bs-target="#viewModal${deg.degreeId}" data-bs-toggle="modal">
                                                        <i class="fas fa-eye"></i>
                                                    </button>

                                                    <c:if test="${deg.status == 0}">
                                                        <button class="btn btn-primary btn-sm" type="button"
                                                                data-bs-placement="top" title="Edit"
                                                                data-bs-target="#editModal${deg.degreeId}" data-bs-toggle="modal">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                    </c:if>

                                                    <c:if test="${deg.status == 0 || deg.status == 2}">
                                                        <button class="btn btn-danger btn-sm" type="button"
                                                                data-bs-placement="top" title="Delete"
                                                                data-bs-target="#deleteModal${deg.degreeId}" data-bs-toggle="modal">
                                                            <i class="fas fa-trash-alt"></i>
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
                        <div class="alert alert-warning text-center fw-semibold fs-5 mt-4">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> No data found.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Create Modal -->

        <div class="modal fade" id="createModal" tabindex="-1" aria-labelledby="createModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content shadow-lg rounded-4">

                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="createModalLabel">New Submit Degree</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>

                    <form method="POST" action="${pageContext.request.contextPath}/instructor/profile/degree?action=create" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="create">
                        <c:if test="${not empty sessionScope.user}">
                            <input type="hidden" name="userId" value="${sessionScope.user.userId}">
                        </c:if>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="degreeLink" class="form-label fw-bold">Link of Degree</label>
                                <input type="text" class="form-control" id="degreeLink" name="degreeLink"
                                       required
                                       placeholder="Enter link..."
                                       pattern="https?://.+"
                                       title="Please enter a valid URL starting with http:// or https://"
                                       oninvalid="this.setCustomValidity('Please enter a valid URL starting with http://')"
                                       oninput="this.setCustomValidity('')">
                            </div>

                            <div class="row">
                                <div class="mb-3">
                                    <label for="degreeImage" class="form-label fw-bold">Image</label>
                                    <input type="file"
                                           class="form-control"
                                           id="degreeImage"
                                           name="degreeImage"
                                           accept="image/*"
                                           onchange="previewImg(event)">
                                    <img id="imgPreview" class="mt-2 rounded shadow" style="max-height: 200px; display: none;" alt="Preview">
                                </div>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
    <img id="previewImage" class="img-thumbnail mt-2" style="max-height: 200px;"/>
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
    <!-- Edit Modal -->
    <c:forEach var="deg" items="${listDegree}">
        <div class="modal fade" id="editModal${deg.degreeId}" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content shadow-lg rounded-4">
                    <!-- Modal Header -->
                    <div class="modal-header bg-primary text-white rounded-top-4">
                        <h5 class="modal-title w-100 text-center" id="editModalLabel">Edit Degree - ID: ${deg.degreeId}</h5>
                        <button type="button" class="btn-close btn-close-white position-absolute end-0 me-3" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <!-- Form -->
                    <form method="POST" action="${pageContext.request.contextPath}/instructor/profile/degree?action=edit" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="edit">

                        <div class="modal-body px-4 py-3">
                            <!-- Degree ID and Link -->
                            <div class="mb-3 row">
                                <div class="col-md-2">
                                    <label for="degreeId" class="form-label fw-bold">ID</label>
                                    <input type="text" class="form-control" id="degreeId" name="degreeId"
                                           required value="${deg.degreeId}" readonly>
                                </div>
                                <div class="col-md-10">
                                    <label for="degreeLink" class="form-label fw-bold">Link of Degree</label>
                                    <input type="text" class="form-control" id="degreeLink" name="degreeLink"
                                           required value="${deg.link}">
                                </div>
                            </div>

                            <!-- Image Upload -->
                            <input type="hidden" name="deleteImage" id="deleteImage${deg.degreeId}" value="false" />
                            <input type="hidden" name="keepOldImage" id="keepOldImage${deg.degreeId}" value="true" />

                            <div class="mb-4">
                                <label for="degreeImage" class="form-label fw-bold">Upload New Image</label>
                                <input type="file"
                                       class="form-control"
                                       id="degreeImage${deg.degreeId}"
                                       name="degreeImage"
                                       accept="image/*"
                                       onchange="previewImage(event, '${deg.degreeId}')" />
                            </div>

                            <!-- Current Image -->
                            <c:if test="${not empty deg.imageDataURI}">
                                <div class="mb-4 text-center" id="currentImageDiv${deg.degreeId}">
                                    <label class="form-label fw-bold">Current Image</label><br>
                                    <img src="${deg.imageDataURI}" alt="Current Image"
                                         class="img-fluid rounded shadow"
                                         style="max-height: 500px; object-fit: contain;" />
                                </div>
                            </c:if>

                            <!-- Image Preview -->
                            <div class="mb-3 text-center">
                                <label class="form-label fw-bold">Image Preview</label><br>
                                <img id="imagePreview${deg.degreeId}" class="img-fluid rounded shadow"
                                     style="max-height: 500px; object-fit: contain; display: none;" />
                            </div>
                        </div>

                        <!-- Modal Footer -->
                        <div class="modal-footer bg-light rounded-bottom-4">
                            <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary px-4">Edit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>



        <!-- View Detail Modal -->
        <div class="modal fade" id="viewModal${deg.degreeId}" tabindex="-1" aria-labelledby="viewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content shadow rounded-4">
                    <!-- Modal Header -->
                    <div class="modal-header bg-info text-white rounded-top-4">
                        <h5 class="modal-title w-100 text-center" id="viewModalLabel">
                            View Detail - ID: ${deg.degreeId}
                        </h5>
                        <button type="button" class="btn-close btn-close-white position-absolute end-0 me-3" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <!-- Modal Body -->
                    <div class="modal-body px-4 py-3">
                        <!-- ID and Link -->
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <label class="form-label fw-bold">ID</label>
                                <input type="text" class="form-control-plaintext border rounded px-2" value="${deg.degreeId}" readonly>
                            </div>
                            <div class="col-md-9">
                                <label class="form-label fw-bold">Link of Degree</label>
                                <input type="text" class="form-control-plaintext border rounded px-2" value="${deg.link}" readonly>
                            </div>
                        </div>

                        <!-- Image -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Current Image</label>
                            <c:choose>
                                <c:when test="${empty deg.imageDataURI}">
                                    <div class="alert alert-warning text-center mt-2">No Image Available</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center">
                                        <img src="${deg.imageDataURI}" alt="Degree Image" class="img-fluid rounded shadow-sm" style="max-height: 300px;">
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Modal Footer -->
                    <div class="modal-footer bg-light rounded-bottom-4">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>


        <div class="modal fade" id="zoomImageModal${deg.degreeId}" tabindex="-1" aria-labelledby="zoomImageModalLabel${deg.degreeId}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header border-0">
                        <h5 class="modal-title" id="zoomImageModalLabel${deg.degreeId}">Image Preview</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body d-flex justify-content-center">
                        <img src="${deg.imageDataURI}" alt="Zoomed Image" class="img-fluid rounded shadow" style="max-height: 600px; object-fit: contain;">
                    </div>
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
            document.getElementById("degreeImage${deg.degreeId}").addEventListener("change", function (event) {
                const preview = document.getElementById("imagePreview${deg.degreeId}");
                const currentImageDiv = document.getElementById("currentImageDiv${deg.degreeId}"); // Sử dụng ID cụ thể
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
            const zoomModal = document.getElementById('zoomImageModal${deg.degreeId}');
            zoomModal.addEventListener('click', function (e) {
                if (e.target === zoomModal) {
                    const modalInstance = bootstrap.Modal.getInstance(zoomModal);
                    modalInstance.hide();
                }
            });
        </script>

        <!-- Delete Modal -->
        <div class="modal fade" id="deleteModal${deg.degreeId}" tabindex="-1" aria-labelledby="deleteModalLabel"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm Delete Degree</h5>

                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="POST" action="${pageContext.request.contextPath}/instructor/profile/degree?action=delete">
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
    </c:forEach>
    <jsp:include page="/layout/toast.jsp"/>
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
