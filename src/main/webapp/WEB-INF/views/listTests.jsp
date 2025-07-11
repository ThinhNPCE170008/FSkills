<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Available Tests - F-Skills</title>
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
            #testList{
                flex: 1 1 0;
                min-width: 0;
                margin-top: 5vh;
                border-radius: 10px;
                overflow-y: auto;
                max-height: 100%;
            }
            #testDetail{
                margin-left: 2vw;
                width: 65%;
            }
            #rightside{
                width: 35%;
            }

            #testText{
                padding: 10px 30px 30px 30px;
                font-size: 22px;
                width: 100%;
            }
            #testTitle{
                text-align: left;
                font-size: 48px;
                font-weight: 600;
                margin-bottom: 30px
            }
            #testSubtitle{
                margin-bottom: 15px;
                color: #6c757d;
                font-size: 18px;
            }
            .contentBox{
                display: block;
                margin: 0 7vh;
                width: 80%;
            }
            .filterBox{
                background: white;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                border: 1px solid #dee2e6;
            }
            .eachTest{
                display: grid;
                grid-template-columns: 1fr auto;
                padding: 15px 20px;
                margin-bottom: 10px;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                background: white;
                transition: all 0.3s ease;
            }
            .eachTest:hover{
                background-color: #f8f9fa;
                border-color: #4f46e5;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            .testInfo{
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .testTitle{
                font-size: 18px;
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
            }
            .testMeta{
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                color: #6c757d;
                font-size: 14px;
            }
            .testMeta span{
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .testActions{
                display: flex;
                gap: 10px;
                justify-content: center;
                align-items: flex-end;
            }
            .btn-take-test{
                background-color: #4f46e5;
                border-color: #4f46e5;
                color: white;
                padding: 8px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 14px;
                transition: all 0.3s ease;
            }
            .btn-take-test:hover{
                background-color: #3730a3;
                border-color: #3730a3;
                color: white;
                transform: translateY(-1px);
            }
            .btn-view-detail{
                background-color: transparent;
                border: 1px solid #6c757d;
                color: #6c757d;
                padding: 6px 16px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 12px;
                transition: all 0.3s ease;
            }
            .btn-view-detail:hover{
                background-color: #6c757d;
                color: white;
            }
            .result-badge{
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
            }
            .result-passed{
                background-color: #d4edda;
                color: #155724;
            }
            .result-failed{
                background-color: #f8d7da;
                color: #721c24;
            }
            .no-tests{
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }
            .no-tests i{
                font-size: 64px;
                margin-bottom: 20px;
                opacity: 0.5;
            }
        </style>
    </head>
    <body>
        <%@include file="../../layout/header_user.jsp" %>
        <%@include file="../../layout/sidebar_user.jsp"%>

        <main id="main-body" class="main d-flex">
            <div id="testDetail" class="mt-5 flex-fill">
                <div id="testText">
                    <p id="testTitle">Available Tests</p>
                    <p id="testSubtitle">Take tests from your enrolled courses to assess your knowledge</p>
                </div>

                <div id="siteContent" class="d-flex mx-auto">
                    <div id="testList" class="d-flex flex-column overflow-auto mx-auto">
                        <!-- Filter Section -->
                        <div class="contentBox">
                            <div class="filterBox">
                                <h5><i class="fas fa-filter"></i> Filters</h5>
                                <form method="GET" action="${pageContext.request.contextPath}/learner/tests">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label class="form-label">Course</label>
                                            <select class="form-select" name="courseId" id="courseSelect" onchange="loadModules()">
                                                <option value="">All Courses</option>
                                                <c:forEach var="course" items="${enrolledCourses}">
                                                    <option value="${course.courseID}" 
                                                        ${selectedCourseId == course.courseID ? 'selected' : ''}>
                                                        ${course.courseName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Module</label>
                                            <select class="form-select" name="moduleId" id="moduleSelect">
                                                <option value="">All Modules</option>
                                                <c:forEach var="module" items="${modules}">
                                                    <option value="${module.moduleID}" 
                                                        ${selectedModuleId == module.moduleID ? 'selected' : ''}>
                                                        ${module.moduleName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search"></i> Filter
                                        </button>
                                        <a href="${pageContext.request.contextPath}/learner/tests" class="btn btn-outline-secondary">
                                            <i class="fas fa-times"></i> Clear
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Tests List -->
                        <div class="contentBox">
                            <c:choose>
                                <c:when test="${empty tests}">
                                    <div class="no-tests">
                                        <i class="fas fa-clipboard-list"></i>
                                        <h4>No Tests Available</h4>
                                        <p>There are no tests available in your enrolled courses at the moment.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="test" items="${tests}">
                                        <div class="eachTest">
                                            <div class="testInfo">
                                                <div class="testTitle">
                                                    Test ${test.testOrder} - ${test.module.moduleName}
                                                </div>
                                                <div class="testMeta">
                                                    <span>
                                                        <i class="fas fa-book"></i>
                                                        Course: ${test.module.course.courseName}
                                                    </span>
                                                    <span>
                                                        <i class="fas fa-question-circle"></i>
                                                        ${test.questionCount} Questions
                                                    </span>
                                                    <span>
                                                        <i class="fas fa-percentage"></i>
                                                        Pass: ${test.passPercentage}%
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="testActions">
                                                <a href="${pageContext.request.contextPath}/learner/tests?action=take&testId=${test.testID}" 
                                                   class="btn-take-test">
                                                    <i class="fas fa-play"></i> Take Test
                                                </a>
                                                <a href="${pageContext.request.contextPath}/learner/tests?action=detail&testId=${test.testID}"
                                                   class="btn-view-detail">
                                                    <i class="fas fa-info-circle"></i> Details
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div id="rightside">
                <div class="mt-5 text-start" style="padding: 20px;">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-info-circle text-primary"></i>
                                Test Information
                            </h5>
                            <ul class="list-unstyled">
                                <li class="mb-2">
                                    <i class="fas fa-check-circle text-success"></i>
                                    You can retake tests multiple times
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-clock text-warning"></i>
                                    No time limit for tests
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-random text-info"></i>
                                    Some tests may have randomized questions
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-eye text-secondary"></i>
                                    Answer visibility depends on test settings
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%@include file="../../layout/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        
        <script>
            function loadModules() {
                const courseSelect = document.getElementById('courseSelect');
                const moduleSelect = document.getElementById('moduleSelect');
                
                // Clear modules
                moduleSelect.innerHTML = '<option value="">All Modules</option>';
                
                const courseId = courseSelect.value;
                if (!courseId) {
                    return;
                }
                
                // Show loading
                moduleSelect.innerHTML = '<option value="">Loading modules...</option>';
                
                // Fetch modules for the selected course
                fetch('${pageContext.request.contextPath}/learner/tests?action=getModules&courseId=' + courseId)
                    .then(response => response.json())
                    .then(modules => {
                        moduleSelect.innerHTML = '<option value="">All Modules</option>';
                        modules.forEach(module => {
                            const option = document.createElement('option');
                            option.value = module.moduleID;
                            option.textContent = module.moduleName;
                            moduleSelect.appendChild(option);
                        });
                    })
                    .catch(error => {
                        console.error('Error loading modules:', error);
                        moduleSelect.innerHTML = '<option value="">Error loading modules</option>';
                    });
            }
        </script>
    </body>
</html> 