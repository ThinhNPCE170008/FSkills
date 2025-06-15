package controller;

import dao.ProfileDAO;
import model.Profile;
import model.User;
import util.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/editProfile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        System.out.println("Session ID: " + session.getId());
        System.out.println("User in session: " + (user != null ? user.getDisplayName() : "null"));


        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        DBContext dbContext = null;
        try {
            dbContext = new DBContext();
            ProfileDAO profileDAO = new ProfileDAO(dbContext.getConnection());
            Profile profile = profileDAO.getProfile(user.getUserID()); // Dùng getUserId() từ User

            if (profile != null) {
                System.out.println("Profile found: " + profile.getDisplayName());
                request.setAttribute("profile", profile);
                request.getRequestDispatcher("/WEB-INF/views/editProfile.jsp").forward(request, response);
            } else {
                System.out.println("Profile is null");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error loading profile: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } finally {
            if (dbContext != null) {
                dbContext.close();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {
            System.out.println("User found: " + user.getDisplayName());
        } else {
            System.out.println("User is null");
        }

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        DBContext dbContext = null;
        try {
            dbContext = new DBContext();
            ProfileDAO profileDAO = new ProfileDAO(dbContext.getConnection());
            Profile profile = new Profile();
            profile.setUserID(user.getUserID()); // Dùng setUserId() từ Profile, getUserId() từ User
            profile.setDisplayName(request.getParameter("displayName")); // Đổi "DisplayName" -> "displayName"
            profile.setEmail(request.getParameter("email")); // Đổi "Email" -> "email"
            profile.setPhoneNumber(request.getParameter("phoneNumber")); // Đổi "PhoneNumber" -> "phoneNumber"
            profile.setInfo(request.getParameter("info")); // Đổi "Info" -> "info"

            String dateOfBirthStr = request.getParameter("dateOfBirth");
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                java.sql.Date date = java.sql.Date.valueOf(dateOfBirthStr);
                profile.setDateOfBirth(new java.sql.Timestamp(date.getTime()));
            }

            profile.setGender(Boolean.parseBoolean(request.getParameter("gender")));

            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = processFileUpload(filePart, user.getUserID()); // Dùng getUserId() từ User
                profile.setAvatar(fileName);
            } else {
                Profile oldProfile = profileDAO.getProfile(user.getUserID()); // Dùng getUserId() từ User
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
                request.setAttribute("success", "Profile updated successfully");
            } else {
                request.setAttribute("error", "Failed to update profile");
            }

            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/editProfile.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } finally {
            if (dbContext != null) {
                dbContext.close();
            }
        }
    }

    private String processFileUpload(Part filePart, int userId) throws IOException { // Đổi UserID -> userId
        String fileName = "avatar_" + userId + "_" + System.currentTimeMillis() + getFileExtension(filePart);
        String uploadPath = getServletContext().getRealPath("/uploads/avatars/");
        java.io.File uploadDir = new java.io.File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        filePart.write(uploadPath + java.io.File.separator + fileName);
        return "uploads/avatars/" + fileName;
    }

    private String getFileExtension(Part part) {
        String submittedFileName = part.getSubmittedFileName();
        return submittedFileName.substring(submittedFileName.lastIndexOf("."));
    }
}