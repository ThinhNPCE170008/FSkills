<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Create Material | F-Skill</title>
        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }

            .container {
                max-width: 800px;
            }

            h2 {
                color: #343a40;
                margin-bottom: 25px;
            }
            input[type="file"]::file-selector-button {
                background-color: #4f46e5;
                color: white;
                border: none;
                padding: 0.4rem 1rem;
                border-radius: 0.3rem;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/layout/headerInstructor.jsp"/>

        <div class="container py-5">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="instructor">Home</a></li>
                    <li class="breadcrumb-item">
                        <a href="managemodule?id=${course.courseID}">${course.courseName}</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="InstructorMaterial?moduleId=${module.moduleID}&courseId=${course.courseID}">
                            ${module.moduleName}
                        </a>
                    </li>
                </ol>
            </nav>
            <div class="bg-white p-5 rounded-4 shadow-lg mx-auto" style="max-width: 900px;">
                <h3 class="mb-4 text-primary fw-semibold text-center">
                    <i class="bi bi-journal-plus"></i> Create New Material
                </h3>
                <form method="POST" action="InstructorMaterial" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="moduleId" value="${module.moduleID}">

                    <div class="row g-4">
                        <!-- Material Name -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Material Name</label>
                            <input type="text" name="materialName" class="form-control" required
                                   maxlength="1000" pattern=".{3,}" title="Must be at least 3 characters">
                        </div>

                        <!-- Type -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Material Type</label>
                            <select class="form-select form-select-lg" id="type" name="type" onchange="toggleInputFields()" required>
                                <option value="">-- Choose Type --</option>
                                <option value="video">Video</option>
                                <option value="pdf">PDF</option>
                                <option value="doc">DOC</option>
                                <option value="link">Link</option>
                            </select>
                        </div>

                        <!-- Dynamic Upload Areas -->
                        <div class="col-md-6 d-none" id="videoUploadDiv">
                            <label class="form-label fw-semibold">Upload Video</label>
                            <input type="file" name="materialVideo" class="form-control" accept="video/*">
                        </div>

                        <div class="col-md-6 d-none" id="fileUploadDiv">
                            <label class="form-label fw-semibold">Upload File (PDF/DOC)</label>
                            <input type="file" name="materialFile" class="form-control" accept=".pdf,.doc,.docx">
                        </div>

                        <div class="col-md-6 d-none" id="linkInputDiv">
                            <label class="form-label fw-semibold">Material Link</label>
                            <input type="url" name="materialLink" class="form-control"
                                   placeholder="https://..." pattern="https?://.+" title="Must start with http:// or https://">
                        </div>
                        
                        <div class="col-md-6 d-none" id="videoDurationDiv">
                            <label class="form-label fw-semibold">Video Duration</label>
                            <input type="text" name="videoTime" class="form-control"
                                   pattern="^([0-9]{1,2}:)?[0-5]?[0-9]:[0-5][0-9]$"
                                   title="Format: mm:ss or hh:mm:ss" placeholder="e.g. 10:45 or 01:02:33">

                        </div>
                        <!-- Order -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Display Order</label>
                            <input type="number" name="materialOrder" class="form-control" required min="1" max="1000">
                        </div>

                        <!-- Description -->
                        <div class="col-12">
                            <label class="form-label fw-semibold">Material Description</label>
                            <textarea name="materialDescription" class="form-control" rows="4" placeholder="Enter description..."></textarea>
                        </div>

                        <!-- Buttons -->
                        <div class="col-12 text-center pt-3">
                            <button type="submit" class="btn btn-success btn-lg px-4 shadow-sm">
                                <i class="bi bi-check-circle-fill"></i> Create
                            </button>
                            <a href="InstructorMaterial?courseId=${course.courseID}&moduleId=${module.moduleID}"
                               class="btn btn-outline-secondary btn-lg px-4 ms-2">
                                <i class="bi bi-x-circle"></i> Cancel
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function toggleInputFields() {
                const type = document.getElementById("type").value;

                const videoUpload = document.getElementsByName("materialVideo")[0];
                const fileUpload = document.getElementsByName("materialFile")[0];
                const linkInput = document.getElementsByName("materialLink")[0];
                const videoTime = document.getElementsByName("videoTime")[0];

                // Ẩn tất cả các trường
                document.getElementById("videoUploadDiv").classList.add("d-none");
                document.getElementById("fileUploadDiv").classList.add("d-none");
                document.getElementById("linkInputDiv").classList.add("d-none");
                document.getElementById("videoDurationDiv").classList.add("d-none");

                // Bỏ required tất cả
                if (videoUpload)
                    videoUpload.removeAttribute("required");
                if (fileUpload)
                    fileUpload.removeAttribute("required");
                if (linkInput)
                    linkInput.removeAttribute("required");
                if (videoTime)
                    videoTime.removeAttribute("required");

                // Hiển thị + yêu cầu tương ứng theo type
                if (type === "video") {
                    document.getElementById("videoUploadDiv").classList.remove("d-none");
                    document.getElementById("videoDurationDiv").classList.remove("d-none");
                    if (videoUpload)
                        videoUpload.setAttribute("required", "required");
                    if (videoTime)
                        videoTime.setAttribute("required", "required");
                } else if (type === "pdf" || type === "doc") {
                    document.getElementById("fileUploadDiv").classList.remove("d-none");
                    if (fileUpload)
                        fileUpload.setAttribute("required", "required");
                } else if (type === "link") {
                    document.getElementById("linkInputDiv").classList.remove("d-none");
                    if (linkInput)
                        linkInput.setAttribute("required", "required");
                }
            }
        </script>




        <jsp:include page="/layout/footerInstructor.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
