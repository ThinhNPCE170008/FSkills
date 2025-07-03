<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Feedback Form - F-Skills</title>

  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <script src="https://cdn.tailwindcss.com/3.4.16"></script>
  <script>
    tailwind.config={
      theme:{
        extend:{
          colors:{
            primary:'#4CAF50',
            secondary:'#2E7D32'
          },
          borderRadius:{
            'none':'0px',
            'sm':'4px',
            DEFAULT:'8px',
            'md':'12px',
            'lg':'16px',
            'xl':'20px',
            '2xl':'24px',
            '3xl':'32px',
            'full':'9999px',
            'button':'8px'
          }
        }
      }
    }
  </script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.6.0/remixicon.min.css">
  <style>
    body {
      background-color: #f8fafc;
      height: 100vh;
      display: flex;
      font-family: 'Inter', sans-serif;
      overflow: hidden;
      margin: 0;
      padding: 0;
    }
    .custom-radio {
      display: flex;
      align-items: center;
      cursor: pointer;
    }
    .custom-radio-input {
      appearance: none;
      -webkit-appearance: none;
      width: 20px;
      height: 20px;
      border: 2px solid #d1d5db;
      border-radius: 50%;
      margin-right: 8px;
      position: relative;
      cursor: pointer;
    }
    .custom-radio-input:checked {
      border-color: #4CAF50;
    }
    .custom-radio-input:checked::after {
      content: "";
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 10px;
      height: 10px;
      background-color: #4CAF50;
      border-radius: 50%;
    }
    textarea, input[type="text"], input[type="email"] {
      transition: border-color 0.2s;
    }
    textarea:focus, input[type="text"]:focus, input[type="email"]:focus {
      border-color: #4CAF50;
      outline: none;
      box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
    }
    .main-content {
      flex: 1; /* Cho phép main-content chiếm hết không gian còn lại */
      display: flex;
      flex-direction: column; /* Sắp xếp header và feedback-container theo chiều dọc */
      height: 100vh; /* Quan trọng để flex-direction: column hoạt động đúng cách */
      transition: margin-left 0.3s ease;
      box-sizing: border-box;
      margin-left: 80px; /* sidebar ban đầu */
      padding: 0;
    }
    .header {
      flex-shrink: 0; /* Ngăn header bị co lại */
      /* Các style khác của header */
    }
    .feedback-container {
      flex: 1; /* Cho phép feedback-container chiếm hết không gian còn lại trong main-content */
      display: flex;
      align-items: center; /* Căn giữa theo chiều dọc */
      justify-content: center; /* Căn giữa theo chiều ngang */
      padding: 10px; /* Giảm padding để tối đa hóa không gian */
      overflow-y: auto; /* Cho phép cuộn chỉ trong phần feedback-container nếu nội dung quá lớn */
      box-sizing: border-box;
      height: 100%; /* Đảm bảo chiếm toàn bộ chiều cao */
    }
    /* Make the feedback form responsive and use maximum available space */
    .feedback-container > div { /* Target the div with w-[1300px] */
      width: 100%; /* Đảm bảo nó không vượt quá 1300px nhưng vẫn responsive */
      max-width: 1300px; /* Giới hạn chiều rộng tối đa */
      height: 100%; /* Chiếm toàn bộ chiều cao có sẵn */
      min-height: 500px; /* Đảm bảo chiều cao tối thiểu */
      display: flex;
      flex-direction: column;
      margin: 0 auto; /* Căn giữa và loại bỏ margin không cần thiết */
    }
    .feedback-container form {
      flex: 1; /* Cho phép form chiếm hết không gian còn lại */
      display: flex;
      flex-direction: column;
    }
    .grid.grid-cols-2.gap-6 {
      flex: 1; /* Cho phép grid chiếm hết không gian còn lại trong form */
      height: 100% !important; /* Đảm bảo grid chiếm toàn bộ chiều cao */
      min-height: 0; /* Cho phép grid co lại khi cần thiết */
    }
    .col-span-1.flex.flex-col.h-full {
      height: 100%; /* Đảm bảo chiếm toàn bộ chiều cao của grid */
      min-height: 0; /* Cho phép co lại khi cần thiết */
    }
    textarea#feedbackContent {
      flex: 1; /* Cho textarea chiếm hết chiều cao còn lại trong cột của nó */
      min-height: 150px; /* Chiều cao tối thiểu cho textarea */
      height: 100%; /* Đảm bảo chiếm toàn bộ chiều cao có sẵn */
      box-sizing: border-box; /* Đảm bảo padding không làm tăng kích thước */
      resize: none; /* Ngăn người dùng thay đổi kích thước, để tránh phá vỡ layout */
    }

    /* Slide effect for sidebar - main content and header */
    .sidebar:hover ~ .main-content {
      margin-left: 250px; /* Chiều rộng sidebar khi hover */
      width: calc(100% - 250px); /* Điều chỉnh chiều rộng của main-content */
    }
  </style>
