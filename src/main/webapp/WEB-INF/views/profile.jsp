<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Profile - F-Skills</title>
  <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
</head>


<body>
<jsp:include page="/layout/sidebar_user.jsp" />
<div class="profile-edit-container">

  <div class="welcome-section">
    <h1>Welcome back, <c:out value="${not empty sessionScope.user.displayName ? sessionScope.user.displayName : 'Guest'}"/>!</h1>
  </div>

  <!-- Old alerts removed -->

  <c:if test="${not empty profile}">
    <%-- Profile Display Card --%>
    <div class="profile-card">
      <div class="profile-header">
        <div class="avatar">
          <img src="${pageContext.request.contextPath}/${profile.avatar}" alt="Avatar">
        </div>
        <div class="user-info">
          <h2><c:out value="${profile.displayName}"/></h2>
          <p><c:out value="${profile.email}"/></p>
          <div class="btn-group">
            <button class="change-password">Change Password</button>
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
          <input type="date" value="<fmt:formatDate value="${profile.dateOfBirth}" pattern="yyyy-MM-dd" />" readonly>
        </div>
        <div class="field address-field">
          <label>Address</label>
          <input type="text" value="<c:out value="${profile.info}"/>" readonly>
        </div>
        <div class="field email-field">
          <label>My email Address</label>
          <div class="email-info">
            <span>📧 <c:out value="${profile.email}"/></span>
            <span>1 month ago</span> <%-- This is static --%>
          </div>
        </div>
      </div>
    </div>

    <%-- Profile Edit Form (Initially Hidden) --%>
    <form class="profile-form" id="profileEditForm" action="${pageContext.request.contextPath}${sessionScope.user.role eq 'INSTRUCTOR' ? '/instructor/profile' : '/learner/profile'}?action=edit" method="POST" enctype="multipart/form-data" style="display: none;">
      <div class="avatar-section">
        <div class="avatar-container">
          <img src="${pageContext.request.contextPath}/${profile.avatar}" alt="Profile Picture" id="avatar-preview">
        </div>
        <input type="file" id="avatar-upload" name="avatar" accept="image/*" hidden>
        <button type="button" class="avatar-upload-btn" onclick="document.getElementById('avatar-upload').click()">
          Change Profile Picture
        </button>
      </div>

      <div class="form-row">
        <div class="form-group name-group">
          <label for="displayName">Full Name</label>
          <input type="text" id="displayName" name="displayName" value="<c:out value="${profile.displayName}"/>" required>
        </div>
        <div class="form-group phone-group">
          <label for="phoneNumber">Phone Number</label>
          <input type="tel" id="phoneNumber" name="phoneNumber" value="<c:out value="${profile.phoneNumber}"/>" required>
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
          <input type="date" id="dateOfBirth" name="dateOfBirth" value="<fmt:formatDate value="${profile.dateOfBirth}" pattern="yyyy-MM-dd" />">
        </div>
      </div>

      <div class="form-row">
        <div class="form-group address-group">
          <label for="info">Address</label>
          <input type="text" id="info" name="info" value="<c:out value="${profile.info}"/>">
        </div>
      </div>

      <div class="form-row">
        <div class="form-group email-group">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" value="<c:out value="${profile.email eq null ? 'example@gmail.com' : profile.email}"/>" required>
          <div id="emailError" class="invalid-feedback" style="display: none;">Error: Email in vaild</div>
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
  <span class="avatar-modal-close">&times;</span>
  <img class="avatar-modal-content" id="modalImage">
</div>

<!-- Modal for Change Password -->
<div id="passwordModal" class="avatar-modal">
  <div class="change-password-container">
    <span class="avatar-modal-close password-modal-close">&times;</span>
    <h1>Change Password</h1>

    <form id="passwordForm" action="${pageContext.request.contextPath}${sessionScope.user.role eq 'INSTRUCTOR' ? '/instructor/profile' : '/learner/profile'}?action=password" method="POST">
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

