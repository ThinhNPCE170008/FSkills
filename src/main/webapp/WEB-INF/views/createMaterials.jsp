<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Create Material | F-Skill</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                background: linear-gradient(135deg, #f0f4ff, #f9f9f9);
                font-family: 'Segoe UI', sans-serif;
            }
            .card-custom {
                border: none;
                border-radius: 20px;
                box-shadow: 0 12px 25px rgba(0, 0, 0, 0.1);
                background-color: #ffffff;
                overflow: hidden;
            }
            .section-title {
                font-size: 1.3rem;
                font-weight: 600;
                color: #495057;
                margin-top: 1.5rem;
            }
            .info-block {
                padding: 1rem;
                border-radius: 12px;
                background-color: #f8f9fa;
                margin-bottom: 1rem;
            }
            .info-label {
                color: #6c757d;
                font-weight: 500;
                margin-bottom: 0.25rem;
            }
            .info-value {
                font-size: 1.1rem;
                font-weight: 600;
                color: #212529;
            }
            .material-type-icon {
                font-size: 1.2rem;
                color: #0d6efd;
            }
            .btn-back {
                font-size: 1rem;
                padding: 0.6rem 1.2rem;
            }
            .description-box {
                background-color: #f1f3f5;
                padding: 1rem;
                border-radius: 12px;
                white-space: pre-line;
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
        <jsp:include page="/layout/header_user.jsp"/>
        <div class="container py-2 ps-3">
            <div class="container py-2 ps-3">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/instructor">Home</a></li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${course.courseID}">${course.courseName}</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/instructor/courses/modules/material?moduleId=${module.moduleID}&courseId=${course.courseID}">
                                ${module.moduleName}
                            </a>
                        </li>
                        <li class="breadcrumb-item">
                            Create New
                        </li>
                    </ol>
                </nav>
                <div class="bg-white p-5 rounded-4 shadow-lg mx-auto" style="max-width: 900px;">
                    <h3 class="mb-4 text-primary fw-semibold text-center">
                        <i class="bi bi-journal-plus"></i> Create New Material
                    </h3>
                    <form method="POST" action="${pageContext.request.contextPath}/instructor/courses/modules/material?action=create" enctype="multipart/form-data" onsubmit="return prepareCreateMaterial()">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="moduleId" value="${module.moduleID}">
                        <input type="hidden" name="courseId" value="${course.courseID}">
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
                                    <option value="pdf">PDF/Doc</option>
                                    <option value="link">Link</option>
                                </select>
                            </div>

                            <!-- Upload Video -->
                            <div class="col-md-6 d-none" id="videoUploadDiv">
                                <label class="form-label fw-semibold">Upload Video</label>
                                <input type="file" name="videoFile" id="videoFile" class="form-control" accept="video/*"
                                       onchange="previewSelectedVideo(); updateMaterialLocation('video')">

                                <!-- Video preview -->
                                <div id="videoPreviewContainer" class="mt-3 d-none">
                                    <label class="form-label">Video Preview</label>
                                    <video id="videoPreview" width="200%" controls>
                                        <source id="videoPreviewSource" src="" type="video/mp4">
                                        Your browser does not support the video tag.
                                    </video>
                                </div>
                            </div>


                            <div class="col-md-6 d-none" id="fileUploadDiv">
                                <label class="form-label fw-semibold">Upload File (PDF/DOC)</label>
                                <input type="file" name="docFile" class="form-control" accept=".pdf,.doc,.docx">
                            </div>

                            <div class="col-md-6 d-none" id="linkInputDiv">
                                <label class="form-label fw-semibold">Material Link</label>
                                <input type="url" name="materialLink" class="form-control"
                                       placeholder="https://..." pattern="https?://.+" title="Must start with http:// or https://">
                            </div>

                            <div class="col-md-6 d-none" id="videoDurationDiv">
                                <label class="form-label fw-semibold">Video Duration (hh:mm:ss)</label>
                                <input type="text" class="form-control" id="durationInput"
                                       placeholder="e.g. 5:03, 00:02:59" onchange="updateVideoDuration()">
                                <div id="durationError" class="text-danger small mt-1 d-none">
                                    ⚠ Please enter correct format hh:mm:ss (time can be shortened)
                                </div>
                                <input type="hidden" name="videoTime" id="videoTime" value="00:00:00" required>
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
                                <a href="${pageContext.request.contextPath}/instructor/courses/modules/material?moduleId=${module.moduleID}&courseId=${course.courseID}""
                                   class="btn btn-outline-secondary btn-lg px-4 ms-2">
                                    <i class="bi bi-x-circle"></i> Cancel
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script>
            function toggleInputFields() {
                const type = document.getElementById("type").value;

                const videoUpload = document.querySelector('input[name="videoFile"]');
                const fileUpload = document.querySelector('input[name="docFile"]');
                const linkInput = document.querySelector('input[name="materialLink"]');
                const videoTime = document.getElementById("durationInput");

                // Hide all
                document.getElementById("videoUploadDiv").classList.add("d-none");
                document.getElementById("fileUploadDiv").classList.add("d-none");
                document.getElementById("linkInputDiv").classList.add("d-none");
                document.getElementById("videoDurationDiv").classList.add("d-none");

                // Remove required
                if (videoUpload)
                    videoUpload.removeAttribute("required");
                if (fileUpload)
                    fileUpload.removeAttribute("required");
                if (linkInput)
                    linkInput.removeAttribute("required");
                if (videoTime)
                    videoTime.removeAttribute("required");

                // Show required inputs by type
                if (type === "video") {
                    document.getElementById("videoUploadDiv").classList.remove("d-none");
                    document.getElementById("videoDurationDiv").classList.remove("d-none");
                    if (videoUpload)
                        videoUpload.setAttribute("required", "required");
                    if (videoTime)
                        videoTime.setAttribute("required", "required");
                } else if (type === "pdf") {
                    document.getElementById("fileUploadDiv").classList.remove("d-none");
                    if (fileUpload)
                        fileUpload.setAttribute("required", "required");
                } else if (type === "link") {
                    document.getElementById("linkInputDiv").classList.remove("d-none");
                    if (linkInput)
                        linkInput.setAttribute("required", "required");
                }
            }
            function prepareCreateMaterial() {
                // Nếu loại là video thì cập nhật lại videoTime
                const type = document.getElementById("type").value;
                if (type === "video") {
                    updateVideoDuration();
                }
                return true; // cho phép form submit
            }

            function updateVideoDuration() {
                const inputEl = document.getElementById("durationInput");
                const errorEl = document.getElementById("durationError");
                const hiddenInput = document.getElementById("videoTime");

                let input = inputEl.value.trim();

                if (input === "") {
                    hiddenInput.value = "00:00:00";
                    errorEl.classList.remove("d-none");
                    errorEl.textContent = "⚠ Please enter a non-zero duration.";
                    return;
                }

                const parts = input.split(":");

                if (parts.length === 2) {
                    parts.unshift("0");
                }

                if (parts.length !== 3) {
                    showError("⚠ Invalid format. Use hh:mm:ss or mm:ss.");
                    return;
                }

                let [hh, mm, ss] = parts.map(p => p.trim());

                if (!/^\d+$/.test(hh) || !/^\d+$/.test(mm) || !/^\d+$/.test(ss)) {
                    showError("⚠ Hours, minutes, and seconds must be numbers.");
                    return;
                }

                hh = parseInt(hh, 10);
                mm = parseInt(mm, 10);
                ss = parseInt(ss, 10);

                if (mm > 59 || ss > 59) {
                    showError("⚠ Minutes and seconds must be between 00 and 59.");
                    return;
                }

                // Không được bằng 00:00:00
                if (hh === 0 && mm === 0 && ss === 0) {
                    showError("⚠ Duration cannot be 00:00:00.");
                    return;
                }

                const formatted = [
                    hh.toString().padStart(2, "0"),
                    mm.toString().padStart(2, "0"),
                    ss.toString().padStart(2, "0")
                ].join(":");

                hiddenInput.value = formatted;
                errorEl.classList.add("d-none");

                function showError(message) {
                    hiddenInput.value = "00:00:00";
                    errorEl.classList.remove("d-none");
                    errorEl.textContent = message;
                }
            }

            function previewSelectedVideo() {
                const fileInput = document.getElementById("videoFile");
                const file = fileInput?.files[0];

                const previewContainer = document.getElementById("videoPreviewContainer");
                const previewSource = document.getElementById("videoPreviewSource");
                const previewVideo = document.getElementById("videoPreview");

                if (file) {
                    const url = URL.createObjectURL(file);
                    previewSource.src = url;
                    previewVideo.load();
                    previewContainer.classList.remove("d-none");
                } else {
                    previewSource.src = "";
                    previewVideo.load();
                    previewContainer.classList.add("d-none");
                }
            }

        </script>
        <jsp:include page="/layout/footer.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="/layout/toast.jsp"/>
    </body>
</html>
