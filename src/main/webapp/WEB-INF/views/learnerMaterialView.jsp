<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html>
    <head>
        <title>${Material.materialName}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
            }
            #content{
                display: flex;
                align-items: flex-start;
                flex-direction: row;
                padding-left: 3vw;
                min-height: 100vh;
                box-sizing: border-box;
                width: 100%;
                overflow: hidden;
            }
            .material{
                display: grid;
                width: 100%;
                grid-template-columns: 50px auto;
                grid-template-rows: 22px;
                padding: 10px;
                font-size: 16px;
                background-color: #dae3f1;
                padding-right: 10%;
                line-height: 22px;
            }
            a.material{
                text-decoration: none;
                color: black;
                background-color: #ffffff;
            }
            a.material:hover{
                background-color: #dae3f1;
            }

            #material-content{
                overflow-y: scroll;
                flex: 5 1 0;
                height: 100vh;
                padding: 3vh 0 10vh 0;
                min-width: 0;
            }

            #material-content::-webkit-scrollbar {
                display: none;
            }

            #material-content {
                -ms-overflow-style: none;
                scrollbar-width: none;
            }

            #material-list{
                border-left: grey solid 1px;
                height: 100vh;
                flex: 1 1 0;
                overflow-y: scroll;
                padding: 3vh 0 10vh 0;
                min-width: 0;
            }

            #material-list::-webkit-scrollbar {
                display: none;
            }

            #material-list {
                -ms-overflow-style: none;
                scrollbar-width: none;
            }

            .mat-des{
                margin: 50px 80px 0 80px;
            }

            iframe{
                margin-top: 30px;
                width: 90%;
                height: 80%;
            }
            #completeButton{
                padding: 10px;
                margin: 30px;
                font-size: 18px;
            }

            .linkoverflow{
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            #listOfLink.linkoverflow{
                max-width: 100px;
            }

            #listOfLink{
                height: 5vh;
                padding-top: 3vh;
            }
            .arrow{
                padding: 0 15px;
            }
            .check-icon{
                color: #009900;
                font-size: 22px;
                grid-row: 1 / span 2;
                align-self: center;
                text-align: center;
            }
            #molName{
                display:block;
                font-size: 18px;
                padding-left: 5%;
                padding-right: 10%;
                font-weight: 600;
                text-decoration: none;
                color: black;
                padding-top: 10px;
                padding-bottom: 10px;
                background-color: lightgray;
            }

            .btn-dark-custom {
                background-color: #000 !important;
                color: #fff !important;
                border-radius: 999px;
                padding: 10px 0;
                font-weight: 500;
                font-size: 16px;
            }
            /* Font chữ rõ và hiện đại */
            .report-modal {
                font-family: "Segoe UI", "Roboto", sans-serif;
                font-size: 16px;
                color: #111;
            }

            .report-modal h5 {
                font-size: 20px;
                font-weight: 700;
                text-align: center;
            }

            .report-modal h6 {
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .report-modal p {
                color: #555;
                font-size: 14px;
            }

            .form-check-label {
                font-weight: 500;
                color: #222;
            }

            .form-check-input:checked {
                background-color: #111;
                border-color: #111;
            }

            /* Nút Next đẹp */
            .btn-next {
                background-color: #000;
                color: white;
                font-weight: 600;
                border-radius: 999px;
                padding: 12px 0;
                font-size: 16px;
            }

            .btn-next:disabled {
                opacity: 0.4;
                cursor: not-allowed;
            }

            .modal-footer {
                padding: 1.2rem;
            }

            .modal-body {
                padding: 1.5rem;
            }
        </style>
    </head>
    <body>
        <%@include file="../../layout/sidebar_user.jsp" %>

        <div id="content" class="w-100">
            <div id="material-content" class="main">
                <div id="listOfLink" class="ms-5">
                    <a class="linkoverflow link-primary"
                       href="${pageContext.request.contextPath}/learner/course?courseID=${Course.courseID}">
                        ${Course.courseName}
                    </a>
                    <span class="arrow">></span>
                    <span class="linkoverflow">${Material.module.moduleName}/${Material.materialName}</span>
                </div>

                <p class="h1 text-center mt-3">${Material.materialName}</p>
                <%System.out.println("a");%>
                <c:choose>
                    <c:when test="${fn:endsWith(MaterialPath,'.docx')}">
                        <p class="h6 ms-5 mt-5">Download Word Document:</p>
                        <a class="h6 ms-5 link-primary" href="${MaterialPath}" download>
                            ${Material.fileName}
                        </a>
                    </c:when>
                    <c:otherwise>
                        <iframe class="d-block mx-auto" src="${MaterialPath}"></iframe>
                        </c:otherwise>
                    </c:choose>
                    <%System.out.println("b");%>




                <!-- nút report của DUY -->   
                <button class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#reportMaterialModal">
                    <i class="fa-solid fa-flag me-1"></i> Report
                </button>

                <!-- nút report của DUY --> 


                <p class="h6 ms-5 mat-des">${Material.materialDescription}</p>

                <c:if test="${!StudyMap[Material.materialId]}">
                    <form method="POST" action="${pageContext.request.contextPath}/learner/course/module/material">
                        <button type="submit" name="completeMaterial" value="1" id="completeButton" class="btn btn-primary">Complete</button>
                        <input type="hidden" name="courseID" value="${Course.courseID}"/>
                        <input type="hidden" name="moduleID" value="${Material.module.moduleID}"/>
                        <input type="hidden" name="materialID" value="${Material.materialId}"/>
                    </form>
                </c:if>
                
                <%-- de ké o day 
                <c:if test="${StudyMap[Material.materialId]}">
                    <jsp:include page="/WEB-INF/views/comments_section.jsp" />
                </c:if>
                <c:if test="${!StudyMap[Material.materialId]}">
                    <div class="alert alert-info text-center mx-auto mt-5" style="width: 80%;">
                        Complete the material before !.
                    </div>
                </c:if>  --%>
                
                <%-- de ké o day --%>
                <jsp:include page="/WEB-INF/views/comments_section.jsp" /> 
            </div>
            <%System.out.println("c");%>
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
                                    <span class="material ">
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
                <div class="modal-content rounded-4 report-modal">


                    <form method="POST" action="${pageContext.request.contextPath}/report" 
                          onsubmit="return validateReportForm();">
                        <input type="hidden" name="action" value="reportMaterial">
                        <input type="hidden" name="courseId" value="${Course.courseID}">
                        <input type="hidden" name="moduleId" value="${Material.module.moduleID}">
                        <input type="hidden" name="materialId" value="${Material.materialId}">
                        <input type="hidden" name="userId" value="${sessionScope.user.userId}">


                        <!-- Step 1 -->
                        <div id="reportStep1">
                            <div class="modal-header border-0">
                                <h4 class="modal-title flex-grow-1 text-center fw-semibold m-0">Report</h4>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <h6 class="fw-bold">What's going on?</h6>
                                <p class="text-muted small">We'll check for all Community Guidelines, so don't worry about making the perfect choice.</p>

                                <c:forEach var="cate" items="${listReportCategory}">
                                    <div class="form-check mb-2">
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

                            <div class="modal-footer border-0">
                                <button type="button" class="btn btn-dark w-100 rounded-pill" id="nextStep" disabled>Next</button>
                            </div>
                        </div>

                        <!-- Step 2 -->
                        <div id="reportStep2" style="display: none;">
                            <div class="modal-header border-0 d-flex align-items-center justify-content-between">

                                <button type="button" class="btn btn-outline-secondary btn-sm me-2 px-3 py-2 rounded-pill" id="backStep">
                                    ← Back
                                </button>
                                <h4 class="modal-title mx-auto fw-semibold m-0 position-absolute start-50 translate-middle-x">Report</h4>

                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>

                            </div>
                            <input type="hidden" name="categoryId" id="selectedCategoryId" />

                            <div class="modal-body">
                                <h6 class="fw-bold">Want to tell us more? It's optional</h6>
                                <p class="text-muted small">Sharing a few details can help us understand the issue. Please don't include personal info or questions.</p>
                                <textarea name="reportDetail" class="form-control" rows="6" placeholder="Add details..."></textarea>
                            </div>

                            <div class="modal-footer border-0">
                                <button type="submit" class="btn btn-dark w-100 rounded-pill">Report</button>
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
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const radios = document.querySelectorAll('input[name="categorySelection"]');
                const nextBtn = document.getElementById("nextStep");
                const backBtn = document.getElementById("backStep");
                const selectedInput = document.getElementById("selectedCategoryId");

                const step1 = document.getElementById("reportStep1");
                const step2 = document.getElementById("reportStep2");
                console.log("radios: ", radios);
                radios.forEach(radio => {
                    radio.addEventListener("change", () => {
                        nextBtn.disabled = false;
                        console.log("radio.value", radio.value);
                        selectedInput.value = radio.value;
                        console.log("CateID: ", selectedInput);
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>