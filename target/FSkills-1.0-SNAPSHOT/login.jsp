<%-- 
    Document   : login
    Created on : May 22, 2025, 10:12:29 PM
    Author     : NgoThinh1902
--%>

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
                        <input type="text" class="form-control" name="username" placeholder="Username or Email" />
                    </div>
                    <div class="mb-3">
                        <input type="password" class="form-control" name="password" placeholder="Password" />
                    </div>
                    <button type="submit" class="btn btn-primary">Login</button>
                </form>

                <%
                    String err = (String) request.getAttribute("err");
                    if (err != null) {
                        out.println(err);
                    }
                %>

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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
