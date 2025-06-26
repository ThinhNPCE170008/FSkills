/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import util.ImageBase64;

/**
 *
 * @author huakh
 */
public class Announcement {

    private int annoucementID;
    private String title;
    private String announcementText;
    private Timestamp createDate;
    private Timestamp TakeDownDate;
    private byte[] announcementImage;
    private User userId;

    public Announcement() {
    }

    public Announcement(int annoucementID, String title, String annoucementText, Timestamp createDate, Timestamp TakeDownDate, byte[] announcementImage, User userId) {
        this.annoucementID = annoucementID;
        this.title = title;
        this.announcementText = annoucementText;
        this.createDate = createDate;
        this.TakeDownDate = TakeDownDate;
        this.announcementImage = announcementImage;
        this.userId = userId;
    }

    public int getAnnoucementID() {
        return annoucementID;
    }

    public void setAnnoucementID(int annoucementID) {
        this.annoucementID = annoucementID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAnnouncementText() {
        return announcementText;
    }

    public void setAnnouncementText(String announcementText) {
        this.announcementText = announcementText;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public Timestamp getTakeDownDate() {
        return TakeDownDate;
    }

    public void setTakeDownDate(Timestamp TakeDownDate) {
        this.TakeDownDate = TakeDownDate;
    }

    public byte[] getAnnouncementImage() {
        return announcementImage;
    }

    public void setAnnouncementImage(byte[] announcementImage) {
        this.announcementImage = announcementImage;
    }

    public User getUserId() {
        return userId;
    }

    public void setUserId(User userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "Announcement{" + "annoucementID=" + annoucementID + ", title=" + title + ", annoucementText=" + announcementText + ", createDate=" + createDate + ", TakeDownDate=" + TakeDownDate + ", announcementImage=" + announcementImage + ", userId=" + userId + '}';
    }

    public String getImageDataURI() {
        return ImageBase64.toDataURI(announcementImage, "image/jpeg");
    }
}
