/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author AI Assistant
 */
public class Test {
    private int testId;
    private String testName;
    private String description;
    private int duration; // in minutes
    private int totalQuestions;
    private int courseId;
    private int userId; // instructor who created the test
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private boolean isActive;

    // Default constructor
    public Test() {
    }

    // Full constructor
    public Test(int testId, String testName, String description, int duration, int totalQuestions, 
                int courseId, int userId, Timestamp createdDate, Timestamp updatedDate, boolean isActive) {
        this.testId = testId;
        this.testName = testName;
        this.description = description;
        this.duration = duration;
        this.totalQuestions = totalQuestions;
        this.courseId = courseId;
        this.userId = userId;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
        this.isActive = isActive;
    }
    
    // Constructor without ID (for creating new tests)
    public Test(String testName, String description, int duration, int totalQuestions, 
                int courseId, int userId, Timestamp createdDate, boolean isActive) {
        this.testName = testName;
        this.description = description;
        this.duration = duration;
        this.totalQuestions = totalQuestions;
        this.courseId = courseId;
        this.userId = userId;
        this.createdDate = createdDate;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public String getTestName() {
        return testName;
    }

    public void setTestName(String testName) {
        this.testName = testName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "Test{" + "testId=" + testId + ", testName=" + testName + ", description=" + description + 
               ", duration=" + duration + ", totalQuestions=" + totalQuestions + ", courseId=" + courseId + 
               ", userId=" + userId + ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + 
               ", isActive=" + isActive + '}';
    }
}