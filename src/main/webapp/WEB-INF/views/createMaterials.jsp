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
        <jsp:include page="/layout/sidebar_user.jsp"/>
        <div class="container-fluid flex px-4">
            <div class="container py-2 ps-3">
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
                            Create New
                        </li>
                    </ol>
                </nav>

                <div class="bg-white p-5 rounded-4 shadow-lg mx-auto" style="max-width: 900px;">
                    <h2 class="mb-4 text-primary fw-semibold text-center fs-1">
                        <i class="bi bi-journal-plus"></i>New Material
                    </h2>
                    <form method="POST" action="${pageContext.request.contextPath}/instructor/courses/modules/material?action=create" 
                          enctype="multipart/form-data" 
                          onsubmit="return validateYoutubeFields()">
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

                            <!-- Nhúng Video YouTube -->
                            <div class="col-md-6 d-none" id="youtubeLinkDiv">
                                <label class="form-label fw-semibold">YouTube Video URL</label>
                                <input type="text" name="materialVideo" id="youtubeLinkInput" class="form-control"
                                       placeholder="https://www.youtube.com/"
                                       onchange="previewYoutubeThumbnail(); updateMaterialLocation('video')">
                                <div id="youtubeUrlError" class="text-danger small mt-1 d-none">
                                    Please enter Youtube's link!
                                </div>
                                <!-- Preview thumbnail -->
                                <div id="youtubeThumbnailPreview" class="mt-3 d-none">
                                    <label class="form-label">Thumbnail Preview</label><br>
                                    <img id="youtubeThumbnailImage" class="img-fluid rounded shadow-sm" style="max-height: 160px;" alt="Video thumbnail">
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

                            <!-- Thời lượng video (readonly) -->
                            <div class="col-md-6 d-none" id="videoDurationDiv">
                                <label class="form-label fw-semibold">Video Duration (hh:mm:ss)</label>
                                <input type="text" class="form-control bg-light" id="durationInput"
                                       placeholder="Auto-filled after entering YouTube link"
                                       readonly>

                                <div id="durationError" class="text-danger small mt-1 d-none">
                                    ⚠ Could not fetch video duration. Please check the YouTube link.
                                </div>

                                <!-- Hidden input để gửi giá trị thời lượng cho backend -->
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

                const fileUpload = document.querySelector('input[name="docFile"]');
                const linkInput = document.querySelector('input[name="materialLink"]');
                const youtubeLink = document.getElementById("youtubeLinkInput");
                const videoTime = document.getElementById("durationInput");

                // Ẩn tất cả input
                document.getElementById("youtubeLinkDiv").classList.add("d-none");
                document.getElementById("fileUploadDiv").classList.add("d-none");
                document.getElementById("linkInputDiv").classList.add("d-none");
                document.getElementById("videoDurationDiv").classList.add("d-none");

                // Gỡ required
                if (youtubeLink)
                    youtubeLink.removeAttribute("required");
                if (fileUpload)
                    fileUpload.removeAttribute("required");
                if (linkInput)
                    linkInput.removeAttribute("required");
                if (videoTime)
                    videoTime.removeAttribute("required");

                // Hiện đúng input theo type
                if (type === "video") {
                    document.getElementById("youtubeLinkDiv").classList.remove("d-none");
                    document.getElementById("videoDurationDiv").classList.remove("d-none");
                    if (youtubeLink)
                        youtubeLink.setAttribute("required", "required");
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
        </script>



        <script>
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
                                    console.log(convertISO8601ToTime("PT3M43S"));  // → "00:03:43"
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


        </script>


        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Gắn sự kiện khi bất kỳ modal nào đóng
                document.querySelectorAll('.modal').forEach(modal => {
                    modal.addEventListener('hidden.bs.modal', function () {
                        const iframe = modal.querySelector('iframe');
                        if (iframe) {
                            const src = iframe.getAttribute('src');
                            iframe.setAttribute('src', '');   // Dừng video
                            iframe.setAttribute('src', src);  // Gán lại để giữ link
                        }
                    });
                });
            });

            function showDurationError() {
                document.getElementById("durationError").classList.remove("d-none"); // Hiện lỗi
                document.getElementById("durationInput").value = "";
                document.getElementById("videoTime").value = ""; // Xoá giá trị cũ
            }
        </script>


        <jsp:include page="/layout/footer.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="/layout/toast.jsp"/>
    </body>
</html>
