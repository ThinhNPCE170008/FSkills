<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>${Course.courseName} Content</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" integrity="sha384-XGjxtQfXaH2tnPFa9x+ruJTuLE3Aa6LhHSWRr1XeTyhezb4abCG4ccI5AkVDxqC+" crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <style>
            :root {
                --primary-color: #2c3e50;
                --secondary-color: #3498db;
                --success-color: #2ecc71;
                --background-color: #f8f9fa;
                --card-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            #main-body {
                background-color: var(--background-color) !important;
                padding: 2rem;
                min-height: 100vh;
                box-sizing: border-box;
            }

            #siteContent {
                width: 100%;
                max-width: 1200px;
                margin: 0 auto;
            }

            #matList {
                margin-top: 2rem;
                border-radius: 8px;
            }

            #courseDetail {
                width: 65%;
                padding-right: 2rem;
            }

            #rightside {
                width: 35%;
                background: white;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: var(--card-shadow);
            }

            #courseImage {
                width: 100%;
                height: auto;
                border-radius: 8px;
                object-fit: cover;
            }

            #courseText {
                padding: 2rem;
                background: white;
                border-radius: 8px;
                box-shadow: var(--card-shadow);
                margin-bottom: 2rem;
            }

            #courseName {
                font-size: 2.5rem;
                font-weight: 700;
                color: var(--primary-color);
                margin-bottom: 1.5rem;
            }

            #courseSum, #courseHighlight {
                font-size: 1.1rem;
                line-height: 1.6;
                color: #4a4a4a;
                margin-bottom: 1rem;
            }

            .contentBox {
                margin: 1rem 0;
                background: white;
                border-radius: 8px;
                box-shadow: var(--card-shadow);
                transition: transform 0.3s ease;
            }

            .contentBox:hover {
                transform: translateY(-5px);
            }

            .eachMat {
                display: grid !important;
                grid-template-columns: 40px 1fr 100px;
                padding: 1rem;
                border-bottom: 1px solid #eee;
                transition: background-color 0.2s ease;
                color: var(--primary-color) !important;
                visibility: visible !important;
                font-size: 1rem !important;
            }

            .eachMat:hover {
                background-color: #f5f5f5;
            }

            .listheader {
                display: flex !important;
                align-items: center !important;
                font-size: 1.25rem;
                font-weight: 600;
                padding: 1rem 1.5rem;
                background: var(--secondary-color) !important;
                color: white !important;
                border-radius: 8px 8px 0 0;
                text-decoration: none;
                transition: background-color 0.2s ease;
            }

            .listheader:hover {
                background-color: #2980b9 !important;
            }

            .check-icon {
                color: var(--success-color) !important;
                font-size: 1.5rem !important;
                align-self: center;
                text-align: center;
                display: block !important;
                visibility: visible !important;
            }

            .mat-type {
                color: #6c757d !important;
                font-size: 0.9rem !important;
                text-align: right;
                display: block !important;
                visibility: visible !important;
            }

            a.link {
                color: var(--primary-color) !important;
                text-decoration: none;
                transition: color 0.2s ease;
                display: grid !important;
                align-items: center;
                visibility: visible !important;
            }

            a.link:hover {
                color: var(--secondary-color) !important;
            }

            ul.list {
                margin: 0;
                padding: 0;
                list-style: none;
                display: block !important;
                visibility: visible !important;
            }

            .arrow-icon {
                transition: transform 0.3s ease;
                margin-right: 1rem;
                display: block !important;
                visibility: visible !important;
            }

            .listheader[aria-expanded="true"] .arrow-icon {
                transform: rotate(180deg);
            }

            .text {
                font-size: 1rem;
                line-height: 1.6;
                color: #4a4a4a;
            }

            .progress {
                height: 1.5rem;
                background: #e9ecef;
                border-radius: 0.75rem;
                overflow: hidden;
            }

            .progress-bar {
                background: var(--success-color) !important;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: width 0.6s ease;
            }

            /* Accordion-specific styles with ultra-high specificity to override Tailwind */
            #matList.accordion#moduleAccordion {
                display: block !important;
                background: transparent !important;
            }

            #matList .accordion-item {
                border: none !important;
                background: transparent !important;
            }

            #matList .accordion-header {
                margin: 0 !important;
                padding: 0 !important;
            }

            #matList .accordion-button {
                background: var(--secondary-color) !important;
                color: white !important;
                border-radius: 8px 8px 0 0 !important;
                box-shadow: none !important;
                padding: 1rem 1.5rem !important;
                display: flex !important;
                align-items: center !important;
                border: none !important;
            }

            #matList .accordion-button:not(.collapsed) {
                background: #2980b9 !important;
                color: white !important;
            }

            #matList .accordion-button:focus {
                box-shadow: none !important;
                outline: none !important;
                border: none !important;
            }

            /* Ultra-specific selectors to ensure transition */
            html body #matList.accordion#moduleAccordion .accordion-collapse {
                height: 0 !important;
                overflow: hidden !important;
                transition: height 0.35s ease !important;
                display: block !important;
                visibility: visible !important;
                max-height: none !important;
            }

            html body #matList.accordion#moduleAccordion .accordion-collapse.show {
                height: auto !important;
                overflow: visible !important;
                transition: height 0.35s ease !important;
                max-height: 3000px !important; /* Fallback */
            }

            html body #matList.accordion#moduleAccordion .accordion-collapse.collapsing {
                overflow: hidden !important;
                transition: height 0.35s ease !important;
                max-height: 3000px !important; /* Fallback */
            }

            /* Explicitly disable Tailwind utilities */
            html body #matList.accordion#moduleAccordion .accordion-collapse {
                transition-property: height !important;
                transition-duration: 0.35s !important;
                transition-timing-function: ease !important;
                display: block !important;
                visibility: visible !important;
                max-height: none !important;
                opacity: 1 !important;
            }

            /* Ensure accordion body is visible */
            html body #matList.accordion#moduleAccordion .accordion-body {
                padding: 0.5rem 1.5rem !important;
                background: white !important;
                border-radius: 0 0 8px 8px !important;
                display: block !important;
                visibility: visible !important;
                color: var(--primary-color) !important;
                opacity: 1 !important;
            }

            html body #matList.accordion#moduleAccordion .accordion-body ul.list {
                display: block !important;
                visibility: visible !important;
                color: var(--primary-color) !important;
                opacity: 1 !important;
            }

            html body #matList.accordion#moduleAccordion .accordion-body ul.list li {
                display: block !important;
                visibility: visible !important;
                color: var(--primary-color) !important;
                opacity: 1 !important;
            }

            html body #matList.accordion#moduleAccordion .accordion-body ul.list li a.link span {
                display: block !important;
                visibility: visible !important;
                color: var(--primary-color) !important;
                font-size: 1rem !important;
                line-height: 1.6 !important;
                opacity: 1 !important;
            }

            @media (max-width: 992px) {
                #courseDetail, #rightside {
                    width: 100% !important;
                }
                #rightside {
                    margin-top: 2rem;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="../../layout/header_user.jsp" %>
        <%@include file="../../layout/sidebar_user.jsp"%>

        <main id="main-body" class="main d-flex">
            <div id="siteContent" class="d-flex flex-column flex-lg-row">
                <div id="courseDetail">
                    <div id="courseText">
                        <h1 id="courseName">${Course.courseName}</h1>
                        <c:if test="${not empty Course.courseSummary}">
                            <p id="courseSum">${Course.courseSummary}</p>
                        </c:if>
                        <c:if test="${not empty Course.courseHighlight}">
                            <p id="courseHighlight">${Course.courseHighlight}</p>
                        </c:if>
                    </div>

                    <div id="matList" class="accordion" id="moduleAccordion">
                        <c:forEach var="mol" items="${ModuleList}" varStatus="loop">
                            <c:set var="matList" value="${matMap[mol.moduleID]}" />
                            <div class="accordion-item contentBox">
                                <h2 class="accordion-header">
                                    <button class="listheader accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                            data-bs-target="#list${loop.index}" aria-expanded="false" aria-controls="list${loop.index}">
                                        <i class="fa-solid fa-chevron-down arrow-icon"></i>
                                        <span class="flex-grow-1">${mol.moduleName}</span>
                                        <c:if test="${totalStudyMap[mol.moduleID]}">
                                            <span class="check-icon"><i class="fa-solid fa-circle-check"></i></span>
                                        </c:if>
                                    </button>
                                </h2>
                                <div id="list${loop.index}" class="accordion-collapse collapse" data-bs-parent="#moduleAccordion">
                                    <div class="accordion-body">
                                        <ul class="list">
                                            <c:choose>
                                                <c:when test="${not empty matList}">
                                                    <c:forEach var="mat" items="${matList}">
                                                        <li>
                                                            <a class="link eachMat w-100"
                                                               href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${Course.courseID}&moduleID=${mol.moduleID}&materialID=${mat.materialId}">
                                                                <span class="check-icon">
                                                                    <c:if test="${studyMap[mat.materialId]}">
                                                                        <i class="fa-solid fa-circle-check"></i>
                                                                    </c:if>
                                                                </span>
                                                                <span class="flex-grow-1">${mat.materialName}</span>
                                                                <span class="mat-type">${mat.type}</span>
                                                            </a>
                                                        </li>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <li>No materials available for this module.</li>
                                                </c:otherwise>
                                            </c:choose>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div id="rightside">
                    <c:if test="${not empty Course.courseImageLocation}">
                        <img id="courseImage" src="${Course.imageDataURI}" alt="Course Image"/>
                    </c:if>
                    <div class="mt-4 text">
                        <p><b>Author:</b> ${Course.user.userName}</p>
                        <p><b>Category:</b> ${Course.category.name}</p>
                        <p><b>Last update:</b> <fmt:formatDate value="${Course.courseLastUpdate}" pattern="dd/MM/yyyy"/></p>
                        <p><b>Progress:</b></p>
                        <div class="progress w-100">
                            <div class="progress-bar bg-success" role="progressbar" style="width: ${progress}%"
                                 aria-valuenow="${progress}" aria-valuemin="0" aria-valuemax="100">
                                ${progress}%
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%@include file="../../layout/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    </body>
</html>