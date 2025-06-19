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
import model.Notification;
import model.User;
import util.DBContext;

/**
 *
 * @author huakh
 */
public class NotificationDAO extends DBContext {

    public NotificationDAO() {
        super();
    }

    public List<Notification> getAllNotificationsByUserId(int id) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT N.*, U.UserName, U.DisplayName,U.Avatar FROM [dbo].[Notification] N " +
                "JOIN [dbo].[Users] U ON N.UserID = U.UserID WHERE N.UserID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id); // Đừng quên set tham số
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int notificationId = rs.getInt("NotificationID");
                String link = rs.getString("Link");
                String message = rs.getString("NotificationMessage");
                boolean status = rs.getBoolean("Status");
                Timestamp date = rs.getTimestamp("NotificationDate");

                int userId = rs.getInt("UserID");
                String username = rs.getString("UserName");
                String displayName = rs.getString("DisplayName");
                String avatar = rs.getString("Avatar");
                Notification noti = new Notification(notificationId, new User(userId, username, displayName, avatar),
                        link, message, status, date );
                list.add(noti);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllNotificationsByUserId: " + e.getMessage());
        }
        return list;
    }

    public int sendNofication(int userId, String link, String notiMess) {
        String sql = "  INSERT INTO [dbo].[Notification]([UserID], [Link], [NotificationMessage], "
                + "[Status], [NotificationDate])\n"
                + "VALUES (?, ?, ?, 0, GETDATE());";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, link);
            ps.setString(3, notiMess);
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
}
