/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Ngo Phuoc Thinh - CE170008 - SE1815
 */
public class Course {
    private int courseID;
    private String courseName;
    private String courseCategory;
    private User user;
    private int approveStatus;
    private Timestamp publicDate;
    private Timestamp courseLastUpdate;
    private int salePrice;
    private int originalPrice;
    private int isSale;
    private String courseImageLocation;

    public Course() {
    }

    public Course(int courseID, String courseName, String courseCategory, User user, int approveStatus, Timestamp publicDate, Timestamp courseLastUpdate, int salePrice, int originalPrice, int isSale, String courseImageLocation) {
        this.courseID = courseID;
        this.courseName = courseName;
        this.courseCategory = courseCategory;
        this.user = user;
        this.approveStatus = approveStatus;
        this.publicDate = publicDate;
        this.courseLastUpdate = courseLastUpdate;
        this.salePrice = salePrice;
        this.originalPrice = originalPrice;
        this.isSale = isSale;
        this.courseImageLocation = courseImageLocation;
    }

    public Course(int courseID, String courseName, String courseCategory, User user, int approveStatus, Timestamp publicDate, Timestamp courseLastUpdate, String courseImageLocation) {
        this.courseID = courseID;
        this.courseName = courseName;
        this.courseCategory = courseCategory;
        this.user = user;
        this.approveStatus = approveStatus;
        this.publicDate = publicDate;
        this.courseLastUpdate = courseLastUpdate;
        this.courseImageLocation = courseImageLocation;
    }
    
    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseCategory() {
        return courseCategory;
    }

    public void setCourseCategory(String courseCategory) {
        this.courseCategory = courseCategory;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public int getApproveStatus() {
        return approveStatus;
    }

    public void setApproveStatus(int approveStatus) {
        this.approveStatus = approveStatus;
    }

    public Timestamp getPublicDate() {
        return publicDate;
    }

    public void setPublicDate(Timestamp publicDate) {
        this.publicDate = publicDate;
    }

    public Timestamp getCourseLastUpdate() {
        return courseLastUpdate;
    }

    public void setCourseLastUpdate(Timestamp courseLastUpdate) {
        this.courseLastUpdate = courseLastUpdate;
    }

    public int getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(int salePrice) {
        this.salePrice = salePrice;
    }

    public int getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(int originalPrice) {
        this.originalPrice = originalPrice;
    }

    public int getIsSale() {
        return isSale;
    }

    public void setIsSale(int isSale) {
        this.isSale = isSale;
    }

    public String getCourseImageLocation() {
        return courseImageLocation;
    }

    public void setCourseImageLocation(String courseImageLocation) {
        this.courseImageLocation = courseImageLocation;
    }

    @Override
    public String toString() {
        return "Course{" + "courseID=" + courseID + ", courseName=" + courseName + ", courseCategory=" + courseCategory + ", user=" + user + ", approveStatus=" + approveStatus + ", publicDate=" + publicDate + ", courseLastUpdate=" + courseLastUpdate + ", salePrice=" + salePrice + ", originalPrice=" + originalPrice + ", isSale=" + isSale + ", courseImageLocation=" + courseImageLocation + '}';
    }
}
