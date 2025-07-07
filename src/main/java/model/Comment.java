package model;

import java.sql.Timestamp;

public class Comment {
    private int commentId;
    private int userId;
    private int materialId;
    private String commentContent;
    private Timestamp commentDate;
    private boolean isEdit;
    private User user; 

    public Comment() {}

    public Comment(int commentId) {
        this.commentId = commentId;
    }

    public Comment(int commentId, String commentContent) {
        this.commentId = commentId;
        this.commentContent = commentContent;
    }
    
    

    public Comment(int commentId, int userId, int materialId, String commentContent, Timestamp commentDate, boolean isEdit, User user) {
        this.commentId = commentId;
        this.userId = userId;
        this.materialId = materialId;
        this.commentContent = commentContent;
        this.commentDate = commentDate;
        this.isEdit = isEdit;
        this.user = user;
    }

    public Comment(int userId, int materialId, String commentContent) {
        this.userId = userId;
        this.materialId = materialId;
        this.commentContent = commentContent;
    }

    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getMaterialId() {
        return materialId;
    }

    public void setMaterialId(int materialId) {
        this.materialId = materialId;
    }

    public String getCommentContent() {
        return commentContent;
    }

    public void setCommentContent(String commentContent) {
        this.commentContent = commentContent;
    }

    public Timestamp getCommentDate() {
        return commentDate;
    }

    public void setCommentDate(Timestamp commentDate) {
        this.commentDate = commentDate;
    }

    public boolean isIsEdit() {
        return isEdit;
    }

    public void setIsEdit(boolean isEdit) {
        this.isEdit = isEdit;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}