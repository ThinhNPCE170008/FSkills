/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
public class Review {
    private int reviewID;
    private int userID;
    private int courseID;
    private float rate;
    private String reviewDescription;
    private User user;

    public Review() {
    }

    public Review(int reviewID, int userID, int courseID, float rate, String reviewDescription, User user) {
        this.reviewID = reviewID;
        this.userID = userID;
        this.courseID = courseID;
        this.rate = rate;
        this.reviewDescription = reviewDescription;
        this.user = user;
    }
    

    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int ReviewID) {
        this.reviewID = ReviewID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int UserID) {
        this.userID = UserID;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int CourseID) {
        this.courseID = CourseID;
    }

    public float getRate() {
        return rate;
    }

    public void setRate(float rate) {
        this.rate = rate;
    }

    public String getReviewDescription() {
        return reviewDescription;
    }

    public void setReviewDescription(String ReviewDescription) {
        this.reviewDescription = ReviewDescription;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
