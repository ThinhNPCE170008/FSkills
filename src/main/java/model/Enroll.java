/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
public class Enroll {
    private int courseID;
    private int userID;
    private Timestamp completeDate;
    private Timestamp enrollDate;

    public Enroll(int courseID, int userID, Timestamp completeDate, Timestamp enrollDate) {
        this.courseID = courseID;
        this.userID = userID;
        this.completeDate = completeDate;
        this.enrollDate = enrollDate;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Timestamp getCompleteDate() {
        return completeDate;
    }

    public void setCompleteDate(Timestamp completeDate) {
        this.completeDate = completeDate;
    }

    public Timestamp getEnrollDate() {
        return enrollDate;
    }

    public void setEnrollDate(Timestamp enrollDate) {
        this.enrollDate = enrollDate;
    }
    
    
}
