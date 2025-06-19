<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en" class="w-100">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Profile - F-Skills</title>
        <link rel="icon" href="img/favicon_io/favicon.ico" type="image/x-icon">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <style>

        </style>
    </head>
    <body class="w-100 m-0 p-0">
        <div class="profile-edit-container w-100 mt-20">
            <jsp:include page="/layout/header.jsp"/>
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
                                                    <c:when test="${deg.image == 'No Image'}">
                                                        <span class="text-muted fst-italic">No Image</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="d-flex justify-content-center align-items-center"
                                                             style="height: 100%;">
                                                            <a href="#" data-bs-toggle="modal"
                                                               data-bs-target="#zoomImageModal${deg.degreeId}">
                                                                <img src="${deg.image}" class="rounded-3 shadow"
                                                                     style="max-height: 80px; object-fit: cover; cursor: zoom-in;"/>
                                                            </a>
                                                        </div>
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

                    <form method="POST" action="Degree" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="create">
                        <c:if test="${not empty sessionScope.user}">
                            <input type="hidden" name="userId" value="${sessionScope.user.userId}">
                        </c:if>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="degreeLink" class="form-label fw-bold">Link of Degree</label>
                                <input type="text" class="form-control" id="degreeLink" name="degreeLink"
                                       placeholder="Enter link..." required
                                       pattern="https?://.+"
                                       title="Please enter a valid URL starting with http:// or https://"
                                       oninvalid="this.setCustomValidity('Please enter a valid URL starting with http://')"
                                       oninput="this.setCustomValidity('')">
                            </div>

                            <div class="mb-3">
                                <label for="degreeImage" class="form-label fw-bold">Image</label>
                                <input type="file" class="form-control" id="degreeImage" name="degreeImage"
                                       accept="image/*" onchange="previewImage(event)" required
                                       oninvalid="this.setCustomValidity('')"
                                       oninput="this.setCustomValidity('')"
                                       onblur="setNoImageIfEmpty(this)">
                                <!-- Ảnh preview -->
                                <img id="imagePreview" class="img-thumbnail mt-2" style="max-width: 300px; display: none;"/>
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
        function previewImage(event) {
            const input = event.target;
            const preview = document.getElementById('imagePreview');
            const file = input.files[0];

            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                preview.src = '';
                preview.style.display = 'none';
            }
        }
    </script>
    <!-- Edit Modal -->
    <c:forEach var="deg" items="${listDegree}">
        <div class="modal fade" id="editModal${deg.degreeId}" tabindex="-1" aria-labelledby="editModalLabel"
             aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content shadow-lg rounded-4">
                    <div class="modal-header bg-primary text-white text-center">
                        <h5 class="modal-title" id="editModalLabel">Edit Announcement - ID: ${deg.degreeId} </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>

                    <form method="POST" action="Degree" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="edit">

                        <div class="modal-body">
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

                            <div class="col-md-12 mb-3">
                                <label for="degreeImage" class="form-label fw-bold">Image</label>
                                <!-- Display existing image -->

                                <input type="file" class="form-control" id="announcementImage${deg.degreeId}"
                                       name="degreeImage" accept="image/*">
                                <input type="hidden" name="oldImagePath" value="${deg.image != null ? deg.image : ''}">


                                <div class="mt-2" id="currentImageDiv${deg.degreeId}">
                                    <label class="form-label fw-bold">Current Image</label><br>
                                    <c:choose>
                                        <c:when test="${not empty deg.image}">
                                            <img src="${deg.image}" alt="Current Image" class="img-fluid rounded"
                                                 style="max-width: 200px; max-height: 200px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <p>No image available</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="mt-2">
                                    <label class="form-label fw-bold">Image Preview</label><br>
                                    <img id="imagePreview${deg.degreeId}" class="img-fluid rounded"
                                         style="max-width: 200px; max-height: 200px; object-fit: cover; display: none;">
                                </div>
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
                            <td>
                                <c:choose>
                                    <c:when test="${deg.image == 'No Image'}">
                                        <span class="text-muted fst-italic">No Image</span>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Click vào ảnh để mở modal -->
                                        <a href="#"
                                           data-bs-toggle="modal"
                                           data-bs-target="#zoomImageModal${deg.degreeId}">
                                            <img src="${deg.image}"
                                                 class="rounded shadow-sm"
                                                 style="max-height: 80px; object-fit: cover; cursor: zoom-in;"/>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
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
                <div class="modal-content bg-transparent border-0 d-flex justify-content-center align-items-center">
                    <div class="modal-body p-0 text-center">
                        <img src="${deg.image}" alt="Zoomed Image" class="img-fluid rounded shadow"
                             style="max-height: 90vh; max-width: 90vw; object-fit: contain;">
                    </div>
                </div>
            </div>
        </div>


        <!-- JavaScript for image preview -->
        <script>
            document.getElementById("announcementImage${deg.degreeId}").addEventListener("change", function (event) {
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
                    <form method="POST" action="Degree">
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
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
