<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Test | F-Skill</title>
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

        .question-container {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background-color: white;
            position: relative;
        }

        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .question-number {
            background-color: #4f46e5;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: bold;
        }

        .remove-question {
            background: none;
            border: none;
            color: #dc3545;
            font-size: 1.2rem;
            cursor: pointer;
        }

        .remove-question:hover {
            color: #a71e2a;
        }

        .option-group {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .option-group input[type="radio"] {
            margin-right: 10px;
        }

        .option-group input[type="text"] {
            flex: 1;
            margin-left: 10px;
        }

        .add-question-btn {
            width: 100%;
            padding: 15px;
            border: 2px dashed #6c757d;
            background: white;
            color: #6c757d;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .add-question-btn:hover {
            border-color: #4f46e5;
            color: #4f46e5;
            background-color: #f8f9fa;
        }

        .test-settings {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }

        .form-check-input:checked {
            background-color: #4f46e5;
            border-color: #4f46e5;
        }

        .btn-primary {
            background-color: #4f46e5;
            border-color: #4f46e5;
        }

        .btn-primary:hover {
            background-color: #3730a3;
            border-color: #3730a3;
        }

        .test-info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #2196f3;
        }

        /* Add new styles */
        .writing-area {
            display: none;
        }
        
        .choice-options {
            display: block;
        }
        
        .question-image {
            max-width: 100%;
            margin: 10px 0;
            max-height: 400px;
        }
        
        .image-preview {
            max-width: 300px;
            margin-top: 10px;
        }
        
        .image-upload-container {
            margin-bottom: 15px;
        }

        .image-upload-icon {
            display: inline-block;
            cursor: pointer;
            padding: 5px 10px;
            border-radius: 4px;
            margin: 2px;
            color: #4f46e5;
            user-select: none;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
        }

        .image-upload-icon:hover {
            background-color: #f3f4f6;
        }

        .image-upload-icon i {
            font-size: 1.2em;
        }

        [contenteditable] .image-upload-icon {
            border: none;
            display: inline-block;
            vertical-align: middle;
        }

        .position-relative {
            position: relative;
        }

        .image-upload-icon {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 10;
            cursor: pointer;
            padding: 5px 10px;
            border-radius: 4px;
            color: #4f46e5;
            background-color: white;
            border: 1px solid #e5e7eb;
            transition: all 0.2s ease;
        }

        .image-upload-icon:hover {
            background-color: #f3f4f6;
            border-color: #4f46e5;
        }

        .image-upload-icon i {
            font-size: 1.2em;
        }

        .question-image {
            max-width: 100%;
            margin: 10px 0;
            max-height: 400px;
            display: block;
        }
    </style>
</head>
<body>
<jsp:include page="/layout/sidebar_user.jsp"/>

<div class="container px-5 py-6">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <a href="${pageContext.request.contextPath}/instructor/tests?action=list" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back
        </a>
    </div>

<%--    <!-- Success/Error Messages -->--%>
<%--    <c:if test="${not empty success}">--%>
<%--        <div class="alert alert-success alert-dismissible fade show" role="alert">--%>
<%--            ${success}--%>
<%--            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>--%>
<%--        </div>--%>
<%--    </c:if>--%>

