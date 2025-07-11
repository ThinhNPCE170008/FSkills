<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Details - F-SKILL</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <style>
        .test-detail-card {
            background: linear-gradient(145deg, #ffffff, #f8f9fa);
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        
        .test-detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }
        
        .test-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            padding: 1rem;
        }
        
        .test-info-item {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border-left: 4px solid #667eea;
        }
        
        .result-badge {
            font-size: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 50px;
        }
        
        .result-pass {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        .result-fail {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }
        
        .btn-take-test {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .btn-take-test:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-back {
            background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
            border: none;
            border-radius: 50px;
            padding: 10px 25px;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(132, 250, 176, 0.4);
            color: white;
        }
        
        .history-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .history-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .history-table th {
            border: none;
            padding: 1rem;
            font-weight: 600;
        }
        
        .history-table td {
            border: none;
            padding: 1rem;
            vertical-align: middle;
        }
        
        .history-table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .history-table tbody tr:hover {
            background-color: #e3f2fd;
            transition: background-color 0.3s ease;
        }
        
        #main-body{
            background-color: white;
            padding: 0;
            min-height: 100vh;
            box-sizing: border-box;
            padding-bottom: 50px;
        }
    </style>
</head>
<body>
    <%@include file="../../layout/header_user.jsp" %>
    <%@include file="../../layout/sidebar_user.jsp"%>

    <main id="main-body" class="main d-flex">
        <div class="mt-5 flex-fill">
            <div class="container-fluid px-4 py-4">
                            <!-- Breadcrumb -->
                            <nav aria-label="breadcrumb" class="mb-4">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/learner/tests?action=list" class="text-decoration-none">
                                            <i class="bi bi-journal-text"></i> Tests
                                        </a>
                                    </li>
                                    <li class="breadcrumb-item active">Detail</li>
                                </ol>
                            </nav>

                            <!-- Test Detail Card -->
                            <div class="row justify-content-center">
                                <div class="col-lg-10">
                                    <div class="card test-detail-card">
                                        <!-- Test Header -->
                                        <div class="test-header text-center">
                                            <h1 class="display-6 mb-3">
                                                <i class="bi bi-journal-text me-3"></i>
                                                Test ${test.testOrder} - ${test.module.moduleName}
                                            </h1>
                                            <p class="lead mb-0">${test.module.course.courseName}</p>
                                        </div>

                                        <!-- Test Information -->
                                        <div class="card-body p-4">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="test-info-item">
                                                        <h5 class="mb-2">
                                                            <i class="bi bi-question-circle text-primary me-2"></i>
                                                            Total Questions
                                                        </h5>
                                                        <p class="mb-0 fs-4 fw-bold text-primary">${test.questionCount}</p>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="test-info-item">
                                                        <h5 class="mb-2">
                                                            <i class="bi bi-trophy text-warning me-2"></i>
                                                            Pass Percentage
                                                        </h5>
                                                        <p class="mb-0 fs-4 fw-bold text-warning">${test.passPercentage}%</p>
                                                    </div>
                                                </div>
                                            </div>

<%--                                            <div class="row mt-3">--%>
<%--                                                <div class="col-md-6">--%>
<%--                                                    <div class="test-info-item">--%>
<%--                                                        <h5 class="mb-2">--%>
<%--                                                            <i class="bi bi-shuffle text-info me-2"></i>--%>
<%--                                                            Question Order--%>
<%--                                                        </h5>--%>
<%--                                                        <p class="mb-0 fs-5">--%>
<%--                                                            <c:choose>--%>
<%--                                                                <c:when test="${test.isRandomize}">--%>
<%--                                                                    <span class="badge bg-info">Randomized</span>--%>
<%--                                                                </c:when>--%>
<%--                                                                <c:otherwise>--%>
<%--                                                                    <span class="badge bg-secondary">Sequential</span>--%>
<%--                                                                </c:otherwise>--%>
<%--                                                            </c:choose>--%>
<%--                                                        </p>--%>
<%--                                                    </div>--%>
<%--                                                </div>--%>
<%--                                                <div class="col-md-6">--%>
<%--                                                    <div class="test-info-item">--%>
<%--                                                        <h5 class="mb-2">--%>
<%--                                                            <i class="bi bi-eye text-success me-2"></i>--%>
<%--                                                            Answer Review--%>
<%--                                                        </h5>--%>
<%--                                                        <p class="mb-0 fs-5">--%>
<%--                                                            <c:choose>--%>
<%--                                                                <c:when test="${test.showAnswer}">--%>
<%--                                                                    <span class="badge bg-success">Available</span>--%>
<%--                                                                </c:when>--%>
<%--                                                                <c:otherwise>--%>
<%--                                                                    <span class="badge bg-warning">Not Available</span>--%>
<%--                                                                </c:otherwise>--%>
<%--                                                            </c:choose>--%>
<%--                                                        </p>--%>
<%--                                                    </div>--%>
<%--                                                </div>--%>
<%--                                            </div>--%>

                                            <!-- Latest Result -->
                                            <c:if test="${not empty latestResult}">
                                                <div class="mt-4">
                                                    <h4 class="mb-3">
                                                        <i class="bi bi-clock-history text-primary me-2"></i>
                                                        Latest Result
                                                    </h4>
                                                    <div class="test-info-item">
                                                        <div class="row align-items-center">
                                                            <div class="col-md-4">
                                                                <h6 class="mb-1">Score</h6>
                                                                <p class="mb-0 fs-4 fw-bold">${latestResult.result}%</p>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <h6 class="mb-1">Status</h6>
                                                                <span class="result-badge ${latestResult.passed ? 'result-pass' : 'result-fail'}">
                                                                    <i class="bi ${latestResult.passed ? 'bi-check-circle' : 'bi-x-circle'} me-1"></i>
                                                                    ${latestResult.passed ? 'PASSED' : 'FAILED'}
                                                                </span>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <h6 class="mb-1">Attempt</h6>
                                                                <p class="mb-0 fs-5">#${latestResult.attempt}</p>
                                                            </div>
                                                        </div>
                                                        <c:if test="${test.showAnswer}">
                                                            <div class="mt-3">
                                                                <a href="${pageContext.request.contextPath}/learner/tests?action=result&testResultId=${latestResult.testResultID}" 
                                                                   class="btn btn-outline-primary">
                                                                    <i class="bi bi-eye me-2"></i>View Detailed Results
                                                                </a>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <!-- Test History -->
                                            <c:if test="${not empty testHistory}">
                                                <div class="mt-4">
                                                    <h4 class="mb-3">
                                                        <i class="bi bi-list-ul text-primary me-2"></i>
                                                        Test History
                                                    </h4>
                                                    <div class="table-responsive">
                                                        <table class="table history-table">
                                                            <thead>
                                                                <tr>
                                                                    <th>Attempt</th>
                                                                    <th>Score</th>
                                                                    <th>Status</th>
                                                                    <th>Date Taken</th>
                                                                    <th>Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="result" items="${testHistory}">
                                                                    <tr>
                                                                        <td class="fw-bold">#${result.attempt}</td>
                                                                        <td class="fw-bold">${result.result}%</td>
                                                                        <td>
                                                                                                                                                    <span class="result-badge ${result.passed ? 'result-pass' : 'result-fail'}">
                                                                            <i class="bi ${result.passed ? 'bi-check-circle' : 'bi-x-circle'} me-1"></i>
                                                                            ${result.passed ? 'PASSED' : 'FAILED'}
                                                                        </span>
                                                                        </td>
                                                                        <td>
                                                                            <fmt:formatDate value="${result.dateTaken}" pattern="MMM dd, yyyy HH:mm"/>
                                                                        </td>
                                                                        <td>
                                                                            <c:if test="${test.showAnswer}">
                                                                                                                                                <a href="${pageContext.request.contextPath}/learner/tests?action=result&testResultId=${result.testResultID}" 
                                                                   class="btn btn-sm btn-outline-primary">
                                                                    <i class="bi bi-eye me-1"></i>View
                                                                </a>
                                                                            </c:if>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <!-- Action Buttons -->
                                            <div class="text-center mt-5">
                                                <a href="${pageContext.request.contextPath}/learner/tests?action=list" 
                                                   class="btn btn-back me-3">
                                                    <i class="bi bi-arrow-left me-2"></i>Back to Tests
                                                </a>
                                                <a href="${pageContext.request.contextPath}/learner/tests?action=take&testId=${test.testID}" 
                                                   class="btn btn-take-test">
                                                    <i class="bi bi-play-circle me-2"></i>Take Test
                                                </a>
                                            </div>
                                        </div>
                                    </div>
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
</body>
</html> 