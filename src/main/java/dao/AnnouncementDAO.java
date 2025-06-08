/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Announcement;
import model.User;
import util.DBContext;

/**
 *
 * @author huakh
 */
public class AnnouncementDAO extends DBContext {

    public List<Announcement> getAll() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT A.AnnoucementID,A.Title,A.AnnouncementText,A.CreateAt,\n"
                + "A.TakeDownDate,A.AnnouncementImage,U.UserID,U.UserName,U.DisplayName\n"
                + "FROM  Announcement A JOIN Users U ON A.UserID = U.UserID;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int annoucementID = rs.getInt("AnnoucementID");
                String title = rs.getString("Title");
                String announcementText = rs.getString("AnnouncementText");
                Timestamp createAt = rs.getTimestamp("CreateAt");
                Timestamp takeDownDate = rs.getTimestamp("TakeDownDate");
                String announcementImage = rs.getString("AnnouncementImage");
                int userId = rs.getInt("UserID");
                String userName = rs.getString("UserName");
                String displayName = rs.getString("DisplayName");
                list.add(new Announcement(annoucementID, title, announcementText, createAt,
                        takeDownDate, announcementImage, new User(userId, userName, displayName)));
            }
            return list;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public int insert(String Title, String AnnouncementText, String CreateAt, String TakeDownDate,
            String AnnouncementImage, int UserID) {
        String sql = "INSERT INTO Announcement (Title, AnnouncementText,CreateAt,TakeDownDate,"
                + "AnnouncementImage,UserID) VALUES (?,?,?,?,?,?);";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                try {
                    ps.setString(1, Title);
                    ps.setString(2, AnnouncementText);
                    ps.setString(3, CreateAt);
                    ps.setString(4, TakeDownDate);
                    ps.setString(5, AnnouncementImage);
                    ps.setInt(6, UserID);
                    int row = ps.executeUpdate();
                    if (row > 0) {
                        return 1;
                    } else {
                        return 0;
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                    return 0;
                }

            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
        return 0;
    }

    public Announcement getAnnouncementById(int id) {
        Announcement ann = null;
        String sql = "";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int annoucementID = rs.getInt("AnnoucementID");
                String title = rs.getString("Title");
                String announcementText = rs.getString("AnnouncementText");
                Timestamp createAt = rs.getTimestamp("CreateAt");
                Timestamp takeDownDate = rs.getTimestamp("TakeDownDate");
                String announcementImage = rs.getString("AnnouncementImage");
                int userId = rs.getInt("UserID");
                String userName = rs.getString("UserName");
                String displayName = rs.getString("DisplayName");
                ann = new Announcement(annoucementID, title, announcementText, createAt, takeDownDate, announcementImage, new User(userId, userName, displayName));
                return ann;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return ann;
    }
    
    public boolean update(String title, String announcementText, String createAt, String takeDownDate, 
            String announcementImage, int annoucementID) {
        String sql = "UPDATE Announcement SET Title =?, AnnouncementText=?, CreateAt=?, TakeDownDate=?, \n" +
"AnnouncementImage = ? WHERE AnnoucementID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, announcementText);
            ps.setString(3, createAt);
            ps.setString(4, takeDownDate);
            ps.setString(5, announcementImage);
            ps.setInt(6, annoucementID);
            int num = ps.executeUpdate();
            if (num > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
    
    public int delete(int id) {
        String sql = "DELETE FROM Announcement WHERE AnnoucementID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int num = ps.executeUpdate();
            if (num > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return 0;
    }
}
