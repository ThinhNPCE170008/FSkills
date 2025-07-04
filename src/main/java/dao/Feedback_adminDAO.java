package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Feedback_admin;
import util.DBContext;

/**
 * Data Access Object for Feedback_admin
 */
public class Feedback_adminDAO extends DBContext {

    /**
     * Get all feedback from the database
     * 
     * @return List of all feedback
     */
    public List<Feedback_admin> getAllFeedback() {
        List<Feedback_admin> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM Feedback_user ORDER BY CreatedAt DESC";
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Check if connection is valid
            if (conn == null || conn.isClosed()) {
                System.err.println("Database connection is null or closed");
                return feedbackList;
            }

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Feedback_admin feedback = new Feedback_admin();
                feedback.setFeedbackId(rs.getInt("FeedbackID"));
                feedback.setFeedbackType(rs.getString("FeedbackType"));
                feedback.setTitle(rs.getString("FeedbackTitle"));
                feedback.setContent(rs.getString("FeedbackContent"));

                // Combine first and last name for userName
                String firstName = rs.getString("FirstName");
                String lastName = rs.getString("LastName");
                feedback.setUserName((firstName != null ? firstName : "") + 
                                     (lastName != null ? " " + lastName : ""));

                feedback.setUserId(rs.getInt("UserID"));
                feedback.setTimestamp(rs.getTimestamp("CreatedAt"));

                // Set email
                feedback.setEmail(rs.getString("Email"));

                // Convert boolean IsResolved to string status
                boolean isResolved = rs.getBoolean("IsResolved");
                feedback.setStatus(isResolved ? "resolved" : "new");

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all feedback: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources to prevent leaks
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    System.err.println("Error closing ResultSet: " + e.getMessage());
                }
            }
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    System.err.println("Error closing PreparedStatement: " + e.getMessage());
                }
            }
        }
        return feedbackList;
    }

    /**
     * Get feedback filtered by type
     * 
     * @param type The type of feedback to retrieve (comments, suggestions, questions)
     * @return List of feedback of the specified type
     */
    public List<Feedback_admin> getFeedbackByType(String type) {
        List<Feedback_admin> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM Feedback_user WHERE FeedbackType = ? ORDER BY CreatedAt DESC";
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Check if connection is valid
            if (conn == null || conn.isClosed()) {
                System.err.println("Database connection is null or closed");
                return feedbackList;
            }

            ps = conn.prepareStatement(sql);
            ps.setString(1, type);
            rs = ps.executeQuery();

            while (rs.next()) {
                Feedback_admin feedback = new Feedback_admin();
                feedback.setFeedbackId(rs.getInt("FeedbackID"));
                feedback.setFeedbackType(rs.getString("FeedbackType"));
                feedback.setTitle(rs.getString("FeedbackTitle"));
                feedback.setContent(rs.getString("FeedbackContent"));

                // Combine first and last name for userName
                String firstName = rs.getString("FirstName");
                String lastName = rs.getString("LastName");
                feedback.setUserName((firstName != null ? firstName : "") + 
                                     (lastName != null ? " " + lastName : ""));

                feedback.setUserId(rs.getInt("UserID"));
                feedback.setTimestamp(rs.getTimestamp("CreatedAt"));

                // Set email
                feedback.setEmail(rs.getString("Email"));

                // Convert boolean IsResolved to string status
                boolean isResolved = rs.getBoolean("IsResolved");
                feedback.setStatus(isResolved ? "resolved" : "new");

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            System.err.println("Error getting feedback by type '" + type + "': " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources to prevent leaks
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    System.err.println("Error closing ResultSet: " + e.getMessage());
                }
            }
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    System.err.println("Error closing PreparedStatement: " + e.getMessage());
                }
            }
        }
        return feedbackList;
    }

    /**
     * Update the status of a feedback
     * 
     * @param id The ID of the feedback to update
     * @param status The new status (new, read, archived, resolved)
     * @return 1 if successful, 0 if failed
     */
    public int updateFeedbackStatus(int id, String status) {
        String sql = "UPDATE Feedback_user SET IsResolved = ? WHERE FeedbackID = ?";
        PreparedStatement ps = null;

        try {
            // Check if connection is valid
            if (conn == null || conn.isClosed()) {
                System.err.println("Database connection is null or closed");
                return 0;
            }

            ps = conn.prepareStatement(sql);

            // Convert string status to boolean IsResolved
            boolean isResolved = status.equals("resolved");
            ps.setBoolean(1, isResolved);
            ps.setInt(2, id);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.err.println("Error updating feedback status for ID " + id + " to '" + status + "': " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources to prevent leaks
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    System.err.println("Error closing PreparedStatement: " + e.getMessage());
                }
            }
        }
        return 0;
    }

    /**
     * Delete a feedback permanently from the database
     * 
     * @param id The ID of the feedback to delete
     * @return 1 if successful, 0 if failed
     */
    public int deleteFeedback(int id) {
        String sql = "DELETE FROM Feedback_user WHERE FeedbackID = ?";
        PreparedStatement ps = null;

        try {
            // Reinitialize connection if needed
            if (conn == null || conn.isClosed()) {
                System.err.println("Attempting to reconnect to database...");
                // Create a new DBContext to get a fresh connection
                DBContext dbContext = new DBContext();
                conn = dbContext.conn;

                if (conn == null || conn.isClosed()) {
                    System.err.println("Failed to reconnect to database");
                    return 0;
                }
                System.out.println("Successfully reconnected to database");
            }

            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            // Log the SQL query for debugging
            System.out.println("Executing SQL: " + sql + " with ID: " + id);

            int result = ps.executeUpdate();
            System.out.println("Delete result: " + result + " rows affected");

            if (result > 0) {
                System.out.println("Successfully deleted feedback with ID: " + id);
                return 1;
            } else {
                System.err.println("No feedback found with ID: " + id);

                // Check if the feedback exists
                String checkSql = "SELECT COUNT(*) FROM Feedback_user WHERE FeedbackID = ?";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setInt(1, id);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    System.err.println("Feedback exists but could not be deleted");
                } else {
                    System.err.println("Feedback with ID " + id + " does not exist in the database");
                }

                rs.close();
                checkPs.close();
                return 0;
            }
        } catch (SQLException e) {
            // Print detailed error information for debugging
            System.err.println("Error deleting feedback with ID " + id + ": " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();

            // Try a simpler approach as a fallback
            try {
                System.out.println("Attempting fallback delete method...");
                String fallbackSql = "DELETE FROM Feedback_user WHERE FeedbackID = " + id;
                java.sql.Statement stmt = conn.createStatement();
                int fallbackResult = stmt.executeUpdate(fallbackSql);
                stmt.close();

                if (fallbackResult > 0) {
                    System.out.println("Fallback delete method succeeded: " + fallbackResult + " rows affected");
                    return 1;
                } else {
                    System.err.println("Fallback delete method affected 0 rows");
                }
            } catch (SQLException ex) {
                System.err.println("Fallback delete method failed: " + ex.getMessage());
            }
        } finally {
            // Close resources to prevent leaks
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    System.err.println("Error closing PreparedStatement: " + e.getMessage());
                }
            }
        }
        return 0;
    }

    /**
     * Add a new feedback to the database
     * 
     * @param feedback The feedback to add
     * @return 1 if successful, 0 if failed
     */
    public int addFeedback(Feedback_admin feedback) {
        String sql = "INSERT INTO Feedback_user (FeedbackType, FeedbackTitle, FeedbackContent, FirstName, LastName, Email, UserID, CreatedAt, IsResolved) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = null;

        try {
            // Check if connection is valid
            if (conn == null || conn.isClosed()) {
                System.err.println("Database connection is null or closed");
                return 0;
            }

            // Validate feedback object
            if (feedback == null) {
                System.err.println("Feedback object is null");
                return 0;
            }

            ps = conn.prepareStatement(sql);
            ps.setString(1, feedback.getFeedbackType());
            ps.setString(2, feedback.getTitle());
            ps.setString(3, feedback.getContent());

            // Split userName into firstName and lastName
            String[] nameParts = feedback.getUserName().split(" ", 2);
            String firstName = nameParts.length > 0 ? nameParts[0] : "";
            String lastName = nameParts.length > 1 ? nameParts[1] : "";
            ps.setString(4, firstName);
            ps.setString(5, lastName);

            // Set email from the model
            ps.setString(6, feedback.getEmail() != null ? feedback.getEmail() : "");
            ps.setInt(7, feedback.getUserId());
            ps.setTimestamp(8, feedback.getTimestamp() != null ? feedback.getTimestamp() : new Timestamp(System.currentTimeMillis()));

            // Convert string status to boolean IsResolved
            boolean isResolved = feedback.getStatus().equals("resolved");
            ps.setBoolean(9, isResolved);

            int result = ps.executeUpdate();
            return result > 0 ? 1 : 0;
        } catch (SQLException e) {
            System.err.println("Error adding feedback: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Unexpected error adding feedback: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources to prevent leaks
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    System.err.println("Error closing PreparedStatement: " + e.getMessage());
                }
            }
        }
        return 0;
    }

    /**
     * Delete all feedback records from the database
     * 
     * @return The number of records deleted, or -1 if an error occurred
     */
    public int deleteAllFeedback() {
        String sql = "DELETE FROM Feedback_user";
        PreparedStatement ps = null;

        try {
            // Check if connection is valid
            if (conn == null || conn.isClosed()) {
                System.err.println("Database connection is null or closed");
                return -1;
            }

            ps = conn.prepareStatement(sql);

            int result = ps.executeUpdate();
            return result; // Return the actual number of records deleted
        } catch (SQLException e) {
            System.err.println("Error deleting all feedback: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources to prevent leaks
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    System.err.println("Error closing PreparedStatement: " + e.getMessage());
                }
            }
        }
        return -1;
    }
}
