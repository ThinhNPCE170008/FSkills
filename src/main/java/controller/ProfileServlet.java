package controller;

import dao.ProfileDAO;
import dao.UserDAO;
import model.Profile;
import model.User;
import util.DBContext;
import util.SendEmail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Random;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/learner/profile", "/instructor/profile", "/admin/profile", "/editProfile", "/changePassword"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String OTP_ATTRIBUTE = "otpCode";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (requestURI.startsWith(contextPath + "/learner/profile") && !"LEARNER".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only learners can access this page.");
            return;
        } else if (requestURI.startsWith(contextPath + "/instructor/profile") && !"INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only instructors can access this page.");
            return;
        } else if (requestURI.startsWith(contextPath + "/admin/profile") && !"ADMIN".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only administrators can access this page.");
            return;
        } else if ((requestURI.equals(contextPath + "/editProfile") || requestURI.equals(contextPath + "/changePassword"))
                && !("LEARNER".equalsIgnoreCase(user.getRole().toString()) || "INSTRUCTOR".equalsIgnoreCase(user.getRole().toString()) || "ADMIN".equalsIgnoreCase(user.getRole().toString()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only learners, instructors, or administrators can access this page.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "edit";
        }

        switch (action) {
            case "edit":
                showEditProfilePage(request, response, user);
                break;
            case "password":
                showChangePasswordPage(request, response);
                break;
            default:
                showEditProfilePage(request, response, user);
                break;
        }
    }

    private void showEditProfilePage(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        DBContext dbContext = null;
        try {
            dbContext = new DBContext();
            ProfileDAO profileDAO = new ProfileDAO(dbContext);
            Profile profile = profileDAO.getProfile(user.getUserId());

            if (profile != null) {
                request.setAttribute("profile", profile);
                request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            } else {
                throw new SQLException("Profile not found.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error loading profile: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } finally {
            if (dbContext != null && dbContext.conn != null) {
                try {
                    dbContext.conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    private void showChangePasswordPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        showEditProfilePage(request, response, user);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (requestURI.startsWith(contextPath + "/learner/profile") && !"LEARNER".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only learners can access this page.");
            return;
        } else if (requestURI.startsWith(contextPath + "/instructor/profile") && !"INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only instructors can access this page.");
            return;
        } else if (requestURI.startsWith(contextPath + "/admin/profile") && !"ADMIN".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only administrators can access this page.");
            return;
        } else if ((requestURI.equals(contextPath + "/editProfile") || requestURI.equals(contextPath + "/changePassword"))
                && !("LEARNER".equalsIgnoreCase(user.getRole().toString()) || "INSTRUCTOR".equalsIgnoreCase(user.getRole().toString()) || "ADMIN".equalsIgnoreCase(user.getRole().toString()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only learners, instructors, or administrators can access this page.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "edit";
        }

        switch (action) {
            case "edit":
                handleEditProfile(request, response, user);
                break;
            case "password":
                handleChangePassword(request, response, user);
                break;
            case "sendOtp":
                handleSendOtp(request, response, user);
                break;
            case "changeEmail":
                handleChangeEmail(request, response, user);
                break;
            default:
                handleEditProfile(request, response, user);
                break;
        }
    }

    private void handleEditProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DBContext dbContext = null;
        try {
            dbContext = new DBContext();
            ProfileDAO profileDAO = new ProfileDAO(dbContext);

            Profile profile = new Profile();
            profile.setUserId(user.getUserId());
            profile.setDisplayName(request.getParameter("displayName"));
            profile.setPhoneNumber(request.getParameter("phoneNumber"));
            profile.setInfo(request.getParameter("info"));

            String dateOfBirthStr = request.getParameter("dateOfBirth");
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                java.sql.Date date = java.sql.Date.valueOf(dateOfBirthStr);
                profile.setDateOfBirth(new java.sql.Timestamp(date.getTime()));
            }
            profile.setGender(Boolean.parseBoolean(request.getParameter("gender")));

            if (!profile.validatePhoneNumber() || !profile.validateDisplayName()) {
                request.setAttribute("profile", profile);
                request.setAttribute("error", "Invalid input data");
                request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
                return;
            }

            boolean updateSuccess = false;
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                java.io.InputStream imageInputStream = filePart.getInputStream();
                updateSuccess = profileDAO.updateProfileWithImage(profile, imageInputStream);
            } else {
                updateSuccess = profileDAO.updateProfile(profile);
            }

            if (updateSuccess) {
                UserDAO userDAO = new UserDAO();
                User updatedUser = userDAO.getByUserID(user.getUserId());
                if (updatedUser != null) {
                    session.setAttribute("user", updatedUser);
                }
                if ("INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
                    response.sendRedirect(request.getContextPath() + "/instructor/profile?action=edit&success=true");
                } else if ("ADMIN".equalsIgnoreCase(user.getRole().toString())) {
                    response.sendRedirect(request.getContextPath() + "/admin/profile?action=edit&success=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/learner/profile?action=edit&success=true");
                }
            } else {
                if ("INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
                    response.sendRedirect(request.getContextPath() + "/instructor/profile?action=edit&error=true");
                } else if ("ADMIN".equalsIgnoreCase(user.getRole().toString())) {
                    response.sendRedirect(request.getContextPath() + "/admin/profile?action=edit&error=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/learner/profile?action=edit&error=true");
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } finally {
            if (dbContext != null && dbContext.conn != null) {
                try {
                    dbContext.conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean isLengthValid = newPassword.length() >= 8;
        boolean hasBothCases = newPassword.matches(".*[a-z].*") && newPassword.matches(".*[A-Z].*");
        boolean hasSpecialChar = newPassword.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*");

        if (!isLengthValid || !hasBothCases || !hasSpecialChar) {
            request.setAttribute("err", "Create failed: Password does not meet requirements!");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("err", "Error: Incorrect confirmpassword");
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        try {
            boolean isPasswordCorrect = userDAO.checkPassword(user.getUserId(), oldPassword);
            if (!isPasswordCorrect) {
                request.setAttribute("err", "Error: Incorrect old password");
                showEditProfilePage(request, response, user);
                return;
            }

            userDAO.updatePassword(user.getUserId(), newPassword);
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                if (referer.contains("?")) {
                    referer += "&passwordSuccess=true";
                } else {
                    referer += "?passwordSuccess=true";
                }
                response.sendRedirect(referer);
            } else {
                request.setAttribute("successMessage", "Password changed successfully.");
                showEditProfilePage(request, response, user);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("err", "Create failed: " + e.getMessage());
            showEditProfilePage(request, response, user);
        }
    }

    private void handleSendOtp(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        response.setContentType("application/json");
        String newEmail = request.getParameter("newEmail");

        // Log the request for debugging
        System.out.println("Sending OTP to email: " + newEmail);

        // Validate email parameter
        if (newEmail == null || newEmail.trim().isEmpty()) {
            System.out.println("Error: Email parameter is null or empty");
            response.getWriter().write("{\"success\": false, \"message\": \"Email address is required\"}");
            return;
        }

        // Validate email format
        Profile profile = new Profile();
        profile.setEmail(newEmail);
        if (!profile.validateEmail()) {
            System.out.println("Error: Invalid email format: " + newEmail);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid email format. Email must be valid and contain at least one number.\"}");
            return;
        }

        // Generate OTP
        String otp = generateOtp();
        HttpSession session = request.getSession();

        // Store OTP and email in session with timestamp
        session.setAttribute(OTP_ATTRIBUTE, otp);
        session.setAttribute("newEmail", newEmail);
        session.setAttribute("otpTimestamp", System.currentTimeMillis());

        // Log the OTP for debugging (remove in production)
        System.out.println("Generated OTP: " + otp + " for email: " + newEmail);

        // Prepare email message
        SendEmail sendEmail = new SendEmail();
        String message = "Your OTP code for email change is: <strong>" + otp + "</strong>";

        try {
            // Send email
            boolean sent = sendEmail.sendEmailNormal(newEmail, message, "Email Change Verification");

            if (sent) {
                // Success response
                System.out.println("OTP sent successfully to: " + newEmail);
                response.getWriter().write("{\"success\": true, \"message\": \"OTP sent successfully. Please check your email.\"}");
            } else {
                // Failed to send email
                System.out.println("Failed to send OTP to: " + newEmail);
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to send OTP. Please try again later.\"}");
            }
        } catch (Exception e) {
            // Exception handling
            System.out.println("Exception when sending OTP: " + e.getMessage());
            e.printStackTrace();

            // Send a user-friendly error message
            String errorMessage = "An error occurred while sending the OTP. Please try again later.";
            System.out.println("Sending error response: " + errorMessage);
            response.getWriter().write("{\"success\": false, \"message\": \"" + errorMessage + "\"}");
        }
    }

    private void handleChangeEmail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String newEmail = request.getParameter("newEmail");
        String otpCode = request.getParameter("otpCode");

        // Log the request for debugging
        System.out.println("Handling change email request for user: " + user.getUserId());
        System.out.println("New email: " + newEmail);
        System.out.println("OTP code: " + otpCode);

        // Validate parameters
        if (newEmail == null || newEmail.trim().isEmpty() || otpCode == null || otpCode.trim().isEmpty()) {
            System.out.println("Error: Email or OTP is null or empty");
            request.setAttribute("err", "Email and OTP code are required");
            showEditProfilePage(request, response, user);
            return;
        }

        // Get stored values from session
        String storedOtp = (String) session.getAttribute(OTP_ATTRIBUTE);
        String storedEmail = (String) session.getAttribute("newEmail");
        Long otpTimestamp = (Long) session.getAttribute("otpTimestamp");

        System.out.println("Stored OTP: " + storedOtp);
        System.out.println("Stored email: " + storedEmail);
        System.out.println("OTP timestamp: " + otpTimestamp);

        // Check if OTP exists
        if (storedOtp == null || storedEmail == null) {
            System.out.println("Error: No OTP found in session");
            request.setAttribute("err", "No OTP request found. Please request a new OTP.");
            showEditProfilePage(request, response, user);
            return;
        }

        // Check if OTP has expired (10 minutes)
        if (otpTimestamp != null) {
            long currentTime = System.currentTimeMillis();
            long otpAge = currentTime - otpTimestamp;
            long otpMaxAge = 10 * 60 * 1000; // 10 minutes in milliseconds

            if (otpAge > otpMaxAge) {
                System.out.println("Error: OTP has expired. Age: " + (otpAge / 1000) + " seconds");
                request.setAttribute("err", "OTP has expired. Please request a new OTP.");
                session.removeAttribute(OTP_ATTRIBUTE);
                session.removeAttribute("newEmail");
                session.removeAttribute("otpTimestamp");
                showEditProfilePage(request, response, user);
                return;
            }
        }

        // Validate OTP and email
        if (!newEmail.equals(storedEmail)) {
            System.out.println("Error: Email mismatch. Input: " + newEmail + ", Stored: " + storedEmail);
            request.setAttribute("err", "Email does not match the one used to request OTP");
            showEditProfilePage(request, response, user);
            return;
        }

        if (!otpCode.equals(storedOtp)) {
            System.out.println("Error: Invalid OTP. Input: " + otpCode + ", Stored: " + storedOtp);
            request.setAttribute("err", "Invalid OTP code");
            showEditProfilePage(request, response, user);
            return;
        }

        // Update email in database
        DBContext dbContext = null;
        try {
            dbContext = new DBContext();
            ProfileDAO profileDAO = new ProfileDAO(dbContext);

            System.out.println("Updating email for user " + user.getUserId() + " to: " + newEmail);
            boolean success = profileDAO.updateEmail(user.getUserId(), newEmail);

            if (success) {
                System.out.println("Email updated successfully");

                // Update user in session
                UserDAO userDAO = new UserDAO();
                User updatedUser = userDAO.getByUserID(user.getUserId());
                if (updatedUser != null) {
                    session.setAttribute("user", updatedUser);
                    System.out.println("User updated in session");
                }

                // Clean up session attributes
                session.removeAttribute(OTP_ATTRIBUTE);
                session.removeAttribute("newEmail");
                session.removeAttribute("otpTimestamp");

                // Redirect with success message
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    if (referer.contains("?")) {
                        referer += "&emailSuccess=true";
                    } else {
                        referer += "?emailSuccess=true";
                    }
                    System.out.println("Redirecting to: " + referer);
                    response.sendRedirect(referer);
                } else {
                    System.out.println("No referer, showing success message on profile page");
                    request.setAttribute("successMessage", "Email changed successfully.");
                    showEditProfilePage(request, response, user);
                }
            } else {
                System.out.println("Failed to update email in database");
                request.setAttribute("err", "Failed to update email. Please try again.");
                showEditProfilePage(request, response, user);
            }
        } catch (Exception e) {
            System.out.println("Exception when updating email: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("err", "Error updating email: " + e.getMessage());
            showEditProfilePage(request, response, user);
        } finally {
            if (dbContext != null && dbContext.conn != null) {
                try {
                    dbContext.conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    private String generateOtp() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));
    }
}
