<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>${Course.courseName} Content</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <style>
            #main-body{
                background-color: white;
                padding: 0;
                min-height: 100vh;
                box-sizing: border-box;
                padding-bottom: 50px;
            }
            #siteContent{
                width: 100%;
            }
            #matList{
                flex: 1 1 0;
                min-width: 0;
                margin-top: 5vh;
                border-radius: 10px;
                overflow-y: auto;
                max-height: 100%;
            }
            #courseDetail{
                margin-left: 2vw;
                width: 65%;
            }
            #rightside{
                width: 35%;
            }

            #courseImage{
                width: 70%;
                height: auto;
            }
            #courseText{
                padding: 10px 30px 30px 30px;
                font-size: 22px;
                width: 100%;

            }
            #courseName{
                text-align: left;
                font-size: 48px;
                font-weight: 600;
                margin-bottom: 30px
            }
            #courseSum{
                margin-bottom: 15px;
            }
            #courseHighlight{
            }
            .contentBox{
                display: block;
                margin: 0 7vh;
                width: 80%;
            }
            .eachMat{
                display: grid;
                grid-template-columns: 50px auto;
                padding: 10px;
                padding-left: 50px;
                font-size: 16px;
            }
            .eachMat:hover{
                background-color: lightgray;
            }
            .listheader{
                display:block;
                font-size: 24px;
                width: 100%;
                background-color: lightgray;
                padding: 3vh 5vh 10px 3vh;
                text-decoration: none;
                color: black;
            }
            .check-icon{
                color: #009900;
                font-size: 22px;
                grid-row: 1 / span 2;
                align-self: center;
                text-align: center;
            }
            .mat-type{
                color: gray;
            }

            a.link{
                color: black;
            }

            ul.list{
                margin: 0;
                padding: 0;
            }

            .headlink{
                display: block;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 200px;
            }
            .arrow{
                padding: 0 15px;
            }
            .collapse.show {
                visibility: visible;
            }
            .collapse {
                transition: height 0.35s ease;
                overflow: hidden;
            }
            .arrow-icon {
                transition: transform 0.3s ease;
                margin: 0 10px;
            }

            .listheader[aria-expanded="true"] .arrow-icon {
                transform: rotate(180deg);
            }
            .text{
                font-size: 18px;
                margin-left: 100px;
            }


        </style>
    </head>
    <body>
        <%@include file="../../layout/header_user.jsp" %>
        <%@include file="../../layout/sidebar_user.jsp"%>

        <main id="main-body" class="main d-flex">
            <div id="courseDetail" class="mt-5 flex-fill">
                <div id="courseText">
                    <p id="courseName">${Course.courseName}</p>
                    <c:if test="${not empty Course.courseSummary}">
                        <p id="courseSum">${Course.courseSummary}</p>
                    </c:if>
                    <c:if test="${not empty Course.courseHighlight}">
                        <p id="courseHighlight">${Course.courseHighlight}</p>
                    </c:if>
                </div>

                <div id="siteContent" class="d-flex mx-auto">
                    <div id="matList" class="d-flex flex-column overflow-auto mx-auto">
                        <c:forEach var="mol" items="${ModuleList}" varStatus="loop">
                            <c:set var="matList" value="${matMap[mol.moduleID]}" />
                            <div class="contentBox">
                                <a class="listheader" data-bs-toggle="collapse" href="#list${loop.index}"
                                   role="button" aria-expanded="false" aria-controls="list${loop.index}">
                                    <i class="fa-solid fa-chevron-down arrow-icon"></i>
                                    <span class="flex-grow-1">${mol.moduleName}</span>
                                    <c:if test="${totalStudyMap[mol.moduleID]}">
                                        <span class="check-icon"><i class="fa-solid fa-circle-check"></i></span>
                                        </c:if>
                                </a>

                                <div id="list${loop.index}" class="collapse">
                                    <div class="list">
                                        <c:forEach var="mat" items="${matList}">
                                            <a class="link eachMat w-100"
                                               href="${pageContext.request.contextPath}/learner/course/module/material?courseID=${Course.courseID}&moduleID=${mol.moduleID}&materialID=${mat.materialId}">
                                                <c:if test="${studyMap[mat.materialId]}">
                                                    <span class="check-icon"><i class="fa-solid fa-circle-check"></i></span>
                                                    </c:if>
                                                <span class="flex-grow-1">${mat.materialName}</span>
                                                <span class="mat-type">${mat.type}</span>
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div id="rightside">
                <c:if test="${not empty Course.courseImageLocation}">
                    <img id="courseImage" class="mx-auto mt-5" src="${Course.imageDataURI}" alt="Course Image"/>
                </c:if>
                <div class="mt-5 text-start text">
                    <p><b>Author:</b> ${Course.user.userName}</p>
                    <p><b>Category:</b> ${Course.category.name}</p>
                    <p><b>Last update:</b> <fmt:formatDate value="${Course.courseLastUpdate}" pattern="dd/MM/yyyy"/></p>
                    <p><b>Progress:</b></p>
                    <div class="progress w-75" style="height: 20px">
                        <div class="progress-bar bg-success" role="progressbar" style="width: ${progress}%"
                             aria-valuenow="${progress}" aria-valuemin="0" aria-valuemax="100">
                            <b>${progress}%</b>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%@include file="../../layout/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>
