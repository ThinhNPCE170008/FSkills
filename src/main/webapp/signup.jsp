<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Sign Up</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
        <link rel="stylesheet" href="css/sign.css">
    </head>
    <body>
        <a href="${pageContext.request.contextPath}/login" class="login-signup-back-btn btn btn-secondary position-fixed top-0 end-0 m-3" title="Back to Homepage">
            <i class="bi bi-arrow-left"></i>
        </a>

        <div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
            <div class="login-signup-container text-center">
                <img src="img/logo.png" alt="Logo" class="login-signup-logo-img" />

                <form action="${pageContext.request.contextPath}/signup" method="POST">
                    <div class="mb-3">
                        <input type="text" class="form-control" name="username" placeholder="Username" required/>
                    </div>

                    <div class="mb-3">
                        <input type="password" class="form-control" name="password" placeholder="Password" required/>
                    </div>

                    <div class="mb-3">
                        <input type="password" class="form-control" name="confirmPassword" placeholder="Confirm Password" required/>
                    </div>

                    <div class="mb-3">
                        <input type="email" class="form-control" name="email" placeholder="Email" required/>
                    </div>

                    <div class="mb-3">
                        <input type="tel" class="form-control" name="phoneNumber" placeholder="Phone Number" required/>
                    </div>

                    <button type="submit" class="btn btn-info w-100 mb-3">Sign Up</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const form = document.querySelector("form");
            form.addEventListener("submit", function (e) {
                const username = form.username.value.trim();
                const password = form.password.value.trim();
                const confirmPassword = form.confirmPassword.value.trim();
                const email = form.email.value.trim();
                const phone = form.phoneNumber.value.trim();

                const usernameRegex = /^[a-zA-Z0-9_-]+$/;
                if (!usernameRegex.test(username)) {
                    showJsToast("Username must not contain Vietnamese characters or special symbols.");
                    e.preventDefault();
                    return;
                }

                const hasUpper = /[A-Z]/.test(password);
                const hasLower = /[a-z]/.test(password);
                const hasDigit = /\d/.test(password);
                const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);
                const hasNoSpace = !/\s/.test(password);

                if (password.length < 8) {
                    showJsToast("Password must be at least 8 characters long.");
                    e.preventDefault();
                    return;
                }

                if (!hasUpper) {
                    showJsToast("Password must contain at least one uppercase letter.");
                    e.preventDefault();
                    return;
                }

                if (!hasLower) {
                    showJsToast("Password must contain at least one lowercase letter.");
                    e.preventDefault();
                    return;
                }

                if (!hasDigit) {
                    showJsToast("Password must contain at least one digit.");
                    e.preventDefault();
                    return;
                }

                if (!hasSpecial) {
                    showJsToast("Password must contain at least one special character.");
                    e.preventDefault();
                    return;
                }

                if (!hasNoSpace) {
                    showJsToast("Password must not contain any whitespace characters.");
                    e.preventDefault();
                    return;
                }

                if (password !== confirmPassword) {
                    showJsToast("Password and Confirm Password do not match.");
                    e.preventDefault();
                    return;
                }

                const domain = email.split('@')[1]?.toLowerCase();
                const acceptedDomains = ['gmail.com', 'email.com'];
                const acceptedTLDs = ['.vn', '.io', '.me'];
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (!emailRegex.test(email)) {
                    showJsToast('Invalid email format.');
                    e.preventDefault();
                    return;
                }

                if (
                    !acceptedDomains.includes(domain) &&
                    !acceptedTLDs.some(tld => domain.endsWith(tld))
                ) {
                    showJsToast('Only accept gmail.com, email.com, or domains ending in .vn, .io, .me');
                    e.preventDefault();
                    return;
                }

                if (
                    (domain.startsWith('gmail.') && domain !== 'gmail.com') ||
                    (domain.startsWith('email.') && domain !== 'email.com')
                ) {
                    showJsToast('Invalid gmail/email domain. Only gmail.com or email.com are accepted.');
                    e.preventDefault();
                    return;
                }

                const phoneRegex = /^0[1-9](?!.*000)\d{8}$/;
                const zeroCount = (phone.match(/0/g) || []).length;

                if (!phoneRegex.test(phone) || zeroCount > 5) {
                    showJsToast("Phone number must start with 0, second digit ≠ 0, 10 digits, no '000', and no more than five 0s.");
                    e.preventDefault();
                    return;
                }
            });
        });
    </script>

    <jsp:include page="/layout/toast.jsp" />
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>