```html
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Profile - F-Skills</title>

  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
  <style>
    .verified-badge {
      display: inline-flex;
      align-items: center;
      color: #28a745;
      font-size: 0.9em;
      margin-left: 8px;
      background-color: rgba(40, 167, 69, 0.1);
      padding: 2px 8px;
      border-radius: 12px;
      font-weight: 500;
    }
    .verified-badge i {
      margin-right: 4px;
    }
    .avatar-modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    /* Styles for change-password-container and change-email-container moved to profile.css */
    .avatar-modal-close {
      float: right;
      font-size: 1.5rem;
      cursor: pointer;
    }
  </style>
</head>

<body>
<c:choose>
  <c:when test="${sessionScope.user.role eq 'ADMIN'}">
    <jsp:include page="/layout/sidebar_admin.jsp"/>
  </c:when>
  <c:otherwise>
    <jsp:include page="/layout/sidebar_user.jsp"/>
  </c:otherwise>
</c:choose>
<div class="profile-edit-container">

  <div class="welcome-section">
    <h1>Welcome back, <c:out
            value="${not empty sessionScope.user.displayName ? sessionScope.user.displayName : 'Guest'}"/>!</h1>
  </div>

  <c:if test="${not empty profile}">
    <%-- Profile Display Card --%>
  <div class="profile-card">
    <div class="profile-header">
      <div class="avatar">
        <img src="${profile.imageDataURI}" alt="Avatar">
      </div>
      <div class="user-info">
        <h2><c:out value="${profile.displayName}"/></h2>
        <p>
          <c:out value="${profile.email}"/>

          <c:choose>
            <c:when test="${profile.isVerified}">
              <span class="verified-badge" title="Email đã xác nhận">
                <i class="bi bi-check-circle-fill"></i> Confirmed
              </span>
            </c:when>
            <c:otherwise>
              <span class="unverified-badge" title="Email chưa xác minh">
                <i class="bi bi-exclamation-circle-fill"></i> Not Verified
              </span>
            </c:otherwise>
          </c:choose>
        </p>
        <div class="btn-group">
          <button class="change-password">Change Password</button>
          <button class="change-email">Change Email</button>
          <button class="edit-btn">Edit Profile</button>
        </div>
      </div>
    </div>
    <div class="profile-details">
      <div class="field name-field">
        <label>Full Name</label>
        <input type="text" value="<c:out value="${profile.displayName}"/>" readonly>
      </div>
      <div class="field phone-field">
        <label>Phone Number</label>
        <input type="text" value="<c:out value="${profile.phoneNumber}"/>" readonly>
      </div>
      <div class="field gender-field">
        <label>Gender</label>
        <select disabled>
          <option value="true" ${profile.gender ? 'selected' : ''}>Male</option>
          <option value="false" ${!profile.gender ? 'selected' : ''}>Female</option>
        </select>
      </div>
      <div class="field dob-field">
        <label>Date of Birth</label>
        <input type="date" value="<fmt:formatDate value="${profile.dateOfBirth}" pattern="yyyy-MM-dd" />"
               readonly>
      </div>

      <div class="field address-field">
        <label>Address</label>
        <input type="text" value="<c:out value="${profile.info}"/>" readonly>
      </div>
    </div>
  </div>

    <%-- Profile Edit Form (Initially Hidden) --%>
  <form class="profile-form" id="profileEditForm"
        action="${pageContext.request.contextPath}${sessionScope.user.role eq 'INSTRUCTOR' ? '/instructor/profile' : sessionScope.user.role eq 'ADMIN' ? '/admin/profile' : '/learner/profile'}?action=edit"
        method="POST" enctype="multipart/form-data" style="display: none;">
    <div class="avatar-section">
      <div class="avatar-container">
        <img src="${profile.imageDataURI}" alt="Profile Picture" id="avatar-preview">
      </div>
      <input type="file" id="avatar-upload" name="avatar" accept="image/*" hidden>
      <button type="button" class="avatar-upload-btn" onclick="document.getElementById('avatar-upload').click()">
        Change Profile Picture
      </button>
    </div>

    <div class="form-row">
      <div class="form-group name-group">
        <label for="displayName">Full Name</label>
        <input type="text" id="displayName" name="displayName" value="<c:out value="${profile.displayName}"/>"
               required>
      </div>
      <div class="form-group phone-group">
        <label for="phoneNumber">Phone Number</label>
        <input type="tel" id="phoneNumber" name="phoneNumber" value="<c:out value="${profile.phoneNumber}"/>"
               required>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group gender-group">
        <label for="gender">Gender</label>
        <select id="gender" name="gender">
          <option value="true" ${profile.gender ? 'selected' : ''}>Male</option>
          <option value="false" ${!profile.gender ? 'selected' : ''}>Female</option>
        </select>
      </div>
      <div class="form-group dob-group">
        <label for="dateOfBirth">Date of Birth</label>
        <input type="date" id="dateOfBirth" name="dateOfBirth"
               value="<fmt:formatDate value="${profile.dateOfBirth}" pattern="yyyy-MM-dd" />">
      </div>
    </div>

    <div class="form-row">
      <div class="form-group address-group">
        <label for="info">Address</label>
        <input type="text" id="info" name="info" value="<c:out value="${profile.info}"/>">
      </div>
    </div>

    <div class="button-group">
      <button type="button" class="cancel-btn">Cancel</button>
      <button type="submit" class="save-btn">Save Changes</button>
    </div>
  </form>
  </c:if>

  <!-- Modal for Avatar Preview -->
  <div id="avatarModal" class="avatar-modal">
    <span class="avatar-modal-close">×</span>
    <img class="avatar-modal-content" id="modalImage">
  </div>

  <!-- Modal for Change Password -->
  <div id="passwordModal" class="avatar-modal">
    <div class="change-password-container">
      <span class="avatar-modal-close password-modal-close">×</span>
      <h1>Change Password</h1>

      <form id="passwordForm"
            action="${pageContext.request.contextPath}${sessionScope.user.role eq 'INSTRUCTOR' ? '/instructor/profile' : sessionScope.user.role eq 'ADMIN' ? '/admin/profile' : '/learner/profile'}?action=password"
            method="POST">
        <div class="form-group">
          <label for="oldPassword">Old Password</label>
          <input type="password" id="oldPassword" name="oldPassword" required>
        </div>
        <div class="form-group">
          <label for="newPassword">New Password</label>
          <input type="password" id="newPassword" name="newPassword" required>
          <div class="password-requirements">
            <p class="requirement" id="length-requirement">At least 8 characters</p>
            <p class="requirement" id="case-requirement">Must have uppercase and lowercase letters</p>
            <p class="requirement" id="special-requirement">Must have special characters</p>
          </div>
        </div>
        <div class="form-group">
          <label for="confirmPassword">Confirm New Password</label>
          <input type="password" id="confirmPassword" name="confirmPassword" required>
          <p id="confirm-message" class="requirement"></p>
        </div>
        <button type="submit" id="savePasswordBtn" disabled>Save Change</button>
      </form>
    </div>
  </div>

  <!-- Modal for Change Email -->
  <div id="emailModal" class="avatar-modal">
    <div class="change-email-container">
      <span class="avatar-modal-close email-modal-close">×</span>
      <h1>Change Email</h1>

      <form id="emailForm"
            action="${pageContext.request.contextPath}${sessionScope.user.role eq 'INSTRUCTOR' ? '/instructor/profile' : sessionScope.user.role eq 'ADMIN' ? '/admin/profile' : '/learner/profile'}?action=changeEmail"
            method="POST">
        <div class="form-group">
          <label for="newEmail">New Email</label>
          <div style="display: flex; align-items: center;">
            <input type="email" id="newEmail" name="newEmail" required>
            <button type="button" id="sendOtpBtn">Send OTP</button>
          </div>
          <div class="password-requirements">
            <p class="requirement" id="email-format">Valid email format required</p>
            <p class="requirement" id="email-number">Must contain at least one number</p>
          </div>
        </div>
      </form>
      <form
              id="OTPForm"
              action="${pageContext.request.contextPath}${sessionScope.user.role eq 'INSTRUCTOR' ? '/instructor/profile' : sessionScope.user.role eq 'ADMIN' ? '/admin/profile' : '/learner/profile'}?action=OTP"
              method="POST">
      <div class="form-group">
          <label for="otpCode">OTP Code</label>
          <input type="text" id="otpCode" name="otpCode" required>
          <p id="otp-message" class="requirement"></p>
        </div>
        <button type="submit" id="saveEmailBtn" disabled>Save Change</button>
      </form>
    </div>
  </div>

  <!-- Toast Notification -->
  <div style="z-index: 2000;" class="toast-container position-fixed bottom-0 end-0 p-3">
    <!-- Error Toast -->
    <div id="serverToast" class="toast align-items-center text-bg-danger border-0" role="alert"
         aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          <c:if test="${not empty err}">${err}</c:if>
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="Close"></button>
      </div>
    </div>

    <!-- Password Success Toast -->
    <div id="passwordSuccessToast" class="toast align-items-center text-bg-success border-0" role="alert"
         aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          Password changed successfully.
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="Close"></button>
      </div>
    </div>

    <!-- Email Success Toast -->
    <div id="emailSuccessToast" class="toast align-items-center text-bg-success border-0" role="alert"
         aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          Email changed successfully.
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="Close"></button>
      </div>
    </div>

    <!-- Profile Success Toast -->
    <div id="profileSuccessToast" class="toast align-items-center text-bg-success border-0" role="alert"
         aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          Profile updated successfully.
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="Close"></button>
      </div>
    </div>

    <!-- Profile Error Toast -->
    <div id="profileErrorToast" class="toast align-items-center text-bg-danger border-0" role="alert"
         aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">
          Failed to update profile.
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="Close"></button>
      </div>
    </div>

    <!-- Custom Error Toast -->
    <div id="customErrorToast" class="toast align-items-center text-bg-danger border-0" role="alert"
         aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body" id="customErrorMessage">
          Error message here
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="Close"></button>
      </div>
    </div>

    <!-- Custom Success Toast -->
    <div id="customSuccessToast" class="toast align-items-center text-bg-success border-0" role="alert"
         aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body" id="customSuccessMessage">
          Success message here
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                aria-label="Close"></button>
      </div>
    </div>
  </div>

  <script>
    // JavaScript for toggling view and image preview
    const profileCard = document.querySelector('.profile-card');
    const form = document.querySelector('.profile-form');
    const editBtn = document.querySelector('.edit-btn');
    const cancelBtn = document.querySelector('.cancel-btn');
    const changePasswordBtn = document.querySelector('.change-password');
    const changeEmailBtn = document.querySelector('.change-email');

    // Toggle between view and edit mode
    editBtn.addEventListener('click', () => {
      profileCard.style.display = 'none';
      form.style.display = 'block';
    });

    cancelBtn.addEventListener('click', () => {
      profileCard.style.display = 'block';
      form.style.display = 'none';
    });

    changePasswordBtn.addEventListener('click', () => {
      document.getElementById('passwordModal').style.display = 'block';
    });

    changeEmailBtn.addEventListener('click', () => {
      document.getElementById('emailModal').style.display = 'block';
      document.getElementById('newEmail').value = '';
      document.getElementById('otpCode').value = '';
      document.getElementById('otp-message').textContent = '';
      document.getElementById('saveEmailBtn').disabled = true;
    });

    // Preview avatar
    document.getElementById('avatar-upload').addEventListener('change', function (e) {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = function (event) {
          document.getElementById('avatar-preview').src = event.target.result;
        }
        reader.readAsDataURL(file);
      }
    });

    // Avatar Modal Popup
    const modal = document.getElementById("avatarModal");
    const modalImg = document.getElementById("modalImage");
    const closeBtn = document.getElementsByClassName("avatar-modal-close")[0];

    // Get all avatar images
    const avatarImages = document.querySelectorAll('.avatar img, .avatar-container img');

    // Add click event to all avatar images
    avatarImages.forEach(img => {
      img.style.cursor = 'pointer';
      img.addEventListener('click', function () {
        modal.style.display = "block";
        modalImg.src = this.src;
      });
    });

    // Close the modal when clicking on the close button
    closeBtn.addEventListener('click', function () {
      modal.style.display = "none";
    });

    // Close modals when clicking outside
    window.addEventListener('click', function (event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
      if (event.target == document.getElementById('passwordModal')) {
        document.getElementById('passwordModal').style.display = "none";
      }
      if (event.target == document.getElementById('emailModal')) {
        document.getElementById('emailModal').style.display = "none";
      }
    });

    // Close password modal
    document.querySelector('.password-modal-close').addEventListener('click', function () {
      document.getElementById('passwordModal').style.display = "none";
    });

    // Close email modal
    document.querySelector('.email-modal-close').addEventListener('click', function () {
      document.getElementById('emailModal').style.display = "none";
    });

    // Auto-hide alerts after 3 seconds
    window.addEventListener('load', function () {
      const alerts = document.querySelectorAll('.alert');
      if (alerts.length > 0) {
        setTimeout(function () {
          alerts.forEach(function (alert) {
            alert.style.display = 'none';
          });
        }, 2000);
      }
    });

    // Password validation
    const newPasswordInput = document.getElementById('newPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const lengthRequirement = document.getElementById('length-requirement');
    const caseRequirement = document.getElementById('case-requirement');
    const specialRequirement = document.getElementById('special-requirement');
    const savePasswordBtn = document.getElementById('savePasswordBtn');

    newPasswordInput.addEventListener('input', validatePassword);
    confirmPasswordInput.addEventListener('input', validatePassword);

    function validatePassword() {
      const oldPassword = document.getElementById('oldPassword').value;
      const password = newPasswordInput.value;
      const confirmPassword = confirmPasswordInput.value;
      const confirmMessage = document.getElementById('confirm-message');

      if (password === oldPassword && password.length > 0) {
        confirmMessage.textContent = "The New Password can't be the same as the Old Password";
        confirmMessage.classList.add('invalid');
        confirmMessage.classList.remove('valid');
        confirmPasswordInput.disabled = true;
        savePasswordBtn.disabled = true;
        return;
      } else {
        confirmPasswordInput.disabled = false;
      }

      if (password.length >= 8) {
        lengthRequirement.classList.add('valid');
      } else {
        lengthRequirement.classList.remove('valid');
      }

      if (/[a-z]/.test(password) && /[A-Z]/.test(password)) {
        caseRequirement.classList.add('valid');
      } else {
        caseRequirement.classList.remove('valid');
      }

      if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
        specialRequirement.classList.add('valid');
      } else {
        specialRequirement.classList.remove('valid');
      }

      if (confirmPassword.length > 0) {
        if (password === confirmPassword) {
          confirmMessage.textContent = "Passwords match";
          confirmMessage.classList.add('valid');
          confirmMessage.classList.remove('invalid');
        } else {
          confirmMessage.textContent = "Passwords do not match";
          confirmMessage.classList.add('invalid');
          confirmMessage.classList.remove('valid');
        }
      } else {
        confirmMessage.textContent = "";
      }

      if (lengthRequirement.classList.contains('valid') &&
              caseRequirement.classList.contains('valid') &&
              specialRequirement.classList.contains('valid') &&
              password === confirmPassword &&
              password.length > 0 &&
              password !== oldPassword) {
        savePasswordBtn.disabled = false;
      } else {
        savePasswordBtn.disabled = true;
      }
    }

    // Email validation and OTP handling
    const newEmailInput = document.getElementById('newEmail');
    const otpCodeInput = document.getElementById('otpCode');
    const sendOtpBtn = document.getElementById('sendOtpBtn');
    const saveEmailBtn = document.getElementById('saveEmailBtn');
    const otpMessage = document.getElementById('otp-message');
    const emailFormatRequirement = document.getElementById('email-format');
    const emailNumberRequirement = document.getElementById('email-number');

    // Add input event listener to validate email as user types
    newEmailInput.addEventListener('input', validateEmail);

    function validateEmail() {
      const email = newEmailInput.value;

      // Validate email format
      const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|vn|io|me|net|edu|org|info|biz|co|xyz|gov|mil|asia|us|uk|ca|au|edu\.vn|fpt\.edu\.vn)$/;
      const isValidFormat = emailRegex.test(email);

      if (isValidFormat) {
        emailFormatRequirement.classList.add('valid');
      } else {
        emailFormatRequirement.classList.remove('valid');
      }

      // Check if email contains at least one number
      let containsNumber = false;
      for (let i = 0; i < email.length; i++) {
        if (!isNaN(parseInt(email[i]))) {
          containsNumber = true;
          break;
        }
      }

      if (containsNumber) {
        emailNumberRequirement.classList.add('valid');
      } else {
        emailNumberRequirement.classList.remove('valid');
      }

      // Enable/disable send OTP button based on validation
      sendOtpBtn.disabled = !(isValidFormat && containsNumber);
    }

    sendOtpBtn.addEventListener('click', function () {
      // Disable button to prevent multiple clicks
      sendOtpBtn.disabled = true;
      sendOtpBtn.textContent = "Sending...";

      // Clear previous messages
      otpMessage.textContent = "";
      otpMessage.classList.remove('valid', 'invalid');

      const newEmail = newEmailInput.value;

      // Validate email is not empty
      if (!newEmail) {
        otpMessage.textContent = "Please enter a new email.";
        otpMessage.classList.add('invalid');
        sendOtpBtn.disabled = false;
        sendOtpBtn.textContent = "Send";
        return;
      }

      // Validate email format
      const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|vn|io|me|net|edu|org|info|biz|co|xyz|gov|mil|asia|us|uk|ca|au|edu\.vn|fpt\.edu\.vn)$/;
      let containsNumber = false;
      for (let i = 0; i < newEmail.length; i++) {
        if (!isNaN(parseInt(newEmail[i]))) {
          containsNumber = true;
          break;
        }
      }

      if (!emailRegex.test(newEmail) || !containsNumber) {
        otpMessage.textContent = "Invalid email format or missing number.";
        otpMessage.classList.add('invalid');
        sendOtpBtn.disabled = false;
        sendOtpBtn.textContent = "Send";
        return;
      }

      console.log("Sending OTP request for email: " + newEmail);

      // Send OTP via AJAX
      fetch('${pageContext.request.contextPath}${sessionScope.user.role eq "INSTRUCTOR" ? "/instructor/profile" : sessionScope.user.role eq "ADMIN" ? "/admin/profile" : "/learner/profile"}?action=sendOtp', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'newEmail=' + encodeURIComponent(newEmail)
      })
      .then(response => {
        console.log("Response status: " + response.status);

        // Check if response is ok (status in the range 200-299)
        if (!response.ok) {
          throw new Error("Server returned status " + response.status);
        }

        // Try to parse as JSON
        return response.text().then(text => {
          try {
            return JSON.parse(text);
          } catch (e) {
            console.error("Failed to parse JSON response: ", text);
            throw new Error("Invalid response from server");
          }
        });
      })
      .then(data => {
        console.log("Response data: ", data);

        if (data.success) {
          // Success case
          otpMessage.textContent = data.message || "OTP sent to your email.";
          otpMessage.classList.add('valid');
          otpMessage.classList.remove('invalid');
          otpCodeInput.disabled = false;
          otpCodeInput.focus();

          // Show success toast
          const customSuccessMessage = document.getElementById('customSuccessMessage');
          if (customSuccessMessage) {
            customSuccessMessage.textContent = "OTP sent successfully. Please check your email.";
            const toast = new bootstrap.Toast(document.getElementById('customSuccessToast'), {delay: 3000});
            toast.show();
          }
        } else {
          // Error case
          otpMessage.textContent = data.message || "Failed to send OTP.";
          otpMessage.classList.add('invalid');
          otpMessage.classList.remove('valid');

          // Show error toast
          const customErrorMessage = document.getElementById('customErrorMessage');
          if (customErrorMessage) {
            customErrorMessage.textContent = data.message || "Failed to send OTP.";
            const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 3000});
            toast.show();
          }
        }
      })
      .catch(error => {
        console.error("Error sending OTP: ", error);
        otpMessage.textContent = "Error sending OTP: " + error.message;
        otpMessage.classList.add('invalid');

        // Show error toast
        const customErrorMessage = document.getElementById('customErrorMessage');
        if (customErrorMessage) {
          customErrorMessage.textContent = "Error sending OTP: " + error.message;
          const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 3000});
          toast.show();
        }
      })
      .finally(() => {
        // Re-enable button
        sendOtpBtn.disabled = false;
        sendOtpBtn.textContent = "Send";
      });
    });

    otpCodeInput.addEventListener('input', function () {
      const otp = otpCodeInput.value;
      if (otp.length >= 6) {
        saveEmailBtn.disabled = false;
      } else {
        saveEmailBtn.disabled = true;
      }
    });

    // Initialize toast notifications
    document.addEventListener('DOMContentLoaded', function () {
      if ('${not empty err}' === 'true') {
        const toastEl = document.getElementById('serverToast');
        if (toastEl) {
          const bsToast = new bootstrap.Toast(toastEl, {delay: 5000});
          bsToast.show();
        }
        const errorMessage = '${err}';
        if (errorMessage.includes('password')) {
          document.getElementById('passwordModal').style.display = 'block';
        } else if (errorMessage.includes('email')) {
          document.getElementById('emailModal').style.display = 'block';
        }
      }

      const urlParams = new URLSearchParams(window.location.search);
      if (urlParams.has('passwordSuccess')) {
        const passwordSuccessToastEl = document.getElementById('passwordSuccessToast');
        if (passwordSuccessToastEl) {
          const passwordSuccessToast = new bootstrap.Toast(passwordSuccessToastEl, {delay: 2000});
          passwordSuccessToast.show();
        }
      }
      if (urlParams.has('emailSuccess')) {
        const emailSuccessToastEl = document.getElementById('emailSuccessToast');
        if (emailSuccessToastEl) {
          const emailSuccessToast = new bootstrap.Toast(emailSuccessToastEl, {delay: 2000});
          emailSuccessToast.show();
        }
      }
      if (urlParams.has('success') && urlParams.get('success') === 'true') {
        const profileSuccessToastEl = document.getElementById('profileSuccessToast');
        if (profileSuccessToastEl) {
          const profileSuccessToast = new bootstrap.Toast(profileSuccessToastEl, {delay: 2000});
          profileSuccessToast.show();
        }
      }
      if (urlParams.has('error') && urlParams.get('error') === 'true') {
        const profileErrorToastEl = document.getElementById('profileErrorToast');
        if (profileErrorToastEl) {
          const profileErrorToast = new bootstrap.Toast(profileErrorToastEl, {delay: 2000});
          profileErrorToast.show();
        }
      }
    });

    // Form validation for profile edit
    document.getElementById('profileEditForm').addEventListener('submit', function (event) {
      const displayName = document.getElementById('displayName').value;
      const phoneNumber = document.getElementById('phoneNumber').value;
      const dateOfBirth = document.getElementById('dateOfBirth').value;
      const info = document.getElementById('info').value;

      if (/\s{2,}/.test(displayName)) {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: We only accept one space, check again please";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }

      if (/\s{2,}/.test(info)) {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: We only accept one space, check again please";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }

      if (phoneNumber.length !== 10) {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: Phone number must be 10 digits";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }

      if (parseInt(phoneNumber) <= 0) {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: Phone number must greater than 0";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }

      if (phoneNumber.charAt(0) !== '0') {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: Phone number must begin by 0";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }

      if (phoneNumber.charAt(1) === '0' || phoneNumber.charAt(1) === '1' || phoneNumber.charAt(1) === '4' || phoneNumber.charAt(1) === '6' || phoneNumber.charAt(1) === '7') {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: Phone number not valid";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }

      if (dateOfBirth) {
        const selectedDate = new Date(dateOfBirth);
        const currentDate = new Date();
        if (selectedDate > currentDate) {
          event.preventDefault();
          document.getElementById('customErrorMessage').textContent = "Error: Date of birth cannot be in the future";
          const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
          toast.show();
          return false;
        }
        const year = selectedDate.getFullYear();
        if (year > 3000) {
          event.preventDefault();
          document.getElementById('customErrorMessage').textContent = "Error: Year of birth cannot exceed 3000";
          const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
          toast.show();
          return false;
        }
      }

      return true;
    });
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
