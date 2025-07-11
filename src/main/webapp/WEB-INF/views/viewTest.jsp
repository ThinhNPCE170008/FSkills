<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>View Test | F-Skill</title>
    <meta charset="UTF-8">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }

        h2 {
            color: #343a40;
            margin-bottom: 25px;
        }

        .test-info {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }

        .question-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background-color: white;
        }

        .question-header {
            background-color: #4f46e5;
            color: white;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .option {
            padding: 8px 0;
            margin: 5px 0;
        }

        .correct-option {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 4px;
            padding: 8px 12px;
            margin: 5px 0;
            color: #155724;
        }

        .incorrect-option {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 8px 12px;
            margin: 5px 0;
            color: #6c757d;
        }

        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }

        .badge-custom {
            font-size: 0.9rem;
            padding: 8px 12px;
        }

        .correct-answer-icon {
            color: #28a745;
            margin-right: 8px;
        }
    </style>
</head>
<body>
<jsp:include page="/layout/sidebar_user.jsp"/>

<div class="container px-5 py-6">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <a href="${pageContext.request.contextPath}/instructor/tests?action=listByModule&moduleId=${test.moduleID}" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back
        </a>
        
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/instructor/tests?action=update&testId=${test.testID}" class="btn btn-warning">
                <i class="fas fa-edit"></i> Edit Test
            </a>
        </div>
    </div>

    <h2 class="mb-4 fw-bold fs-3">
        <i class="fas fa-eye"></i> View Test #${test.testID}
    </h2>

    <!-- Test Information -->
    <div class="test-info">
        <div class="row">
            <div class="col-md-8">
                <h4><i class="fas fa-info-circle"></i> Test Information</h4>
                <div class="row mt-3">
                    <div class="col-sm-4"><strong>Test ID:</strong></div>
                    <div class="col-sm-8">#${test.testID}</div>
                </div>
                <div class="row mt-2">
                    <div class="col-sm-4"><strong>Module:</strong></div>
                    <div class="col-sm-8">${test.module.moduleName}</div>
                </div>
                <div class="row mt-2">
                    <div class="col-sm-4"><strong>Test Order:</strong></div>
                    <div class="col-sm-8"><span class="badge bg-primary">${test.testOrder}</span></div>
                </div>
                <div class="row mt-2">
                    <div class="col-sm-4"><strong>Pass Percentage:</strong></div>
                    <div class="col-sm-8"><span class="badge bg-success">${test.passPercentage}%</span></div>
                </div>
                <div class="row mt-2">
                    <div class="col-sm-4"><strong>Randomize Questions:</strong></div>
                    <div class="col-sm-8">
                        <c:choose>
                            <c:when test="${test.randomize}">
                                <span class="badge bg-info"><i class="fas fa-check"></i> Yes</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary"><i class="fas fa-times"></i> No</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-sm-4"><strong>Show Answers:</strong></div>
                    <div class="col-sm-8">
                        <c:choose>
                            <c:when test="${test.showAnswer}">
                                <span class="badge bg-info"><i class="fas fa-check"></i> Yes</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary"><i class="fas fa-times"></i> No</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-sm-4"><strong>Last Updated:</strong></div>
                    <div class="col-sm-8">
                        <c:choose>
                            <c:when test="${not empty test.testLastUpdate}">
                                <span class="datetime" data-utc="${test.testLastUpdate}Z"></span>
                            </c:when>
                            <c:otherwise>N/A</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="stats-card">
                    <h5><i class="fas fa-chart-bar"></i> Test Statistics</h5>
                    <div class="row text-center mt-3">
                        <div class="col-6">
                            <h3 class="mb-1">${questionCount}</h3>
                            <small>Questions</small>
                        </div>
                        <div class="col-6">
                            <h3 class="mb-1">${totalPoints}</h3>
                            <small>Total Points</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Questions -->
    <div class="mb-4">
        <h4 class="mb-3"><i class="fas fa-question-circle"></i> Questions (${questionCount})</h4>
        
        <c:choose>
            <c:when test="${empty questions}">
                <div class="alert alert-warning text-center">
                    <i class="fas fa-exclamation-triangle"></i> No questions available for this test.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="question" items="${questions}" varStatus="status">
                    <div class="question-card">
                        <div class="question-header">
                            <span><strong>Question ${status.index + 1}</strong></span>
                            <div>
                                <span class="badge bg-light text-dark">${question.questionType}</span>
                                <span class="badge bg-warning text-dark">${question.point} point(s)</span>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <h6 class="fw-bold">${question.question}</h6>
                        </div>
                        
                        <div class="options">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="${question.rightOption == 'A' ? 'correct-option' : 'incorrect-option'}">
                                        <c:if test="${question.rightOption == 'A'}">
                                            <i class="fas fa-check-circle correct-answer-icon"></i>
                                        </c:if>
                                        <strong>A.</strong> ${question.option1}
                                    </div>
                                    
                                    <c:if test="${not empty question.option3}">
                                        <div class="${question.rightOption == 'C' ? 'correct-option' : 'incorrect-option'}">
                                            <c:if test="${question.rightOption == 'C'}">
                                                <i class="fas fa-check-circle correct-answer-icon"></i>
                                            </c:if>
                                            <strong>C.</strong> ${question.option3}
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="${question.rightOption == 'B' ? 'correct-option' : 'incorrect-option'}">
                                        <c:if test="${question.rightOption == 'B'}">
                                            <i class="fas fa-check-circle correct-answer-icon"></i>
                                        </c:if>
                                        <strong>B.</strong> ${question.option2}
                                    </div>
                                    
                                    <c:if test="${not empty question.option4}">
                                        <div class="${question.rightOption == 'D' ? 'correct-option' : 'incorrect-option'}">
                                            <c:if test="${question.rightOption == 'D'}">
                                                <i class="fas fa-check-circle correct-answer-icon"></i>
                                            </c:if>
                                            <strong>D.</strong> ${question.option4}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-3 text-end">
                            <small class="text-muted">
                                <i class="fas fa-bullseye"></i> Correct Answer: 
                                <span class="badge bg-success">${question.rightOption}</span>
                            </small>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/layout/footer.jsp"/>
<script src="${pageContext.request.contextPath}/layout/formatUtcToVietnamese.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html> 