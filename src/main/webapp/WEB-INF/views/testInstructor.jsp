<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Tests - Instructor Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/editProfile.css">
    <style>
        .test-management-container {
            margin-left: 250px;
            padding: 20px;
            width: calc(100% - 290px);
            min-height: 100vh;
            box-sizing: border-box;
        }

        .test-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .test-card {
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .test-list {
            margin-top: 30px;
        }

        .test-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .test-item:last-child {
            border-bottom: none;
        }

        .test-info {
            flex: 1;
        }

        .test-title {
            font-size: 18px;
            font-weight: 600;
            color: #343a40;
            margin-bottom: 5px;
            cursor: pointer;
        }

        .test-title a:hover {
            color: #007bff;
            text-decoration: underline;
        }

        .test-meta {
            color: #6c757d;
            font-size: 14px;
        }

        .test-actions {
            display: flex;
            gap: 10px;
        }

        .btn-create {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-edit, .btn-delete {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-edit {
            background-color: #007bff;
            color: white;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }

        .form-group textarea {
            min-height: 100px;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .checkbox-group input {
            width: auto;
        }

        .button-group {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-submit {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-cancel {
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .no-tests {
            text-align: center;
            padding: 30px;
            color: #6c757d;
        }

        .highlight-test {
            background-color: #e6f7ff;
            border-left: 4px solid #1890ff;
            animation: fadeHighlight 3s forwards;
        }

        @keyframes fadeHighlight {
            0% { background-color: #e6f7ff; }
            100% { background-color: transparent; }
        }

        /* Dropdown styles */
        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: #f9f9f9;
            min-width: 200px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 4px;
        }

        .dropdown-content a {
            color: #333;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            transition: background-color 0.3s;
        }

        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        .show {
            display: block;
        }

        /* Test creation option forms */
        #uploadDocumentForm, #multipleChoiceForm, #writingForm {
            display: none;
        }

        /* Document preview */
        .document-preview {
            margin-top: 20px;
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 4px;
            background-color: #f9f9f9;
        }

        .document-preview img {
            max-width: 100%;
            height: auto;
        }

        /* Question container */
        .question-container {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 4px;
            background-color: #f9f9f9;
        }

        .option-container {
            margin-left: 20px;
            margin-bottom: 10px;
        }

        .add-button {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            font-size: 20px;
            line-height: 1;
            cursor: pointer;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <!-- Left Sidebar -->
    <header>
        <a href="${pageContext.request.contextPath}/" class="logo">
            <img src="${pageContext.request.contextPath}/img/logo.png" alt="FSkills Logo" class="logo-img">
        </a>
        <nav>
            <a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-house"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/courses"><i class="bi bi-book"></i> My Courses</a>
            <a href="${pageContext.request.contextPath}/instructor/tests" class="active"><i class="bi bi-file-earmark-text"></i> Tests</a>
            <a href="${pageContext.request.contextPath}/profile"><i class="bi bi-person"></i> Profile</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
        </nav>
    </header>

    <div class="test-management-container">
        <!-- Success/Error Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                ${sessionScope.successMessage}
            </div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                ${errorMessage}
            </div>
        </c:if>

        <!-- Test List View -->
        <c:if test="${action != 'create' && action != 'edit'}">
            <div class="test-card">
                <div class="test-header">
                    <h1>Manage Tests</h1>
                    <div class="dropdown">
                        <button class="btn-create" onclick="toggleDropdown()">
                            <i class="bi bi-plus-circle"></i> Create New Test
                        </button>
                        <div id="createTestDropdown" class="dropdown-content">
                            <a href="#" onclick="showUploadDocumentForm()"><i class="bi bi-file-earmark-arrow-up"></i> Upload a document</a>
                            <a href="#" onclick="showGenerateFromTextForm()"><i class="bi bi-file-earmark-text"></i> Generate from text</a>
                        </div>
                    </div>
                </div>

                <div class="test-list">
                    <c:choose>
                        <c:when test="${empty tests}">
                            <div class="no-tests">
                                <p>You haven't created any tests yet.</p>
                                <p>Click the "Create New Test" button to get started.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="test" items="${tests}">
                                <div class="test-item">
                                    <div class="test-info">
                                        <div class="test-title">
                                            <a href="${pageContext.request.contextPath}/instructor/tests?action=edit&id=${test.testId}" style="text-decoration: none; color: inherit;">
                                                ${test.testName} <i class="bi bi-pencil-square" style="font-size: 0.8em; color: #6c757d;"></i>
                                            </a>
                                        </div>
                                        <div class="test-meta">
                                            <span><i class="bi bi-clock"></i> ${test.duration} minutes</span> | 
                                            <span><i class="bi bi-question-circle"></i> ${test.totalQuestions} questions</span> | 
                                            <span><i class="bi bi-calendar"></i> Created: <fmt:formatDate value="${test.createdDate}" pattern="dd/MM/yyyy" /></span>
                                            <c:if test="${test.isActive}">
                                                <span class="badge badge-success">Active</span>
                                            </c:if>
                                            <c:if test="${!test.isActive}">
                                                <span class="badge badge-secondary">Inactive</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="test-actions">
                                        <a href="${pageContext.request.contextPath}/instructor/tests?action=edit&id=${test.testId}" class="btn-edit">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <form action="${pageContext.request.contextPath}/instructor/tests" method="post" onsubmit="return confirm('Are you sure you want to delete this test?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="testId" value="${test.testId}">
                                            <button type="submit" class="btn-delete">
                                                <i class="bi bi-trash"></i> Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

        <!-- Create Test Form -->
        <c:if test="${action == 'create'}">
            <div class="test-card">
                <h1>Create New Test</h1>
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/instructor/tests" method="post">
                        <input type="hidden" name="action" value="create">

                        <div class="form-group">
                            <label for="testName">Test Name</label>
                            <input type="text" id="testName" name="testName" required>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="4"></textarea>
                        </div>

                        <div class="form-group">
                            <label for="duration">Duration (minutes)</label>
                            <input type="number" id="duration" name="duration" min="1" required>
                        </div>

                        <div class="form-group">
                            <label for="totalQuestions">Total Questions</label>
                            <input type="number" id="totalQuestions" name="totalQuestions" min="1" required>
                        </div>

                        <div class="form-group">
                            <label for="courseId">Course</label>
                            <select id="courseId" name="courseId" required>
                                <option value="">Select a course</option>
                                <!-- This would be populated with actual courses from the database -->
                                <option value="1">Course 1</option>
                                <option value="2">Course 2</option>
                                <option value="3">Course 3</option>
                            </select>
                        </div>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="isActive" name="isActive" checked>
                            <label for="isActive">Active</label>
                        </div>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/instructor/tests" class="btn-cancel">Cancel</a>
                            <button type="submit" class="btn-submit">Create Test</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- Upload Document Form -->
        <c:if test="${action == 'upload'}">
            <div class="test-card">
                <h1>Upload Document Test</h1>
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/instructor/tests" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="uploadDocument">

                        <div class="form-group">
                            <label for="testName">Test Name</label>
                            <input type="text" id="testName" name="testName" required>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="4"></textarea>
                        </div>

                        <div class="form-group">
                            <label for="documentFile">Upload Document</label>
                            <input type="file" id="documentFile" name="documentFile" accept=".doc,.docx,.pdf" required onchange="previewDocument(this)">
                            <small>Allowed file types: .doc, .docx, .pdf</small>
                        </div>

                        <div id="documentPreview" class="document-preview"></div>

                        <div class="form-group">
                            <label for="courseId">Course</label>
                            <select id="courseId" name="courseId" required>
                                <option value="">Select a course</option>
                                <!-- This would be populated with actual courses from the database -->
                                <option value="1">Course 1</option>
                                <option value="2">Course 2</option>
                                <option value="3">Course 3</option>
                            </select>
                        </div>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="isActive" name="isActive" checked>
                            <label for="isActive">Active</label>
                        </div>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/instructor/tests" class="btn-cancel">Cancel</a>
                            <button type="submit" class="btn-submit">Upload Document</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- Generate From Text Form -->
        <c:if test="${action == 'generate'}">
            <div class="test-card">
                <h1>Generate Test From Text</h1>
                <div class="form-container">
                    <!-- Test Type Selection -->
                    <div id="generateFromTextForm">
                        <div class="form-group">
                            <label>Select Test Type</label>
                            <div style="display: flex; gap: 20px; margin-top: 10px;">
                                <button type="button" class="btn-submit" onclick="showMultipleChoiceForm()">Multiple Choice</button>
                                <button type="button" class="btn-submit" style="background-color: #6c757d;" onclick="showWritingForm()">Writing</button>
                            </div>
                        </div>
                    </div>

                    <!-- Multiple Choice Form -->
                    <form id="multipleChoiceForm" action="${pageContext.request.contextPath}/instructor/tests" method="post" style="display: none;">
                        <input type="hidden" name="action" value="createMultipleChoice">
                        <input type="hidden" id="mcQuestionCount" name="mcQuestionCount" value="3">

                        <div class="form-group">
                            <label for="mcTestName">Test Name</label>
                            <input type="text" id="mcTestName" name="testName" required>
                        </div>

                        <div class="form-group">
                            <label for="mcDescription">Description</label>
                            <textarea id="mcDescription" name="description" rows="4"></textarea>
                        </div>

                        <div class="form-group">
                            <label for="mcDuration">Duration (minutes)</label>
                            <input type="number" id="mcDuration" name="duration" min="1" required>
                        </div>

                        <div class="form-group">
                            <label for="mcCourseId">Course</label>
                            <select id="mcCourseId" name="courseId" required>
                                <option value="">Select a course</option>
                                <!-- This would be populated with actual courses from the database -->
                                <option value="1">Course 1</option>
                                <option value="2">Course 2</option>
                                <option value="3">Course 3</option>
                            </select>
                        </div>

                        <h3>Questions</h3>
                        <div id="mcQuestionsContainer">
                            <!-- Question 1 -->
                            <div class="question-container">
                                <div class="form-group">
                                    <label for="question1">Question 1</label>
                                    <input type="text" id="question1" name="mcQuestion1" required>
                                </div>
                                <div class="option-container">
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption1A" name="correctOption1" value="A">
                                        <label for="correctOption1A">A</label>
                                        <input type="text" name="mcOption1A" placeholder="Option A" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption1B" name="correctOption1" value="B">
                                        <label for="correctOption1B">B</label>
                                        <input type="text" name="mcOption1B" placeholder="Option B" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption1C" name="correctOption1" value="C">
                                        <label for="correctOption1C">C</label>
                                        <input type="text" name="mcOption1C" placeholder="Option C" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption1D" name="correctOption1" value="D">
                                        <label for="correctOption1D">D</label>
                                        <input type="text" name="mcOption1D" placeholder="Option D" required>
                                    </div>
                                    <button type="button" class="add-button" onclick="addOption(1)">+</button>
                                </div>
                            </div>

                            <!-- Question 2 -->
                            <div class="question-container">
                                <div class="form-group">
                                    <label for="question2">Question 2</label>
                                    <input type="text" id="question2" name="mcQuestion2" required>
                                </div>
                                <div class="option-container">
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption2A" name="correctOption2" value="A">
                                        <label for="correctOption2A">A</label>
                                        <input type="text" name="mcOption2A" placeholder="Option A" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption2B" name="correctOption2" value="B">
                                        <label for="correctOption2B">B</label>
                                        <input type="text" name="mcOption2B" placeholder="Option B" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption2C" name="correctOption2" value="C">
                                        <label for="correctOption2C">C</label>
                                        <input type="text" name="mcOption2C" placeholder="Option C" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption2D" name="correctOption2" value="D">
                                        <label for="correctOption2D">D</label>
                                        <input type="text" name="mcOption2D" placeholder="Option D" required>
                                    </div>
                                    <button type="button" class="add-button" onclick="addOption(2)">+</button>
                                </div>
                            </div>

                            <!-- Question 3 -->
                            <div class="question-container">
                                <div class="form-group">
                                    <label for="question3">Question 3</label>
                                    <input type="text" id="question3" name="mcQuestion3" required>
                                </div>
                                <div class="option-container">
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption3A" name="correctOption3" value="A">
                                        <label for="correctOption3A">A</label>
                                        <input type="text" name="mcOption3A" placeholder="Option A" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption3B" name="correctOption3" value="B">
                                        <label for="correctOption3B">B</label>
                                        <input type="text" name="mcOption3B" placeholder="Option B" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption3C" name="correctOption3" value="C">
                                        <label for="correctOption3C">C</label>
                                        <input type="text" name="mcOption3C" placeholder="Option C" required>
                                    </div>
                                    <div class="form-group checkbox-group">
                                        <input type="checkbox" id="correctOption3D" name="correctOption3" value="D">
                                        <label for="correctOption3D">D</label>
                                        <input type="text" name="mcOption3D" placeholder="Option D" required>
                                    </div>
                                    <button type="button" class="add-button" onclick="addOption(3)">+</button>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="add-button" onclick="addQuestion('mc')" style="margin-bottom: 20px;">+</button>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="mcIsActive" name="isActive" checked>
                            <label for="mcIsActive">Active</label>
                        </div>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/instructor/tests" class="btn-cancel">Cancel</a>
                            <button type="submit" class="btn-submit">Create Multiple Choice Test</button>
                        </div>
                    </form>

                    <!-- Writing Form -->
                    <form id="writingForm" action="${pageContext.request.contextPath}/instructor/tests" method="post" style="display: none;">
                        <input type="hidden" name="action" value="createWriting">
                        <input type="hidden" id="writingQuestionCount" name="writingQuestionCount" value="1">

                        <div class="form-group">
                            <label for="writingTestName">Test Name</label>
                            <input type="text" id="writingTestName" name="testName" required>
                        </div>

                        <div class="form-group">
                            <label for="writingDescription">Description</label>
                            <textarea id="writingDescription" name="description" rows="4"></textarea>
                        </div>

                        <div class="form-group">
                            <label for="writingDuration">Duration (minutes)</label>
                            <input type="number" id="writingDuration" name="duration" min="1" required>
                        </div>

                        <div class="form-group">
                            <label for="writingCourseId">Course</label>
                            <select id="writingCourseId" name="courseId" required>
                                <option value="">Select a course</option>
                                <!-- This would be populated with actual courses from the database -->
                                <option value="1">Course 1</option>
                                <option value="2">Course 2</option>
                                <option value="3">Course 3</option>
                            </select>
                        </div>

                        <h3>Questions</h3>
                        <div id="writingQuestionsContainer">
                            <!-- Question 1 -->
                            <div class="question-container">
                                <div class="form-group">
                                    <label for="writingQuestion1">Question 1</label>
                                    <input type="text" id="writingQuestion1" name="writingQuestion1" required>
                                </div>
                                <div class="form-group">
                                    <label for="writingAnswer1">Correct Answer</label>
                                    <textarea id="writingAnswer1" name="writingAnswer1" rows="3" required></textarea>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="add-button" onclick="addQuestion('writing')" style="margin-bottom: 20px;">+</button>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="writingIsActive" name="isActive" checked>
                            <label for="writingIsActive">Active</label>
                        </div>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/instructor/tests" class="btn-cancel">Cancel</a>
                            <button type="submit" class="btn-submit">Create Writing Test</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- Edit Test Form -->
        <c:if test="${action == 'edit'}">
            <div class="test-card">
                <h1>Edit Test</h1>
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/instructor/tests" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="testId" value="${test.testId}">

                        <div class="form-group">
                            <label for="testName">Test Name</label>
                            <input type="text" id="testName" name="testName" value="${test.testName}" required>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="4">${test.description}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="duration">Duration (minutes)</label>
                            <input type="number" id="duration" name="duration" min="1" value="${test.duration}" required>
                        </div>

                        <div class="form-group">
                            <label for="totalQuestions">Total Questions</label>
                            <input type="number" id="totalQuestions" name="totalQuestions" min="1" value="${test.totalQuestions}" required>
                        </div>

                        <div class="form-group">
                            <label for="courseId">Course</label>
                            <select id="courseId" name="courseId" required>
                                <option value="">Select a course</option>
                                <!-- This would be populated with actual courses from the database -->
                                <option value="1" ${test.courseId == 1 ? 'selected' : ''}>Course 1</option>
                                <option value="2" ${test.courseId == 2 ? 'selected' : ''}>Course 2</option>
                                <option value="3" ${test.courseId == 3 ? 'selected' : ''}>Course 3</option>
                            </select>
                        </div>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="isActive" name="isActive" ${test.isActive ? 'checked' : ''}>
                            <label for="isActive">Active</label>
                        </div>

                        <div class="button-group">
                            <a href="${pageContext.request.contextPath}/instructor/tests" class="btn-cancel">Cancel</a>
                            <button type="submit" class="btn-submit">Update Test</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>
    </div>

    <script>
        // Auto-hide alerts after 3 seconds
        window.addEventListener('load', function() {
            const alerts = document.querySelectorAll('.alert');
            if (alerts.length > 0) {
                setTimeout(function() {
                    alerts.forEach(function(alert) {
                        alert.style.display = 'none';
                    });
                }, 3000);
            }

            // Highlight newly created test
            const urlParams = new URLSearchParams(window.location.search);
            const newTestId = urlParams.get('newTest');
            if (newTestId) {
                const testItems = document.querySelectorAll('.test-item');
                testItems.forEach(function(item) {
                    const testIdInput = item.querySelector('input[name="testId"]');
                    if (testIdInput && testIdInput.value === newTestId) {
                        item.classList.add('highlight-test');
                        // Scroll to the highlighted test
                        item.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                });
            }
        });

        // Toggle dropdown menu
        function toggleDropdown() {
            document.getElementById("createTestDropdown").classList.toggle("show");
        }

        // Close the dropdown if the user clicks outside of it
        window.onclick = function(event) {
            if (!event.target.matches('.btn-create')) {
                var dropdowns = document.getElementsByClassName("dropdown-content");
                for (var i = 0; i < dropdowns.length; i++) {
                    var openDropdown = dropdowns[i];
                    if (openDropdown.classList.contains('show')) {
                        openDropdown.classList.remove('show');
                    }
                }
            }
        }

        // Show upload document form
        function showUploadDocumentForm() {
            window.location.href = "${pageContext.request.contextPath}/instructor/tests?action=upload";
        }

        // Show generate from text form
        function showGenerateFromTextForm() {
            window.location.href = "${pageContext.request.contextPath}/instructor/tests?action=generate";
        }

        // Show multiple choice form
        function showMultipleChoiceForm() {
            document.getElementById("generateFromTextForm").style.display = "none";
            document.getElementById("multipleChoiceForm").style.display = "block";
            document.getElementById("writingForm").style.display = "none";
            console.log("Multiple Choice form should be visible now");
        }

        // Show writing form
        function showWritingForm() {
            document.getElementById("generateFromTextForm").style.display = "none";
            document.getElementById("multipleChoiceForm").style.display = "none";
            document.getElementById("writingForm").style.display = "block";
            console.log("Writing form should be visible now");
        }

        // Add more questions (for both multiple choice and writing)
        function addQuestion(type) {
            const container = document.getElementById(type + "QuestionsContainer");
            const questionCount = container.getElementsByClassName("question-container").length + 1;

            const questionDiv = document.createElement("div");
            questionDiv.className = "question-container";

            if (type === "mc") {
                questionDiv.innerHTML = `
                    <div class="form-group">
                        <label for="question${questionCount}">Question ${questionCount}</label>
                        <input type="text" id="question${questionCount}" name="mcQuestion${questionCount}" required>
                    </div>
                    <div class="option-container">
                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="correctOption${questionCount}A" name="correctOption${questionCount}" value="A">
                            <label for="correctOption${questionCount}A">A</label>
                            <input type="text" name="mcOption${questionCount}A" placeholder="Option A" required>
                        </div>
                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="correctOption${questionCount}B" name="correctOption${questionCount}" value="B">
                            <label for="correctOption${questionCount}B">B</label>
                            <input type="text" name="mcOption${questionCount}B" placeholder="Option B" required>
                        </div>
                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="correctOption${questionCount}C" name="correctOption${questionCount}" value="C">
                            <label for="correctOption${questionCount}C">C</label>
                            <input type="text" name="mcOption${questionCount}C" placeholder="Option C" required>
                        </div>
                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="correctOption${questionCount}D" name="correctOption${questionCount}" value="D">
                            <label for="correctOption${questionCount}D">D</label>
                            <input type="text" name="mcOption${questionCount}D" placeholder="Option D" required>
                        </div>
                        <button type="button" class="add-button" onclick="addOption(${questionCount})">+</button>
                    </div>
                `;
            } else {
                questionDiv.innerHTML = `
                    <div class="form-group">
                        <label for="writingQuestion${questionCount}">Question ${questionCount}</label>
                        <input type="text" id="writingQuestion${questionCount}" name="writingQuestion${questionCount}" required>
                    </div>
                    <div class="form-group">
                        <label for="writingAnswer${questionCount}">Correct Answer</label>
                        <textarea id="writingAnswer${questionCount}" name="writingAnswer${questionCount}" rows="3" required></textarea>
                    </div>
                `;
            }

            container.appendChild(questionDiv);

            // Update hidden field with question count
            document.getElementById(type + "QuestionCount").value = questionCount;
        }

        // Add more options for multiple choice questions
        function addOption(questionNumber) {
            const optionContainer = document.querySelector(`#mcQuestionsContainer .question-container:nth-child(${questionNumber}) .option-container`);
            const optionCount = optionContainer.getElementsByClassName("checkbox-group").length;
            const nextOptionLetter = String.fromCharCode(65 + optionCount); // A=65, B=66, etc.

            const optionDiv = document.createElement("div");
            optionDiv.className = "form-group checkbox-group";
            optionDiv.innerHTML = `
                <input type="checkbox" id="correctOption${questionNumber}${nextOptionLetter}" name="correctOption${questionNumber}" value="${nextOptionLetter}">
                <label for="correctOption${questionNumber}${nextOptionLetter}">${nextOptionLetter}</label>
                <input type="text" name="mcOption${questionNumber}${nextOptionLetter}" placeholder="Option ${nextOptionLetter}" required>
            `;

            // Insert before the add button
            optionContainer.insertBefore(optionDiv, optionContainer.lastElementChild);
        }

        // Preview uploaded document
        function previewDocument(input) {
            const preview = document.getElementById('documentPreview');
            const file = input.files[0];

            if (file) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    if (file.type === 'application/pdf') {
                        preview.innerHTML = `
                            <p>PDF Preview (${file.name})</p>
                            <embed src="${e.target.result}" type="application/pdf" width="100%" height="500px" />
                        `;
                    } else {
                        preview.innerHTML = `
                            <p>Document Preview (${file.name})</p>
                            <p>Preview not available for this file type. The document will be available for download.</p>
                        `;
                    }
                };

                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>
