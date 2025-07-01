package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
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

    public List<Notification> getAllNotificationsByUserId(int receiverId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT N.*, RU.UserName AS ReceiverUserName, SU.UserName AS SenderUserName, SU.DisplayName AS SenderDisplayName, SU.Avatar AS SenderAvatar\n"
                + "FROM [dbo].[Notification] N\n"
                + "JOIN [dbo].[Users] RU ON N.ReceiverID = RU.UserID\n"
                + "JOIN [dbo].[Users] SU ON N.Sender = SU.UserName\n"
                + "WHERE N.ReceiverID = ? AND N.Type = 'toUser' ";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, receiverId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int notificationId = rs.getInt("NotificationID");
                String link = rs.getString("Link");
                String message = rs.getString("NotificationMessage");
                boolean status = rs.getBoolean("Status");
                Timestamp date = rs.getTimestamp("NotificationDate");
                String type = rs.getString("Type");
                //ReceiverID    
                int receiverID = rs.getInt("ReceiverID");
                String receiverUserName = rs.getString("ReceiverUserName");
                //Sender
                String senderUserName = rs.getString("SenderUserName");
                String senderDisplayName = rs.getString("senderDisplayName");
                String senderAvatar = rs.getString("senderAvatar");
                User receiver = new User(receiverID, receiverUserName);
                User sender = new User(senderUserName, senderDisplayName, senderAvatar);
                Notification noti = new Notification(notificationId, receiver, sender,
                        link, message, status, date, type);
                list.add(noti);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllNotificationsByUserId: " + e.getMessage());
        }
        return list;
    }

    public int sendNofication(int receiverId, String sender, String link,
            String notiMess, String type) {
        String sql;
        if (type.equalsIgnoreCase("toUser")) {
            sql = "INSERT INTO [dbo].[Notification]([ReceiverID], [Sender], [Link], [NotificationMessage], \n"
                    + "[Status], [NotificationDate], [Type]) \n"
                    + "VALUES (?, ?, ?, ?,0, GETDATE(), 'toUser');";
        } else {
            sql = "INSERT INTO [dbo].[Notification]([ReceiverID], [Sender], [Link], [NotificationMessage], \n"
                    + "[Status], [NotificationDate], [Type]) \n"
                    + "VALUES (?, ?, ?, ?,0, GETDATE(), ?);";
        }
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, receiverId);
            ps.setString(2, sender);
            ps.setString(3, link);
            ps.setString(4, notiMess);
            int row = ps.executeUpdate();
            if (!type.equalsIgnoreCase("toUser")) {
                ps.setString(5, type);
            }
            if (row > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public List<Notification> getAllNotificationsForAdmin() {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT N.*, RU.UserName AS ReceiverUserName, SU.UserName AS SenderUserName, SU.DisplayName AS SenderDisplayName, SU.Avatar AS SenderAvatar\n"
                + "FROM [dbo].[Notification] N\n"
                + "JOIN [dbo].[Users] RU ON N.ReceiverID = RU.UserID\n"
                + "JOIN [dbo].[Users] SU ON N.Sender = SU.UserName\n"
                + "WHERE N.Type <> 'toUser'\n"
                + "ORDER BY N.NotificationDate DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int notificationId = rs.getInt("NotificationID");
                String link = rs.getString("Link");
                String message = rs.getString("NotificationMessage");
                boolean status = rs.getBoolean("Status");
                Timestamp date = rs.getTimestamp("NotificationDate");
                String type = rs.getString("Type");
                //ReceiverID    
                int receiverID = rs.getInt("ReceiverID");
                String receiverUserName = rs.getString("ReceiverUserName");
                //Sender
                String senderUserName = rs.getString("SenderUserName");
                String senderDisplayName = rs.getString("senderDisplayName");
                String senderAvatar = rs.getString("senderAvatar");
                User receiver = new User(receiverID, receiverUserName);
                User sender = new User(senderUserName, senderDisplayName, senderAvatar);
                Notification noti = new Notification(notificationId, receiver, sender,
                        link, message, status, date, type);
                list.add(noti);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllNotificationsByUserId: " + e.getMessage());
        }
        return list;
    }
}
