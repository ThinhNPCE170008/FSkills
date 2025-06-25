<%-- 
    Document   : updateMaterials
    Created on : 20/06/2025, 10:07:26 PM
    Author     : Hua Khanh Duy - CE180230 - SE1814
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
        </style>
    </head>
    <body>
        <jsp:include page="/layout/sidebar_user.jsp"/>

        <div class="container py-5">
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
                        ${material.materialName}
                    </li>
                </ol>
            </nav>
            <div class="bg-white p-5 rounded-4 shadow-lg mx-auto" style="max-width: 900px;">
                <h3 class="mb-4 text-primary fw-semibold text-center">
                    <i class="bi bi-journal-plus"></i> Update Material
                </h3>
                <form method="POST" action="${pageContext.request.contextPath}/instructor/courses/modules/material?action=update" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="moduleId" value="${module.moduleID}">
                    <input type="hidden" name="courseId" value="${course.courseID}">
                    <input type="hidden" name="materialId" value="${material.materialId}">
                    <div class="row g-4">
                        <!-- Material Name -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Material Name</label>
                            <input type="text" name="materialName" class="form-control" required
                                   maxlength="1000" pattern=".{3,}" title="Must be at least 3 characters"
                                   value="${material.materialName}">
                        </div>

                        <!-- Type -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Material Type</label>
                            <select class="form-select form-select-lg" id="type" name="type" onchange="toggleInputFields()" required>
                                <option value="">-- Choose Type --</option>
                                <option value="video" ${material.type == 'video' ? 'selected' : ''}>Video</option>
                                <option value="pdf" ${material.type == 'pdf' ? 'selected' : ''}>PDF/Doc</option>
                                <option value="link" ${material.type == 'link' ? 'selected' : ''}>Link</option>
                            </select>
                        </div>
                        <input type="hidden" name="materialLocation" id="materialLocation" value="${material.materialLocation}">

                        <!-- Upload Video -->
                        <div class="col-md-6 ${material.type == 'video' ? '' : 'd-none'}" id="videoUploadDiv">
                            <label class="form-label fw-semibold">Upload Video</label>
                            <input type="file" id="videoFile" name="videoFile"class="form-control" accept="video/*" onchange="previewSelectedVideo(); updateMaterialLocation('video')">

                            <!-- Hiển thị preview nếu có video hiện tại -->
                            <c:if test="${material.type == 'video' && not empty material.materialLocation}">
                                <div class="mt-3">
                                    <label class="form-label">Preview Video</label><br>
                                    <video id="videoPreviewOld" width="100%" controls>
                                        <source src="${pageContext.request.contextPath}/${material.materialLocation}" type="video/mp4">
                                        Your browser does not support the video tag.
                                    </video>
                                </div>
                            </c:if>

                            <!-- Hiển thị preview video mới chọn -->
                            <div id="videoPreviewContainer" class="mt-3 d-none">
                                <label class="form-label">Selected Video Preview</label><br>
                                <video id="videoPreviewNew" width="100%" controls></video>
                            </div>
                        </div>


                        <div class="col-md-6 ${material.type == 'pdf' ? '' : 'd-none'}" id="fileUploadDiv">
                            <label class="form-label fw-semibold">Upload File (PDF/DOC)</label>
                            <input type="file" id="docFile" name="docFile" class="form-control" accept=".pdf,.doc,.docx" onchange="updateMaterialLocation('pdf')">
                            <c:if test="${material.type == 'pdf'}">
                                <small class="text-muted">Current file: ${material.materialLocation}</small>
                            </c:if>
                        </div>

                        <div class="col-md-6 ${material.type eq 'link' ? '' : 'd-none'}" id="linkInputDiv">
                            <label class="form-label fw-semibold">Material Link</label>
                            <input type="url" id="materialLink" name="materialLink"
                                   class="form-control"
                                   placeholder="https://..." pattern="https?://.+"
                                   title="Must start with http:// or https://"
                                   value="${material.materialLocation}"
                                   oninput="updateMaterialLocation('link')">
                        </div>

                        <div class="col-md-6 " id="videoDurationDiv">
                            <label class="form-label fw-semibold">Video Duration (hh:mm:ss)</label>

                            <!-- Input nhập thời lượng -->
                            <input type="text" class="form-control" id="durationInput"
                                   placeholder="e.g. 5:03, 00:02:59"
                                   value="${material.time}"
                                   onchange="updateVideoDuration()">

                            <!-- Thông báo lỗi -->
                            <div id="durationError" class="text-danger small mt-1 d-none">
                                ⚠ Please enter correct format hh:mm:ss (time can be shortened)
                            </div>

                            <!-- Input ẩn để submit -->
                            <input type="hidden" name="videoTime" id="videoTime" value="${material.time}">
                        </div>


                        <!-- Display Order -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Display Order</label>
                            <input type="number" name="materialOrder" class="form-control" required min="1" max="1000"
                                   value="${material.materialOrder}">
                        </div>

                        <!-- Description -->
                        <div class="col-12">
                            <label class="form-label fw-semibold">Material Description</label>
                            <textarea name="materialDescription" class="form-control" rows="4" placeholder="Enter description...">${material.materialDescription}</textarea>
                        </div>

                        <!-- Buttons -->
                        <div class="col-12 text-center pt-3">
                            <button type="submit" class="btn btn-success btn-lg px-4 shadow-sm">
                                <i class="bi bi-check-circle-fill"></i> Update
                            </button>
                            <a href="${pageContext.request.contextPath}/instructor/courses/modules/material?moduleId=${module.moduleID}&courseId=${course.courseID}"
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
            const videoDiv = document.getElementById("videoUploadDiv");
            const fileDiv = document.getElementById("fileUploadDiv");
            const linkDiv = document.getElementById("linkInputDiv");
            const durationDiv = document.getElementById("videoDurationDiv");
            const videoFile = document.getElementById("videoFile");
            const docFile = document.getElementById("docFile");
            const materialLink = document.getElementById("materialLink");
            // Ẩn tất cả các khu vực
            [videoDiv, fileDiv, linkDiv, durationDiv].forEach(div => div.classList.add("d-none"));
            // Xóa thuộc tính required khỏi tất cả input liên quan
            videoFile?.removeAttribute("required");
            docFile?.removeAttribute("required");
            materialLink?.removeAttribute("required");
            // Hiển thị đúng vùng theo loại
            if (type === "video") {
            videoDiv.classList.remove("d-none");
            durationDiv.classList.remove("d-none");
            // KHÔNG thêm required cho videoTime vì nó là hidden
            } else if (type === "pdf") {
            fileDiv.classList.remove("d-none");
            } else if (type === "link") {
            linkDiv.classList.remove("d-none");
            materialLink?.setAttribute("required", "required");
            }
            if (type !== "link") {
            materialLink.value = "";
            }

            updateMaterialLocation(type);
            }


            function updateMaterialLocation(type) {
            const materialLocation = document.getElementById("materialLocation");
            if (type === "video") {
            const file = document.getElementById("videoFile").files[0];
            if (file) {
            materialLocation.value = "materialUpload/" + file.name;
            } else {
            materialLocation.value = "${material.materialLocation}";
            }
            } else if (type === "pdf") {
            const file = document.getElementById("docFile").files[0];
            if (file) {
            materialLocation.value = "materialUpload/" + file.name;
            } else {
            materialLocation.value = "${material.materialLocation}";
            }
            } else if (type === "link") {
            const link = document.getElementById("materialLink").value;
            materialLocation.value = link;
            }
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
            parts.unshift("0"); // Thêm giờ nếu chỉ có phút:giây
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
            const file = fileInput.files[0];
            const previewContainer = document.getElementById("videoPreviewContainer");
            const previewVideo = document.getElementById("videoPreviewNew");
            if (file) {
            const url = URL.createObjectURL(file);
            previewVideo.src = url;
            previewVideo.load();
            previewContainer.classList.remove("d-none");
            // Ẩn video cũ nếu có
            const oldPreview = document.getElementById("videoPreviewOld");
            if (oldPreview) {
            oldPreview.parentElement.classList.add("d-none");
            }
            }
            }

            window.onload = function () {
            toggleInputFields();
            updateVideoDuration();
            const currentType = document.getElementById("type").value;
            updateMaterialLocation(currentType);
            };
        </script>

        <jsp:include page="/layout/footer.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
