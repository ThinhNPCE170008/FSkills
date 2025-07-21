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

@WebServlet(name = "ProfileServlet", urlPatterns = {"/learner/profile", "/instructor/profile", "/admin/profile", "/editProfile", "/changePassword"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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
                // Remove any existing success parameters to avoid showing multiple notifications
                if (referer.contains("success=true")) {
                    referer = referer.replace("success=true", "").replace("&&", "&").replace("?&", "?");
                    if (referer.endsWith("?") || referer.endsWith("&")) {
                        referer = referer.substring(0, referer.length() - 1);
                    }
                }

                // Add passwordSuccess parameter
                if (referer.contains("?")) {
                    referer += "&passwordSuccess=true";
                } else {
                    referer += "?passwordSuccess=true";
                }
                response.sendRedirect(referer);
            } else {
                // If no referer, redirect to profile page with passwordSuccess parameter
                if ("INSTRUCTOR".equalsIgnoreCase(user.getRole().toString())) {
                    response.sendRedirect(request.getContextPath() + "/instructor/profile?action=edit&passwordSuccess=true");
                } else if ("ADMIN".equalsIgnoreCase(user.getRole().toString())) {
                    response.sendRedirect(request.getContextPath() + "/admin/profile?action=edit&passwordSuccess=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/learner/profile?action=edit&passwordSuccess=true");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("err", "Create failed: " + e.getMessage());
            showEditProfilePage(request, response, user);
        }
    }
}
