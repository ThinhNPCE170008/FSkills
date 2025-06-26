///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
package controller;

import dao.UserDAO;
import model.User;
import model.Role;
import model.Ban;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

@WebServlet(name = "updateUserServlet", urlPatterns = {"/updateUserServlet"})
public class UpdateUserServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateUserServlet.class.getName());
    private static final Pattern DISPLAY_NAME_PATTERN = Pattern.compile("^[\\p{L}]+(\\s[\\p{L}]+)*$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x5e-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$");
    private static final Pattern PHONE_NUMBER_PATTERN = Pattern.compile("^(?:(0|\\+84)[35789]\\d{8}|016[2-9]\\d{7}|02\\d{9,10}|09\\d{8}|08\\d{8}|07\\d{8}|03\\d{8}|05\\d{8})$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String userNameFromParam = request.getParameter("userName");

        Map<String, String> errorMessages = new HashMap<>();

        String userName = request.getParameter("userName");
        String displayName = request.getParameter("displayName");
        String email = request.getParameter("email");
        String roleStr = request.getParameter("role");
        String banStr = request.getParameter("ban");
        String reportsStr = request.getParameter("reports");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String info = request.getParameter("info");
        String phone = request.getParameter("phone");
        String globalMessage = "";

        if (displayName == null || displayName.trim().isEmpty()) {
            errorMessages.put("displayName", "Display Name cannot be empty.");
        } else if (!DISPLAY_NAME_PATTERN.matcher(displayName.trim()).matches()) {
            errorMessages.put("displayName", "Display Name must contain only letters A–Z, a–z and no more than 1 space between characters.");
        }

        if (email == null || email.trim().isEmpty()) {
            errorMessages.put("email", "Email cannot be empty.");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errorMessages.put("email", "Invalid email format. E.g., user@example.com");
        }
        if (phone != null && !phone.trim().isEmpty()) {
            if (!PHONE_NUMBER_PATTERN.matcher(phone.trim()).matches()) {
                errorMessages.put("phone", "Invalid phone format");
            }
        }

        Timestamp dateOfBirthTimestamp = null;
        LocalDate dob = null;

        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            try {
                dob = LocalDate.parse(dateOfBirthStr);
                dateOfBirthTimestamp = Timestamp.valueOf(dob.atStartOfDay());

                if (dob.isAfter(LocalDate.now())) {
                    errorMessages.put("dateOfBirth", "Date of Birth cannot be in the future.");
                }
            } catch (DateTimeParseException e) {
                LOGGER.log(Level.WARNING, "Invalid DateOfBirth format: " + dateOfBirthStr, e);
                errorMessages.put("dateOfBirth", "Invalid Date Of Birth format. Use YYYY-MM-DD.");
            }
        } else {
            if ("INSTRUCTOR".equalsIgnoreCase(roleStr) || "ADMIN".equalsIgnoreCase(roleStr)) {
                errorMessages.put("dateOfBirth", "Date of Birth is required for Instructors and Admins.");
            }
        }

        if (dob != null && roleStr != null) {
            int age = Period.between(dob, LocalDate.now()).getYears();

            switch (roleStr.toUpperCase()) {
                case "LEARNER":
                    if (age <= 6 || age >= 100) {
                        errorMessages.put("dateOfBirth", "Learner must be older than 6 and younger than 100 years old.");
                    }
                    break;
                case "INSTRUCTOR":
                    if (age <= 18 || age >= 100) {
                        errorMessages.put("dateOfBirth", roleStr + " must be older than 18 and younger than 100 years old.");
                    }
                    break;
                default:
                    break;
            }
        }

        if (!errorMessages.isEmpty()) {
            globalMessage = "Update failed. Please check the errors below.";

            request.setAttribute("param", request.getParameterMap());

            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorMessages", errorMessages);
            request.setAttribute("editMode", true);
            UserDAO userDAO = new UserDAO();
            try {
                request.setAttribute("allInform", userDAO.showAllInform(userNameFromParam));
            } catch (SQLException ex) {
                Logger.getLogger(UpdateUserServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            request.setAttribute("currentUsername", userNameFromParam);
            request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
            return;
        }

        User updatedUser = new User();
        updatedUser.setUserName(userName);
        updatedUser.setDisplayName(displayName.trim());
        updatedUser.setEmail(email.trim());
        updatedUser.setPhone(phone.trim());
        updatedUser.setInfo(info != null ? info.trim() : null);

        updatedUser.setDateOfBirth(dateOfBirthTimestamp);

        try {
            if (roleStr != null && !roleStr.isEmpty()) {
                updatedUser.setRole(Role.valueOf(roleStr.toUpperCase()));
            }
            if (banStr != null && !banStr.isEmpty()) {
                updatedUser.setBan(Ban.valueOf(banStr.toUpperCase()));
            }
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid Role or Ban value.", e);
            globalMessage = "Ban has some errors.";
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorMessages", errorMessages);
            request.setAttribute("editMode", true);
            try {
                UserDAO userDAO = new UserDAO();
                request.setAttribute("allInform", userDAO.showAllInform(userNameFromParam));
            } catch (SQLException ex) {
            }
            request.setAttribute("currentUsername", userNameFromParam);
            request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
            return;
        }

        try {
            updatedUser.setReports(Integer.parseInt(reportsStr));
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid Reports format: " + reportsStr, e);
            globalMessage = "We has some errors.";
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorMessages", errorMessages);
            request.setAttribute("editMode", true);
            try {
                UserDAO userDAO = new UserDAO();
                request.setAttribute("allInform", userDAO.showAllInform(userNameFromParam));
            } catch (SQLException ex) {
                /* handle */ }
            request.setAttribute("currentUsername", userNameFromParam);
            request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateUser(updatedUser);

            if (success) {
                globalMessage = "Update Succeed!";
                request.setAttribute("globalMessage", globalMessage);
                request.setAttribute("editMode", false);

                request.setAttribute("allInform", userDAO.showAllInform(userNameFromParam));
                request.setAttribute("currentUsername", userNameFromParam);
                request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
            } else {
                globalMessage = "We do not found any user.";
                request.setAttribute("globalMessage", globalMessage);
                request.setAttribute("editMode", true);
                request.setAttribute("allInform", userDAO.showAllInform(userNameFromParam));
                request.setAttribute("currentUsername", userNameFromParam);
                request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error during user update.", ex);
            globalMessage = "Error!!!: " + ex.getMessage();
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("editMode", true);
            UserDAO userDAO = new UserDAO();
            try {
                request.setAttribute("allInform", userDAO.showAllInform(userNameFromParam));
            } catch (SQLException ex1) {
                Logger.getLogger(UpdateUserServlet.class.getName()).log(Level.SEVERE, null, ex1);
            }
            request.setAttribute("currentUsername", userNameFromParam);
            request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "An unexpected error occurred during user update.", ex);
            globalMessage = "Some errors occur: " + ex.getMessage();
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("editMode", true);
            UserDAO userDAO = new UserDAO();
            try {
                request.setAttribute("allInform", userDAO.showAllInform(userNameFromParam));
            } catch (SQLException ex1) {
                Logger.getLogger(UpdateUserServlet.class.getName()).log(Level.SEVERE, null, ex1);
            }
            request.setAttribute("currentUsername", userNameFromParam);
            request.getRequestDispatcher("/WEB-INF/views/userDetails.jsp").forward(request, response);
        }
    }
}
