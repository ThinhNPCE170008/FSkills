<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Profile - F-Skills</title>
  <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/editProfile.css">
</head>
<body>
<div class="profile-edit-container">
  <header>
    <img src="img/logo.png" alt="Logo" class="logo-img"/>
    <nav>
      <a href="#">My Course</a>
      <a href="#">Home</a>
      <a href="#">All Courses</a>
      <%-- 2. Update Degree Icon --%>
      <a href="${pageContext.request.contextPath}/Degree"><i class="bi bi-journal-text"></i> Degree</a>
      <div class="search-bar">
        <input type="text" placeholder="Search for courses...">
        <%-- 3. Update Search Icon --%>
        <button><i class="bi bi-search"></i></button>
      </div>
      <div class="icons">
        <%-- 4. Update Cart Icon --%>
        <span class="cart">
                            <i class="bi bi-cart3"></i><span class="badge">2</span>
                        </span>
        <%-- 5. Update Bell Icon --%>
        <span class="bell"><i class="bi bi-bell"></i></span>
        <div class="user">Hi, <c:out value="${not empty sessionScope.user.displayName ? sessionScope.user.displayName : 'Guest'}"/></div>
      </div>
    </nav>
  </header>

  <div class="welcome-section">
    <h1>Welcome back, <c:out value="${not empty sessionScope.user.displayName ? sessionScope.user.displayName : 'Guest'}"/>!</h1>
  </div>

  <c:if test="${not empty success}">
    <div class="alert alert-success" role="alert">
        ${success}
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger" role="alert">
        ${error}
    </div>
  </c:if>

  <c:if test="${not empty profile}">
    <%-- Profile Display Card --%>
    <div class="profile-card">
      <div class="profile-header">
        <div class="avatar">👤</div>
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
        <div class="field">
          <label>Full Name</label>
          <input type="text" value="<c:out value="${profile.displayName}"/>" readonly>
        </div>
        <div class="field">
          <label>Phone Number</label>
          <input type="text" value="<c:out value="${profile.phoneNumber}"/>" readonly>
        </div>
        <div class="field">
          <label>Gender</label>
          <select disabled>
            <option value="true" ${profile.gender ? 'selected' : ''}>Male</option>
            <option value="false" ${!profile.gender ? 'selected' : ''}>Female</option>
          </select>
        </div>
        <div class="field">
          <label>Date of Birth</label>
          <input type="date" value="${profile.dateOfBirth}" readonly>
        </div>
        <div class="field">
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
    <form class="profile-form" action="editProfile" method="POST" enctype="multipart/form-data">
      <div class="avatar-section">
        <div class="avatar-container">
          <img src="${profile.avatar != null ? profile.avatar : 'img/default-avatar.png'}"
               alt="Profile Picture" id="avatar-preview">
        </div>
        <input type="file" id="avatar-upload" name="avatar" accept="image/*" hidden>
        <button type="button" class="avatar-upload-btn" onclick="document.getElementById('avatar-upload').click()">
          Change Profile Picture
        </button>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="displayName">Full Name</label>
          <input type="text" id="displayName" name="displayName" value="<c:out value="${profile.displayName}"/>" required>
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input type="email" id="email" name="email" value="<c:out value="${profile.email}"/>" required>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="phoneNumber">Phone Number</label>
          <input type="tel" id="phoneNumber" name="phoneNumber" value="<c:out value="${profile.phoneNumber}"/>">
        </div>
        <div class="form-group">
          <label for="dateOfBirth">Date of Birth</label>
          <input type="date" id="dateOfBirth" name="dateOfBirth" value="${profile.dateOfBirth}">
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="gender">Gender</label>
          <select id="gender" name="gender">
            <option value="true" ${profile.gender ? 'selected' : ''}>Male</option>
            <option value="false" ${!profile.gender ? 'selected' : ''}>Female</option>
          </select>
        </div>
        <div class="form-group">
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
</div>


<script>
  // JavaScript for toggling view and image preview
  const profileCard = document.querySelector('.profile-card');
  const form = document.querySelector('.profile-form');
  const editBtn = document.querySelector('.edit-btn');
  const cancelBtn = document.querySelector('.cancel-btn');

  editBtn.addEventListener('click', () => {
    profileCard.style.display = 'none';
    form.style.display = 'block';
  });

  cancelBtn.addEventListener('click', () => {
    profileCard.style.display = 'block';
    form.style.display = 'none';
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
</script>
</body>
</html>