<%--    <c:if test="${not empty err}">--%>
<%--        <div class="alert alert-danger alert-dismissible fade show" role="alert">--%>
<%--            ${err}--%>
<%--            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>--%>
<%--        </div>--%>
<%--    </c:if>--%>

    <!-- Test Info -->
    <div class="test-info">
        <h5><i class="fas fa-info-circle"></i> Test Information</h5>
        <p class="mb-1"><strong>Test ID:</strong> #${test.testID}</p>
        <p class="mb-1"><strong>Module:</strong> ${test.module.moduleName}</p>
        <p class="mb-0"><strong>Last Updated:</strong> 
            <c:choose>
                <c:when test="${not empty test.testLastUpdate}">
                    <span class="datetime" data-utc="${test.testLastUpdate}Z"></span>
                </c:when>
                <c:otherwise>N/A</c:otherwise>
            </c:choose>
        </p>
    </div>

    <h2 class="mb-4 fw-bold fs-3">Update Test</h2>
    
    <form id="updateTestForm" action="${pageContext.request.contextPath}/instructor/tests" method="POST">
        <input type="hidden" name="action" value="update" />
        <input type="hidden" name="testId" value="${test.testID}">
        <input type="hidden" name="questionCount" id="questionCount" value="${questions.size()}">

        <!-- Test Settings -->
        <div class="test-settings">
            <h4 class="mb-3"><i class="fas fa-cog"></i> Test Settings</h4>
            
            <div class="row">
                <div class="col-md-12">
                    <div class="mb-3">
                        <label for="testName" class="form-label">Test Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="testName" name="testName" 
                               value="${test.testName}" placeholder="Enter test name" required maxlength="255">
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="testOrder" class="form-label">Test Order</label>
                        <input type="number" class="form-control" id="testOrder" name="testOrder" 
                               value="${test.testOrder}" min="1" required>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="requiredCorrectAnswers" class="form-label">Required Correct Answers</label>
                        <input type="number" class="form-control" id="requiredCorrectAnswers" name="requiredCorrectAnswers" 
                               min="1" required onchange="calculatePassPercentage()">
                        <input type="hidden" id="passPercentage" name="passPercentage" value="${test.passPercentage}">
                        <small class="form-text text-muted">
                            Equivalent percentage: <span id="calculatedPercentage">${test.passPercentage}</span>%
                        </small>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="isRandomize" name="isRandomize" value="1"
                               <c:if test="${test.randomize}">checked</c:if>>
                        <label class="form-check-label" for="isRandomize">
                            <i class="fas fa-random"></i> Randomize Questions
                        </label>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="showAnswer" name="showAnswer" value="1"
                               <c:if test="${test.showAnswer}">checked</c:if>>
                        <label class="form-check-label" for="showAnswer">
                            <i class="fas fa-eye"></i> Show Answers After Submit
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Questions Section -->
        <div class="mb-4">
            <h4 class="mb-3"><i class="fas fa-question-circle"></i> Questions</h4>
            
            <div id="questionsContainer">
                <!-- Existing questions will be loaded here -->
            </div>

            <button type="button" class="btn add-question-btn" onclick="addQuestion()">
                <i class="fas fa-plus"></i> Add Question
            </button>
        </div>

        <div class="d-flex gap-2 justify-content-end">
            <a href="${pageContext.request.contextPath}/instructor/tests?action=list" class="btn btn-secondary">Cancel</a>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> Update Test
            </button>
        </div>
    </form>
</div>

