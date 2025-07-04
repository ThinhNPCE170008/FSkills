<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Feedback Management - F-Skills</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <style>
        .feedback-item {
            transition: all 0.3s ease;
        }
        .feedback-content {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
        }
        .feedback-item.expanded .feedback-content {
            max-height: 500px;
        }
        .feedback-item.expanded .expand-icon {
            transform: rotate(180deg);
        }
        .expand-icon {
            transition: transform 0.3s ease;
        }
        /* Highlight style for search results */
        .highlight {
            background-color: #FFFF00;
            padding: 2px;
            border-radius: 2px;
        }
        .tab-active {
            position: relative;
        }
        .tab-active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: #4f46e5;
            border-radius: 3px;
        }
        @media (max-width: 640px) {
            .tabs-container {
                flex-direction: column;
            }
            .tab-button {
                width: 100%;
                margin-bottom: 8px;
            }
        }
        /* Remove fixed margin-left to avoid conflict with sidebar.css */
        .main-content {
            padding: 20px;
            max-width: 100%;
            overflow-x: hidden;
        }

        /* Ensure container doesn't overflow */
        .container {
            max-width: 100%;
            overflow-x: hidden;
        }

        /* Ensure feedback items don't overflow */
        .feedback-item {
            max-width: 100%;
            word-wrap: break-word;
        }

        /* Ensure feedback content doesn't overflow */
        .feedback-content p {
            max-width: 100%;
            word-wrap: break-word;
            overflow-wrap: break-word;
        }
        .delete-btn {
            color: #ef4444;
        }
        .delete-btn:hover {
            color: #b91c1c;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 8px;
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
    <jsp:include page="/layout/sidebar_admin.jsp" />
    <jsp:include page="/layout/header_admin.jsp" />

    <div class="main-content">
        <div class="container mx-auto px-4 py-8">
            <!-- Header -->
            <header class="mb-8">
                <div class="flex flex-col md:flex-row md:justify-between md:items-center">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-800">View Feedback</h1>
                        <p class="text-gray-600 mt-2">Review and manage user feedback submissions</p>
                    </div>
                    <div class="mt-4 md:mt-0">
                        <div class="relative">
                            <input type="text" id="searchInput" placeholder="Search in feedback..." 
                                class="w-full md:w-64 pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-gray-400"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Navigation Tabs -->
            <div class="bg-white rounded-lg shadow-sm mb-6 p-1">
                <div class="tabs-container flex flex-wrap">
                    <a href="${pageContext.request.contextPath}/admin/feedback?type=comments" 
                       class="tab-button ${activeTab == 'comments' ? 'tab-active text-indigo-600' : 'text-gray-600 hover:text-indigo-600'} px-6 py-3 font-medium rounded-md focus:outline-none">
                        <i class="fas fa-comment-alt mr-2"></i>Comments
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/feedback?type=suggestions" 
                       class="tab-button ${activeTab == 'suggestions' ? 'tab-active text-indigo-600' : 'text-gray-600 hover:text-indigo-600'} px-6 py-3 font-medium rounded-md focus:outline-none">
                        <i class="fas fa-lightbulb mr-2"></i>Suggestions
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/feedback?type=questions" 
                       class="tab-button ${activeTab == 'questions' ? 'tab-active text-indigo-600' : 'text-gray-600 hover:text-indigo-600'} px-6 py-3 font-medium rounded-md focus:outline-none">
                        <i class="fas fa-question-circle mr-2"></i>Questions
                    </a>
                </div>
            </div>

            <!-- Feedback Count and Filter -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6">
                <div class="text-sm text-gray-500 mb-2 sm:mb-0">
                    Showing <span id="feedback-count" class="font-medium">${feedbackCount}</span> items
                </div>
                <div class="flex items-center space-x-4 ml-4">
                    <button id="deleteAllBtn" class="bg-red-500 hover:bg-red-600 text-white text-sm px-3 py-1 rounded-md focus:outline-none transition-colors duration-200">
                        <i class="fas fa-trash-alt mr-1"></i> Delete All Feedback
                    </button>
                    <div class="flex items-center">
                        <label for="sort-by" class="text-sm text-gray-500 mr-2">Sort by:</label>
                        <select id="sort-by" class="bg-white border border-gray-300 rounded-md px-3 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-indigo-500">
                            <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Newest first</option>
                            <option value="oldest" ${sortBy == 'oldest' ? 'selected' : ''}>Oldest first</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Feedback List -->
            <div id="feedback-container" class="space-y-4">
                <c:forEach var="feedback" items="${feedbackList}">
                    <div class="feedback-container border-2 border-gray-200 rounded-xl p-4 mb-4 shadow-md hover:shadow-lg transition-shadow">
                        <div class="feedback-item bg-white rounded-lg p-4 cursor-pointer ${feedback.status == 'new' ? 'border-l-4 border-blue-500' : ''}">
                            <div class="flex justify-between items-start">
                                <div class="flex-1">
                                    <div class="flex items-center mb-1">
                                        <span class="status-dot ${feedback.status == 'new' ? 'bg-blue-500' : 'bg-gray-400'} w-2 h-2 rounded-full mr-2"></span>
                                        <h3 class="text-lg font-medium text-gray-800">${not empty feedback.title ? feedback.title : 'Untitled Feedback'
                                                }</h3>
                                        <i class="expand-icon fas fa-chevron-down text-gray-400 ml-2 text-sm"></i>
                                    </div>
                                    <div class="flex items-center text-sm text-gray-500">
                                        <span class="mr-3"><i class="fas fa-user mr-1"></i>${feedback.userName}</span>
                                        <span class="mr-3"><i class="fas fa-envelope mr-1"></i>${not empty feedback.email ? feedback.email : 'Email not available'}</span>
                                        <span><i class="fas fa-clock mr-1"></i><fmt:formatDate value="${feedback.timestamp}" pattern="MMM d, yyyy h:mm a" /></span>
                                    </div>
                                </div>
                                <div class="flex space-x-2">
                                    <button class="action-button p-1 text-gray-400 hover:text-indigo-600 focus:outline-none" data-id="${feedback.feedbackId}" data-action="archive">
                                        <i class="fas fa-archive"></i>
                                    </button>
                                    <button class="action-button p-1 text-gray-400 hover:text-green-600 focus:outline-none" data-id="${feedback.feedbackId}" data-action="resolve">
                                        <i class="fas fa-check"></i>
                                    </button>
                                    <button class="action-button delete-btn p-1 text-gray-400 hover:text-red-600 focus:outline-none" data-id="${feedback.feedbackId}" data-action="delete">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="feedback-content mt-3 pt-3 border-t border-gray-100">
                                <p class="text-gray-700">${feedback.content}</p>
                                <div class="mt-4 flex justify-end space-x-3">
                                    <button class="px-3 py-1 bg-gray-100 text-gray-700 rounded-md text-sm hover:bg-gray-200 focus:outline-none">
                                        <i class="fas fa-reply mr-1"></i>Reply
                                    </button>
                                    <button class="px-3 py-1 bg-indigo-50 text-indigo-600 rounded-md text-sm hover:bg-indigo-100 focus:outline-none">
                                        <i class="fas fa-tag mr-1"></i>Tag
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Empty State -->
            <c:if test="${empty feedbackList}">
                <div id="empty-state" class="bg-white rounded-lg shadow-sm p-8 text-center">
                    <i class="fas fa-inbox text-4xl text-gray-300 mb-4"></i>
                    <h3 class="text-lg font-medium text-gray-700 mb-2">No feedback yet</h3>
                    <p class="text-gray-500">There are no feedback items in this category.</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Confirmation Modal for Single Feedback Deletion -->
    <div id="confirmationModal" class="modal">
        <div class="modal-content">
            <h2 class="text-xl font-bold mb-4">Confirm Deletion</h2>
            <p class="mb-6">Are you sure you want to permanently delete this feedback? This action cannot be undone.</p>
            <form id="deleteForm" action="${pageContext.request.contextPath}/admin/feedback" method="post">
                <input type="hidden" id="deleteId" name="id" value="">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="type" value="${activeTab}">
                <div class="flex justify-end space-x-3">
                    <button type="button" id="cancelDelete" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">Cancel</button>
                    <button type="submit" id="confirmDelete" class="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600">Delete</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Confirmation Modal for Delete All Feedback -->
    <div id="deleteAllModal" class="modal">
        <div class="modal-content">
            <h2 class="text-xl font-bold mb-4">Delete All Feedback</h2>
            <p class="mb-6">Are you sure you want to permanently delete ALL feedback records? This action cannot be undone and will remove all feedback data from the system.</p>
            <form id="deleteAllForm" action="${pageContext.request.contextPath}/admin/feedback" method="post">
                <input type="hidden" name="action" value="deleteAll">
                <input type="hidden" name="type" value="${activeTab}">
                <div class="flex justify-end space-x-3">
                    <button type="button" id="cancelDeleteAll" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">Cancel</button>
                    <button type="submit" id="confirmDeleteAll" class="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600">Delete All</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Toast Notification -->
    <div style="z-index: 2000;" class="toast-container position-fixed bottom-0 end-0 p-3">
        <!-- Success Toast -->
        <div id="successToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <c:if test="${not empty sessionScope.success}">${sessionScope.success}</c:if>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>

        <!-- Error Toast -->
        <div id="errorToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body" id="errorToastMessage">
                    <c:if test="${not empty sessionScope.err}">${sessionScope.err}</c:if>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <script>
        // DOM elements
        const sortSelect = document.getElementById('sort-by');
        const modal = document.getElementById('confirmationModal');
        const deleteAllModal = document.getElementById('deleteAllModal');
        const cancelDelete = document.getElementById('cancelDelete');
        const confirmDelete = document.getElementById('confirmDelete');
        const deleteAllBtn = document.getElementById('deleteAllBtn');
        const cancelDeleteAll = document.getElementById('cancelDeleteAll');
        const confirmDeleteAll = document.getElementById('confirmDeleteAll');

        // Initialize the page
        document.addEventListener('DOMContentLoaded', () => {
            setupEventListeners();
            initializeToasts();
            setupSearch();
        });

        // Initialize toast notifications
        function initializeToasts() {
            // Check if success message exists in session
            if ('${not empty sessionScope.success}' === 'true') {
                const successToastEl = document.getElementById('successToast');
                if (successToastEl) {
                    const successToast = new bootstrap.Toast(successToastEl, {delay: 5000});
                    successToast.show();
                    // Clear the session attribute after showing the toast
                    <% session.removeAttribute("success"); %>
                }
            }

            // Check if error message exists in session
            if ('${not empty sessionScope.err}' === 'true') {
                const errorToastEl = document.getElementById('errorToast');
                if (errorToastEl) {
                    const errorToast = new bootstrap.Toast(errorToastEl, {delay: 5000});
                    errorToast.show();
                    // Clear the session attribute after showing the toast
                    <% session.removeAttribute("err"); %>
                }
            }
        }

        // Set up event listeners
        function setupEventListeners() {
            // Sort select change
            sortSelect.addEventListener('change', () => {
                window.location.href = '${pageContext.request.contextPath}/admin/feedback?type=${activeTab}&sort=' + sortSelect.value;
            });

            // Set up click events for feedback items
            document.querySelectorAll('.feedback-item').forEach(item => {
                item.addEventListener('click', function(e) {
                    // Don't expand if clicking on an action button
                    if (!e.target.closest('.action-button')) {
                        this.classList.toggle('expanded');
                    }
                });
            });

            // Set up click events for action buttons
            document.querySelectorAll('.action-button').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const action = this.getAttribute('data-action');
                    const id = this.getAttribute('data-id');

                    if (action === 'delete') {
                        // Show confirmation modal and set the feedback ID in the form
                        document.getElementById('deleteId').value = id;
                        modal.style.display = 'block';
                    } else {
                        // Handle other actions directly
                        handleFeedbackAction(id, action);
                    }
                });
            });

            // Delete All button event listener
            if (deleteAllBtn) {
                deleteAllBtn.addEventListener('click', () => {
                    // Show delete all confirmation modal
                    deleteAllModal.style.display = 'block';
                });
            }

            // Single delete modal event listeners
            cancelDelete.addEventListener('click', () => {
                modal.style.display = 'none';
            });

            // The form submission is now handled by the form's submit event
            // No need for confirmDelete click handler as the button is now a submit button

            // Delete all modal event listeners
            cancelDeleteAll.addEventListener('click', () => {
                deleteAllModal.style.display = 'none';
            });

            // The form submission is now handled by the form's submit event
            // No need for confirmDeleteAll click handler as the button is now a submit button

            // Close modals when clicking outside
            window.addEventListener('click', (e) => {
                if (e.target === modal) {
                    modal.style.display = 'none';
                }
                if (e.target === deleteAllModal) {
                    deleteAllModal.style.display = 'none';
                }
            });
        }

        // Handle feedback actions (archive, resolve)
        function handleFeedbackAction(id, action) {
            // Create form data
            const formData = new FormData();
            formData.append('action', action);
            formData.append('id', id);

            // Send AJAX request
            fetch('${pageContext.request.contextPath}/admin/feedback', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Success - refresh the page
                    window.location.reload();
                } else {
                    // Error - show alert
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            });
        }

        // Setup search functionality
        function setupSearch() {
            const searchInput = document.getElementById('searchInput');
            if (!searchInput) return;

            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.trim().toLowerCase();
                const feedbackItems = document.querySelectorAll('.feedback-container');
                let matchCount = 0;

                // Remove existing highlights
                document.querySelectorAll('.highlight').forEach(el => {
                    const parent = el.parentNode;
                    parent.replaceChild(document.createTextNode(el.textContent), el);
                    parent.normalize();
                });

                feedbackItems.forEach(container => {
                    const feedbackContent = container.querySelector('.feedback-content p');
                    const feedbackTitle = container.querySelector('h3');
                    const feedbackItem = container.querySelector('.feedback-item');

                    if (!feedbackContent || !feedbackTitle || !feedbackItem) return;

                    const contentText = feedbackContent.textContent.toLowerCase();
                    const titleText = feedbackTitle.textContent.toLowerCase();

                    if (searchTerm === '') {
                        // If search is empty, show all items and remove highlights
                        container.style.display = '';
                        return;
                    }

                    // Check if the search term is in the content or title
                    if (contentText.includes(searchTerm) || titleText.includes(searchTerm)) {
                        matchCount++;
                        container.style.display = '';

                        // Expand the item to show content
                        feedbackItem.classList.add('expanded');

                        // Highlight matches in content
                        if (contentText.includes(searchTerm)) {
                            highlightText(feedbackContent, searchTerm);
                        }

                        // Highlight matches in title
                        if (titleText.includes(searchTerm)) {
                            highlightText(feedbackTitle, searchTerm);
                        }
                    } else {
                        container.style.display = 'none';
                    }
                });

                // Update the feedback count
                const feedbackCount = document.getElementById('feedback-count');
                if (feedbackCount) {
                    feedbackCount.textContent = searchTerm ? matchCount : '${feedbackCount}';
                }

                // Show/hide empty state
                const emptyState = document.getElementById('empty-state');
                if (emptyState) {
                    if (searchTerm && matchCount === 0) {
                        emptyState.style.display = '';
                        emptyState.querySelector('h3').textContent = 'No matching feedback';
                        emptyState.querySelector('p').textContent = 'No feedback items match your search criteria.';
                    } else if (searchTerm) {
                        emptyState.style.display = 'none';
                    }
                }
            });
        }

        // Function to highlight text in an element
        function highlightText(element, searchTerm) {
            const innerHTML = element.innerHTML;
            const index = element.textContent.toLowerCase().indexOf(searchTerm.toLowerCase());
            if (index >= 0) {
                const length = searchTerm.length;
                const beforeText = element.textContent.substring(0, index);
                const matchText = element.textContent.substring(index, index + length);
                const afterText = element.textContent.substring(index + length);

                // Create a new element with the highlighted text
                const highlightedHTML = document.createTextNode(beforeText);
                const highlightSpan = document.createElement('span');
                highlightSpan.className = 'highlight';
                highlightSpan.textContent = matchText;

                // Clear the element and append the new content
                element.innerHTML = '';
                element.appendChild(highlightedHTML);
                element.appendChild(highlightSpan);
                element.appendChild(document.createTextNode(afterText));
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
