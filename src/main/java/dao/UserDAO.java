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
import model.UserGoogle;

/**
 *
 * @author DELL
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
                        u.setRole(Role.STUDENT);
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
                            u.setRole(Role.STUDENT);
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
        PreparedStatement psGetUserId = null;
        PreparedStatement psDeleteInstructorApp = null;
        PreparedStatement psDeleteUser = null;
        int userIdToDelete = -1;

        try {
            conn.setAutoCommit(false);

            // Bước 1: Tìm UserID của người dùng dựa trên UserName
            String getUserIdSql = "SELECT UserID FROM Users WHERE UserName = ?";
            psGetUserId = conn.prepareStatement(getUserIdSql);
            psGetUserId.setString(1, userName);
            ResultSet rs = psGetUserId.executeQuery();

            if (rs.next()) {
                userIdToDelete = rs.getInt("UserID");
            } else {
                conn.rollback();
                return false;
            }
            rs.close(); // Đóng ResultSet

            // Nếu tìm thấy userId
            if (userIdToDelete != -1) {
                //Xóa các bản ghi liên quan trong bảng InstructorApplication
                String deleteInstructorAppSql = "DELETE FROM InstructorApplication WHERE UserID = ?";
                psDeleteInstructorApp = conn.prepareStatement(deleteInstructorAppSql);
                psDeleteInstructorApp.setInt(1, userIdToDelete);
                int rowsDeletedInstructorApp = psDeleteInstructorApp.executeUpdate();
                System.out.println("Deleted " + rowsDeletedInstructorApp + " records from InstructorApplication for UserID: " + userIdToDelete);
                // Bước 3: Cuối cùng, xóa bản ghi người dùng từ bảng Users
                String deleteUserSql = "DELETE FROM Users WHERE UserID = ?";
                psDeleteUser = conn.prepareStatement(deleteUserSql); // Sử dụng conn trực tiếp
                psDeleteUser.setInt(1, userIdToDelete);
                int rowsAffectedUser = psDeleteUser.executeUpdate();

                // Bước 4: Commit transaction nếu mọi thao tác đều thành công
                conn.commit();

                return rowsAffectedUser > 0;
            } else {
                conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            // Xử lý lỗi: Rollback transaction nếu có bất kỳ lỗi nào xảy ra
            if (conn != null) { // Kiểm tra conn có null không trước khi rollback
                try {
                    conn.rollback();
                    System.err.println("Transaction rolled back due to error: " + e.getMessage());
                } catch (SQLException ex) {
                    System.err.println("Error during rollback: " + ex.getMessage());
                }
            }
            e.printStackTrace(); // In lỗi ra console
            throw e; // Ném lại ngoại lệ để lớp gọi xử lý
        } finally {
            // Đóng tất cả các PreparedStatement
            try {
                if (psGetUserId != null) psGetUserId.close();
                if (psDeleteInstructorApp != null) psDeleteInstructorApp.close();
                if (psDeleteUser != null) psDeleteUser.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }

            // Khôi phục auto-commit về true
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

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
                    u.setRole(Role.STUDENT);
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

    public User verifyMD5(String UserName, String Password) {
        //acc.setId(-1); // Đảm bảo id mặc định là -1 nếu không tìm thấy tài khoản
        String sql = "SELECT * FROM Users WHERE UserName = ? AND Password = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, UserName);
            ps.setString(2, hashMD5(Password));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int UserId = rs.getInt("UserID");
                UserName = rs.getString("UserName");
                String DisplayName = rs.getString("DisplayName");
                String Email = rs.getString("Email");
                Password = rs.getString("Password");
                int roleInt = rs.getInt("Role");
                    Role Role = null; 
                    switch (roleInt) {
                        case 0:
                            Role = Role.STUDENT;
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
                int banInt = rs.getInt("Ban");
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

    public boolean banAccount(String userName) throws SQLException {
        String sql = "UPDATE Users SET BanStatus = CASE WHEN BanStatus = 0 THEN 1 WHEN BanStatus = 1 THEN 0 ELSE BanStatus END WHERE UserName = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userName);
            int ii = ps.executeUpdate();
            return ii > 0;
        }
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
                            Role = Role.STUDENT;
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
                int banInt = rs.getInt("Ban");
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
                            Role = Role.STUDENT;
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
                int banInt = rs.getInt("Ban");
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

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();

//        String googleID = "123111";
//        String email = "admin01@example.com";
//
//        User acc = dao.findByGoogleID(googleID);
//        User user = dao.findByEmail(email);
//
//        System.out.println(acc);
//        System.out.println(user);

    }
}