<!-- Toast Notification -->
<div style = "z-index: 2000;"
        class="toast-container position-fixed bottom-0 end-0 p-3">
  <!-- Error Toast -->
  <div id="serverToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body">
        <c:if test="${not empty err}">${err}</c:if>
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>

  <!-- Password Success Toast -->
  <div id="passwordSuccessToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body">
        Password changed successfully.
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>

  <!-- Profile Success Toast -->
  <div id="profileSuccessToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body">
        Profile updated successfully.
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>

  <!-- Profile Error Toast -->
  <div id="profileErrorToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body">
        Failed to update profile.
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
  </div>

  <!-- Custom Error Toast -->
  <div id="customErrorToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body" id="customErrorMessage">
        Error message here
      </div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
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

  // Email validation
  const emailInput = document.getElementById('email');
  const emailError = document.getElementById('emailError');

  // Set default value if empty
  if (!emailInput.value) {
    emailInput.value = 'example@gmail.com';
  }

  // Email input event listener
  emailInput.addEventListener('input', function() {
    validateEmail();
  });

  function validateEmail() {
    const email = emailInput.value.trim();

    // Valid domains
    const validDomains = [
      '@gmail.com',
      '@email.com',
      '@fpt.edu.vn',
      '@gmail.vn',
      '@gmail.io',
      '@gmail.net',
      '@gmail.me',
      '@email.vn',
      '@email.io',
      '@email.net',
      '@email.me',
    ];

    // Check if email is empty
    if (email === '') {
      emailInput.value = 'example@gmail.com';
      emailError.style.display = 'block';
      emailInput.classList.add('is-invalid');
      return false;
    }

    // Check if email is example@gmail.com or ends with one of the valid domains
    if (email === 'example@gmail.com' || validDomains.some(domain => email.endsWith(domain))) {
      emailError.style.display = 'none';
      emailInput.classList.remove('is-invalid');
      return true;
    } else {
      emailError.style.display = 'block';
      emailInput.classList.add('is-invalid');
      return false;
    }
  }

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
    img.addEventListener('click', function() {
      modal.style.display = "block";
      modalImg.src = this.src;
    });
  });

  // Close the modal when clicking on the close button
  closeBtn.addEventListener('click', function() {
    modal.style.display = "none";
  });

  // Close the modal when clicking outside the image
  window.addEventListener('click', function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
    if (event.target == document.getElementById('passwordModal')) {
      document.getElementById('passwordModal').style.display = "none";
    }
  });

  // Close password modal
  document.querySelector('.password-modal-close').addEventListener('click', function() {
    document.getElementById('passwordModal').style.display = "none";
  });

  // Auto-hide alerts after 3 seconds
  window.addEventListener('load', function() {
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(function() {
            alerts.forEach(function(alert) {
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

    // Check if new password is same as old password
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

    // Check length requirement
    if (password.length >= 8) {
      lengthRequirement.classList.add('valid');
    } else {
      lengthRequirement.classList.remove('valid');
    }

    // Check case requirement
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) {
      caseRequirement.classList.add('valid');
    } else {
      caseRequirement.classList.remove('valid');
    }

    // Check special character requirement
    if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
      specialRequirement.classList.add('valid');
    } else {
      specialRequirement.classList.remove('valid');
    }

    // Check if passwords match
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

    // Enable submit button if all requirements are met and passwords match
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
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Initialize toast notifications
  document.addEventListener('DOMContentLoaded', function() {
    // Set max date for date of birth to current date
    const dateOfBirthInput = document.getElementById('dateOfBirth');
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, '0');
    const dd = String(today.getDate()).padStart(2, '0');
    const currentDate = `${yyyy}-${mm}-${dd}`;
    dateOfBirthInput.setAttribute('max', currentDate);

    // Check for error message  
    if ('${not empty err}' === 'true') {
      const toastEl = document.getElementById('serverToast');
      if (toastEl) {
        const bsToast = new bootstrap.Toast(toastEl, {delay: 5000});
        bsToast.show();
      }

      // Check if error is related to password change and show password modal
      const errorMessage = '${err}';
      if (errorMessage.includes('password')) {
        document.getElementById('passwordModal').style.display = 'block';
      }
    }

    // Get URL parameters
    const urlParams = new URLSearchParams(window.location.search);

    // Check for password success parameter in URL
    if (urlParams.has('passwordSuccess')) {
      const passwordSuccessToastEl = document.getElementById('passwordSuccessToast');
      if (passwordSuccessToastEl) {
        const passwordSuccessToast = new bootstrap.Toast(passwordSuccessToastEl, {delay: 2000});
        passwordSuccessToast.show();
      }
    }

    // Check for profile update success parameter in URL
    if (urlParams.has('success') && urlParams.get('success') === 'true') {
      const profileSuccessToastEl = document.getElementById('profileSuccessToast');
      if (profileSuccessToastEl) {
        const profileSuccessToast = new bootstrap.Toast(profileSuccessToastEl, {delay: 2000});
        profileSuccessToast.show();
      }
    }

    // Check for profile update error parameter in URL
    if (urlParams.has('error') && urlParams.get('error') === 'true') {
      const profileErrorToastEl = document.getElementById('profileErrorToast');
      if (profileErrorToastEl) {
        const profileErrorToast = new bootstrap.Toast(profileErrorToastEl, {delay: 2000});
        profileErrorToast.show();
      }
    }
  });

  // Form validation for profile edit
  document.getElementById('profileEditForm').addEventListener('submit', function(event) {
    // Get form values
    const displayName = document.getElementById('displayName').value;
    const phoneNumber = document.getElementById('phoneNumber').value;
    const dateOfBirth = document.getElementById('dateOfBirth').value;
    const info = document.getElementById('info').value;
    const email = document.getElementById('email').value;

    // Check for consecutive spaces in displayName
    if (/\s{2,}/.test(displayName)) {
      event.preventDefault();
      document.getElementById('customErrorMessage').textContent = "Error: We only accept one space, check again please";
      const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
      toast.show();
      return false;
    }

    // Check for consecutive spaces in info (address)
    if (/\s{2,}/.test(info)) {
      event.preventDefault();
      document.getElementById('customErrorMessage').textContent = "Error: We only accept one space, check again please";
      const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
      toast.show();
      return false;
    }

    // Validate email using our validateEmail function
    if (!validateEmail()) {
      event.preventDefault();
      document.getElementById('customErrorMessage').textContent = "Error: Email in vaild";
      const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
      toast.show();
      return false;
    }

    // Phone number validation
    // Check if phone number has exactly 10 digits
    if (phoneNumber.length !== 10) {
      event.preventDefault();
      document.getElementById('customErrorMessage').textContent = "Error: Phone number must be 10 digits";
      const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
      toast.show();
      return false;
    }

    // Check if it contains only digits
    if (!/^\d+$/.test(phoneNumber)) {
      event.preventDefault();
      document.getElementById('customErrorMessage').textContent = "Error: Phone number must contain only digits";
      const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
      toast.show();
      return false;
    }

    // Check if phone number starts with 0
    if (phoneNumber.charAt(0) !== '0') {
      event.preventDefault();
      document.getElementById('customErrorMessage').textContent = "Error: Phone number must begin with 0";
      const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
      toast.show();
      return false;
    }

    // Check if second digit is valid (3, 5, 7, 8, 9)
    const validSecondDigits = ['3', '5', '7', '8', '9'];
    if (!validSecondDigits.includes(phoneNumber.charAt(1))) {
      event.preventDefault();
      document.getElementById('customErrorMessage').textContent = "Error: Invalid phone number format. Vietnamese phone numbers should start with 03, 05, 07, 08, or 09";
      const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
      toast.show();
      return false;
    }

    // Check for 5 consecutive occurrences of the same digit
    for (let i = 0; i <= phoneNumber.length - 5; i++) {
      const currentDigit = phoneNumber.charAt(i);
      let hasFiveConsecutive = true;

      for (let j = 1; j < 5; j++) {
        if (phoneNumber.charAt(i + j) !== currentDigit) {
          hasFiveConsecutive = false;
          break;
        }
      }

      if (hasFiveConsecutive) {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: Phone number not vaild";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }
    }

    // Check for any digit appearing 6 or more times in total
    const digitCount = Array(10).fill(0); // Count occurrences of each digit (0-9)

    for (let i = 0; i < phoneNumber.length; i++) {
      const digit = parseInt(phoneNumber.charAt(i));
      digitCount[digit]++;

      if (digitCount[digit] >= 6) {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: Phone number cannot contain any digit that appears 6 or more times";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }
    }

    // Check date of birth
    if (dateOfBirth) {
      const selectedDate = new Date(dateOfBirth);
      const today = new Date();

      // Reset time part for accurate date comparison
      today.setHours(0, 0, 0, 0);
      selectedDate.setHours(0, 0, 0, 0);

      // Check if date is in the future
      if (selectedDate > today) {
        event.preventDefault();
        document.getElementById('customErrorMessage').textContent = "Error: Date of birth cannot be in the future";
        const toast = new bootstrap.Toast(document.getElementById('customErrorToast'), {delay: 2000});
        toast.show();
        return false;
      }

      // Check if year is too far in the future (legacy check)
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
</body>
</html>
