package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Feedback_user;
import util.DBContext;

/**
 * Data Access Object for Feedback_user
 */
public class Feedback_userDAO extends DBContext {
    
    /**
     * Insert a new feedback into the database
     * 
     * @param feedback The feedback to insert
     * @return 1 if successful, 0 if failed
     */
    public int insertFeedback(Feedback_user feedback) {
        String sql = "INSERT INTO Feedback_user (FeedbackType, FeedbackTitle, FeedbackContent, FirstName, LastName, Email, UserID, CreatedAt, IsResolved) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, feedback.getFeedbackType());
            ps.setString(2, feedback.getFeedbackTitle());
            ps.setString(3, feedback.getFeedbackContent());
            ps.setString(4, feedback.getFirstName());
            ps.setString(5, feedback.getLastName());
            ps.setString(6, feedback.getEmail());
            ps.setInt(7, feedback.getUserId());
            ps.setTimestamp(8, feedback.getCreatedAt() != null ? feedback.getCreatedAt() : new Timestamp(System.currentTimeMillis()));
            ps.setBoolean(9, feedback.isIsResolved());
            
            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println("Error inserting feedback: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Get all feedback from the database
     * 
     * @return List of all feedback
     */
    public List<Feedback_user> getAllFeedback() {
        List<Feedback_user> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM Feedback_user ORDER BY CreatedAt DESC";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Feedback_user feedback = new Feedback_user();
                feedback.setFeedbackId(rs.getInt("FeedbackID"));
                feedback.setFeedbackType(rs.getString("FeedbackType"));
                feedback.setFeedbackContent(rs.getString("FeedbackContent"));
                feedback.setFirstName(rs.getString("FirstName"));
                feedback.setLastName(rs.getString("LastName"));
                feedback.setEmail(rs.getString("Email"));
                feedback.setUserId(rs.getInt("UserID"));
                feedback.setCreatedAt(rs.getTimestamp("CreatedAt"));
                feedback.setIsResolved(rs.getBoolean("IsResolved"));
                
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all feedback: " + e.getMessage());
        }
        return feedbackList;
    }
    
    /**
     * Get feedback by ID
     * 
     * @param feedbackId The ID of the feedback to retrieve
     * @return The feedback with the specified ID, or null if not found
     */
    public Feedback_user getFeedbackById(int feedbackId) {
        String sql = "SELECT * FROM Feedback_user WHERE FeedbackID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Feedback_user feedback = new Feedback_user();
                feedback.setFeedbackId(rs.getInt("FeedbackID"));
                feedback.setFeedbackType(rs.getString("FeedbackType"));
                feedback.setFeedbackContent(rs.getString("FeedbackContent"));
                feedback.setFirstName(rs.getString("FirstName"));
                feedback.setLastName(rs.getString("LastName"));
                feedback.setEmail(rs.getString("Email"));
                feedback.setUserId(rs.getInt("UserID"));
                feedback.setCreatedAt(rs.getTimestamp("CreatedAt"));
                feedback.setIsResolved(rs.getBoolean("IsResolved"));
                
                return feedback;
            }
        } catch (SQLException e) {
            System.out.println("Error getting feedback by ID: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Get feedback by user ID
     * 
     * @param userId The ID of the user whose feedback to retrieve
     * @return List of feedback submitted by the specified user
     */
    public List<Feedback_user> getFeedbackByUserId(int userId) {
        List<Feedback_user> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM Feedback_user WHERE UserID = ? ORDER BY CreatedAt DESC";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Feedback_user feedback = new Feedback_user();
                feedback.setFeedbackId(rs.getInt("FeedbackID"));
                feedback.setFeedbackType(rs.getString("FeedbackType"));
                feedback.setFeedbackContent(rs.getString("FeedbackContent"));
                feedback.setFirstName(rs.getString("FirstName"));
                feedback.setLastName(rs.getString("LastName"));
                feedback.setEmail(rs.getString("Email"));
                feedback.setUserId(rs.getInt("UserID"));
                feedback.setCreatedAt(rs.getTimestamp("CreatedAt"));
                feedback.setIsResolved(rs.getBoolean("IsResolved"));
                
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            System.out.println("Error getting feedback by user ID: " + e.getMessage());
        }
        return feedbackList;
    }
    
    /**
     * Update the resolved status of a feedback
     * 
     * @param feedbackId The ID of the feedback to update
     * @param isResolved The new resolved status
     * @return 1 if successful, 0 if failed
     */
    public int updateFeedbackStatus(int feedbackId, boolean isResolved) {
        String sql = "UPDATE Feedback_user SET IsResolved = ? WHERE FeedbackID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setBoolean(1, isResolved);
            ps.setInt(2, feedbackId);
            
            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.out.println("Error updating feedback status: " + e.getMessage());
        }
        return 0;
    }
}