</head>
<body>
<jsp:include page="/layout/sidebar_user.jsp" />

<div class="main-content">
  <%--  <jsp:include page="/layout/header_user.jsp" />--%>

  <div class="feedback-container">

    <div class="w-[1300px] mx-auto bg-white shadow-xl rounded-xl p-6 border border-green-100" style="box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04); height: calc(100% - 20px);">
      <div class="text-center mb-4">
        <h1 class="text-3xl font-bold text-gray-900 mb-2 bg-gradient-to-r from-green-600 to-green-400 bg-clip-text text-transparent">Share Your Feedback</h1>
        <p class="text-sm text-gray-600 max-w-2xl mx-auto">We value your input! Help us improve by sharing your thoughts, suggestions, or questions.</p>
      </div>
      <form id="feedbackForm" action="${pageContext.request.contextPath}/feedback" method="POST" class="h-full flex flex-col">
        <div class="grid grid-cols-2 gap-6 flex-grow"> <%-- Added flex-grow to ensure it takes available space --%>
          <div class="col-span-1 flex flex-col h-full">
            <div class="space-y-4">
              <p class="text-sm font-medium text-gray-800 mb-2">Feedback Type:</p>
              <div class="flex gap-4">
                <label class="custom-radio hover:bg-green-50 px-3 py-2 rounded-lg transition-all">
                  <input type="radio" name="feedbackType" value="comments" class="custom-radio-input" checked>
                  <span class="text-sm font-medium text-gray-700">Comments</span>
                </label>
                <label class="custom-radio hover:bg-green-50 px-3 py-2 rounded-lg transition-all">
                  <input type="radio" name="feedbackType" value="suggestions" class="custom-radio-input">
                  <span class="text-sm font-medium text-gray-700">Suggestions</span>
                </label>
                <label class="custom-radio hover:bg-green-50 px-3 py-2 rounded-lg transition-all">
                  <input type="radio" name="feedbackType" value="questions" class="custom-radio-input">
                  <span class="text-sm font-medium text-gray-700">Questions</span>
                </label>
              </div>
              <div class="grid grid-cols-2 gap-4 mt-4">
                <div>
                  <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
                  <input type="text" id="firstName" name="firstName" class="w-full border border-gray-200 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-green-200 focus:border-green-500 transition-all" placeholder="John" value="${sessionScope.user.displayName != null ? sessionScope.user.displayName.split(' ')[0] : ''}">
                </div>
                <div>
                  <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
                  <input type="text" id="lastName" name="lastName" class="w-full border border-gray-200 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-green-200 focus:border-green-500 transition-all" placeholder="Doe">
                </div>
              </div>
              <div class="mt-4">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email Receive Feedback</label>
                <input type="email" id="email" name="email" class="w-full border border-gray-200 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-green-200 focus:border-green-500 transition-all" placeholder="ex: myname@example.com" value="${sessionScope.user.email != null ? sessionScope.user.email : ''}">
              </div>
            </div>
            <div class="mt-auto pt-4">
              <button type="submit" class="bg-gradient-to-r from-green-500 to-green-600 text-white font-medium py-2.5 px-6 rounded-lg hover:shadow-md transition-all duration-300 whitespace-nowrap text-sm shadow-sm hover:shadow-green-100">
                Submit Feedback <i class="ri-send-plane-2-fill ml-1"></i>
              </button>
            </div>
          </div>
          <div class="col-span-1 flex flex-col h-full"> <%-- Added h-full to ensure full height --%>
            <div class="mb-3">
              <label for="feedbackTitle" class="block text-sm font-medium text-gray-800 mb-1">Title Name:</label>
              <input type="text" id="feedbackTitle" name="feedbackTitle" class="w-full border border-gray-200 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-green-200 focus:border-green-500 transition-all" placeholder="Enter a title for your feedback">
            </div>
            <label for="feedbackContent" class="block text-sm font-medium text-gray-800 mb-1">Describe Your Feedback:</label>
            <textarea id="feedbackContent" name="feedbackContent" class="w-full flex-grow border border-gray-200 rounded-lg p-3 text-sm focus:ring-2 focus:ring-green-200 focus:border-green-500 transition-all" placeholder="Please share your feedback details here..." style="min-height: 200px; height: 100%;"></textarea>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Toast Notification -->
