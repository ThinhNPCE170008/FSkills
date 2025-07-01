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
    private int notificationId;
    private User userId;
    private User userName;
    private String link;
    private String notificationMessage;
    private Boolean status;
    private Timestamp notificationDate;
    private String type;

    public Notification() {
    }

    public Notification(int notificationId, User userId, User userName, String link, String notificationMessage, Boolean status, Timestamp notificationDate, String type) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.userName = userName;
        this.link = link;
        this.notificationMessage = notificationMessage;
        this.status = status;
        this.notificationDate = notificationDate;
        this.type = type;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public User getUserId() {
        return userId;
    }

    public void setUserId(User userId) {
        this.userId = userId;
    }

    public User getUserName() {
        return userName;
    }

    public void setUserName(User userName) {
        this.userName = userName;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "Notification{" + "notificationId=" + notificationId + ", userId=" + userId + ", userName=" + userName + ", link=" + link + ", notificationMessage=" + notificationMessage + ", status=" + status + ", notificationDate=" + notificationDate + ", type=" + type + '}';
    }

}
