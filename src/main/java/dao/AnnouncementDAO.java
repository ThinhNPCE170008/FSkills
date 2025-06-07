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
public class AnnouncementDAO extends DBContext{
    public List<Announcement> getAll() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT A.AnnoucementID,A.Title,A.AnnouncementText,A.CreateAt,\n" +
                     "A.TakeDownDate,A.AnnouncementImage,U.UserID,U.UserName,U.DisplayName\n" +
                     "FROM  Announcement A JOIN Users U ON A.UserID = U.UserID;";
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
    
    
}
