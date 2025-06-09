/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.MessageDigest;
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

/**
 *
 * @author DELL
 */
public class UserDAO extends DBContext {

    public List<User> getAllStudents() {
        List<User> list = new ArrayList<>();
        String sql = "select UserID ,UserName ,DisplayName, Role, Ban, Reports from Users Order by Reports Desc";
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
                int banInt = rs.getInt("Ban");
                switch (banInt) {
                    case 0:
                        u.setBan(Ban.NORMAL);
                        break;
                    case 1:
                        u.setBan(Ban.BANNED);
                        break;
                }
                u.setReports(rs.getInt("Reports"));
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
        String sql = "SELECT UserID, UserName, DisplayName, Role, Ban, Reports FROM Users WHERE LOWER(UserName) LIKE LOWER(?)";
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
                    int banInt = rs.getInt("Ban");
                    switch (banInt) {
                        case 0:
                            u.setBan(Ban.NORMAL);
                            break;
                        case 1:
                            u.setBan(Ban.BANNED);
                            break;
                    }
                    u.setReports(rs.getInt("Reports"));
                    users.add(u);
                }
            }
        }
        return users;
    }

    public boolean deleteAccount(String userName) throws SQLException {
        String sql = "DELETE FROM Users WHERE UserName = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userName);
            int i = ps.executeUpdate();
            return i > 0;
        }
    }

    public List<User> showAllInform(String informUser) throws SQLException {
        List<User> us = new ArrayList<>();
        String sql = "SELECT UserName, DisplayName, Email, Password, Role, DateOfBirth, UserCreateDate, Info, Ban, Reports FROM Users WHERE UserName = ?";
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
            int banInt = rs.getInt("Ban");
            switch (banInt) {
                case 0:
                    u.setBan(Ban.NORMAL);
                    break;
                case 1:
                    u.setBan(Ban.BANNED);
                    break;
            }
            u.setReports(rs.getInt("Reports"));
            us.add(u);
        }
        return us;
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET DisplayName = ?, Email = ?, Role = ?, Ban = ?, Reports = ?, DateOfBirth = ?, Info = ? WHERE UserName = ?";

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

    public List<User> verifyMD5(String UserName, String Password) {
        List<User> acc = new ArrayList<>();
        //acc.setId(-1); // Đảm bảo id mặc định là -1 nếu không tìm thấy tài khoản
        String sql = "SELECT * FROM Users WHERE UserName = ? AND Password = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, UserName);
            ps.setString(2, Password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int UserId = rs.getInt("UserID");
                UserName = rs.getString("UserName");
                String DisplayName = rs.getString("DisplayName");
                String Email = rs.getString("Email");
                Password = rs.getString("Password");
                int roleInt = rs.getInt("Role");
                Role userRole = null;
                switch (roleInt) {
                    case 0:
                        userRole = Role.STUDENT;
                        break;
                    case 1:
                        userRole = Role.INSTRUCTOR;
                        break;
                    case 2:
                        userRole = Role.ADMIN;
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
                Ban userBan = null;
                switch (banInt) {
                    case 0:
                        userBan = Ban.NORMAL;
                        break;
                    case 1:
                        userBan = Ban.BANNED;
                        break;
                    default:
                        System.err.println("Invalid ban value from DB: " + banInt);
                    }
                int ReportAmount = rs.getInt("ReportAmount");
                String PhoneNumber = rs.getString("PhoneNumber");
                acc.add(new User(UserId, UserName, DisplayName, Email, Password, userRole, Gender,
                        BirthOfDay, TimeCreate, Avatar, Info, userBan, ReportAmount, PhoneNumber));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return acc;
    }

    public boolean banAccount(String userName) throws SQLException {
        String sql = "UPDATE Users SET BAN = CASE WHEN BAN = 0 THEN 1 WHEN BAN = 1 THEN 0 ELSE BAN END WHERE UserName = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userName);
            int ii = ps.executeUpdate();
            return ii > 0;
        }
    }
}
