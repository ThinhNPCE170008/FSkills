<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Result Detail - F-SKILL</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <style>
        #main-body {
            background-color: white;
            padding: 0;
            min-height: 100vh;
            box-sizing: border-box;
            padding-bottom: 50px;
        }
        
        .result-detail-card {
            background: linear-gradient(145deg, #ffffff, #f8f9fa);
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        
        .result-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            padding: 2rem;
        }
        
        .info-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border-left: 4px solid #667eea;
        }
        
        .status-passed {
            background-color: #218334;
            color: white;
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .status-failed {
            background-color: #B93636;
            color: white;
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .questions-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .questions-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .questions-table th {
            border: none;
            padding: 1rem;
            font-weight: 600;
        }
        
        .questions-table td {
            border: none;
            padding: 1rem;
            vertical-align: top;
        }
        
        .questions-table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .question-text {
            font-weight: 500;
            color: #333;
            line-height: 1.6;
        }
        
        .answer-text {
            background: #e3f2fd;
            padding: 12px;
            border-radius: 8px;
            border-left: 4px solid #2196f3;
            color: #1565c0;
            font-weight: 500;
        }
        
        .choice-option {
            padding: 8px 12px;
            margin: 4px 0;
            border-radius: 6px;
            background: #f8f9fa;
        }
        
        .choice-selected {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            font-weight: 600;
            color: #1565c0;
        }
        
        .btn-back {
            background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(132, 250, 176, 0.4);
            color: white;
        }
    </style>
</head>
<body>
    <%@include file="../../layout/header.jsp" %>
    <%@include file="../../layout/sidebar_user.jsp"%>

    <main id="main-body" class="main d-flex">
        <div class="mt-5 flex-fill" style="margin-top: 60px !important;">
            <div class="container-fluid px-4 py-4">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/instructor/tests?action=list" class="text-decoration-none">
                                <i class="bi bi-journal-text"></i> Test Management
                            </a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/instructor/tests?action=studentResults" class="text-decoration-none">
                                <i class="bi bi-people"></i> Student Results
                            </a>
                        </li>
                        <li class="breadcrumb-item active">Detail</li>
                    </ol>
                </nav>

                <!-- Result Detail Card -->
                <div class="row justify-content-center">
                    <div class="col-lg-10">
                        <div class="card result-detail-card">
                            <!-- Result Header -->
                            <div class="result-header text-center">
                                <h1 class="display-6 mb-3">
                                    <i class="bi bi-person-check me-3"></i>
                                    Student Test Result
                                </h1>
                                <p class="lead mb-0">${studentResult.testName}</p>
                            </div>

                            <!-- Student Information -->
                            <div class="card-body p-4">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <h5 class="mb-2">
                                                <i class="bi bi-person text-primary me-2"></i>
                                                Student Information
                                            </h5>
                                            <p class="mb-1"><strong>Name:</strong> ${studentResult.fullName}</p>
                                            <p class="mb-0"><strong>Email:</strong> ${studentResult.email}</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <h5 class="mb-2">
                                                <i class="bi bi-clipboard-data text-primary me-2"></i>
                                                Test Information
                                            </h5>
                                            <p class="mb-1"><strong>Attempt:</strong> #${studentResult.attempt}</p>
                                            <p class="mb-0">
                                                <strong>Date Taken:</strong> 
                                                <fmt:formatDate value="${studentResult.dateTaken}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Test Result -->
                                <div class="mt-4">
                                    <h4 class="mb-3">
                                        <i class="bi bi-trophy text-primary me-2"></i>
                                        Test Result
                                    </h4>
                                    <div class="info-card">
                                        <div class="row align-items-center">
                                            <div class="col-md-4">
                                                <h6 class="mb-1">Score</h6>
                                                <p class="mb-0 fs-2 fw-bold text-primary">${studentResult.result}%</p>
                                            </div>
                                            <div class="col-md-4">
                                                <h6 class="mb-1">Status</h6>
                                                <span class="${studentResult.passed ? 'status-passed' : 'status-failed'}">
                                                    <i class="bi ${studentResult.passed ? 'bi-check-circle' : 'bi-x-circle'} me-1"></i>
                                                    ${studentResult.passed ? 'PASSED' : 'FAILED'}
                                                </span>
                                            </div>
                                            <div class="col-md-4">
                                                <h6 class="mb-1">Total Questions</h6>
                                                <p class="mb-0 fs-4 fw-bold">${userAnswers.size()}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Questions and Answers -->
                                <div class="mt-4">
                                    <h4 class="mb-3">
                                        <i class="bi bi-question-circle text-primary me-2"></i>
                                        Questions and Answers
                                    </h4>
                                    <div class="table-responsive">
                                        <table class="table questions-table">
                                            <thead>
                                                <tr>
                                                    <th style="width: 60%">Question</th>
                                                    <th style="width: 40%">Student Answer</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="userAnswer" items="${userAnswers}" varStatus="status">
                                                    <tr>
                                                        <td>
                                                            <div class="question-text">
                                                                <strong>Question ${status.index + 1}:</strong><br>
                                                                ${userAnswer.question.question}
                                                                
                                                                <!-- Show options for choice questions -->
                                                                <c:if test="${userAnswer.question.questionType == 'CHOICE'}">
                                                                    <div class="mt-3">
                                                                        <div class="choice-option ${userAnswer.answer == '1' ? 'choice-selected' : ''}">
                                                                            A. ${userAnswer.question.option1}
                                                                        </div>
                                                                        <div class="choice-option ${userAnswer.answer == '2' ? 'choice-selected' : ''}">
                                                                            B. ${userAnswer.question.option2}
                                                                        </div>
                                                                        <div class="choice-option ${userAnswer.answer == '3' ? 'choice-selected' : ''}">
                                                                            C. ${userAnswer.question.option3}
                                                                        </div>
                                                                        <div class="choice-option ${userAnswer.answer == '4' ? 'choice-selected' : ''}">
                                                                            D. ${userAnswer.question.option4}
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${userAnswer.question.questionType == 'CHOICE'}">
                                                                    <div class="answer-text">
                                                                        <strong>Selected:</strong>
                                                                        <c:choose>
                                                                            <c:when test="${userAnswer.answer == '1'}">A. ${userAnswer.question.option1}</c:when>
                                                                            <c:when test="${userAnswer.answer == '2'}">B. ${userAnswer.question.option2}</c:when>
                                                                            <c:when test="${userAnswer.answer == '3'}">C. ${userAnswer.question.option3}</c:when>
                                                                            <c:when test="${userAnswer.answer == '4'}">D. ${userAnswer.question.option4}</c:when>
                                                                            <c:otherwise>No answer selected</c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="answer-text">
                                                                        <c:choose>
                                                                            <c:when test="${not empty userAnswer.answer}">
                                                                                ${userAnswer.answer}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <em class="text-muted">No answer provided</em>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Back Button -->
                                <div class="text-center mt-5">
                                    <a href="${pageContext.request.contextPath}/instructor/tests?action=studentResults" 
                                       class="btn btn-back">
                                        <i class="bi bi-arrow-left me-2"></i>Back to Student Results
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@include file="../../layout/footer.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Script to ensure proper sidebar hover behavior
        document.addEventListener('DOMContentLoaded', function() {
            const sidebar = document.querySelector('.sidebar');
            const mainContent = document.querySelector('main');
            const header = document.querySelector('header');

            // Event handler functions defined outside to allow removal
            function handleSidebarMouseEnter() {
                const windowWidth = window.innerWidth;
                mainContent.style.transition = 'margin-left 0.2s ease, width 0.2s ease';

                if (windowWidth <= 768) {
                    // Mobile layout
                    mainContent.style.marginLeft = '250px';
                    if (header) {
                        header.style.left = '250px';
                        header.style.width = 'calc(100% - 266px)';
                    }
                } else {
                    // Desktop layout
                    mainContent.style.marginLeft = '250px';
                    if (header) {
                        header.style.left = '250px';
                        header.style.width = 'calc(100% - 266px)';
                    }
                }
            }

            function handleSidebarMouseLeave() {
                const windowWidth = window.innerWidth;
                mainContent.style.transition = 'margin-left 0.2s ease, width 0.2s ease';

                if (windowWidth <= 768) {
                    // Mobile layout
                    mainContent.style.marginLeft = '0';
                    if (header) {
                        header.style.left = '0';
                        header.style.width = 'calc(100% - 16px)';
                    }
                } else {
                    // Desktop layout
                    mainContent.style.marginLeft = '80px';
                    if (header) {
                        header.style.left = '80px';
                        header.style.width = 'calc(100% - 96px)';
                    }
                }
            }

            // Add event listeners
            sidebar.addEventListener('mouseenter', handleSidebarMouseEnter);
            sidebar.addEventListener('mouseleave', handleSidebarMouseLeave);

            // Set initial state based on window width
            handleSidebarMouseLeave();

            // Add resize event listener to handle window size changes
            window.addEventListener('resize', function() {
                // Update layout based on current sidebar state
                if (sidebar.matches(':hover')) {
                    handleSidebarMouseEnter();
                } else {
                    handleSidebarMouseLeave();
                }
            });
        });
    </script>
</body>
</html>