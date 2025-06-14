/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.MessageDigest;
import java.security.SecureRandom;
import model.User;
import model.Role;
import model.Ban;
import util.DBContext;
import model.Announcement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.UserGoogle;

/**
 *
 * @author DELL
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class UserDAO extends DBContext {

    public List<User> getAllStudents() {
        List<User> list = new ArrayList<>();
        String sql = "select UserID ,UserName ,DisplayName, Role, BanStatus, ReportAmount from Users Order by ReportAmount Desc";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("UserID"));
                u.setUserName(rs.getString("UserName"));
                u.setDisplayName(rs.getString("DisplayName"));
                int roleInt = rs.getInt("Role");
                switch (roleInt) {
                    case 0:
                        u.setRole(Role.LEARNER);
                        break;
                    case 1:
                        u.setRole(Role.INSTRUCTOR);
                        break;
                    case 2:
                        u.setRole(Role.ADMIN);
                        break;
                }
                int banInt = rs.getInt("BanStatus");
                switch (banInt) {
                    case 0:
                        u.setBan(Ban.NORMAL);
                        break;
                    case 1:
                        u.setBan(Ban.BANNED);
                        break;
                }
                u.setReports(rs.getInt("ReportAmount"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> searchUsersByName(String searchName) throws SQLException {
        List<User> users = new ArrayList<>();
        // Sử dụng LIKE để tìm kiếm gần đúng, % là ký tự đại diện
        // CONCAT('%', ?, '%') cho phép tìm kiếm bất kỳ đâu trong tên
        String sql = "SELECT UserID, UserName, DisplayName, Role, BanStatus, ReportAmount FROM Users WHERE LOWER(UserName) LIKE LOWER(?)";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + searchName + "%");

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("UserID"));
                    u.setUserName(rs.getString("UserName"));
                    u.setDisplayName(rs.getString("DisplayName"));
                    int roleInt = rs.getInt("Role");
                    switch (roleInt) {
                        case 0:
                            u.setRole(Role.LEARNER);
                            break;
                        case 1:
                            u.setRole(Role.INSTRUCTOR);
                            break;
                        case 2:
                            u.setRole(Role.ADMIN);
                            break;
                    }
                    int banInt = rs.getInt("BanStatus");
                    switch (banInt) {
                        case 0:
                            u.setBan(Ban.NORMAL);
                            break;
                        case 1:
                            u.setBan(Ban.BANNED);
                            break;
                    }
                    u.setReports(rs.getInt("ReportAmount"));
                    users.add(u);
                }
            }
        }
        return users;
    }


    public boolean deleteAccount(String userName) throws SQLException {
        String sql = "DELETE FROM Users WHERE UserName = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userName);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw e;
        }
    }


//    public boolean deleteAccount(String userName) throws SQLException {
//        PreparedStatement psGetUserId = null;
//        // PreparedStatement cho các bảng con không có ON DELETE CASCADE trên UserID
//        PreparedStatement psDeleteUserAnswer = null;
//        PreparedStatement psDeleteTestResult = null;
//        PreparedStatement psDeleteComments = null;
//        PreparedStatement psDeleteFeedbacks = null;
//        PreparedStatement psDeleteUserModificationLog = null;
//        PreparedStatement psDeleteInstructorApp = null;
//        PreparedStatement psDeleteAnnouncement = null;
//        PreparedStatement psDeleteCourses = null; // Sẽ xóa các khóa học do user này tạo
//
//        PreparedStatement psDeleteUser = null; // Cuối cùng là xóa user
//        int userIdToDelete = -1;
//
//        try {
//            // Đảm bảo connection đang mở trước khi thiết lập autoCommit
//            if (this.conn == null || this.conn.isClosed()) {
//                throw new SQLException("Database connection is null or closed.");
//            }
//
//            this.conn.setAutoCommit(false); // Bắt đầu transaction để đảm bảo tính toàn vẹn
//
//            // Bước 1: Tìm UserID của người dùng dựa trên UserName
//            String getUserIdSql = "SELECT UserID FROM Users WHERE UserName = ?";
//            psGetUserId = this.conn.prepareStatement(getUserIdSql);
//            psGetUserId.setString(1, userName);
//            ResultSet rs = psGetUserId.executeQuery();
//
//            if (rs.next()) {
//                userIdToDelete = rs.getInt("UserID");
//            } else {
//                rs.close();
//                this.conn.rollback(); // Rollback nếu không tìm thấy người dùng
//                return false; // Người dùng không tồn tại để xóa
//            }
//            rs.close(); // Đóng ResultSet
//
//            // Nếu tìm thấy userId
//            if (userIdToDelete != -1) {
//                // Bước 2: Xóa các bản ghi liên quan trong các bảng con
//                // ĐẢM BẢO THỨ TỰ XÓA ĐÚNG: Xóa từ các bảng con sâu nhất trước,
//                // và các bảng có khóa ngoại không có ON DELETE CASCADE trên UserID
//
//                // 2.1. Xóa từ bảng UserAnswer (phụ thuộc vào TestResult và UserID)
//                String deleteUserAnswerSql = "DELETE FROM UserAnswer WHERE UserID = ?";
//                psDeleteUserAnswer = this.conn.prepareStatement(deleteUserAnswerSql);
//                psDeleteUserAnswer.setInt(1, userIdToDelete);
//                int rowsDeletedUserAnswer = psDeleteUserAnswer.executeUpdate();
//                System.out.println("Deleted " + rowsDeletedUserAnswer + " records from UserAnswer for UserID: " + userIdToDelete);
//
//                // 2.2. Xóa từ bảng TestResult (phụ thuộc vào Users.UserID và Tests.TestID)
//                String deleteTestResultSql = "DELETE FROM TestResult WHERE UserID = ?";
//                psDeleteTestResult = this.conn.prepareStatement(deleteTestResultSql);
//                psDeleteTestResult.setInt(1, userIdToDelete);
//                int rowsDeletedTestResult = psDeleteTestResult.executeUpdate();
//                System.out.println("Deleted " + rowsDeletedTestResult + " records from TestResult for UserID: " + userIdToDelete);
//
//                // 2.3. Xóa từ bảng Comments (phụ thuộc vào Users.UserID và Materials.MaterialID)
//                String deleteCommentsSql = "DELETE FROM Comments WHERE UserID = ?";
//                psDeleteComments = this.conn.prepareStatement(deleteCommentsSql);
//                psDeleteComments.setInt(1, userIdToDelete);
//                int rowsDeletedComments = psDeleteComments.executeUpdate();
//                System.out.println("Deleted " + rowsDeletedComments + " records from Comments for UserID: " + userIdToDelete);
//
//                // 2.4. Xóa từ bảng Feedbacks (phụ thuộc vào Users.UserID và Courses.CourseID)
//                String deleteFeedbacksSql = "DELETE FROM Feedbacks WHERE UserID = ?";
//                psDeleteFeedbacks = this.conn.prepareStatement(deleteFeedbacksSql);
//                psDeleteFeedbacks.setInt(1, userIdToDelete);
//                int rowsDeletedFeedbacks = psDeleteFeedbacks.executeUpdate();
//                System.out.println("Deleted " + rowsDeletedFeedbacks + " records from Feedbacks for UserID: " + userIdToDelete);
//
//                // 2.5. Xóa từ bảng UserModificationLog (trực tiếp phụ thuộc UserID)
//                String deleteUserModificationLogSql = "DELETE FROM UserModificationLog WHERE UserID = ?";
//                psDeleteUserModificationLog = this.conn.prepareStatement(deleteUserModificationLogSql);
//                psDeleteUserModificationLog.setInt(1, userIdToDelete);
//                int rowsDeletedUserModificationLog = psDeleteUserModificationLog.executeUpdate();
//                System.out.println("Deleted " + rowsDeletedUserModificationLog + " records from UserModificationLog for UserID: " + userIdToDelete);
//
//                // 2.6. Xóa từ bảng InstructorApplication (trực tiếp phụ thuộc UserID)
//                String deleteInstructorAppSql = "DELETE FROM InstructorApplication WHERE UserID = ?";
//                psDeleteInstructorApp = this.conn.prepareStatement(deleteInstructorAppSql);
//                psDeleteInstructorApp.setInt(1, userIdToDelete);
//                int rowsDeletedInstructorApp = psDeleteInstructorApp.executeUpdate();
//                System.out.println("Deleted " + rowsDeletedInstructorApp + " records from InstructorApplication for UserID: " + userIdToDelete);
//
//                // 2.7. Xóa từ bảng Announcement (trực tiếp phụ thuộc UserID)
//                String deleteAnnouncementSql = "DELETE FROM Announcement WHERE UserID = ?";
//                psDeleteAnnouncement = this.conn.prepareStatement(deleteAnnouncementSql);
//                psDeleteAnnouncement.setInt(1, userIdToDelete);
//                int rowsDeletedAnnouncement = psDeleteAnnouncement.executeUpdate();
//                System.out.println("Deleted " + rowsDeletedAnnouncement + " records from Announcement for UserID: " + userIdToDelete);
//
//                // 2.8. Xóa các khóa học do người dùng này tạo từ bảng Courses
//                // Việc xóa khóa học ở đây sẽ tự động kích hoạt ON DELETE CASCADE
//                // trên CourseID cho các bảng như Modules, Materials, Tests, Questions, Enroll, Cart, Feedbacks
//                String deleteCoursesSql = "DELETE FROM Courses WHERE UserID = ?"; // Sửa từ InstructorID sang UserID
//                psDeleteCourses = this.conn.prepareStatement(deleteCoursesSql);
//                psDeleteCourses.setInt(1, userIdToDelete);
//                int rowsDeletedCourses = psDeleteCourses.executeUpdate();
//                System.out.println("Deleted " + rowsDeletedCourses + " records from Courses created by UserID: " + userIdToDelete);
//
//                // Bước 3: Cuối cùng, xóa bản ghi người dùng từ bảng Users
//                String deleteUserSql = "DELETE FROM Users WHERE UserID = ?";
//                psDeleteUser = this.conn.prepareStatement(deleteUserSql);
//                psDeleteUser.setInt(1, userIdToDelete);
//                int rowsAffectedUser = psDeleteUser.executeUpdate();
//
//                // Bước 4: Commit transaction nếu mọi thao tác đều thành công
//                this.conn.commit();
//
//                return rowsAffectedUser > 0; // Trả về true nếu người dùng đã được xóa thành công
//            } else {
//                this.conn.rollback(); // Rollback nếu userIdToDelete không được tìm thấy
//                return false;
//            }
//
//        } catch (SQLException e) {
//            // Xử lý lỗi: Rollback transaction nếu có bất kỳ lỗi nào xảy ra
//            if (this.conn != null) {
//                try {
//                    this.conn.rollback();
//                    System.err.println("Transaction rolled back due to error: " + e.getMessage());
//                    Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, "Database error during account deletion (rolled back): " + e.getMessage(), e);
//                } catch (SQLException ex) {
//                    System.err.println("Error during rollback: " + ex.getMessage());
//                }
//            }
//            e.printStackTrace(); // In lỗi ra console
//            throw e; // Ném lại ngoại lệ để lớp gọi xử lý
//        } finally {
//            // Đóng tất cả các PreparedStatement đã được tạo trong khối try
//            try {
//                if (psGetUserId != null) psGetUserId.close();
//                if (psDeleteUserAnswer != null) psDeleteUserAnswer.close();
//                if (psDeleteTestResult != null) psDeleteTestResult.close();
//                if (psDeleteComments != null) psDeleteComments.close();
//                if (psDeleteFeedbacks != null) psDeleteFeedbacks.close();
//                if (psDeleteUserModificationLog != null) psDeleteUserModificationLog.close();
//                if (psDeleteInstructorApp != null) psDeleteInstructorApp.close();
//                if (psDeleteAnnouncement != null) psDeleteAnnouncement.close();
//                if (psDeleteCourses != null) psDeleteCourses.close();
//                if (psDeleteUser != null) psDeleteUser.close();
//            } catch (SQLException e) {
//                e.printStackTrace();
//            }
//
//            // Khôi phục auto-commit về true
//            if (this.conn != null) {
//                try {
//                    this.conn.setAutoCommit(true);
//                    // LƯU Ý QUAN TRỌNG: Với thiết kế DBContext hiện tại, kết nối này không được đóng ở đây.
//                    // Nếu UserDAO được tạo cho mỗi request, điều này sẽ gây ra rò rò rỉ kết nối.
//                    // Một giải pháp tốt hơn là sử dụng Connection Pool hoặc đảm bảo DBContext đóng kết nối
//                    // khi không còn được sử dụng.
//                } catch (SQLException e) {
//                    e.printStackTrace();
//                }
//            }
//        }
//    }
  
    public List<User> showAllInform(String informUser) throws SQLException {
        List<User> us = new ArrayList<>();
        String sql = "SELECT UserName, DisplayName, Email, Password, Role, DateOfBirth, UserCreateDate, Info, BanStatus, ReportAmount FROM Users WHERE UserName = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, informUser);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            User u = new User();
            u.setUserName(rs.getString("UserName"));
            u.setDisplayName(rs.getString("DisplayName"));
            u.setEmail(rs.getString("Email"));
            u.setPassword(rs.getString("Password"));
            int roleInt = rs.getInt("Role");
            switch (roleInt) {
                case 0:
                    u.setRole(Role.LEARNER);
                    break;
                case 1:
                    u.setRole(Role.INSTRUCTOR);
                    break;
                case 2:
                    u.setRole(Role.ADMIN);
                    break;
            }
            u.setDateOfBirth(rs.getTimestamp("DateOfBirth"));
            u.setUserCreateDate(rs.getTimestamp("UserCreateDate"));
            u.setInfo(rs.getString("Info"));
            int banInt = rs.getInt("BanStatus");
            switch (banInt) {
                case 0:
                    u.setBan(Ban.NORMAL);
                    break;
                case 1:
                    u.setBan(Ban.BANNED);
                    break;
            }
            u.setReports(rs.getInt("ReportAmount"));
            us.add(u);
        }
        return us;
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET DisplayName = ?, Email = ?, Role = ?, BanStatus = ?, ReportAmount = ?, DateOfBirth = ?, Info = ? WHERE UserName = ?";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;

            ps.setString(i++, user.getDisplayName());
            ps.setString(i++, user.getEmail());

            if (user.getRole() != null) {
                ps.setInt(i++, user.getRole().ordinal());
            }

            if (user.getBan() != null) {
                ps.setInt(i++, user.getBan().ordinal());
            }

            ps.setInt(i++, user.getReports());
            ps.setTimestamp(i++, user.getDateOfBirth());
            ps.setString(i++, user.getInfo());
            ps.setString(i++, user.getUserName());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public String hashMD5(String pass) {
        try {
            MessageDigest mes = MessageDigest.getInstance("MD5");
            byte[] mesMD5 = mes.digest(pass.getBytes());
            //[0x0a, 0x7a, 0x12, 0x09,...]
            StringBuilder str = new StringBuilder();
            for (byte b : mesMD5) {
                //0x0a
                String ch = String.format("%02x", b);
                //0a
                str.append(ch);
            }
            //str = 0a7a1209
            return str.toString();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return "";
    }

    public boolean banAccount(String userName) throws SQLException {
        String sql = "UPDATE Users SET BanStatus = CASE WHEN BanStatus = 0 THEN 1 WHEN BanStatus = 1 THEN 0 ELSE BanStatus END WHERE UserName = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userName);
            int ii = ps.executeUpdate();
            return ii > 0;
        }
    }

    public User verifyMD5(String input, String Password) {
        String sql = "SELECT * FROM Users WHERE (UserName = ? OR Email = ?) AND Password = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, input); // có thể là username hoặc email
            ps.setString(2, input);
            ps.setString(3, hashMD5(Password));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int UserId = rs.getInt("UserID");
                String UserName = rs.getString("UserName");
                String DisplayName = rs.getString("DisplayName");
                String Email = rs.getString("Email");
                Password = rs.getString("Password");
                int roleInt = rs.getInt("Role");
                Role Role = null;
                switch (roleInt) {
                    case 0:
                        Role = Role.LEARNER;
                        break;
                    case 1:
                        Role = Role.INSTRUCTOR;
                        break;
                    case 2:
                        Role = Role.ADMIN;
                        break;
                    default:
                        System.err.println("Invalid role value from DB: " + roleInt);
                }
                int Gender = rs.getInt("Gender");
                Timestamp BirthOfDay = rs.getTimestamp("DateOfBirth");
                Timestamp TimeCreate = rs.getTimestamp("UserCreateDate");
                String Avatar = rs.getString("Avatar");
                String Info = rs.getString("Info");
                int banInt = rs.getInt("BanStatus");
                Ban Ban = null;
                switch (banInt) {
                    case 0:
                        Ban = Ban.NORMAL;
                        break;
                    case 1:
                        Ban = Ban.BANNED;
                        break;
                    default:
                        System.err.println("Invalid ban value from DB: " + banInt);
                }
                int ReportAmount = rs.getInt("ReportAmount");
                String PhoneNumber = rs.getString("PhoneNumber");
                boolean isVerified = rs.getBoolean("IsVerified");
                String GoogleID = rs.getString("GoogleID");

                User acc = new User(UserId, UserName, DisplayName, Email, Password, Role, Gender, TimeCreate, TimeCreate, Avatar, Info, Ban, ReportAmount, Info, isVerified, GoogleID);
                return acc;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public User findByGoogleID(String googleID) {
        String sql = "SELECT * FROM Users WHERE GoogleID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, googleID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int UserId = rs.getInt("UserID");
                String UserName = rs.getString("UserName");
                String DisplayName = rs.getString("DisplayName");
                String Email = rs.getString("Email");
                String Password = rs.getString("Password");
                int roleInt = rs.getInt("Role");
                Role Role = null;
                switch (roleInt) {
                    case 0:
                        Role = Role.LEARNER;
                        break;
                    case 1:
                        Role = Role.INSTRUCTOR;
                        break;
                    case 2:
                        Role = Role.ADMIN;
                        break;
                    default:
                        System.err.println("Invalid role value from DB: " + roleInt);
                }
                int Gender = rs.getInt("Gender");
                Timestamp BirthOfDay = rs.getTimestamp("DateOfBirth");
                Timestamp TimeCreate = rs.getTimestamp("UserCreateDate");
                String Avatar = rs.getString("Avatar");
                String Info = rs.getString("Info");
                int banInt = rs.getInt("BanStatus");
                Ban Ban = null;
                switch (banInt) {
                    case 0:
                        Ban = Ban.NORMAL;
                        break;
                    case 1:
                        Ban = Ban.BANNED;
                        break;
                    default:
                        System.err.println("Invalid ban value from DB: " + banInt);
                }
                int ReportAmount = rs.getInt("ReportAmount");
                String PhoneNumber = rs.getString("PhoneNumber");
                boolean isVerified = rs.getBoolean("IsVerified");

                User acc = new User(UserId, UserName, DisplayName, Email, Password, Role, Gender, TimeCreate, TimeCreate, Avatar, Info, Ban, ReportAmount, Info, isVerified, googleID);
                return acc;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public User findByEmail(String Email) {
        String sql = "SELECT * FROM Users WHERE Email = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, Email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int UserId = rs.getInt("UserID");
                String UserName = rs.getString("UserName");
                String DisplayName = rs.getString("DisplayName");
                String Password = rs.getString("Password");
                int roleInt = rs.getInt("Role");
                Role Role = null;
                switch (roleInt) {
                    case 0:
                        Role = Role.LEARNER;
                        break;
                    case 1:
                        Role = Role.INSTRUCTOR;
                        break;
                    case 2:
                        Role = Role.ADMIN;
                        break;
                    default:
                        System.err.println("Invalid role value from DB: " + roleInt);
                }
                int Gender = rs.getInt("Gender");
                Timestamp BirthOfDay = rs.getTimestamp("DateOfBirth");
                Timestamp TimeCreate = rs.getTimestamp("UserCreateDate");
                String Avatar = rs.getString("Avatar");
                String Info = rs.getString("Info");
                int banInt = rs.getInt("BanStatus");
                Ban Ban = null;
                switch (banInt) {
                    case 0:
                        Ban = Ban.NORMAL;
                        break;
                    case 1:
                        Ban = Ban.BANNED;
                        break;
                    default:
                        System.err.println("Invalid ban value from DB: " + banInt);
                }
                int ReportAmount = rs.getInt("ReportAmount");
                String PhoneNumber = rs.getString("PhoneNumber");
                boolean isVerified = rs.getBoolean("IsVerified");
                String GoogleID = rs.getString("GoogleID");

                User acc = new User(UserId, UserName, DisplayName, Email, Password, Role, Gender, TimeCreate, TimeCreate, Avatar, Info, Ban, ReportAmount, Info, isVerified, GoogleID);
                return acc;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public int updateGoogleID(User user) {
        String sql = "UPDATE Users SET GoogleID = ?, IsVerified = ? WHERE UserID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getGoogleID());
            ps.setBoolean(2, true);
            ps.setInt(3, user.getUserId());
            
            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0; 
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int insertGoogle(UserGoogle user) {
        String sql = "INSERT INTO Users (UserName, DisplayName, Email, Password, Role, Avatar, GoogleID, IsVerified) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            String email = user.getEmail();
            String name = user.getName();
            String picture = user.getPicture();
            String googleID = user.getId();

            String username = email.split("@")[0];
            String password = generateRandomPassword(10); // tạo password ngẫu nhiên

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setInt(5, 0);
            ps.setString(6, picture);
            ps.setString(7, googleID);
            ps.setBoolean(8, true); // IsVerified

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;

        } catch (Exception e) {
            System.out.println("insertGoogle error: " + e.getMessage());
        }
        return 0;
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }

        return sb.toString();
    }

    public int saveToken(int userId, String token, Timestamp expiryDate) {
        String sql = "INSERT INTO RememberTokens (user_id, token, expiry_date) VALUES (?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiryDate);
            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public User findByToken(String token) {
        String sql = "SELECT u.* FROM users u JOIN RememberTokens t ON u.UserID = t.user_id WHERE t.token = ? AND t.expiry_date > CURRENT_TIMESTAMP;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int UserId = rs.getInt("UserID");
                String UserName = rs.getString("UserName");
                String DisplayName = rs.getString("DisplayName");
                String Email = rs.getString("Email");
                String Password = rs.getString("Password");
                int roleInt = rs.getInt("Role");
                Role Role = null;
                switch (roleInt) {
                    case 0:
                        Role = Role.LEARNER;
                        break;
                    case 1:
                        Role = Role.INSTRUCTOR;
                        break;
                    case 2:
                        Role = Role.ADMIN;
                        break;
                    default:
                        System.err.println("Invalid role value from DB: " + roleInt);
                }
                int Gender = rs.getInt("Gender");
                Timestamp BirthOfDay = rs.getTimestamp("DateOfBirth");
                Timestamp TimeCreate = rs.getTimestamp("UserCreateDate");
                String Avatar = rs.getString("Avatar");
                String Info = rs.getString("Info");
                int banInt = rs.getInt("BanStatus");
                Ban Ban = null;
                switch (banInt) {
                    case 0:
                        Ban = Ban.NORMAL;
                        break;
                    case 1:
                        Ban = Ban.BANNED;
                        break;
                    default:
                        System.err.println("Invalid ban value from DB: " + banInt);
                }
                int ReportAmount = rs.getInt("ReportAmount");
                String PhoneNumber = rs.getString("PhoneNumber");
                boolean isVerified = rs.getBoolean("IsVerified");
                String GoogleID = rs.getString("GoogleID");

                User acc = new User(UserId, UserName, DisplayName, Email, Password, Role, Gender, TimeCreate, TimeCreate, Avatar, Info, Ban, ReportAmount, Info, isVerified, GoogleID);
                return acc;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public int deleteToken(String token) {
        String sql = "DELETE FROM RememberTokens WHERE token = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int deleteAllTokens(int userId) {
        String sql = "DELETE FROM RememberTokens WHERE user_id = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public static void main(String[] args) {
//        try {
//            UserDAO dao = new UserDAO();

//        String googleID = "123123";
//        String email = "admin01@example.com";
//        User acc = dao.findByGoogleID(googleID);
//        User user = dao.findByEmail(email);
//
//        System.out.println(acc);
//        System.out.println(user);
//        String username = "heroic";
//        String password = "123456";
//        String email = "admin01@example.com";
//
//        User acc = dao.verifyMD5(email, password);
//        System.out.println(acc);
//            Timestamp expiryDate = Timestamp.from(Instant.now().plus(30, ChronoUnit.DAYS));
//            int result = dao.saveToken(1, "1234567", expiryDate);
//            
//        } catch (SQLException ex) {
//            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
//        }

//        String email = "student02@example.com";
//        User acc = dao.findByEmail(email);
//        if (acc != null) {
//            acc.setGoogleID("222333444555");
//            int result = dao.updateGoogleID(acc);
//            System.out.println(result);
//        }
    }
}
