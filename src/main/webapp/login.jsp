<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login</title>

    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="css/log.css">
</head>
<body>

<a href="homePage_Guest.jsp" class="login-back-btn btn btn-secondary position-fixed top-0 end-0 m-3" title="Back to Homepage">
    <i class="bi bi-arrow-left"></i>
</a>

<div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
    <div class="login-container text-center">
        <img src="img/logo.png" alt="Logo" class="logo-img"/>

        <form method="POST" action="login">
            <div class="mb-3">
                <input type="text" class="form-control" name="username" value="${usernameCookieSaved}" placeholder="Username or Email" required/>
            </div>
            <div class="mb-3">
                <input type="password" class="form-control" name="password" placeholder="Password" required/>
            </div>
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" name="rememberMe" id="rememberMe" />
                <label style="margin-right: 70%;" class="form-check-label" for="rememberMe">Remember</label>
            </div>

            <div class="cf-turnstile" data-sitekey="0x4AAAAAABgts3i36HFv5My1"></div>

            <!--<div class="cf-turnstile" data-sitekey="${turnstileSiteKey}"></div>-->
            <button type="submit" class="btn btn-primary">Login</button>
        </form>

        <div class="forgot-text mt-3 ">
            <a href="#" class="login-signup-forgot-link" data-bs-toggle="modal" data-bs-target="#forgotPasswordModal">Forgot Password?</a>
        </div>

        <div class="mt-3">
            <%--Connect Google From Render--%>
            <%--                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=https://fskills.onrender.com/login&response_type=code&client_id=918765723091-gobp8bur9jsd1d4rhkk2e9dkvvdm6eh2.apps.googleusercontent.com&approval_prompt=force"--%>
            <%--                       class="btn btn-outline-secondary w-100 d-flex align-items-center justify-content-center">--%>
            <%--                        <img src="https://img.icons8.com/color/16/000000/google-logo.png" alt="Google Logo" class="me-2" />--%>
            <%--                        Continue with Google--%>
            <%--                    </a>--%>

            <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/FSkills/login&response_type=code&client_id=918765723091-gobp8bur9jsd1d4rhkk2e9dkvvdm6eh2.apps.googleusercontent.com&approval_prompt=force"
               class="btn btn-outline-secondary w-100 d-flex align-items-center justify-content-center">
                <img src="https://img.icons8.com/color/16/000000/google-logo.png" alt="Google Logo" class="me-2" />
                Continue with Google
            </a>
        </div>

        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/signup" class="btn btn-link login-signup-forgot-link">Don't have an account? Sign Up</a>
        </div>
    </div>
</div>

<!-- Forgot Password Modal -->
<div class="modal fade" id="forgotPasswordModal" tabindex="-1" aria-labelledby="forgotPasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="forgotpassword" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="forgotPasswordModalLabel">Forgot Password</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="forgotEmail" class="form-label">Enter your Email:</label>
                        <input type="email" class="form-control" id="forgotEmail" name="forgotEmail" placeholder="you@example.com" required>
                    </div>
                    <div class="alert alert-info d-none" id="forgotInfo">We will send password reset instructions via email.</div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Submit</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.getElementById("forgotPasswordModal").addEventListener('show.bs.modal', function () {
        document.getElementById("forgotInfo").classList.remove("d-none");
    });
</script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const forgotForm = document.querySelector('#forgotPasswordModal form');
        const emailInput = document.getElementById('forgotEmail');
        const toastEl = document.getElementById('customErrorToast');
        const toastMsg = document.getElementById('customErrorMessage');

        if (forgotForm) {
            forgotForm.addEventListener('submit', function (e) {
                const email = emailInput.value.trim();
                const domain = email.split('@')[1]?.toLowerCase();
                const acceptedDomains = ['gmail.com', 'email.com'];
                const acceptedTLDs = ['.vn', '.io', '.me'];

                let isValid = true;

                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    isValid = false;
                    toastMsg.textContent = 'Invalid email.';
                } else if (
                    !acceptedDomains.includes(domain) &&
                    !acceptedTLDs.some(tld => domain.endsWith(tld))
                ) {
                    isValid = false;
                    toastMsg.textContent = 'Only accept gmail.com, email.com, or .vn, .io, .me domains';
                } else if (
                    (domain.startsWith('gmail.') && domain !== 'gmail.com') ||
                    (domain.startsWith('email.') && domain !== 'email.com')
                ) {
                    isValid = false;
                    toastMsg.textContent = 'gmail/email is not valid. Only gmail.com or email.com are accepted.';
                }

                if (!isValid) {
                    e.preventDefault();
                    const toast = new bootstrap.Toast(toastEl);
                    toast.show();
                }
            });
        }
    });
</script>

<div style="z-index: 3000;" id="customErrorToast" class="toast align-items-center text-white bg-danger border-0 position-fixed bottom-0 end-0 m-3" role="alert">
    <div class="d-flex">
        <div class="toast-body" id="customErrorMessage"></div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
    </div>
</div>

<jsp:include page="/layout/toast.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- reCAPTCHA -->
<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
</body>
</html>