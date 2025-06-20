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
                    <li class="breadcrumb-item">
                        ${material.materialName}
                    </li>
                </ol>
            </nav>
            <div class="bg-white p-5 rounded-4 shadow-lg mx-auto" style="max-width: 900px;">
                <h3 class="mb-4 text-primary fw-semibold text-center">
                    <i class="bi bi-journal-plus"></i> Update Material
                </h3>
                <form method="POST" action="InstructorMaterial" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="moduleId" value="${module.moduleID}">
                    <input type="hidden" name="courseId" value="${course.courseID}">

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
                            <input type="file" id="videoFile" class="form-control" accept="video/*" onchange="previewSelectedVideo(); updateMaterialLocation('video')">

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
                            <input type="file" id="docFile" class="form-control" accept=".pdf,.doc,.docx" onchange="updateMaterialLocation('pdf')">
                            <c:if test="${material.type == 'pdf'}">
                                <small class="text-muted">Current file: ${material.materialLocation}</small>
                            </c:if>
                        </div>

                        <div class="col-md-6 ${material.type == 'link' ? '' : 'd-none'}" id="linkInputDiv">
                            <label class="form-label fw-semibold">Material Link</label>
                            <input type="url" id="materialLink" class="form-control"
                                   placeholder="https://..." pattern="https?://.+" title="Must start with http:// or https://"
                                   value="${material.type == 'link' ? material.materialLocation : ''}"
                                   oninput="updateMaterialLocation('link')">
                        </div>

                        <!-- Video Duration -->
                        <c:if test="${not empty material.time}">
                            <c:set var="timeParts" value="${fn:split(material.time, ':')}" />
                        </c:if>
                        <div class="col-md-6 d-none" id="videoDurationDiv">
                            <label class="form-label fw-semibold">Video Duration</label>
                            <div class="d-flex gap-2">
                                <input type="number" min="0" name="videoHour" class="form-control" placeholder="HH"
                                       value="${not empty timeParts ? timeParts[0] : '00'}" style="max-width: 80px;" oninput="updateVideoDuration()">
                                <span class="mt-2">:</span>
                                <input type="number" min="0" max="59" name="videoMinute" class="form-control" placeholder="MM"
                                       value="${not empty timeParts ? timeParts[1] : '00'}" style="max-width: 80px;" oninput="updateVideoDuration()">
                                <span class="mt-2">:</span>
                                <input type="number" min="0" max="59" name="videoSecond" class="form-control" placeholder="SS"
                                       value="${not empty timeParts ? timeParts[2] : '00'}" style="max-width: 80px;" oninput="updateVideoDuration()">
                            </div>
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
            const videoDiv = document.getElementById("videoUploadDiv");
            const fileDiv = document.getElementById("fileUploadDiv");
            const linkDiv = document.getElementById("linkInputDiv");
            const durationDiv = document.getElementById("videoDurationDiv");
            const videoFile = document.getElementById("videoFile");
            const docFile = document.getElementById("docFile");
            const materialLink = document.getElementById("materialLink");
            const videoTime = document.getElementById("videoTime");
            [videoDiv, fileDiv, linkDiv, durationDiv].forEach(div => div.classList.add("d-none"));
            [videoFile, docFile, materialLink, videoTime].forEach(input => input?.removeAttribute("required"));
            if (type === "video") {
            videoDiv.classList.remove("d-none");
            durationDiv.classList.remove("d-none");
            videoFile?.setAttribute("required", "required");
            videoTime?.setAttribute("required", "required");
            } else if (type === "pdf") {
            fileDiv.classList.remove("d-none");
            docFile?.setAttribute("required", "required");
            } else if (type === "link") {
            linkDiv.classList.remove("d-none");
            materialLink?.setAttribute("required", "required");
            }

            updateMaterialLocation(type);
            }

            function updateMaterialLocation(type) {
            const materialLocation = document.getElementById("materialLocation");
            if (type === "video") {
            const file = document.getElementById("videoFile").files[0];
            materialLocation.value = file ? file.name : "${material.materialLocation}";
            } else if (type === "pdf") {
            const file = document.getElementById("docFile").files[0];
            materialLocation.value = file ? file.name : "${material.materialLocation}";
            } else if (type === "link") {
            const link = document.getElementById("materialLink").value;
            materialLocation.value = link;
            }
            }

            function updateVideoDuration() {
            const hour = (document.querySelector("[name='videoHour']").value || "0").padStart(2, '0');
            const minute = (document.querySelector("[name='videoMinute']").value || "0").padStart(2, '0');
            const second = (document.querySelector("[name='videoSecond']").value || "0").padStart(2, '0');
            document.getElementById("videoTime").value = `${hour}:${minute}:${second}`;
                }

                window.onload = function () {
                toggleInputFields(); // Kích hoạt đúng div theo type
                updateVideoDuration(); // Đảm bảo duration hợp lệ

                // Gán lại materialLocation nếu là video/pdf
                const type = "${material.type}";
                if (type === "video" || type === "pdf") {
                document.getElementById("materialLocation").value = "${material.materialLocation}";
                }
                };
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
                // Ẩn preview cũ nếu đang hiển thị
                const oldPreview = document.getElementById("videoPreviewOld");
                if (oldPreview) {
                oldPreview.parentElement.classList.add("d-none");
                }
                }
                }

                function updateMaterialLocation(type) {
                const materialLocation = document.getElementById("materialLocation");
                if (type === "video") {
                const file = document.getElementById("videoFile").files[0];
                if (file) {
                materialLocation.value = file.name; // hoặc full path nếu cần
                } else {
                materialLocation.value = "${material.materialLocation}"; // giữ giá trị cũ nếu không đổi
                }
                } else if (type === "pdf") {
                const file = document.getElementById("docFile").files[0];
                if (file) {
                materialLocation.value = file.name;
                } else {
                materialLocation.value = "${material.materialLocation}";
                }
                } else if (type === "link") {
                const link = document.getElementById("materialLink").value;
                materialLocation.value = link;
                }
                }
                window.onload = function () {
                toggleInputFields();
                updateVideoDuration();
                // Gán lại materialLocation ban đầu dựa theo type
                const currentType = document.getElementById("type").value;
                updateMaterialLocation(currentType);
                };
        </script>
        <jsp:include page="/layout/footerInstructor.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
