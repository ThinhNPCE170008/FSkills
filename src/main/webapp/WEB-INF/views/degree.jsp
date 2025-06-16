<%@page import="java.util.List"%>
<%@page import="model.Degree"%>
<%@page import="model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%
    User acc = (User) session.getAttribute("user");
    if (acc == null) {
        response.sendRedirect("login");
        return;
    }

    List<Degree> listDegree = (List<Degree>) request.getAttribute("listDegree");
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Profile - F-Skills</title>
        <link rel="icon" href="img/favicon_io/favicon.ico" type="image/x-icon">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/editProfile.css">
    </head>
    <body>
        <div class="profile-edit-container">
            <!-- Header -->
            <header class="d-flex justify-content-between align-items-center p-3 bg-light rounded mb-4 shadow-sm">
                <div class="logo fs-4 fw-bold text-primary">F<span class="text-warning">•</span>SKILL</div>
                <nav class="d-flex align-items-center gap-4">
                    <a href="#" class="text-dark text-decoration-none">My Course</a>
                    <a href="#" class="text-dark text-decoration-none">Home</a>
                    <a href="#" class="text-dark text-decoration-none">All Courses</a>
                    <div class="search-bar d-flex">
                        <input type="text" class="form-control" placeholder="Search">
                        <button class="btn btn-primary ms-2">🔍</button>
                    </div>
                    <div class="icons d-flex align-items-center gap-3">
                        <span class="position-relative">
                            <i class="bi bi-cart fs-5"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">2</span>
                        </span>
                        <i class="bi bi-bell fs-5"></i>
                        <div>Hi, <c:out value="${not empty sessionScope.user.displayName ? sessionScope.user.displayName : 'Guest'}"/></div>
                    </div>
                </nav>
            </header>

            <!-- Welcome -->
            <div class="mb-4">
                <h2 class="fw-semibold">Welcome, <c:out value="${not empty sessionScope.user.displayName ? sessionScope.user.displayName : 'Guest'}"/></h2>
            </div>

            <!-- Degree Table Section -->
            <div class="bg-white p-4 rounded shadow-sm">
                <div class="mb-3 text-end">
                    <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#createModal">
                        <i class="bi bi-plus-circle"></i> Submit
                    </button>
                </div>

                <%
                    if (listDegree != null && !listDegree.isEmpty()) {
                %>
                <div class="text-center my-4">
                    <h2 class="fw-bold text-uppercase text-primary border-bottom pb-2 d-inline-block">Your Degree</h2>
                </div>

                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle text-center">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Link</th>
                                <th>Submit Date</th>

                                <th>Image</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm dd/MM/yyyy");
                                for (Degree deg : listDegree) {
                            %>
                            <tr>
                                <td><%=deg.getDegreeId()%></td>
                                <td><%=deg.getLink()%></td>
                                <td><%= timeFormat.format(deg.getSubmitDate())%></td>

                                <td>
                                    <img src="<%= deg.getImage()%>" class="rounded shadow-sm" style="max-height: 80px; object-fit: cover;" />
                                </td>
                                <td class="py-3 px-4 border-b">
                                    <%
                                        int status = deg.getStatus();
                                        String statusText = "";
                                        String badgeClass = "";

                                        if (status == 0) {
                                            statusText = "Processing";
                                            badgeClass = "bg-warning text-dark";
                                        } else if (status == 1) {
                                            statusText = "Accepted";
                                            badgeClass = "bg-success";
                                        } else if (status == 2) {
                                            statusText = "Rejected";
                                            badgeClass = "bg-danger";
                                        }
                                    %>
                                    <span class="badge <%=badgeClass%> px-3 py-2 rounded-pill"><%=statusText%></span>
                                </td>

                                <td class="py-3 px-4 border-b text-center">
                                    <div class="d-flex justify-content-center gap-2">
                                        <button class="btn btn-outline-info btn-sm" type="button"
                                                data-bs-toggle="modal"
                                                data-bs-target="#viewModal<%=deg.getDegreeId()%>"><i class="fas fa-eye"></i>
                                        </button>

                                        <%
                                            if (status == 0) {
                                        %>
                                        <button class="btn btn-primary btn-sm edit" type="button"
                                                data-bs-toggle="modal"
                                                data-bs-target="#editModal<%=deg.getDegreeId()%>"><i class="fas fa-edit"></i>
                                        </button>
                                        <%
                                            }

                                            if (status == 0 || status == 2) {
                                        %>
                                        <button class="btn btn-danger btn-sm trash" type="button"
                                                data-bs-toggle="modal"
                                                data-bs-target="#deleteModal<%=deg.getDegreeId()%>"><i class="fas fa-trash"></i>
                                        </button>
                                        <%
                                            }
                                        %>
                                    </div>
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
                <div class="alert alert-warning text-center">
                    No data found.
                </div>
                <%
                    }
                %>
            </div>
            <!-- Create Modal -->
            <div class="modal fade" id="createModal" tabindex="-1" aria-labelledby="createModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content shadow-lg rounded-4">


                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="createModalLabel">New Submit Degree</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        <form method="POST" action="Degree" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="create">
                            <!-- Lấy userId từ session -->
                            <%
                                if (acc != null) {
                            %>
                            <input type="hidden" name="userId" value="<%= acc.getUserId()%>">
                            <%
                                }
                            %>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="degreeLink" class="form-label fw-bold">Link of Degree</label>
                                    <input type="text" class="form-control" id="degreeLink" name="degreeLink"
                                           placeholder="Enter link..." required>
                                </div>
                                <div class="mb-3">
                                    <label for="degreeImage" class="form-label fw-bold">Image</label>
                                    <input type="file" class="form-control" id="degreeImage" name="degreeImage" accept="image/*" onchange="previewImage(event)">

                                    <!-- Ảnh preview -->
                                    <img id="imagePreview" class="img-thumbnail mt-2" style="max-width: 300px; display: none;" />
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
        <img id="previewImage" class="img-thumbnail mt-2" style="max-height: 200px;" />
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

        <%
            for (Degree deg : listDegree) {
        %>
        <!-- Edit Modal -->
        <div class="modal fade" id="editModal<%=deg.getDegreeId()%>" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content shadow-lg rounded-4">
                    <div class="modal-header bg-primary text-white text-center">
                        <h5 class="modal-title" id="editModalLabel">Edit Announcement - ID: <%=deg.getDegreeId()%> </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <form method="POST" action="Degree" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="edit">

                        <div class="modal-body">
                            <div class="mb-3 row">
                                <div class="col-md-2">
                                    <label for="degreeId" class="form-label fw-bold">ID</label>
                                    <input type="text" class="form-control" id="degreeId" name="degreeId"
                                           required value="<%=deg.getDegreeId()%>" readonly>
                                </div>
                                <div class="col-md-10">
                                    <label for="degreeLink" class="form-label fw-bold">Link of Degree</label>
                                    <input type="text" class="form-control" id="degreeLink" name="degreeLink"
                                           required value="<%=deg.getLink()%>">
                                </div>
                            </div>

                            <div class="col-md-12 mb-3">
                                <label for="degreeImage" class="form-label fw-bold">Image</label>
                                <input type="file" class="form-control" id="degreeImage<%=deg.getDegreeId()%>" 
                                       name="degreeImage" accept="image/*">
                                <!-- Hidden input to store the old image path -->
                                <input type="hidden" name="oldImagePath" value="<%=deg.getImage() != null ? deg.getImage() : ""%>">
                                <!-- Display existing image -->
                                <div class="mt-2" id="currentImageDiv<%=deg.getDegreeId()%>">
                                    <label class="form-label fw-bold">Current Image</label><br>
                                    <% if (deg.getImage() != null && !deg.getImage().isEmpty()) {%>
                                    <img src="<%=deg.getImage()%>" alt="Current Image" class="img-fluid rounded" 
                                         style="max-width: 200px; max-height: 200px; object-fit: cover;">
                                    <% } else { %>
                                    <p>No image available</p>
                                    <% }%>
                                </div>
                                <div class="mt-2">
                                    <label class="form-label fw-bold">Image Preview</label><br>
                                    <img id="imagePreview<%=deg.getDegreeId()%>" class="img-fluid rounded" 
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
        <div class="modal fade" id="viewModal<%=deg.getDegreeId()%>" tabindex="-1" aria-labelledby="viewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content shadow-lg rounded-4">
                    <div class="modal-header bg-info text-white text-center">
                        <h5 class="modal-title" id="viewModalLabel">View Detail - ID: <%=deg.getDegreeId()%></h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <div class="mb-3 row">
                            <div class="col-md-2">
                                <label class="form-label fw-bold">ID</label>
                                <input type="text" class="form-control" value="<%=deg.getDegreeId()%>" readonly>
                            </div>
                            <div class="col-md-10">
                                <label class="form-label fw-bold">Link of Degree</label>
                                <input type="text" class="form-control" value="<%=deg.getLink()%>" readonly>
                            </div>
                        </div>

                        <div class="col-md-12 mb-3">
                            <label class="form-label fw-bold">Current Image</label><br>
                            <% if (deg.getImage() != null && !deg.getImage().isEmpty()) {%>
                            <!-- Image with Zoom Modal Trigger -->
                            <img src="<%=deg.getImage()%>" alt="Image" class="img-fluid rounded shadow-sm"
                                 style="max-width: 300px; max-height: 300px; object-fit: cover; cursor: pointer;"
                                 data-bs-toggle="modal" data-bs-target="#zoomImageModal<%=deg.getDegreeId()%>">
                            <% } else { %>
                            <p>No image available</p>
                            <% }%>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Zoom Image Modal -->
        <div class="modal fade" id="zoomImageModal<%=deg.getDegreeId()%>" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content bg-transparent border-0">
                    <div class="modal-body text-center">
                        <img src="<%=deg.getImage()%>" alt="Zoomed Image" class="img-fluid rounded shadow"
                             style="max-height: 90vh;">
                    </div>
                </div>
            </div>
        </div>


        <!-- JavaScript for image preview -->
        <script>
            document.getElementById("announcementImage<%=deg.getDegreeId()%>").addEventListener("change", function (event) {
                const preview = document.getElementById("imagePreview<%=deg.getDegreeId()%>");
                const currentImageDiv = document.getElementById("currentImageDiv<%=deg.getDegreeId()%>"); // Sử dụng ID cụ thể
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
        <div class="modal fade" id="deleteModal<%=deg.getDegreeId()%>" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm Delete Degree</h5>

                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="POST" action="Degree">
                        <input type="hidden" name="action" value="delete">

                        <div class="modal-body">
                            <input type="hidden" name="id" value="<%=deg.getDegreeId()%>">
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
        <%
            }
        %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
