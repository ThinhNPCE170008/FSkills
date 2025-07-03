package model;

import java.sql.Timestamp;

/**
 * Model class representing feedback for admin management
 */
public class Feedback_admin {
    private int feedbackId;
    private String feedbackType;
    private String title;
    private String content;
    private String userName;
    private int userId;
    private Timestamp timestamp;
    private String status;
    private String email;

    // Default constructor
    public Feedback_admin() {
    }

    // Constructor with all fields
    public Feedback_admin(int feedbackId, String feedbackType, String title, String content, 
                         String userName, int userId, Timestamp timestamp, String status, String email) {
        this.feedbackId = feedbackId;
        this.feedbackType = feedbackType;
        this.title = title;
        this.content = content;
        this.userName = userName;
        this.userId = userId;
        this.timestamp = timestamp;
        this.status = status;
        this.email = email;
    }

    // Constructor without ID (for new feedback)
    public Feedback_admin(String feedbackType, String title, String content, 
                         String userName, int userId, String status, String email) {
        this.feedbackType = feedbackType;
        this.title = title;
        this.content = content;
        this.userName = userName;
        this.userId = userId;
        this.timestamp = new Timestamp(System.currentTimeMillis());
        this.status = status;
        this.email = email;
    }

    // Getters and Setters
    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public String getFeedbackType() {
        return feedbackType;
    }

    public void setFeedbackType(String feedbackType) {
        this.feedbackType = feedbackType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Feedback_admin{" + 
               "feedbackId=" + feedbackId + 
               ", feedbackType='" + feedbackType + '\'' + 
               ", title='" + title + '\'' + 
               ", content='" + content + '\'' + 
               ", userName='" + userName + '\'' + 
               ", userId=" + userId + 
               ", timestamp=" + timestamp + 
               ", status='" + status + '\'' + 
               ", email='" + email + '\'' + 
               '}';
    }
}
