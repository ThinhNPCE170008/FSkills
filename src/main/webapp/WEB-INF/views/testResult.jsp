<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Results - F-SKILL</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <style>
        .result-container {
            background: linear-gradient(145deg, #f8f9fa, #ffffff);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            min-height: 80vh;
        }
        
        .result-header {
            color: white;
            border-radius: 20px 20px 0 0;
            padding: 3rem 2rem;
            text-align: center;
        }
        
        .result-header.passed {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .result-header.failed {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }
        
        .result-score {
            font-size: 4rem;
            font-weight: 800;
            text-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            margin: 1rem 0;
        }
        
        .result-status {
            font-size: 2rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 2px;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        
        .stats-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin: -50px 2rem 2rem;
            position: relative;
            z-index: 10;
        }
        
        .stat-item {
            text-align: center;
            padding: 2rem 1rem;
            border-right: 1px solid #e9ecef;
        }
        
        .stat-item:last-child {
            border-right: none;
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: #6c757d;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.9rem;
        }
        
        .question-review-card {
            background: white;
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .question-review-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }
        
        .question-review-header {
            padding: 1.5rem;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .question-number {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 1rem;
        }
        
        .answer-section {
            padding: 1.5rem;
        }
        
        .answer-option {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.8rem;
            transition: all 0.3s ease;
        }
        
        .answer-option.user-choice {
            background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
            border-color: #e17055;
            color: #2d3436;
            font-weight: 600;
        }
        
        .answer-option.correct-answer {
            background: linear-gradient(135deg, #55efc4, #00b894);
            border-color: #00a085;
            color: white;
            font-weight: 600;
        }
        
        .answer-option.user-choice.correct-answer {
            background: linear-gradient(135deg, #a29bfe, #6c5ce7);
            border-color: #5f3dc4;
        }
        
        .writing-answer {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1.5rem;
            min-height: 100px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .user-writing-answer {
            background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
            border-color: #e17055;
            color: #2d3436;
        }
        
        .points-badge {
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .points-earned {
            background: linear-gradient(135deg, #55efc4, #00b894);
            color: white;
        }
        
        .points-lost {
            background: linear-gradient(135deg, #fd79a8, #e84393);
            color: white;
        }
        
        .result-indicator {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
        }
        
        .indicator-correct {
            color: #00b894;
        }
        
        .indicator-incorrect {
            color: #e17055;
        }
        
        .indicator-partial {
            color: #fdcb6e;
        }
        
        .btn-action {
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .btn-retake {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
        }
        
        .btn-retake:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-back {
            background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
            border: none;
            color: white;
        }
        
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(132, 250, 176, 0.4);
            color: white;
        }
        
        .no-answers-message {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        
        .summary-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .performance-meter {
            height: 20px;
            background: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin: 1rem 0;
        }
        
        .performance-fill {
            height: 100%;
            border-radius: 10px;
            transition: width 1s ease-in-out;
        }
        
        .performance-fill.low {
            background: linear-gradient(90deg, #fa709a, #fee140);
        }
        
        .performance-fill.medium {
            background: linear-gradient(90deg, #ffeaa7, #fdcb6e);
        }
        
        .performance-fill.high {
            background: linear-gradient(90deg, #55efc4, #00b894);
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
                            <!-- Result Container -->
                            <div class="result-container">
                                <!-- Result Header -->
                                <div class="result-header ${testResult.passed ? 'passed' : 'failed'}">
                                    <h1 class="display-6 mb-3">
                                        <i class="bi ${testResult.passed ? 'bi-trophy' : 'bi-x-circle'} me-3"></i>
                                        Test Completed
                                    </h1>
                                    <h2 class="mb-2">${test.testName}</h2>
                                    <p class="mb-4 opacity-75">${test.module.course.courseName} - ${test.module.moduleName}</p>
                                    
                                    <div class="result-score">${testResult.result}%</div>
                                    <div class="result-status">
                                        <i class="bi ${testResult.passed ? 'bi-check-circle' : 'bi-x-circle'} me-2"></i>
                                        ${testResult.passed ? 'PASSED' : 'FAILED'}
                                    </div>
                                    
                                    <p class="mt-3 mb-0 opacity-75">
                                        Attempt #${testResult.attempt} • 
                                        Completed on <fmt:formatDate value="${testResult.dateTaken}" pattern="MMM dd, yyyy 'at' HH:mm"/>
                                    </p>
                                </div>

                                <!-- Statistics -->
                                <div class="stats-container">
                                    <div class="row g-0">
                                        <div class="col-md-3">
                                            <div class="stat-item">
                                                <div class="stat-value">${testResult.result}%</div>
                                                <div class="stat-label">Final Score</div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="stat-item">
                                                <div class="stat-value">${test.passPercentage}%</div>
                                                <div class="stat-label">Required</div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="stat-item">
                                                <div class="stat-value">${correctAnswers}</div>
                                                <div class="stat-label">Correct</div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="stat-item">
                                                <div class="stat-value">${totalQuestions}</div>
                                                <div class="stat-label">Total</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="p-4">
                                    <!-- Performance Summary -->
                                    <div class="summary-card">
                                        <h4 class="mb-3">
                                            <i class="bi bi-graph-up text-primary me-2"></i>
                                            Performance Summary
                                        </h4>
                                        <div class="row">
                                            <div class="col-md-8">
                                                <p class="mb-2">
                                                    You scored <strong>${testResult.result}%</strong> on this test.
                                                    <c:choose>
                                                        <c:when test="${testResult.passed}">
                                                            <span class="text-success fw-bold">Congratulations! You passed this test.</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-warning fw-bold">You need ${test.passPercentage}% to pass. Keep studying and try again!</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <div class="performance-meter">
                                                    <div class="performance-fill ${testResult.result < 50 ? 'low' : testResult.result < 80 ? 'medium' : 'high'}" style="width: ${testResult.result}%;"></div>
                                                </div>
                                                <div class="d-flex justify-content-between small text-muted">
                                                    <span>0%</span>
                                                    <span>Pass: ${test.passPercentage}%</span>
                                                    <span>100%</span>
                                                </div>
                                            </div>
                                            <div class="col-md-4 text-center">
                                                <div class="display-6 ${testResult.passed ? 'text-success' : 'text-warning'} mb-2">
                                                    <i class="bi ${testResult.passed ? 'bi-emoji-smile' : 'bi-emoji-neutral'}"></i>
                                                </div>
                                                <h5 class="${testResult.passed ? 'text-success' : 'text-warning'}">
                                                    ${testResult.passed ? 'Great Job!' : 'Keep Trying!'}
                                                </h5>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Question Review (if ShowAnswer is enabled) -->
                                    <c:choose>
                                        <c:when test="${test.showAnswer and not empty userAnswers}">
                                            <div class="mb-4">
                                                <h4 class="mb-4">
                                                    <i class="bi bi-list-check text-primary me-2"></i>
                                                    Question Review
                                                </h4>
                                                
                                                <c:forEach var="qa" items="${userAnswers}" varStatus="status">
                                                    <div class="question-review-card">
                                                        <div class="question-review-header position-relative">
                                                            <div class="d-flex align-items-start">
                                                                <div class="question-number">${status.index + 1}</div>
                                                                <div class="flex-grow-1">
                                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                                        <span class="badge ${qa.question.questionType == 'CHOICE' ? 'bg-info' : 'bg-warning'} text-white">
                                                                            <i class="bi ${qa.question.questionType == 'CHOICE' ? 'bi-check2-square' : 'bi-pencil-square'} me-1"></i>
                                                                            ${qa.question.questionType}
                                                                        </span>
                                                                        <span class="points-badge ${qa.corrected ? 'points-earned' : 'points-lost'}">
                                                                            ${qa.corrected ? qa.question.point : 0} / ${qa.question.point} points
                                                                        </span>
                                                                    </div>
                                                                    <h5 class="question-text mb-0">${qa.question.question}</h5>
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- Result Indicator -->
                                                            <div class="result-indicator">
                                                                <c:choose>
                                                                    <c:when test="${qa.corrected}">
                                                                        <i class="bi bi-check-circle-fill indicator-correct"></i>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="bi bi-x-circle-fill indicator-incorrect"></i>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="answer-section">
                                                            <c:choose>
                                                                <c:when test="${qa.question.questionType == 'CHOICE'}">
                                                                    <div class="choice-review">
                                                                        <c:if test="${not empty qa.question.option1}">
                                                                            <div class="answer-option ${qa.answer == '1' ? 'user-choice' : ''} ${qa.question.rightOption == 'A' ? 'correct-answer' : ''}">
                                                                                <div class="d-flex justify-content-between align-items-center">
                                                                                    <span><strong>A.</strong> ${qa.question.option1}</span>
                                                                                    <div>
                                                                                        <c:if test="${qa.answer == '1'}">
                                                                                            <span class="badge bg-warning text-dark me-2">Your Choice</span>
                                                                                        </c:if>
                                                                                        <c:if test="${qa.question.rightOption == 'A'}">
                                                                                            <span class="badge bg-success">Correct</span>
                                                                                        </c:if>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </c:if>
                                                                        <c:if test="${not empty qa.question.option2}">
                                                                            <div class="answer-option ${qa.answer == '2' ? 'user-choice' : ''} ${qa.question.rightOption == 'B' ? 'correct-answer' : ''}">
                                                                                <div class="d-flex justify-content-between align-items-center">
                                                                                    <span><strong>B.</strong> ${qa.question.option2}</span>
                                                                                    <div>
                                                                                        <c:if test="${qa.answer == '2'}">
                                                                                            <span class="badge bg-warning text-dark me-2">Your Choice</span>
                                                                                        </c:if>
                                                                                        <c:if test="${qa.question.rightOption == 'B'}">
                                                                                            <span class="badge bg-success">Correct</span>
                                                                                        </c:if>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </c:if>
                                                                        <c:if test="${not empty qa.question.option3}">
                                                                            <div class="answer-option ${qa.answer == '3' ? 'user-choice' : ''} ${qa.question.rightOption == 'C' ? 'correct-answer' : ''}">
                                                                                <div class="d-flex justify-content-between align-items-center">
                                                                                    <span><strong>C.</strong> ${qa.question.option3}</span>
                                                                                    <div>
                                                                                        <c:if test="${qa.answer == '3'}">
                                                                                            <span class="badge bg-warning text-dark me-2">Your Choice</span>
                                                                                        </c:if>
                                                                                        <c:if test="${qa.question.rightOption == 'C'}">
                                                                                            <span class="badge bg-success">Correct</span>
                                                                                        </c:if>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </c:if>
                                                                        <c:if test="${not empty qa.question.option4}">
                                                                            <div class="answer-option ${qa.answer == '4' ? 'user-choice' : ''} ${qa.question.rightOption == 'D' ? 'correct-answer' : ''}">
                                                                                <div class="d-flex justify-content-between align-items-center">
                                                                                    <span><strong>D.</strong> ${qa.question.option4}</span>
                                                                                    <div>
                                                                                        <c:if test="${qa.answer == '4'}">
                                                                                            <span class="badge bg-warning text-dark me-2">Your Choice</span>
                                                                                        </c:if>
                                                                                        <c:if test="${qa.question.rightOption == 'D'}">
                                                                                            <span class="badge bg-success">Correct</span>
                                                                                        </c:if>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </c:if>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="writing-review">
                                                                        <h6 class="mb-2">
                                                                            <i class="bi bi-pencil text-primary me-2"></i>
                                                                            Your Answer:
                                                                        </h6>
                                                                        <div class="writing-answer user-writing-answer">
                                                                            <c:choose>
                                                                                <c:when test="${not empty qa.answer}">
                                                                                    ${qa.answer}
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <em class="text-muted">No answer provided</em>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                        <small class="text-muted mt-2 d-block">
                                                                            <i class="bi bi-info-circle me-1"></i>
                                                                            Writing questions are manually graded by instructors.
                                                                        </small>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        
                                        <c:when test="${not test.showAnswer}">
                                            <div class="no-answers-message">
                                                <i class="bi bi-eye-slash display-1 text-muted mb-3"></i>
                                                <h4 class="text-muted">Answer Review Not Available</h4>
                                                <p class="text-muted">
                                                    The instructor has disabled answer review for this test. 
                                                    You can only see your final score and pass/fail status.
                                                </p>
                                            </div>
                                        </c:when>
                                    </c:choose>

                                    <!-- Action Buttons -->
                                    <div class="text-center mt-5">
                                        <a href="${pageContext.request.contextPath}/learner/tests?action=detail&testId=${test.testID}" 
                                           class="btn btn-back btn-action me-3">
                                            <i class="bi bi-arrow-left me-2"></i>Back to Test Details
                                        </a>
                                        <a href="${pageContext.request.contextPath}/learner/tests?action=take&testId=${test.testID}" 
                                           class="btn btn-retake btn-action">
                                            <i class="bi bi-arrow-clockwise me-2"></i>Retake Test
                                        </a>
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
    <script>
        // Animate performance meter on page load
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                const performanceFill = document.querySelector('.performance-fill');
                if (performanceFill) {
                    performanceFill.style.width = '${testResult.result}%';
                }
            }, 500);
        });
        
        // Add smooth scroll to question review
        function scrollToQuestionReview() {
            const questionReview = document.querySelector('.question-review-card');
            if (questionReview) {
                questionReview.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }
        
        // Add confetti effect for passed tests (optional)
        <c:if test="${testResult.passed}">
        document.addEventListener('DOMContentLoaded', function() {
            // Simple confetti effect using CSS animations
            function createConfetti() {
                const confetti = document.createElement('div');
                confetti.innerHTML = '🎉';
                confetti.style.position = 'fixed';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-10px';
                confetti.style.fontSize = '2rem';
                confetti.style.zIndex = '9999';
                confetti.style.pointerEvents = 'none';
                confetti.style.animation = 'fall 3s linear forwards';
                document.body.appendChild(confetti);
                
                setTimeout(() => {
                    confetti.remove();
                }, 3000);
            }
            
            // Add CSS for confetti animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fall {
                    to {
                        transform: translateY(100vh) rotate(360deg);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
            
            // Create multiple confetti pieces
            for (let i = 0; i < 20; i++) {
                setTimeout(createConfetti, i * 100);
            }
        });
        </c:if>
    </script>
</body>
</html> 