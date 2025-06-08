/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.MessageDigest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Announcement;
import model.User;
import util.DBContext;

/**
 *
 * @author NgoThinh1902
 */
public class UserDAO extends DBContext {

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
                int Role = rs.getInt("Role");
                Boolean Gender = rs.getBoolean("Gender");
                Timestamp BirthOfDay = rs.getTimestamp("DateOfBirth");
                Timestamp TimeCreate = rs.getTimestamp("UserCreateDate");
                String Avatar = rs.getString("Avatar");
                String Info = rs.getString("Info");
                Boolean Ban = rs.getBoolean("BanStatus");
                int ReportAmount = rs.getInt("ReportAmount");
                String PhoneNumber = rs.getString("PhoneNumber");
                acc.add(new User(UserId, UserName, DisplayName, Email, Password, Role, Gender, 
                        BirthOfDay, TimeCreate, Avatar, Info, Ban, ReportAmount, PhoneNumber));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return acc;
    }
}
