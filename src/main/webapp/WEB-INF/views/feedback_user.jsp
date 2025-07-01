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
    :where([class^="ri-"])::before { content: "\f3c2"; }
    body {
      background-color: #ffffff;
      height: 100vh; /* Đảm bảo body chiếm toàn bộ chiều cao viewport */
      display: flex; /* Sử dụng flexbox cho body */
      font-family: 'Roboto', sans-serif;
      overflow: hidden; /* Ngăn cuộn toàn bộ trang nếu không muốn */
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
      padding: 20px; /* Thêm padding để tránh nội dung dính sát vào mép */
      overflow-y: auto; /* Cho phép cuộn chỉ trong phần feedback-container nếu nội dung quá lớn */
      box-sizing: border-box;
    }
    /* Optional: Make the feedback form responsive to the container height */
    .feedback-container > div { /* Target the div with w-[1300px] */
      width: 100%; /* Đảm bảo nó không vượt quá 1300px nhưng vẫn responsive */
      max-width: 1300px; /* Giới hạn chiều rộng tối đa */
      height: auto; /* Chiều cao tự động điều chỉnh theo nội dung */
      min-height: 500px; /* Đảm bảo chiều cao tối thiểu */
      display: flex;
      flex-direction: column;
    }
    .feedback-container form {
      flex: 1; /* Cho phép form chiếm hết không gian còn lại */
      display: flex;
      flex-direction: column;
    }
    .grid.grid-cols-2.gap-6 {
      flex: 1; /* Cho phép grid chiếm hết không gian còn lại trong form */
      height: auto !important; /* Loại bỏ chiều cao cố định để nó tự co giãn */
    }
    .col-span-1.flex.flex-col.h-full {
      height: auto; /* Loại bỏ chiều cao 100% cứng nhắc, cho phép flex tự điều chỉnh */
    }
    textarea#feedbackContent {
      flex: 1; /* Cho textarea chiếm hết chiều cao còn lại trong cột của nó */
      min-height: 150px; /* Chiều cao tối thiểu cho textarea */
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
    <c:if test="${not empty success}">
      <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded absolute top-4 right-4 z-50" role="alert">
        <span class="block sm:inline">${success}</span>
      </div>
    </c:if>

    <c:if test="${not empty err}">
      <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded absolute top-4 right-4 z-50" role="alert">
        <span class="block sm:inline">${err}</span>
      </div>
    </c:if>

    <div class="w-[1300px] mx-auto bg-white shadow-lg rounded-lg p-6 border border-green-500" style="margin-right: 80px;">
      <div class="text-center mb-4">
        <h1 class="text-2xl font-bold text-gray-900 mb-2">Feedback Form</h1>
        <p class="text-sm text-gray-700 max-w-2xl mx-auto">We would love to hear your thoughts, suggestions, concerns or problems with anything so we can improve!</p>
      </div>
      <form id="feedbackForm" action="${pageContext.request.contextPath}/feedback" method="POST">
        <div class="grid grid-cols-2 gap-6"> <%-- Removed h-[calc(100%-80px)] from here --%>
          <div class="col-span-1 flex flex-col h-full">
            <div class="space-y-4">
              <p class="text-sm font-medium text-gray-800 mb-2">Feedback Type:</p>
              <div class="flex gap-4">
                <label class="custom-radio">
                  <input type="radio" name="feedbackType" value="comments" class="custom-radio-input" checked>
                  <span class="text-sm text-gray-700">Comments</span>
                </label>
                <label class="custom-radio">
                  <input type="radio" name="feedbackType" value="suggestions" class="custom-radio-input">
                  <span class="text-sm text-gray-700">Suggestions</span>
                </label>
                <label class="custom-radio">
                  <input type="radio" name="feedbackType" value="questions" class="custom-radio-input">
                  <span class="text-sm text-gray-700">Questions</span>
                </label>
              </div>
              <div class="grid grid-cols-2 gap-4 mt-4">
                <div>
                  <label for="firstName" class="block text-sm font-medium text-gray-800 mb-1">First Name</label>
                  <input type="text" id="firstName" name="firstName" class="w-full border border-gray-300 rounded-lg p-2 text-sm" placeholder="John" value="${sessionScope.user.displayName != null ? sessionScope.user.displayName.split(' ')[0] : ''}">
                </div>
                <div>
                  <label for="lastName" class="block text-sm font-medium text-gray-800 mb-1">Last Name</label>
                  <input type="text" id="lastName" name="lastName" class="w-full border border-gray-300 rounded-lg p-2 text-sm" placeholder="Doe">
                </div>
              </div>
              <div class="mt-4">
                <label for="email" class="block text-sm font-medium text-gray-800 mb-1">E-mail</label>
                <input type="email" id="email" name="email" class="w-full border border-gray-300 rounded-lg p-2 text-sm" placeholder="ex: myname@example.com" value="${sessionScope.user.email != null ? sessionScope.user.email : ''}">
              </div>
            </div>
            <div class="mt-auto pt-4">
              <button type="submit" class="bg-green-500 text-white font-medium py-2 px-6 rounded-button hover:bg-opacity-90 transition-all whitespace-nowrap text-sm">Submit Feedback</button>
            </div>
          </div>
          <div class="col-span-1 flex flex-col"> <%-- Added flex flex-col here to make textarea expand --%>
            <label for="feedbackContent" class="block text-sm font-medium text-gray-800 mb-1">Describe Your Feedback:</label>
            <textarea id="feedbackContent" name="feedbackContent" class="w-full h-full border border-gray-300 rounded-lg p-3 text-sm" placeholder="Please share your feedback details here..."></textarea>
            <%--              <div id="questionTips" class="hidden mt-2 p-2 bg-gray-50 rounded text-xs text-gray-600">--%>
            <%--                <p class="font-medium mb-1">Tips for asking questions:</p>--%>
            <%--                <ul class="list-disc pl-4 space-y-0.5">--%>
            <%--                  <li>Be specific about your question</li>--%>
            <%--                  <li>Include relevant details</li>--%>
            <%--                  <li>Explain what you've already tried</li>--%>
            <%--                  <li>Keep it clear and concise</li>--%>
            <%--                </ul>--%>
            <%--              </div>--%>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("feedbackForm");
    const feedbackContent = document.getElementById("feedbackContent");
    // const questionTips = document.getElementById("questionTips"); // Giữ nguyên bị comment nếu không dùng trong HTML
    const feedbackTypeRadios = document.querySelectorAll('input[name="feedbackType"]');

    function updatePlaceholder(type) {
      switch (type) {
        case "questions":
          feedbackContent.placeholder = "Vui lòng nhập câu hỏi của bạn ở đây...";
          // if (questionTips) questionTips.classList.remove("hidden"); // Uncomment nếu sử dụng questionTips
          break;
        case "comments":
          feedbackContent.placeholder = "Please share your feedback details here...";
          // if (questionTips) questionTips.classList.add("hidden"); // Uncomment nếu sử dụng questionTips
          break;
        case "suggestions":
          feedbackContent.placeholder = "Please share your suggestions here...";
          // if (questionTips) questionTips.classList.add("hidden"); // Uncomment nếu sử dụng questionTips
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


    form.addEventListener("submit", function (e) {
      const feedbackContentValue = feedbackContent.value.trim(); // Dùng biến mới để tránh nhầm lẫn với element
      const email = document.getElementById("email").value.trim();

      if (!feedbackContentValue) {
        e.preventDefault();
        alert("Please enter your feedback content.");
        return;
      }

      if (!email) {
        e.preventDefault();
        alert("Please enter your email address.");
        return;
      }

      // Thêm validation email cơ bản
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailPattern.test(email)) {
        e.preventDefault();
        alert("Please enter a valid email address.");
        return;
      }

      // Form will submit if validation passes
    });
  });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>