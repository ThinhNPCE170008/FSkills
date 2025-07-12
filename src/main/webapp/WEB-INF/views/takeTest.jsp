<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Take Test - F-SKILL</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <style>
        .test-container {
            background: linear-gradient(145deg, #f8f9fa, #ffffff);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            min-height: 80vh;
        }
        
        .test-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            padding: 2rem;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .progress-container {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
        }
        
        .progress-bar {
            background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%);
            border-radius: 10px;
        }
        
        .question-card {
            background: white;
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
            transition: all 0.3s ease;
        }
        
        .question-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }
        
        .question-header {
            background: #f8f9fa;
            border-radius: 15px 15px 0 0;
            padding: 1.5rem;
            border-bottom: 2px solid #e9ecef;
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
                .choice-options{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.8rem;
        }
        .choice-option {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .choice-option:hover {
            background: #e3f2fd;
            border-color: #2196f3;
            transform: translateX(5px);
        }
        
        .choice-option.selected {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
            color: white;
        }
        
        .choice-option input[type="radio"] {
            margin-right: 0.8rem;
            transform: scale(1.2);
        }
        
        .writing-textarea {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
            resize: vertical;
            min-height: 150px;
            transition: border-color 0.3s ease;
        }
        
        .writing-textarea:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .submit-section {
            background: linear-gradient(145deg, #ffffff, #f8f9fa);
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            position: sticky;
            bottom: 20px;
        }
        
        .btn-submit-test {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border: none;
            border-radius: 15px;
            padding: 5px 15px;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .btn-submit-test:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(79, 172, 254, 0.4);
            color: white;
        }
        
        .btn-cancel {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            border: none;
            border-radius: 15px;
            padding: 5px 10px;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(250, 112, 154, 0.4);
            color: white;
        }
        
        .question-type-badge {
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge-choice {
            background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
            color: white;
        }
        
        .badge-writing {
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            color: #8b4513;
        }
        
        .answer-counter {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            padding: 0.4rem 0.8rem;
            font-weight: 600;
            color: #667eea;
            border: 2px solid rgba(102, 126, 234, 0.2);
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
                            <!-- Test Container -->
                            <div class="test-container">
                                <!-- Test Header -->
                                <div class="test-header">
                                    <div class="row align-items-center">
                                        <div class="col-md-4">
                                            <h2 class="mb-2">
                                                <i class="bi bi-journal-text me-3"></i>
                                                ${test.testName}
                                            </h2>
                                            <p class="mb-1 opacity-75">${test.module.course.courseName} - ${test.module.moduleName}</p>
                                            <p class="mb-0 opacity-75">Pass Requirement: ${test.passPercentage}%</p>
                                        </div>
                                        <div class="col-md-4 text-center">
                                            <div class="progress-container">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="fw-bold">Progress</span>
                                                    <span id="progressPercent" class="fw-bold">0%</span>
                                                </div>
                                                <div class="progress" style="height: 8px;">
                                                    <div id="progressBar" class="progress-bar" role="progressbar" style="width: 0%"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-2 text-center">
                                            <div class="answer-counter">
                                                <i class="bi bi-list-check me-2"></i>
                                                <span id="answeredCount">0</span> / ${fn:length(questions)} Answered
                                            </div>
                                        </div>
                                        <div class="col-md-2 text-end">
                                            <div class="d-flex gap-2 justify-content-end">
                                                <a href="${pageContext.request.contextPath}/learner/tests?action=detail&testId=${test.testID}" 
                                                   class="btn btn-cancel btn-sm">
                                                    <i class="bi bi-x-circle me-1"></i>Cancel
                                                </a>
                                                <button type="submit" class="btn btn-submit-test btn-sm" onclick="return confirmSubmit()" form="testForm">
                                                    <i class="bi bi-send me-1"></i>Submit
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Progress Bar -->

                                </div>

                                <!-- Test Form -->
                                <form id="testForm" action="${pageContext.request.contextPath}/learner/tests" method="post">
                                    <input type="hidden" name="action" value="submit">
                                    <input type="hidden" name="testId" value="${test.testID}">
                                    
                                    <div class="p-4">
                                        <!-- Questions -->
                                        <c:forEach var="question" items="${questions}" varStatus="status">
                                            <div class="question-card">
                                                <div class="question-header">
                                                    <div class="d-flex align-items-start">
                                                        <div class="question-number">${status.index + 1}</div>
                                                        <div class="flex-grow-1">
                                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                                <span class="question-type-badge ${question.questionType == 'CHOICE' ? 'badge-choice' : 'badge-writing'}">
                                                                    <i class="bi ${question.questionType == 'CHOICE' ? 'bi-check2-square' : 'bi-pencil-square'} me-1"></i>
                                                                    ${question.questionType}
                                                                </span>
                                                                <span class="text-muted">
                                                                    <i class="bi bi-star-fill text-warning me-1"></i>
                                                                    ${question.point} ${question.point == 1 ? 'point' : 'points'}
                                                                </span>
                                                            </div>
                                                            <h5 class="question-text">${question.question}</h5>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="card-body p-4">
                                                    <c:choose>
                                                        <c:when test="${question.questionType == 'CHOICE'}">
                                                            <div class="choice-options">
                                                                <c:if test="${not empty question.option1}">
                                                                    <label class="choice-option" for="q${question.questionID}_1">
                                                                        <input type="radio" 
                                                                               id="q${question.questionID}_1"
                                                                               name="answer_${question.questionID}" 
                                                                               value="1"
                                                                               onchange="updateProgress()">
                                                                        <span class="option-text">A. ${question.option1}</span>
                                                                    </label>
                                                                </c:if>
                                                                <c:if test="${not empty question.option2}">
                                                                    <label class="choice-option" for="q${question.questionID}_2">
                                                                        <input type="radio" 
                                                                               id="q${question.questionID}_2"
                                                                               name="answer_${question.questionID}" 
                                                                               value="2"
                                                                               onchange="updateProgress()">
                                                                        <span class="option-text">B. ${question.option2}</span>
                                                                    </label>
                                                                </c:if>
                                                                <c:if test="${not empty question.option3}">
                                                                    <label class="choice-option" for="q${question.questionID}_3">
                                                                        <input type="radio" 
                                                                               id="q${question.questionID}_3"
                                                                               name="answer_${question.questionID}" 
                                                                               value="3"
                                                                               onchange="updateProgress()">
                                                                        <span class="option-text">C. ${question.option3}</span>
                                                                    </label>
                                                                </c:if>
                                                                <c:if test="${not empty question.option4}">
                                                                    <label class="choice-option" for="q${question.questionID}_4">
                                                                        <input type="radio" 
                                                                               id="q${question.questionID}_4"
                                                                               name="answer_${question.questionID}" 
                                                                               value="4"
                                                                               onchange="updateProgress()">
                                                                        <span class="option-text">D. ${question.option4}</span>
                                                                    </label>
                                                                </c:if>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="writing-question">
                                                                <textarea class="form-control writing-textarea" 
                                                                          name="answer_${question.questionID}"
                                                                          placeholder="Enter your answer here..."
                                                                          onchange="updateProgress()"
                                                                          oninput="updateProgress()"></textarea>
                                                                <small class="text-muted mt-2 d-block">
                                                                    <i class="bi bi-info-circle me-1"></i>
                                                                    Provide a detailed written response to this question.
                                                                </small>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:forEach>

                                    </div>
                                </form>
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
        // Add JSTL tag for total questions count
        const totalQuestions = ${fn:length(questions)};
        
        // Update choice option selection visual feedback
        document.querySelectorAll('.choice-option').forEach(option => {
            option.addEventListener('click', function() {
                const radio = this.querySelector('input[type="radio"]');
                if (radio) {
                    // Remove selected class from all options in this question
                    const questionName = radio.name;
                    document.querySelectorAll('input[name="'+ questionName + '"]').forEach(r => {
                        r.closest('.choice-option').classList.remove('selected');
                    });
                    // Check the radio button and add selected class
                    radio.checked = true;
                    this.classList.add('selected');
                    updateProgress();
                }
            });
        });
        
        // Update progress function
        function updateProgress() {
            let answeredCount = 0;
            
            // Count answered multiple choice questions
            const allRadioNames = new Set();
            document.querySelectorAll('input[type="radio"][name^="answer_"]').forEach(radio => {
                allRadioNames.add(radio.name);
            });
            
            allRadioNames.forEach(name => {
                if (document.querySelector(`input[name="` + name +`"]:checked`)) {
                    answeredCount++;
                }
            });
            
            // Count answered writing questions
            document.querySelectorAll('textarea[name^="answer_"]').forEach(textarea => {
                if (textarea.value && textarea.value.trim().length > 0) {
                    answeredCount++;
                }
            });
            
            // Update progress display
            const percentage = Math.round((answeredCount / totalQuestions) * 100);
            document.getElementById('answeredCount').textContent = answeredCount;
            document.getElementById('progressPercent').textContent = percentage + '%';
            document.getElementById('progressBar').style.width = percentage + '%';
        }
        
        // Confirm submit function
        function confirmSubmit() {
            const answeredCount = parseInt(document.getElementById('answeredCount').textContent);
            const unanswered = totalQuestions - answeredCount;
            
            if (unanswered > 0) {
                return confirm(`You have `+unanswered+ ` unanswered question(s). Are you sure you want to submit the test?`);
            }
            
            return confirm('Are you sure you want to submit the test? This action cannot be undone.');
        }
        
        // Auto-save functionality (optional - saves to localStorage)
        function autoSave() {
            const formData = new FormData(document.getElementById('testForm'));
            const data = {};
            for (let [key, value] of formData.entries()) {
                if (key.startsWith('answer_')) {
                    data[key] = value;
                }
            }
            localStorage.setItem('test_${test.testID}_autosave', JSON.stringify(data));
        }
        
        // Restore from auto-save
        function restoreAutoSave() {
            const saved = localStorage.getItem('test_${test.testID}_autosave');
            if (saved) {
                const data = JSON.parse(saved);
                Object.entries(data).forEach(([key, value]) => {
                    const input = document.querySelector(`[name="` + key + `"]`);
                    if (input) {
                        if (input.type === 'radio') {
                            const radio = document.querySelector(`[name="`+key+`"][value="`+value+`"]`);
                            if (radio) {
                                radio.checked = true;
                                radio.closest('.choice-option').classList.add('selected');
                            }
                        } else if (input.type === 'textarea' || input.tagName === 'TEXTAREA') {
                            input.value = value;
                        }
                    }
                });
                updateProgress();
            }
        }
        
        // Initialize auto-save
        document.addEventListener('DOMContentLoaded', function() {
            restoreAutoSave();
            updateProgress(); // Initial progress update
            
            // Auto-save every 30 seconds
            setInterval(autoSave, 30000);
            
            // Save on form changes
            document.getElementById('testForm').addEventListener('change', autoSave);
            document.getElementById('testForm').addEventListener('input', autoSave);
            
            // Add progress update listeners to textareas
            document.querySelectorAll('textarea[name^="answer_"]').forEach(textarea => {
                textarea.addEventListener('input', updateProgress);
                textarea.addEventListener('change', updateProgress);
            });
        });
        
        // Clear auto-save on successful submit
        document.getElementById('testForm').addEventListener('submit', function() {
            localStorage.removeItem('test_${test.testID}_autosave');
        });
        
        // Warning before leaving page
        window.addEventListener('beforeunload', function(e) {
            const answeredCount = parseInt(document.getElementById('answeredCount').textContent);
            if (answeredCount > 0) {
                e.preventDefault();
                e.returnValue = '';
                return '';
            }
        });
    </script>
</body>
</html> 