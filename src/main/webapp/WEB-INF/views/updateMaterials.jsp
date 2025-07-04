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
        <div class="container-fluid flex px-4">
            <div class="container py-5">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item inline-flex items-center"><a class="text-indigo-600 hover:text-indigo-700 font-medium no-underline" href="${pageContext.request.contextPath}/instructor">Home</a></li>
                        <li class="breadcrumb-item inline-flex items-center">
                            <a class="text-indigo-600 hover:text-indigo-700 font-medium no-underline" href="${pageContext.request.contextPath}/instructor/courses/modules?courseId=${course.courseID}">${course.courseName}</a>
                        </li>
                        <li class="breadcrumb-item inline-flex items-center">
                            <a class="text-indigo-600 hover:text-indigo-700 font-medium no-underline" href="${pageContext.request.contextPath}/instructor/courses/modules/material?moduleId=${module.moduleID}&courseId=${course.courseID}">
                                ${module.moduleName}
                            </a>
                        </li>
                        <li class="breadcrumb-item">
                            ${material.materialName}
                        </li>
                    </ol>
                </nav>
                <div class="bg-white p-5 rounded-4 shadow-lg mx-auto" style="max-width: 900px;">
                    <h1 class="mb-4 text-primary fw-semibold text-center fs-1">
                        <i class="bi bi-journal-plus"></i>Update Material
                    </h1>
                    <form method="POST" action="${pageContext.request.contextPath}/instructor/courses/modules/material?action=update" 
                          enctype="multipart/form-data" onsubmit="return validateYoutubeFields()">
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
                                    <option value="video" <c:if test="${material.type eq 'video'}">selected</c:if>>Video</option>
                                    <option value="pdf" <c:if test="${material.type eq 'pdf'}">selected</c:if>>PDF/Doc</option>
                                    <option value="link" <c:if test="${material.type eq 'link'}">selected</c:if>>Link</option>
                                    </select>
                                </div>
                            <c:choose>
                                <c:when test="${material.type == 'video' && not empty material.materialUrl}">
                                    <%-- Tách videoId từ nhiều loại URL khác nhau --%>
                                    <c:set var="videoId" value="" />

                                    <%-- 1. Nếu có 'embed/' --%>
                                    <c:if test="${fn:contains(material.materialUrl, 'embed/')}">
                                        <c:set var="temp" value="${fn:substringAfter(material.materialUrl, 'embed/')}" />
                                        <c:set var="videoId" value="${fn:substringBefore(temp, '?')}" />
                                    </c:if>

                                    <%-- 2. Nếu có 'youtu.be/' --%>
                                    <c:if test="${empty videoId && fn:contains(material.materialUrl, 'youtu.be/')}">
                                        <c:set var="temp" value="${fn:substringAfter(material.materialUrl, 'youtu.be/')}" />
                                        <c:set var="videoId" value="${fn:substringBefore(temp, '?')}" />
                                    </c:if>

                                    <%-- 3. Nếu có 'watch?v=' --%>
                                    <c:if test="${empty videoId && fn:contains(material.materialUrl, 'watch?v=')}">
                                        <c:set var="temp" value="${fn:substringAfter(material.materialUrl, 'watch?v=')}" />
                                        <c:choose>
                                            <c:when test="${fn:contains(temp, '&')}">
                                                <c:set var="videoId" value="${fn:substringBefore(temp, '&')}" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="videoId" value="${temp}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <%-- 4. Nếu có 'v=' (fallback) --%>
                                    <c:if test="${empty videoId && fn:contains(material.materialUrl, 'v=')}">
                                        <c:set var="temp" value="${fn:substringAfter(material.materialUrl, 'v=')}" />
                                        <c:choose>
                                            <c:when test="${fn:contains(temp, '&')}">
                                                <c:set var="videoId" value="${fn:substringBefore(temp, '&')}" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="videoId" value="${temp}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <%-- Hiển thị thumbnail và mở modal --%>
                                    <a href="#" data-bs-toggle="modal" data-bs-target="#videoModal${material.materialId}">
                                        <img class="img-fluid rounded shadow-sm d-block mx-auto"
                                             style="max-height: 160px;"
                                             src="https://img.youtube.com/vi/${videoId}/0.jpg"
                                             alt="YouTube Thumbnail">
                                    </a>
                                </c:when>
                            </c:choose>
                        </div>
                        <!-- Upload File -->
                        <div class="col-md-6 ${material.type == 'pdf' || material.type == 'doc' ? '' : 'd-none'}" id="fileUploadDiv">
                            <label class="form-label fw-semibold">Upload File (PDF/DOC)</label>
                            <input type="file" name="docFile" class="form-control" accept=".pdf,.doc,.docx">

                            <!-- Nếu có file cũ thì hiển thị tên + lưu hidden field -->
                            <c:if test="${not empty material.materialFile}">
                                <input type="hidden" name="existingFile" value="${material.materialFile}"/>
                                <div class="mt-2">
                                    <a class="btn btn-sm btn-outline-primary"
                                       href="${pageContext.request.contextPath}/downloadmaterial?id=${material.materialId}"
                                       target="_blank">
                                        ${material.fileName}
                                    </a>
                                </div>
                            </c:if>
                        </div>

                        <!-- Link -->
                        <div class="col-md-6 ${material.type == 'link' ? '' : 'd-none'}" id="linkInputDiv">
                            <label class="form-label fw-semibold">Material Link</label>
                            <input type="url" name="materialLink" class="form-control"
                                   placeholder="https://..."
                                   pattern="https?://.+" title="Must start with http:// or https://"
                                   value="${material.type == 'link' ? material.materialUrl : ''}">
                        </div>

                        <!-- Thời lượng video -->
                        <div class="col-md-6 ${material.type == 'video' ? '' : 'd-none'}" id="videoDurationDiv">
                            <label class="form-label fw-semibold">Video Duration (hh:mm:ss)</label>
                            <input type="text" class="form-control bg-light" id="durationInput"
                                   placeholder="Auto-filled after entering YouTube link"
                                   readonly value="${material.time}">
                            <div id="durationError" class="text-danger small mt-1 d-none">
                                ⚠ Could not fetch video duration. Please check the YouTube link.
                            </div>
                            <input type="hidden" name="videoTime" id="videoTime" value="${material.time}" required>
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
    </div>
    <c:choose>
        <c:when test="${material.type == 'video' && not empty material.materialUrl}">
            <%-- Trích xuất videoId từ mọi loại link YouTube --%>
            <c:set var="videoId" value="" />

            <c:if test="${fn:contains(material.materialUrl, 'embed/')}">
                <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'embed/'), '?')}" />
            </c:if>
            <c:if test="${empty videoId && fn:contains(material.materialUrl, 'youtu.be/')}">
                <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'youtu.be/'), '?')}" />
            </c:if>
            <!-- ✅ 3. watch?v= (đã fix) -->
            <c:if test="${empty videoId && fn:contains(material.materialUrl, 'watch?v=')}">
                <c:set var="temp" value="${fn:substringAfter(material.materialUrl, 'watch?v=')}" />
                <c:choose>
                    <c:when test="${fn:contains(temp, '&')}">
                        <c:set var="videoId" value="${fn:substringBefore(temp, '&')}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="videoId" value="${temp}" />
                    </c:otherwise>
                </c:choose>
            </c:if>v
            <c:if test="${empty videoId && fn:contains(material.materialUrl, 'v=')}">
                <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(material.materialUrl, 'v='), '&')}" />
            </c:if>

            <%-- Modal hiển thị video YouTube --%>
            <div class="modal fade" id="videoModal${material.materialId}" tabindex="-1"
                 aria-labelledby="videoModalLabel${material.materialId}" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="videoModalLabel${material.materialId}">Video</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"
                                    ></button>
                        </div>
                        <div class="modal-body">
                            <div class="ratio ratio-16x9">
                                <iframe id="youtubeFrame${material.materialId}"
                                        src="https://www.youtube.com/embed/${videoId}"
                                        title="YouTube video" frameborder="0" allowfullscreen>
                                </iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
    </c:choose>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
        toggleInputFields();
        });</script>
    <script>
        function previewYoutubeThumbnail() {
        const url = document.getElementById("youtubeLinkInput").value;
        const videoId = extractYouTubeVideoId(url);
        if (videoId) {
        const thumbnailUrl = "https://img.youtube.com/vi/" + videoId + "/hqdefault.jpg";
        const imgElement = document.getElementById("youtubeThumbnailImage");
        const previewDiv = document.getElementById("youtubeThumbnailPreview");
        imgElement.src = thumbnailUrl;
        previewDiv.classList.remove("d-none");
        } else {
        document.getElementById("youtubeThumbnailPreview").classList.add("d-none");
        }
        }

        function extractYouTubeVideoId(url) {
        // Hỗ trợ nhiều định dạng YouTube URL
        const regex = /(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})/;
        const match = url.match(regex);
        return match ? match[1] : null;
        }

        // Tự động hiển thị thumbnail nếu URL đã có sẵn trong input khi load trang
        window.addEventListener("DOMContentLoaded", function () {
        const url = document.getElementById("youtubeLinkInput").value;
        if (url) {
        previewYoutubeThumbnail();
        }
        });
        function toggleInputFields() {
        const type = document.getElementById("type").value;
        const youtubeDiv = document.getElementById("youtubeLinkDiv");
        const fileDiv = document.getElementById("fileUploadDiv");
        const linkDiv = document.getElementById("linkInputDiv");
        const videoDurationDiv = document.getElementById("videoDurationDiv");
        const youtubeInput = document.getElementById("youtubeLinkInput");
        const fileInput = document.querySelector('input[name="docFile"]');
        const linkInput = document.querySelector('input[name="materialLink"]');
        const videoTimeInput = document.getElementById("durationInput");
        // Reset
        youtubeDiv.classList.add("d-none");
        fileDiv.classList.add("d-none");
        linkDiv.classList.add("d-none");
        videoDurationDiv.classList.add("d-none");
        youtubeInput?.removeAttribute("required");
        fileInput?.removeAttribute("required");
        linkInput?.removeAttribute("required");
        videoTimeInput?.removeAttribute("required");
        if (type === "video") {
        youtubeDiv.classList.remove("d-none");
        videoDurationDiv.classList.remove("d-none");
        youtubeInput?.setAttribute("required", "required");
        videoTimeInput?.setAttribute("required", "required");
        previewYoutubeThumbnail();
        } else if (type === "pdf" || type === "doc") {
        fileDiv.classList.remove("d-none");
        } else if (type === "link") {
        linkDiv.classList.remove("d-none");
        linkInput?.setAttribute("required", "required");
        // KHÔNG hiển thị videoDurationDiv ở đây
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



        const YOUTUBE_API_KEY = "AIzaSyBSPV56TgcJqr6mgWr6hDkMA2yfdirLDpA"; // ← bạn cần thay bằng API key thật

        function previewYoutubeThumbnail() {
        const url = document.getElementById("youtubeLinkInput").value.trim();
        let videoId = null;
        const patterns = [
                /(?:https?:\/\/)?(?:www\.)?youtu\.be\/([a-zA-Z0-9_-]{11})/, // youtu.be/VIDEO_ID
                /(?:https?:\/\/)?(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]{11})/, // youtube.com/embed/VIDEO_ID
                /(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})/, // youtube.com/watch?v=VIDEO_ID
                /(?:https?:\/\/)?(?:www\.)?youtube\.com\/.*[?&]v=([a-zA-Z0-9_-]{11})/, // youtube.com/...&v=VIDEO_ID
        ];
        for (const pattern of patterns) {
        const match = url.match(pattern);
        if (match && match[1]) {
        videoId = match[1];
        break;
        }
        }

        if (videoId && videoId.length === 11) {
        // Hiển thị thumbnail
        const thumbnailUrl = "https://img.youtube.com/vi/" + videoId + "/hqdefault.jpg";
        document.getElementById("youtubeThumbnailImage").src = thumbnailUrl;
        document.getElementById("youtubeThumbnailPreview").classList.remove("d-none");
        // Lấy thời lượng video
        fetch("https://www.googleapis.com/youtube/v3/videos?id=" + videoId + "&part=contentDetails&key=" + YOUTUBE_API_KEY)
                .then(response => response.json())
                .then(data => {
                console.log("YouTube API response:", data);
                console.log("Full video item:", data.items[0]);
                const durationISO = data?.items?.[0]?.contentDetails?.duration;
                if (durationISO) {
                const durationFormatted = convertISO8601ToTime(durationISO);
                console.log(convertISO8601ToTime("PT3M43S")); // → "00:03:43"
                document.getElementById("durationInput").value = durationFormatted;
                document.getElementById("videoTime").value = durationFormatted;
                document.getElementById("videoDurationDiv").classList.remove("d-none");
                document.getElementById("durationError").classList.add("d-none");
                } else {
                showDurationError();
                }
                })
                .catch(() => showDurationError());
        } else {
        document.getElementById("youtubeThumbnailPreview").classList.add("d-none");
        showDurationError();
        }
        }

        function convertISO8601ToTime(duration) {
        const regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
        const matches = duration.match(regex);
        if (!matches)
                return "00:00:00";
        const hours = matches[1] ? parseInt(matches[1]) : 0;
        const minutes = matches[2] ? parseInt(matches[2]) : 0;
        const seconds = matches[3] ? parseInt(matches[3]) : 0;
        // Ép thành chuỗi rồi padStart
        const hh = String(hours).padStart(2, '0');
        const mm = String(minutes).padStart(2, '0');
        const ss = String(seconds).padStart(2, '0');
        return hh + ":" + mm + ":" + ss;
        }

        window.onload = function () {
        toggleInputFields(); // để hiển thị đúng input khi load form update

        const type = document.getElementById("type").value;
        if (type === "video") {
        previewYoutubeThumbnail(); // hiển thị lại thumbnail
        }
        };
    </script>
    <script>
        function validateYoutubeFields() {
        const urlInput = document.getElementById("youtubeLinkInput");
        const durationInput = document.getElementById("videoTime");
        const url = urlInput.value.trim();
        const duration = durationInput.value.trim();
        const urlErrorDiv = document.getElementById("youtubeUrlError");
        const durationErrorDiv = document.getElementById("durationError");
        // Reset lỗi
        urlErrorDiv.classList.add("d-none");
        durationErrorDiv.classList.add("d-none");
        urlErrorDiv.innerText = "";
        durationErrorDiv.innerText = "";
        let isValid = true;
        const videoIdPattern = /(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/|.*[?&]v=))([a-zA-Z0-9_-]{11})/;
        const urlIsValid = videoIdPattern.test(url);
        const durationPattern = /^([0-9]{2}):([0-9]{2}):([0-9]{2})$/;
        const durationIsValid = duration.match(durationPattern) && duration !== "00:00:00";
        const isYoutubeVisible = !document.getElementById("youtubeLinkDiv").classList.contains("d-none");
        if (isYoutubeVisible) {
        if (!urlIsValid) {
        urlErrorDiv.innerText = "Please enter a valid YouTube video URL.";
        urlErrorDiv.classList.remove("d-none");
        isValid = false;
        }

        if (!durationIsValid) {
        durationErrorDiv.innerText = "Could not fetch video duration. Please check the YouTube link.";
        durationErrorDiv.classList.remove("d-none");
        isValid = false;
        }
        }

        return isValid;
        }

        function showDurationError() {
        document.getElementById("durationError").classList.remove("d-none"); // Hiện lỗi
        document.getElementById("durationInput").value = "";
        document.getElementById("videoTime").value = ""; // Xoá giá trị cũ
        }
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
        // Gắn sự kiện khi bất kỳ modal nào đóng
        document.querySelectorAll('.modal').forEach(modal => {
        modal.addEventListener('hidden.bs.modal', function () {
        const iframe = modal.querySelector('iframe');
        if (iframe) {
        const src = iframe.getAttribute('src');
        iframe.setAttribute('src', ''); // Dừng video
        iframe.setAttribute('src', src); // Gán lại để giữ link
        }
        });
        });
        });
    </script>
    <jsp:include page="/layout/footer.jsp"/>
    <jsp:include page="/layout/toast.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
