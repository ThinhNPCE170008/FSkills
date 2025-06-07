/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author huakh
 */
public class Notification {
    private String notificationId;
    private User userId;
    private String link;
    private String notificationMessage;
    private Boolean status;
    private Timestamp notificationDate;

    public Notification() {
    }

    public Notification(String notificationId, User userId, String link, String notificationMessage, Boolean status, Timestamp notificationDate) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.link = link;
        this.notificationMessage = notificationMessage;
        this.status = status;
        this.notificationDate = notificationDate;
    }

    public String getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(String notificationId) {
        this.notificationId = notificationId;
    }

    public User getUserId() {
        return userId;
    }

    public void setUserId(User userId) {
        this.userId = userId;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getNotificationMessage() {
        return notificationMessage;
    }

    public void setNotificationMessage(String notificationMessage) {
        this.notificationMessage = notificationMessage;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public Timestamp getNotificationDate() {
        return notificationDate;
    }

    public void setNotificationDate(Timestamp notificationDate) {
        this.notificationDate = notificationDate;
    }

    @Override
    public String toString() {
        return "Notification{" + "notificationId=" + notificationId + ", userId=" + userId + ", link=" + link + ", notificationMessage=" + notificationMessage + ", status=" + status + ", notificationDate=" + notificationDate + '}';
    }
    
    
}
