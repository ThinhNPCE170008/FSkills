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

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        if (!"INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())
                && !"LEARNER".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to edit profiles.");
            return;
        }


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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        if (!"INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())
                && !"LEARNER".equalsIgnoreCase(user.getRole().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to edit profiles.");
            return;
        }

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
                response.sendRedirect("editProfile?success=true");
            } else {
                System.out.println("Failed to update profile.");
                response.sendRedirect("editProfile?error=true");
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
