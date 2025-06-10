<%-- 
    Document   : register
    Created on : Jun 3, 2025, 2:33:22 PM
    Author     : NgoThinh1902
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Sign Up</title>
        <link rel="icon" type="image/png" href="img/favicon_io/favicon.ico">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
        <link rel="stylesheet" href="css/sign.css">
    </head>
    <body>
        <!-- Nút "Back" góc trên phải -->
        <a href="login.jsp" class="login-signup-back-btn btn btn-secondary position-fixed top-0 end-0 m-3" title="Back to Homepage">
            <i class="bi bi-arrow-left"></i>
        </a>

        <div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
            <div class="login-signup-container text-center">
                <!-- Logo -->
                <img src="img/logo.png" alt="Logo" class="login-signup-logo-img" />

                <!-- Form đăng nhập hoặc đăng ký -->
                <form>
                    <!-- Các ô input -->
                    <div class="mb-3">
                        <input type="text" class="form-control" placeholder="Username" />
                    </div>
                    <div class="mb-3">
                        <input type="password" class="form-control" placeholder="Password" />
                    </div>

                    <!-- Thêm các ô cho phần đăng ký -->
                    <div class="mb-3">
                        <input type="password" class="form-control" placeholder="Confirm Password" />
                    </div>
                    <div class="mb-3">
                        <input type="email" class="form-control" placeholder="Email" />
                    </div>
                    <div class="mb-3">
                        <input type="tel" class="form-control" placeholder="Phone Number" />
                    </div>

                    <!-- Nút Sign Up -->
                    <button type="submit" class="btn btn-info w-100 mb-3">SIGN UP</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>