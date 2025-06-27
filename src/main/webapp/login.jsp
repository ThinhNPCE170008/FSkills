<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Login</title>
        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
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
                    <button type="submit" class="btn btn-primary">Login</button>
                </form>

                <div class="forgot-text mt-3 ">
                    <a href="#" class="login-signup-forgot-link">Forgot Password?</a>
                </div>

                <div class="mt-3">
                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/FSkills/login&response_type=code&client_id=918765723091-gobp8bur9jsd1d4rhkk2e9dkvvdm6eh2.apps.googleusercontent.com&approval_prompt=force" 
                       class="btn btn-outline-secondary w-100 d-flex align-items-center justify-content-center">
                        <img src="https://img.icons8.com/color/16/000000/google-logo.png" alt="Google Logo" class="me-2" />
                        Continue with Google
                    </a>
                </div>

                <div class="mt-3">
                    <a href="register.jsp" class="btn btn-link login-signup-forgot-link">Don't have an account? Sign Up</a>
                </div>
            </div>
        </div>

        <div id="jsToast"
             class="toast align-items-center text-white bg-danger border-0 position-fixed bottom-0 end-0 m-3 d-none"
             role="alert">
            <div class="d-flex">
                <div class="toast-body" id="jsToastMessage">
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>

<%--        <script>--%>
<%--            function showJsToast(message, type = 'danger') {--%>
<%--                const toastEl = document.getElementById('jsToast');--%>
<%--                const toastMsg = document.getElementById('jsToastMessage');--%>

<%--                toastMsg.innerHTML = message;--%>

<%--                toastEl.classList.remove('d-none', 'bg-danger', 'bg-success', 'bg-warning', 'bg-info');--%>
<%--                toastEl.classList.add('bg-' + type);--%>

<%--                const bsToast = new bootstrap.Toast(toastEl, {delay: 4000});--%>
<%--                bsToast.show();--%>
<%--            }--%>
<%--        </script>--%>

        <!-- Message -->
        <c:if test="${not empty success || not empty err}">
            <c:choose>
                <c:when test="${not empty success}">
                    <c:set var="toastMessage" value="${success}"/>
                    <c:set var="toastClass" value="text-bg-success"/>
                </c:when>
                <c:when test="${not empty err}">
                    <c:set var="toastMessage" value="${err}"/>
                    <c:set var="toastClass" value="text-bg-danger"/>
                </c:when>
            </c:choose>

            <div class="toast-container position-fixed bottom-0 end-0 p-3">
                <div id="serverToast" class="toast align-items-center ${toastClass} border-0" role="alert" aria-live="assertive"
                     aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body">
                                ${toastMessage}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                                aria-label="Close"></button>
                    </div>
                </div>
            </div>
        </c:if>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const toastEl = document.getElementById('serverToast');
                if (toastEl) {
                    const bsToast = new bootstrap.Toast(toastEl, {delay: 3000});
                    bsToast.show();
                }
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- reCAPTCHA -->
        <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
    </body>
</html>