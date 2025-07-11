<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <title>${Material.materialName}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" integrity="sha384-XGjxtQfXaH2tnPFa9x+ruJTuLE3Aa6LhHSWRr1XeTyhezb4abCG4ccI5AkVDxqC+" crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <style>
            :root {
                --primary-color: #2563eb;
                --secondary-color: #1e3a8a;
                --background-color: #f8fafc;
                --text-color: #1f2937;
                --border-color: #e5e7eb;
                --danger-color: #dc2626;
            }

            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background-color: var(--background-color);
                color: var(--text-color);
            }

            #content {
                display: flex;
                flex-direction: row;
                padding-left: 3vw;
                min-height: 100vh;
                box-sizing: border-box;
                width: 100%;
            }

            #material-content {
                flex: 5 1 0;
                height: 100vh;
                padding: 2rem 3rem;
                overflow-y: auto;
                min-width: 0;
                background-color: white;
                border-radius: 12px;
                margin: 1rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }

            #material-content::-webkit-scrollbar {
                width: 8px;
            }

            #material-content::-webkit-scrollbar-thumb {
                background: var(--border-color);
                border-radius: 4px;
            }

            #material-list {
                flex: 1 1 0;
                height: 100vh;
                padding: 2rem 1rem;
                overflow-y: auto;
                min-width: 250px;
                background-color: white;
                border-left: 1px solid var(--border-color);
            }

            #material-list::-webkit-scrollbar {
                width: 8px;
            }

            #material-list::-webkit-scrollbar-thumb {
                background: var(--border-color);
                border-radius: 4px;
            }

            .material {
                display: flex;
                align-items: center;
                gap: 1rem;
                padding: 0.75rem 1rem;
                font-size: 0.95rem;
                border-radius: 8px;
                margin: 0.25rem 0;
                transition: background-color 0.2s ease;
            }

            a.material {
                text-decoration: none;
                color: var(--text-color);
                background-color: transparent;
            }

            a.material:hover {
                background-color: var(--background-color);
            }

            .material.active {
                background-color: var(--primary-color);
                color: white;
            }

            #molName {
                display: block;
                font-size: 1.1rem;
                font-weight: 600;
                padding: 0.75rem 1rem;
                margin: 0.5rem 0;
                background-color: var(--background-color);
                border-radius: 8px;
                text-decoration: none;
                color: var(--secondary-color);
                transition: background-color 0.2s ease;
            }

            #molName:hover {
                background-color: #e5e7eb;
            }

            .check-icon {
                color: #22c55e;
                font-size: 1.2rem;
                width: 24px;
                text-align: center;
            }

            #listOfLink {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                padding: 1rem 0;
                font-size: 0.95rem;
                color: var(--text-color);
            }

            .linkoverflow {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 200px;
            }

            .arrow {
                color: var(--text-color);
                font-weight: 500;
            }

            .mat-des {
                margin: 2rem 0;
                font-size: 1rem;
                line-height: 1.6;
                color: #4b5563;
            }

            /* YouTube iframe styles */
            html body #material-content .youtube-iframe {
                width: 100%;
                max-width: 800px;
                height: 450px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                transition: box-shadow 0.2s ease, transform 0.2s ease;
                display: block !important;
                margin: 2rem auto 0;
            }

            html body #material-content .youtube-iframe:hover {
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transform: scale(1.01);
            }

            /* PDF iframe styles */
            html body #material-content .material-pdf {
                width: 100%;
                max-width: 800px;
                height: 600px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                display: block !important;
                margin: 2rem auto 0;
            }

            /* Image styles */
            html body #material-content .material-image {
                max-width: 100%;
                max-height: 400px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                transition: box-shadow 0.2s ease, transform 0.2s ease;
                display: block !important;
                margin: 2rem auto 0;
            }

            html body #material-content .material-image:hover {
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transform: scale(1.02);
            }

            /* HTML5 video styles */
            html body #material-content .material-video {
                width: 100%;
                max-width: 800px;
                height: auto;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                display: block !important;
                margin: 2rem auto 0;
            }

            /* Material link styles (external links, downloads) */
            html body #material-content .material-link {
                font-size: 1rem;
                font-weight: 500;
                color: var(--primary-color) !important;
                text-decoration: underline;
                transition: color 0.2s ease;
                display: block !important;
                margin: 2rem auto 0;
            }

            html body #material-content .material-link:hover {
                color: var(--secondary-color) !important;
            }

            /* Fallback text styles */
            html body #material-content .material-fallback {
                font-size: 0.95rem;
                font-style: italic;
                color: #6b7280 !important;
                text-align: center;
                display: block !important;
                margin: 2rem auto 0;
            }

            /* Standardized button styles */
            html body #material-content .btn-report,
            html body #material-content #completeButton {
                padding: 0.75rem 2rem !important;
                font-size: 1rem !important;
                line-height: 1.5 !important;
                min-width: 120px !important;
                border-radius: 999px !important;
                font-weight: 500 !important;
                text-align: center !important;
                transition: all 0.2s ease !important;
                display: inline-flex !important;
                align-items: center !important;
                justify-content: center !important;
            }

            html body #material-content .btn-report {
                border: 1px solid var(--danger-color) !important;
                color: var(--danger-color) !important;
                background-color: transparent !important;
            }

            html body #material-content .btn-report:hover {
                background-color: var(--danger-color) !important;
                color: white !important;
            }

            html body #material-content #completeButton {
                background-color: var(--primary-color) !important;
                border: none !important;
                color: white !important;
            }

            html body #material-content #completeButton:hover {
                background-color: var(--secondary-color) !important;
            }

            .report-modal {
                font-family: 'Inter', sans-serif;
                max-width: 500px;
            }

            .report-modal .modal-content {
                border-radius: 12px;
                border: none;
                box-shadow: 0 4px 24px rgba(0, 0, 0, 0.1);
            }

            .report-modal .modal-header {
                padding: 1.5rem 2rem;
                border-bottom: none;
            }

            .report-modal .modal-body {
                padding: 1.5rem 2rem;
            }

            .report-modal .modal-footer {
                padding: 1rem 2rem;
                border-top: none;
            }

            .report-modal h4 {
                font-size: 1.5rem;
                font-weight: 600;
            }

            .report-modal h6 {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .report-modal p {
                font-size: 0.9rem;
                color: #6b7280;
                margin-bottom: 1.5rem;
            }

            .form-check-label {
                font-size: 0.95rem;
                color: var(--text-color);
            }

            .form-check-input:checked {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .btn-next {
                background-color: var(--primary-color);
                color: white;
                font-weight: 500;
                border-radius: 999px;
                padding: 0.75rem;
                width: 100%;
                transition: background-color 0.2s ease;
            }

            .btn-next:hover {
                background-color: var(--secondary-color);
            }

            .btn-next:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .btn-back {
                border: 1px solid var(--border-color);
                background-color: transparent;
                color: var(--text-color);
                border-radius: 999px;
                padding: 0.5rem 1.5rem;
                font-size: 0.9rem;
            }

            .btn-back:hover {
                background-color: var(--background-color);
            }

            @media (max-width: 768px) {
                #content {
                    flex-direction: column;
                }

                #material-list {
                    min-width: 100%;
                    border-left: none;
                    border-top: 1px solid var(--border-color);
                }

                #material-content {
                    padding: 1.5rem;
                    margin: 0.5rem;
                }

                html body #material-content .youtube-iframe,
                html body #material-content .material-pdf {
                    height: 400px;
                }
            }

            @media (max-width: 576px) {
                html body #material-content .youtube-iframe,
                html body #material-content .material-pdf {
                    height: 300px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="../../layout/sidebar_user.jsp" %>

        <div id="content" class="w-100">
            <div id="material-content" class="main">
                <div id="listOfLink" class="ms-3">
                    <a class="linkoverflow link-primary"
                       href="${pageContext.request.contextPath}/learner/course?courseID=${Course.courseID}">
                        ${Course.courseName}
                    </a>
                    <span class="arrow">></span>
                    <span class="linkoverflow">${Material.module.moduleName}/${Material.materialName}</span>
                </div>

                <h1 class="text-center mt-3 mb-4" style="font-size: 2rem; font-weight: 700;">${Material.materialName}</h1>

                <c:choose>
                    <c:when test="${Material.type == 'video' && not empty Material.materialUrl}">
                        <!-- YouTube video -->
                        <c:set var="videoId" value="" />
                        <!-- 1. Từ embed -->
                        <c:if test="${fn:contains(Material.materialUrl, 'embed/')}">
                            <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(Material.materialUrl, 'embed/'), '?')}" />
                        </c:if>
                        <!-- 2. Từ youtu.be/ -->
                        <c:if test="${empty videoId && fn:contains(Material.materialUrl, 'youtu.be/')}">
                            <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(Material.materialUrl, 'youtu.be/'), '?')}" />
                        </c:if>
                        <!-- 3. watch?v= -->
                        <c:if test="${empty videoId && fn:contains(Material.materialUrl, 'watch?v=')}">
                            <c:set var="temp" value="${fn:substringAfter(Material.materialUrl, 'watch?v=')}" />
                            <c:choose>
                                <c:when test="${fn:contains(temp, '&')}">
                                    <c:set var="videoId" value="${fn:substringBefore(temp, '&')}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="videoId" value="${temp}" />
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <!-- 4. Từ v= ở cuối (fallback) -->
                        <c:if test="${empty videoId && fn:contains(Material.materialUrl, 'v=')}">
                            <c:set var="videoId" value="${fn:substringBefore(fn:substringAfter(Material.materialUrl, 'v='), '&')}" />
                        </c:if>
                        <iframe src="https://www.youtube.com/embed/${videoId}" allowfullscreen class="youtube-iframe mx-auto"></iframe>
                    </c:when>

                    <c:when test="${not empty Material.materialFile && (fn:endsWith(Material.materialFile, '.jpg') || fn:endsWith(Material.materialFile, '.jpeg') || fn:endsWith(Material.materialFile, '.png') || fn:endsWith(Material.materialFile, '.gif'))}">
                        <!-- Image file -->
                        <img src="${pageContext.request.contextPath}/downloadmaterial?id=${Material.materialId}"
                             class="material-image mx-auto"
                             alt="${Material.fileName}">
                    </c:when>

                    <c:when test="${not empty Material.materialFile && (fn:endsWith(Material.materialFile, '.mp4') || fn:endsWith(Material.materialFile, '.webm'))}">
                        <!-- HTML5 video file -->
                        <video controls class="material-video mx-auto">
                            <source src="${pageContext.request.contextPath}/downloadmaterial?id=${Material.materialId}" type="video/${fn:substringAfter(Material.materialFile, '.')}">
                            Your browser does not support the video tag.
                        </video>
                    </c:when>

                    <c:when test="${not empty Material.materialFile && (Material.type == 'pdf' || fn:endsWith(Material.materialFile, '.pdf'))}">
                        <!-- PDF file (inline viewing) -->
                        <iframe src="${pageContext.request.contextPath}/downloadmaterial?id=${Material.materialId}" class="material-pdf mx-auto"></iframe>
                        <div class="text-center mt-2">
                            <a href="${pageContext.request.contextPath}/downloadmaterial?id=${Material.materialId}"
                               class="material-link text-primary mx-auto">
                                Download PDF
                            </a>
                        </div>
                    </c:when>

                    <c:when test="${Material.type == 'link' && not empty Material.materialUrl}">
                        <!-- External link -->
                        <a href="${Material.materialUrl}" target="_blank" class="material-link text-primary mx-auto d-block">
                            ${Material.materialUrl}
                        </a>
                    </c:when>

                    <c:when test="${not empty Material.materialFile}">
                        <!-- Download link for non-viewable files (e.g., .docx, .zip) -->
                        <a href="${pageContext.request.contextPath}/downloadmaterial?id=${Material.materialId}"
                           class="material-link text-primary mx-auto d-block"
                           download>
                            ${Material.fileName}
                        </a>
                    </c:when>

                    <c:otherwise>
                        <!-- Fallback -->
                        <span class="material-fallback text-muted mx-auto d-block">Material not available</span>
                    </c:otherwise>
                </c:choose>

                <div class="d-flex gap-3 ms-3 mt-3">
                    <div class="align-self-center">
                        <button class="btn btn-report" data-bs-toggle="modal" data-bs-target="#reportMaterialModal">
                            <i class="fa-solid fa-flag me-1"></i> Report
                        </button>
                    </div>
                    <c:if test="${!StudyMap[Material.materialId]}">
                        <form method="POST" action="${pageContext.request.contextPath}/learner/course/module/material">
                            <button type="submit" name="completeMaterial" value="1" id="completeButton" class="btn btn-primary">Complete</button>
                            <input type="hidden" name="courseID" value="${Course.courseID}"/>
                            <input type="hidden" name="moduleID" value="${Material.module.moduleID}"/>
                            <input type="hidden" name="materialID" value="${Material.materialId}"/>
                        </form>
                    </c:if>
                </div>

                <p class="mat-des">${Material.materialDescription}</p>

                <jsp:include page="/WEB-INF/views/comments_section.jsp" />
            </div>

            <div id="material-list">
                <c:forEach var="mo" items="${ModuleList}" varStatus="loop">
                    <c:set var="matList" value="${MaterialMap[mo.moduleID]}" />
                    <a id="molName" class="linkoverflow" data-bs-toggle="collapse"
                       href="#list${loop.index}" role="button"
                       aria-expanded="${mo.moduleID == CurrentModuleID}"
                       aria-controls="list${loop.index}">
                        ${mo.moduleName}
                    </a>

                    <div id="list${loop.index}" class="collapse ${mo.moduleID == CurrentModuleID ? 'show' : ''}">
                        <c:forEach var="m" items="${matList}">
                            <c:choose>
                                <c:when test="${m.materialId != CurrentMaterialID}">
                                    <a class="material linkoverflow"
                                       href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${Course.courseID}&moduleID=${mo.moduleID}&materialID=${m.materialId}">
                                        <span class="check-icon">
                                            <c:if test="${StudyMap[m.materialId]}">
                                                <i class="fa-solid fa-circle-check"></i>
                                            </c:if>
                                        </span>
                                        <span class="linkoverflow">${m.materialName}</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="material active">
                                        <span class="check-icon">
                                            <c:if test="${StudyMap[m.materialId]}">
                                                <i class="fa-solid fa-circle-check"></i>
                                            </c:if>
                                        </span>
                                        <span class="linkoverflow">${m.materialName}</span>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="modal fade" id="reportMaterialModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form method="POST" action="${pageContext.request.contextPath}/report" 
                          onsubmit="return validateReportForm();">
                        <input type="hidden" name="action" value="reportMaterial">
                        <input type="hidden" name="courseId" value="${Course.courseID}">
                        <input type="hidden" name="moduleId" value="${Material.module.moduleID}">
                        <input type="hidden" name="materialId" value="${Material.materialId}">
                        <input type="hidden" name="userId" value="${sessionScope.user.userId}">

                        <div id="reportStep1">
                            <div class="modal-header">
                                <h4 class="modal-title flex-grow-1 text-center">Report Material</h4>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <h6>What's the issue?</h6>
                                <p>We'll review your report based on our Community Guidelines.</p>

                                <c:forEach var="cate" items="${listReportCategory}">
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="radio"
                                               name="categorySelection"
                                               id="materialCate${cate.reportCategoryId}"
                                               value="${cate.reportCategoryId}" required>
                                        <label class="form-check-label" for="materialCate${cate.reportCategoryId}">
                                            ${cate.reportCategoryName}
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-next" id="nextStep" disabled>Next</button>
                            </div>
                        </div>

                        <div id="reportStep2" style="display: none;">
                            <div class="modal-header">
                                <button type="button" class="btn btn-back" id="backStep">← Back</button>
                                <h4 class="modal-title mx-auto">Report Material</h4>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <input type="hidden" name="categoryId" id="selectedCategoryId" />

                            <div class="modal-body">
                                <h6>Additional Details (Optional)</h6>
                                <p>Provide more information to help us understand the issue.</p>
                                <textarea name="reportDetail" class="form-control" rows="5" placeholder="Add details..."></textarea>
                            </div>

                            <div class="modal-footer">
                                <button type="submit" class="btn btn-next">Submit Report</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function validateReportForm() {
                const selectedInput = document.getElementById("selectedCategoryId");
                if (!selectedInput.value) {
                    alert("Please select a report reason.");
                    return false;
                }
                return true;
            }

            document.addEventListener("DOMContentLoaded", function () {
                const radios = document.querySelectorAll('input[name="categorySelection"]');
                const nextBtn = document.getElementById("nextStep");
                const backBtn = document.getElementById("backStep");
                const selectedInput = document.getElementById("selectedCategoryId");
                const step1 = document.getElementById("reportStep1");
                const step2 = document.getElementById("reportStep2");

                radios.forEach(radio => {
                    radio.addEventListener("change", () => {
                        nextBtn.disabled = false;
                        selectedInput.value = radio.value;
                    });
                });

                nextBtn.addEventListener("click", () => {
                    step1.style.display = "none";
                    step2.style.display = "block";
                });

                backBtn.addEventListener("click", () => {
                    step2.style.display = "none";
                    step1.style.display = "block";
                });
            });
        </script>

        <jsp:include page="/layout/toast.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    </body>
</html>