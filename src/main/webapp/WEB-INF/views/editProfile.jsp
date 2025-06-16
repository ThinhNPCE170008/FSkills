<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Profile - F-Skills</title>
        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/editProfile.css">
    </head>
    <body>
        <div class="profile-edit-container">
            <header>
                <div class="logo">F<span class="highlight">•</span>SKILL</div>
                <nav class="highlighted-nav">
                    <a href="#">My Course</a>
                    <a href="#">Home</a>
                    <a href="#">All Courses</a>
                    <a class="btn btn-sucess" href="${pageContext.request.contextPath}/Degree">
                        <i class="bi bi-file-earmark-text"></i> Degree
                    </a>

                    <div class="search-bar">
                        <input type="text" placeholder="Search">
                        <button>🔍</button>
                    </div>
                    <div class="icons">
                        <span class="cart">🛒<span class="badge">2</span></span>
                        <span class="bell">🔔</span>
                        <div class="user">Hi, <c:out value="${not empty sessionScope.user.displayName ? sessionScope.user.displayName : 'Guest'}"/></div>
                    </div>
                </nav>
            </header>

            <div class="welcome-section">
                <h1>Welcome, <c:out value="${not empty sessionScope.user.displayName ? sessionScope.user.displayName : 'Guest'}"/></h1>

            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success" role="alert">
                    ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert"> <%-- Changed to alert-danger for error messages --%>
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty profile}">
                <div class="profile-card">
                    <div class="profile-header">
                        <div class="avatar">👤</div>
                        <div class="user-info">
                            <h2><c:out value="${profile.displayName}"/></h2>
                            <p><c:out value="${profile.email}"/></p>
                            <button class="change-password">Change Password</button>
                            <button class="edit-btn">Edit</button>
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
                            <input type="date" value="${profile.dateOfBirth}" readonly> <%-- dateOfBirth is Timestamp, will be formatted by browser --%>
                        </div>
                        <div class="field">
                            <label>Address</label>
                            <input type="text" value="<c:out value="${profile.info}"/>" readonly>
                        </div>
                        <div class="field email-field"> <%-- Added email field explicitly here as well, from your original code --%>
                            <label>My email Address</label>
                            <div class="email-info">
                                <span>📧 <c:out value="${profile.email}"/></span>
                                <span>1 month ago</span> <%-- This is static, consider making dynamic if needed --%>
                            </div>
                            <button class="change-email">Change email</button>
                        </div>
                    </div>
                </div>

                <form class="profile-form" action="editProfile" method="POST" enctype="multipart/form-data" style="display: none;">
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
                        <button type="submit" class="save-btn">Save Changes</button>
                        <button type="button" class="cancel-btn" onclick="window.history.back()">Cancel</button>
                    </div>
                </form>
            </c:if>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            document.getElementById('avatar-upload').addEventListener('change', function (e) {
                                const file = e.target.files[0];
                                if (file) {
                                    const reader = new FileReader();
                                    reader.onload = function (e) {
                                        document.getElementById('avatar-preview').src = e.target.result;
                                    }
                                    reader.readAsDataURL(file);
                                }
                            });

                            document.querySelector('.edit-btn').addEventListener('click', function () {
                                const profileCard = document.querySelector('.profile-card');
                                const form = document.querySelector('.profile-form');
                                if (profileCard.style.display !== 'none') {
                                    profileCard.style.display = 'none';
                                    form.style.display = 'block';
                                } else {
                                    profileCard.style.display = 'block';
                                    form.style.display = 'none';
                                }
                            });
        </script>
    </body>
</html>