<div style="z-index: 2000;" class="toast-container position-fixed bottom-0 end-0 p-3">
  <!-- Success Toast -->
  <div id="successToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body">
        <c:if test="${not empty success}">${success}</c:if>
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>

  <!-- Error Toast -->
  <div id="errorToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body" id="errorToastMessage">
        <c:if test="${not empty err}">${err}</c:if>
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>

  <!-- Validation Error Toast -->
  <div id="validationErrorToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body" id="validationErrorMessage">
        Validation error message
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    // Initialize toast notifications
    if ('${not empty success}' === 'true') {
      const successToastEl = document.getElementById('successToast');
      if (successToastEl) {
        const successToast = new bootstrap.Toast(successToastEl, {delay: 5000});
        successToast.show();
      }
    }

    if ('${not empty err}' === 'true') {
      const errorToastEl = document.getElementById('errorToast');
      if (errorToastEl) {
        const errorToast = new bootstrap.Toast(errorToastEl, {delay: 5000});
        errorToast.show();
      }
    }

    const form = document.getElementById("feedbackForm");
    const feedbackContent = document.getElementById("feedbackContent");
    // const questionTips = document.getElementById("questionTips"); // Giữ nguyên bị comment nếu không dùng trong HTML
    const feedbackTypeRadios = document.querySelectorAll('input[name="feedbackType"]');

    function updatePlaceholder(type) {
      switch (type) {
        case "questions":
          feedbackContent.placeholder = "Please enter your questions details here...";
          break;
        case "comments":
          feedbackContent.placeholder = "Please enter your comments details here...";
          break;
        case "suggestions":
          feedbackContent.placeholder = "Please enter your suggestions details here...";
          break;
      }
    }

    // Lắng nghe sự kiện change trên tất cả các radio button của feedbackType
    feedbackTypeRadios.forEach(radio => {
      radio.addEventListener("change", function() {
        updatePlaceholder(this.value);
      });
    });

    // Thiết lập placeholder ban đầu dựa trên radio được chọn mặc định
    const initialFeedbackType = document.querySelector('input[name="feedbackType"]:checked').value;
    updatePlaceholder(initialFeedbackType);


    // Function to show validation error toast
    function showValidationError(message) {
      const validationErrorMessage = document.getElementById('validationErrorMessage');
      validationErrorMessage.textContent = message;
      const validationErrorToast = new bootstrap.Toast(document.getElementById('validationErrorToast'), {delay: 5000});
      validationErrorToast.show();
    }

    form.addEventListener("submit", function (e) {
      const feedbackContentValue = feedbackContent.value.trim(); // Dùng biến mới để tránh nhầm lẫn với element
      const email = document.getElementById("email").value.trim();

      if (!feedbackContentValue) {
        e.preventDefault();
        showValidationError("Please enter your feedback content.");
        return;
      }

      if (!email) {
        e.preventDefault();
        showValidationError("Please enter your email address.");
        return;
      }

      // Thêm validation email cơ bản
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailPattern.test(email)) {
        e.preventDefault();
        showValidationError("Please enter a valid email address.");
        return;
      }

      // Form will submit if validation passes
    });
  });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
