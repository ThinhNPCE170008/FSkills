package controller;

import dao.ProfileDAO;
import dao.UserDAO;
import model.Profile;
import model.User;
import util.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/learner/profile", "/instructor/profile", "/editProfile", "/changePassword"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get the request URI to determine which URL pattern was used
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        // Check if user role matches the URL pattern
        if (requestURI.startsWith(contextPath + "/learner/profile") && !"LEARNER".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only learners can access this page.");
            return;
        } else if (requestURI.startsWith(contextPath + "/instructor/profile") && !"INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only instructors can access this page.");
            return;
        } else if ((requestURI.equals(contextPath + "/editProfile") || requestURI.equals(contextPath + "/changePassword")) 
                && !("LEARNER".equalsIgnoreCase(user.getRole().toString()) || "INSTRUCTOR".equalsIgnoreCase(user.getRole().toString()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only learners or instructors can access this page.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "edit"; // Default action is edit profile
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
                request.getRequestDispatcher("/WEB-INF/views/editProfile.jsp").forward(request, response);
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
        request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
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

        // Get the request URI to determine which URL pattern was used
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        // Check if user role matches the URL pattern
        if (requestURI.startsWith(contextPath + "/learner/profile") && !"LEARNER".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only learners can access this page.");
            return;
        } else if (requestURI.startsWith(contextPath + "/instructor/profile") && !"INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only instructors can access this page.");
            return;
        } else if ((requestURI.equals(contextPath + "/editProfile") || requestURI.equals(contextPath + "/changePassword")) 
                && !("LEARNER".equalsIgnoreCase(user.getRole().toString()) || "INSTRUCTOR".equalsIgnoreCase(user.getRole().toString()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only learners or instructors can access this page.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "edit"; // Default action is edit profile
        }

        switch (action) {
            case "edit":
                handleEditProfile(request, response, user);
                break;
            case "password":
                handleChangePassword(request, response, user);
                break;
            default:
                handleEditProfile(request, response, user);
                break;
        }
    }

    private void handleEditProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        DBContext dbContext = null;
        try {
            dbContext = new DBContext();
            ProfileDAO profileDAO = new ProfileDAO(dbContext);

            Profile profile = new Profile();
            profile.setUserId(user.getUserId());
            profile.setDisplayName(request.getParameter("displayName"));
            profile.setEmail(request.getParameter("email"));
            profile.setPhoneNumber(request.getParameter("phoneNumber"));
            profile.setInfo(request.getParameter("info"));

            String dateOfBirthStr = request.getParameter("dateOfBirth");
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                java.sql.Date date = java.sql.Date.valueOf(dateOfBirthStr);
                profile.setDateOfBirth(new java.sql.Timestamp(date.getTime()));
            }
            profile.setGender(Boolean.parseBoolean(request.getParameter("gender")));

            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = processFileUpload(filePart, user.getUserId());
                profile.setAvatar(fileName);
            } else {
                Profile oldProfile = profileDAO.getProfile(user.getUserId());
                if (oldProfile != null) {
                    profile.setAvatar(oldProfile.getAvatar());
                }
            }

            if (!profile.validateEmail() || !profile.validatePhoneNumber() || !profile.validateDisplayName()) {
                request.setAttribute("profile", profile);
                request.setAttribute("error", "Invalid input data");
                request.getRequestDispatcher("/WEB-INF/views/editProfile.jsp").forward(request, response);
                return;
            }

            if (profileDAO.updateProfile(profile)) {
                System.out.println("Profile updated successfully.");
                // Redirect based on user role
                if ("INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
                    response.sendRedirect(request.getContextPath() + "/instructor/profile?action=edit&success=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/learner/profile?action=edit&success=true");
                }
            } else {
                System.out.println("Failed to update profile.");
                // Redirect based on user role
                if ("INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
                    response.sendRedirect(request.getContextPath() + "/instructor/profile?action=edit&error=true");
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

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        try {
            boolean isPasswordCorrect = userDAO.checkPassword(user.getUserId(), oldPassword);
            if (!isPasswordCorrect) {
                request.setAttribute("errorMessage", "Old password is incorrect.");
                request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
                return;
            }

            userDAO.updatePassword(user.getUserId(), newPassword);
            request.setAttribute("successMessage", "Password changed successfully.");
            request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/changePassword.jsp").forward(request, response);
        }
    }

    private String processFileUpload(Part filePart, int userId) throws IOException {
        String fileName = "avatar_" + userId + "_" + System.currentTimeMillis() + getFileExtension(filePart);
        String uploadPath = getServletContext().getRealPath("/uploads/avatars/");
        java.io.File uploadDir = new java.io.File(uploadPath);

        if (!uploadDir.exists()) {
            if (uploadDir.mkdirs()) {
                System.out.println("Upload directory created at: " + uploadPath);
            } else {
                System.out.println("Failed to create upload directory at: " + uploadPath);
            }
        }

        filePart.write(uploadPath + java.io.File.separator + fileName);
        return "uploads/avatars/" + fileName;
    }

    private String getFileExtension(Part part) {
        String submittedFileName = part.getSubmittedFileName();
        return submittedFileName.substring(submittedFileName.lastIndexOf("."));
    }
}
