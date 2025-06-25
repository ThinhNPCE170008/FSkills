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

    public int insert(String Title, String AnnouncementText, String TakeDownDate,
            String AnnouncementImage, int UserID) {
        String sql = "INSERT INTO Announcement (Title, AnnouncementText,CreateAt,TakeDownDate,AnnouncementImage,UserID) VALUES (?,?,GETDATE(),?,?,?);";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, Title);
            ps.setString(2, AnnouncementText);
            Timestamp takeDownTimestamp = Timestamp.valueOf(TakeDownDate.replace("T", " ") + ":00");
            ps.setTimestamp(3, takeDownTimestamp);
            ps.setString(4, AnnouncementImage);
            ps.setInt(5, UserID);
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

    public Announcement getAnnouncementById(int id) {
        Announcement ann = null;
        String sql = "SELECT * FROM [dbo].[Announcement] a JOIN [dbo].[Users] u ON a.UserID = u.UserID\n"
                + "WHERE a.AnnoucementID = ?";
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

    public boolean update(String title, String announcementText, String takeDownDate,
            String announcementImage, String annoucementID) {
        String sql = "UPDATE Announcement SET Title = ?, AnnouncementText = ?, CreateAt = GETDATE(), TakeDownDate = ?, AnnouncementImage = ?\n"
                + "WHERE AnnoucementID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, announcementText);
            ps.setString(3, takeDownDate);
            ps.setString(4, announcementImage);
            ps.setString(5, annoucementID);
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
//------------------------------------------------------------------------------------------------------------------------------------------------------
    public List<Announcement> userAnnDetail(int Id) throws SQLException {
        List<Announcement> list = new ArrayList<>();
        String sql = "Select title, AnnouncementText, CreateAt, TakeDownDate, AnnouncementImage from announcement";
        PreparedStatement ps = conn.prepareStatement(sql);
        try {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Announcement a = new Announcement();
                a.setTitle(rs.getString("title"));
                a.setAnnouncementText(rs.getString("AnnouncementText"));
                a.setCreateDate(rs.getTimestamp("CreateAt"));
                a.setTakeDownDate(rs.getTimestamp("TakeDownDate"));
                a.setAnnouncementImage(rs.getString("AnnouncementImage"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Announcement> userAnn(int Id) throws SQLException {
        List<Announcement> list = new ArrayList<>();
        String sql = "Select title, CreateAt from announcement";
        PreparedStatement ps = conn.prepareStatement(sql);
        try {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Announcement ad = new Announcement();
                ad.setTitle(rs.getString("title"));
                ad.setCreateDate(rs.getTimestamp("CreateAt"));
                list.add(ad);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Announcement> searchAnnouncements(String keyword) {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT A.AnnoucementID, A.Title, A.AnnouncementText, A.CreateAt, "
                    + "A.TakeDownDate, A.AnnouncementImage, U.UserID, U.UserName, U.DisplayName "
                    + "FROM Announcement A JOIN Users U ON A.UserID = U.UserID "
                    + "WHERE A.Title LIKE ? OR A.AnnouncementText LIKE ? "
                    + "ORDER BY A.CreateAt DESC;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            // Thêm '%' vào đầu và cuối keyword để tìm kiếm chuỗi con
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
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
            System.out.println("Error in AnnouncementDAO.searchAnnouncements(): " + e.getMessage());
        }
        return list;
    }
//-----------------------------------------------------------------------------------------------------------------------------------------------------
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