<jsp:include page="/layout/footer.jsp"/>
<jsp:include page="/layout/toast.jsp"/>
<script src="${pageContext.request.contextPath}/layout/formatUtcToVietnamese.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let questionCounter = 0;
    const existingQuestions = [
        <c:forEach var="question" items="${questions}" varStatus="status">
        {
            question: '${question.question}',
            option1: '${question.option1}',
            option2: '${question.option2}',
            option3: '${question.option3}',
            option4: '${question.option4}',
            rightOption: '${question.rightOption}',
            point: ${question.point},
            questionType: '${question.questionType}'
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    function addQuestion(questionData = null) {
        questionCounter++;
        const container = document.getElementById('questionsContainer');
        
        const questionDiv = document.createElement('div');
        questionDiv.className = 'question-container';
        questionDiv.id = 'question_' + questionCounter;
        
        const data = questionData || {
            question: '',
            option1: '',
            option2: '',
            option3: '',
            option4: '',
            rightOption: 'A',
            point: 1,
            questionType: 'CHOICE'
        };
        
        questionDiv.innerHTML = 
            '<div class="question-header">' +
                '<span class="question-number">Question ' + questionCounter + '</span>' +
                '<button type="button" class="remove-question" onclick="removeQuestion(' + questionCounter + ')">' +
                    '<i class="fas fa-times"></i>' +
                '</button>' +
            '</div>' +
            
            '<div class="mb-3" id="question-container_' + questionCounter + '">' +
                '<label class="form-label">Question Text *</label>' +
                '<div class="position-relative">' +
                    '<div class="image-upload-icon" onclick="triggerImageUpload(' + questionCounter + ')">' +
                        '<i class="fas fa-image"></i>' +
                    '</div>' +
                    '<div contenteditable="true" class="form-control" id="question-content_' + questionCounter + '" ' +
                         'style="min-height: 100px;" ' +
                         'onblur="updateHiddenField(this, ' + questionCounter + ')" ' +
                         'oninput="updateHiddenField(this, ' + questionCounter + ')" ' +
                         'onpaste="setTimeout(() => updateHiddenField(this, ' + questionCounter + '), 0)"></div>' +
                    '<input type="file" id="imageUpload_' + questionCounter + '" ' +
                           'accept="image/*" style="display: none;" ' +
                           'onchange="handleImageUpload(this, ' + questionCounter + ')">' +
                    '<input type="hidden" name="question_' + questionCounter + '" value="">' +
                '</div>' +
            '</div>' +

            '<div class="row">' +
                '<div class="col-md-12">' +
                    '<div class="mb-3">' +
                        '<label class="form-label">Question Type</label>' +
                        '<select class="form-select" name="questionType_' + questionCounter + '" onchange="toggleQuestionType(this, ' + questionCounter + ')">' +
                            '<option value="CHOICE"' + (data.questionType == 'CHOICE' ? ' selected' : '') + '>Multiple Choice</option>' +
                            '<option value="WRITING"' + (data.questionType == 'WRITING' ? ' selected' : '') + '>Writing</option>' +
                        '</select>' +
                        '<input type="hidden" name="point_' + questionCounter + '" value="' + (data.point || '1') + '">' +
                    '</div>' +
                '</div>' +
            '</div>' +

            '<div class="choice-options" id="choiceOptions_' + questionCounter + '">' +
                '<div class="mb-3">' +
                    '<label class="form-label">Answer Options</label>' +
                    
                    '<div class="option-group">' +
                        '<input type="radio" name="rightOption_' + questionCounter + '" value="A"' + (data.rightOption == 'A' ? ' checked' : '') + '>' +
                        '<strong>A.</strong>' +
                        '<input type="text" class="form-control" name="option1_' + questionCounter + '" ' +
                               'placeholder="Option A" value="' + (data.option1 || '') + '" required>' +
                    '</div>' +
                    
                    '<div class="option-group">' +
                        '<input type="radio" name="rightOption_' + questionCounter + '" value="B"' + (data.rightOption == 'B' ? ' checked' : '') + '>' +
                        '<strong>B.</strong>' +
                        '<input type="text" class="form-control" name="option2_' + questionCounter + '" ' +
                               'placeholder="Option B" value="' + (data.option2 || '') + '" required>' +
                    '</div>' +
                    
                    '<div class="option-group">' +
                        '<input type="radio" name="rightOption_' + questionCounter + '" value="C"' + (data.rightOption == 'C' ? ' checked' : '') + '>' +
                        '<strong>C.</strong>' +
                        '<input type="text" class="form-control" name="option3_' + questionCounter + '" ' +
                               'placeholder="Option C" value="' + (data.option3 || '') + '">' +
                    '</div>' +
                    
                    '<div class="option-group">' +
                        '<input type="radio" name="rightOption_' + questionCounter + '" value="D"' + (data.rightOption == 'D' ? ' checked' : '') + '>' +
                        '<strong>D.</strong>' +
                        '<input type="text" class="form-control" name="option4_' + questionCounter + '" ' +
                               'placeholder="Option D" value="' + (data.option4 || '') + '">' +
                    '</div>' +
                '</div>' +
                
                '<div class="alert alert-info">' +
                    '<small><i class="fas fa-info-circle"></i> Select the radio button next to the correct answer.</small>' +
                '</div>' +
            '</div>' +
            
            '<div class="writing-area" id="writingArea_' + questionCounter + '">' +
                '<div class="mb-3">' +
                    '<label class="form-label">Model Answer</label>' +
                    '<textarea class="form-control" name="writingAnswer_' + questionCounter + '" rows="3" ' +
                        'placeholder="Enter the model answer here...">' + (data.questionType == 'WRITING' ? data.rightOption : '') + '</textarea>' +
                    '<input type="hidden" name="rightOption_' + questionCounter + '" value="' + (data.questionType == 'WRITING' ? data.rightOption : 'A') + '">' +
                '</div>' +
            '</div>';
        
        container.appendChild(questionDiv);
        
        // Populate the contenteditable div and hidden field with existing question content
        if (data.question) {
            const questionContentDiv = document.getElementById('question-content_' + questionCounter);
            const hiddenInput = document.querySelector('input[name="question_' + questionCounter + '"]');
            
            questionContentDiv.innerHTML = data.question;
            hiddenInput.value = data.question;
        }
        
        updateQuestionCount();
        updateQuestionNumbers();
        calculatePassPercentage();
        
        // Initialize question type display
        if (data.questionType == 'WRITING') {
            toggleQuestionType(questionDiv.querySelector('select'), questionCounter);
        }
    }

    function removeQuestion(questionId) {
        const questionDiv = document.getElementById('question_' + questionId);
        if (questionDiv) {
            questionDiv.remove();
            updateQuestionCount();
            updateQuestionNumbers();
            calculatePassPercentage();
        }
    }

    function updateQuestionCount() {
        const questions = document.querySelectorAll('.question-container');
        document.getElementById('questionCount').value = questions.length;
    }

    function updateQuestionNumbers() {
        const questions = document.querySelectorAll('.question-container');
        questions.forEach((question, index) => {
            const numberSpan = question.querySelector('.question-number');
            if (numberSpan) {
                numberSpan.textContent = 'Question ' + (index + 1);
            }
        });
    }

    // Add new functions for handling image upload and question type toggle
    function triggerImageUpload(questionId) {
        document.getElementById('imageUpload_' + questionId).click();
    }

    function handleImageUpload(input, questionId) {
        const file = input.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'question-image';
                img.style.maxHeight = '400px';
                
                const questionDiv = document.getElementById('question-content_' + questionId);
                
                // Get cursor position or append to end
                let range;
                if (window.getSelection().rangeCount > 0) {
                    range = window.getSelection().getRangeAt(0);
                    if (questionDiv.contains(range.commonAncestorContainer)) {
                        // Cursor is in the div, insert at cursor
                        range.insertNode(img);
                        range.collapse(false);
                    } else {
                        // Cursor is outside, append to end
                        questionDiv.appendChild(img);
                        range = document.createRange();
                        range.setStartAfter(img);
                        range.collapse(true);
                    }
                } else {
                    // No selection, append to end
                    questionDiv.appendChild(img);
                    range = document.createRange();
                    range.setStartAfter(img);
                    range.collapse(true);
                }
                
                // Add a line break after the image
                const br = document.createElement('br');
                img.after(br);
                
                // Set cursor after the break
                const selection = window.getSelection();
                selection.removeAllRanges();
                range.setStartAfter(br);
                selection.addRange(range);
                
                // Update hidden input
                const hiddenInput = document.querySelector('input[name="question_' + questionId + '"]');
                hiddenInput.value = questionDiv.innerHTML;
                
                // Focus back on the contenteditable div
                questionDiv.focus();
                
                // Clear the file input
                input.value = '';
            };
            reader.readAsDataURL(file);
        }
    }

    function updateHiddenField(element, questionId) {
        const hiddenInput = document.querySelector('input[name="question_' + questionId + '"]');
        
        // Check if there's any content (text or elements)
        const hasText = element.textContent.trim().length > 0;
        const hasImages = element.getElementsByTagName('img').length > 0;
        const hasContent = hasText || hasImages;
        
        // Update hidden input with full HTML content
        hiddenInput.value = element.innerHTML;
        
        // Update validation state
        element.classList.toggle('is-invalid', !hasContent);
        const questionContainer = document.getElementById('question-container_' + questionId);
        const validationMessage = questionContainer.querySelector('.invalid-feedback');
        
        if (!hasContent && !validationMessage) {
            const div = document.createElement('div');
            div.className = 'invalid-feedback';
            div.textContent = 'Question text is required.';
            element.parentNode.appendChild(div);
        } else if (hasContent && validationMessage) {
            validationMessage.remove();
        }
    }

    function validateForm() {
        let isValid = true;
        const questions = document.querySelectorAll('[id^="question-content_"]');
        
        questions.forEach(question => {
            const hasText = question.textContent.trim().length > 0;
            const hasImages = question.getElementsByTagName('img').length > 0;
            const hasContent = hasText || hasImages;
            
            if (!hasContent) {
                isValid = false;
                question.classList.add('is-invalid');
                const questionId = question.id.split('_')[1];
                updateHiddenField(question, questionId);
            }
        });
        
        return isValid;
    }

    function toggleQuestionType(select, questionId) {
        const choiceOptions = document.getElementById('choiceOptions_' + questionId);
        const writingArea = document.getElementById('writingArea_' + questionId);
        const rightOptionHidden = document.querySelector('input[name="rightOption_' + questionId + '"]');
        
        if (select.value === 'WRITING') {
            choiceOptions.style.display = 'none';
            writingArea.style.display = 'block';
            // Clear choice options validation
            const options = choiceOptions.querySelectorAll('input[type="text"]');
            options.forEach(option => option.required = false);
            
            // Set rightOption to current writing answer or empty
            const writingAnswer = document.querySelector('textarea[name="writingAnswer_' + questionId + '"]');
            rightOptionHidden.value = writingAnswer.value;
            
            // Add event listener to sync writing answer with rightOption
            writingAnswer.addEventListener('input', function() {
                rightOptionHidden.value = this.value;
            });
        } else {
            choiceOptions.style.display = 'block';
            writingArea.style.display = 'none';
            // Restore choice options validation
            const options = choiceOptions.querySelectorAll('input[type="text"]');
            options[0].required = true; // Option A
            options[1].required = true; // Option B
            
            // Reset rightOption to selected radio button value
            const selectedRadio = choiceOptions.querySelector('input[type="radio"]:checked');
            rightOptionHidden.value = selectedRadio ? selectedRadio.value : 'A';
        }
    }

    // Form validation
    document.getElementById('updateTestForm').addEventListener('submit', async function(e) {
        e.preventDefault(); // Always prevent default initially
        
        const questions = document.querySelectorAll('.question-container');
        
        if (questions.length === 0) {
            showJsToast('Please add at least one question to the test.', 'danger');
            return;
        }

        // Validate inputs
        if (!validateInputs()) {
            return;
        }

        // Check test order duplicates
        const isOrderValid = await validateTestOrder();
        if (!isOrderValid) {
            return;
        }

        // Check required correct answers vs total questions
        const requiredAnswers = parseInt(document.getElementById('requiredCorrectAnswers').value) || 0;
        const totalQuestions = questions.length;
        
        if (requiredAnswers > totalQuestions) {
            showJsToast('Required correct answers cannot exceed total number of questions.', 'danger');
            document.getElementById('requiredCorrectAnswers').focus();
            return;
        }

        if (requiredAnswers === 0) {
            showJsToast('Please specify the number of required correct answers.', 'danger');
            document.getElementById('requiredCorrectAnswers').focus();
            return;
        }

        // All validations passed, submit the form
        this.submit();
    });

    // Calculate pass percentage based on required correct answers and total questions
    function calculatePassPercentage() {
        const requiredAnswers = parseInt(document.getElementById('requiredCorrectAnswers').value) || 0;
        const totalQuestions = document.querySelectorAll('.question-container').length;
        
        if (totalQuestions > 0 && requiredAnswers > 0) {
            const percentage = Math.round((requiredAnswers / totalQuestions) * 100);
            document.getElementById('calculatedPercentage').textContent = percentage;
            document.getElementById('passPercentage').value = percentage;
        } else {
            document.getElementById('calculatedPercentage').textContent = '--';
        }
    }

    // Calculate required answers from current percentage and total questions
    function calculateRequiredAnswers() {
        const passPercentage = parseInt(document.getElementById('passPercentage').value) || 0;
        const totalQuestions = document.querySelectorAll('.question-container').length;
        
        if (totalQuestions > 0 && passPercentage > 0) {
            const requiredAnswers = Math.ceil((passPercentage / 100) * totalQuestions);
            document.getElementById('requiredCorrectAnswers').value = requiredAnswers;
        }
    }

    // Validate test order for duplicates
    function validateTestOrder() {
        const testOrder = document.getElementById('testOrder').value;
        const testId = document.querySelector('input[name="testId"]').value;
        const moduleId = '${test.moduleID}'; // Get module ID from server-side data
        
        if (!testOrder) {
            return Promise.resolve(true); // Skip validation if field is empty
        }
        
        return fetch('${pageContext.request.contextPath}/instructor/tests?action=checkTestOrder&moduleId=' + moduleId + '&testOrder=' + testOrder + '&testId=' + testId)
            .then(response => response.json())
            .then(data => {
                if (data.exists) {
                    showJsToast('Test order ' + testOrder + ' already exists in this module. Please choose a different order.', 'danger');
                    return false;
                }
                return true;
            })
            .catch(error => {
                console.error('Error checking test order:', error);
                return true; // Allow submission on error
            });
    }

    // Trim whitespace and validate inputs
    function trimAndValidateInput(input) {
        if (!input) return '';
        
        // Trim leading, trailing, and multiple consecutive spaces
        let trimmed = input.trim().replace(/\s+/g, ' ');
        return trimmed;
    }

    function validateInputs() {
        let isValid = true;
        const testName = document.getElementById('testName');
        
        // Validate test name
        const trimmedTestName = trimAndValidateInput(testName.value);
        if (trimmedTestName.length === 0) {
            showJsToast('Test name cannot be empty or contain only whitespace.', 'danger');
            testName.focus();
            isValid = false;
        } else {
            testName.value = trimmedTestName;
        }
        
        // Validate questions and answers
        const questions = document.querySelectorAll('.question-container');
        for (let i = 0; i < questions.length; i++) {
            const questionContent = questions[i].querySelector('[id^="question-content_"]');
            const questionType = questions[i].querySelector('select[name^="questionType_"]').value;
            
            // Validate question text
            const questionText = trimAndValidateInput(questionContent.textContent);
            if (questionText.length === 0 && questionContent.getElementsByTagName('img').length === 0) {
                showJsToast(`Question ${i + 1}: Question text cannot be empty or contain only whitespace.`, 'danger');
                questionContent.focus();
                isValid = false;
                break;
            }
            
            if (questionType === 'CHOICE') {
                // Validate answer options
                const option1 = questions[i].querySelector('input[name^="option1_"]');
                const option2 = questions[i].querySelector('input[name^="option2_"]');
                
                const trimmedOption1 = trimAndValidateInput(option1.value);
                const trimmedOption2 = trimAndValidateInput(option2.value);
                
                if (trimmedOption1.length === 0) {
                    showJsToast(`Question ${i + 1}: Option A cannot be empty or contain only whitespace.`, 'danger');
                    option1.focus();
                    isValid = false;
                    break;
                } else {
                    option1.value = trimmedOption1;
                }
                
                if (trimmedOption2.length === 0) {
                    showJsToast(`Question ${i + 1}: Option B cannot be empty or contain only whitespace.`, 'danger');
                    option2.focus();
                    isValid = false;
                    break;
                } else {
                    option2.value = trimmedOption2;
                }
                
                // Trim optional options
                const option3 = questions[i].querySelector('input[name^="option3_"]');
                const option4 = questions[i].querySelector('input[name^="option4_"]');
                if (option3.value) option3.value = trimAndValidateInput(option3.value);
                if (option4.value) option4.value = trimAndValidateInput(option4.value);
            } else {
                // Validate writing answer
                const writingAnswer = questions[i].querySelector('textarea[name^="writingAnswer_"]');
                const trimmedWritingAnswer = trimAndValidateInput(writingAnswer.value);
                
                if (trimmedWritingAnswer.length === 0) {
                    showJsToast(`Question ${i + 1}: Model answer cannot be empty or contain only whitespace.`, 'danger');
                    writingAnswer.focus();
                    isValid = false;
                    break;
                } else {
                    writingAnswer.value = trimmedWritingAnswer;
                }
            }
        }
        
        return isValid;
    }

    // Load existing questions when page loads
    document.addEventListener('DOMContentLoaded', function() {
        formatUtcToVietnamese(".datetime");
        // Load existing questions
        existingQuestions.forEach(questionData => {
            addQuestion(questionData);
        });
        
        // Add empty question if no existing questions
        if (existingQuestions.length === 0) {
            addQuestion();
        }
        
        // Calculate required answers from existing percentage
        calculateRequiredAnswers();
        
        // Add event listeners for real-time validation
        document.getElementById('testOrder').addEventListener('blur', validateTestOrder);
    });

    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            if (alert.classList.contains('show')) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        });
    }, 5000);
</script>

</body>
</html> 