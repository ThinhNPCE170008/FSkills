<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Change Password</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: "Segoe UI", sans-serif;
            }

            .change-password-wrapper {
                max-width: 450px;
                margin: 60px auto;
                background-color: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            }

            .change-password-wrapper h3 {
                text-align: center;
                margin-bottom: 25px;
                color: #333;
            }

            .form-label {
                font-weight: 600;
            }

            .password-requirements {
                font-size: 0.9rem;
                background: #f1f3f5;
                padding: 10px 15px;
                border-left: 4px solid #adb5bd;
                border-radius: 6px;
                margin-top: 8px;
            }

            .requirement {
                margin: 3px 0;
                color: #6c757d;
                transition: color 0.3s ease;
            }

            .requirement.valid {
                color: #28a745;
            }

            .requirement.valid::before {
                content: "✓ ";
                color: #28a745;
            }

            .requirement.invalid {
                color: #dc3545;
            }

            .requirement.invalid::before {
                content: "✕ ";
                color: #dc3545;
            }

            #confirm-message {
                font-weight: 500;
                margin-top: 6px;
            }

            #confirm-message.valid {
                color: #28a745;
            }

            #confirm-message.valid::before {
                content: "✓ ";
                color: #28a745;
            }

            #confirm-message.invalid {
                color: #dc3545;
            }

            #confirm-message.invalid::before {
                content: "✕ ";
                color: #dc3545;
            }

            .btn-primary:disabled {
                background-color: #adb5bd;
                border-color: #adb5bd;
            }
        </style>
    </head>
    <body>
        <div class="change-password-wrapper">
            <h3>Change Password</h3>

            <form id="passwordForm" method="POST" action="changepassword">
                <input type="hidden" name="token" value="${token}" />

                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                    <div class="password-requirements mt-2">
                        <p class="requirement" id="length-requirement">Minimum 8 characters, maximum 20 characters</p>
                        <p class="requirement" id="case-requirement">Must have uppercase and lowercase letters</p>
                        <p class="requirement" id="special-requirement">Must have special characters</p>
                        <p class="requirement" id="number-requirement">Must contain at least one number</p>
                        <p class="requirement" id="whitespace-requirement">Must not contain spaces</p>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    <p id="confirm-message" class="requirement"></p>
                </div>

                <button type="submit" id="savePasswordBtn" class="btn btn-primary w-100" >Save Change</button>
            </form>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const newPasswordInput = document.getElementById('newPassword');
                const confirmPasswordInput = document.getElementById('confirmPassword');
                const lengthRequirement = document.getElementById('length-requirement');
                const caseRequirement = document.getElementById('case-requirement');
                const specialRequirement = document.getElementById('special-requirement');
                const savePasswordBtn = document.getElementById('savePasswordBtn');
                const confirmMessage = document.getElementById('confirm-message');
                const numberRequirement = document.getElementById('number-requirement');
                const whitespaceRequirement = document.getElementById('whitespace-requirement');

                newPasswordInput.addEventListener('input', validatePassword);
                confirmPasswordInput.addEventListener('input', validatePassword);

                function validatePassword() {
                    const password = newPasswordInput.value;
                    const confirmPassword = confirmPasswordInput.value;

                    toggleClass(lengthRequirement, password.length >= 8);
                    toggleClass(caseRequirement, /[a-z]/.test(password) && /[A-Z]/.test(password));
                    toggleClass(specialRequirement, /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password));
                    toggleClass(numberRequirement, /\d/.test(password));
                    toggleClass(whitespaceRequirement, !/\s/.test(password));

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
                        confirmMessage.classList.remove('valid', 'invalid');
                    }

                    if (
                            lengthRequirement.classList.contains('valid') &&
                            caseRequirement.classList.contains('valid') &&
                            specialRequirement.classList.contains('valid') &&
                            numberRequirement.classList.contains('valid') &&
                            whitespaceRequirement.classList.contains('valid') &&
                            password === confirmPassword &&
                            password.length > 0
                            ) {
                        savePasswordBtn.disabled = false;
                    } else {
                        savePasswordBtn.disabled = true;
                    }
                }

                function toggleClass(element, condition) {
                    if (condition) {
                        element.classList.add('valid');
                        element.classList.remove('invalid');
                    } else {
                        element.classList.remove('valid');
                        element.classList.add('invalid');
                    }
                }
            });
        </script>

        <jsp:include page="/layout/toast.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
