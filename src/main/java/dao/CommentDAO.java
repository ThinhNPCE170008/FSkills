package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Comment;
import model.User;
import util.DBContext;

public class CommentDAO {

    public List<Comment> getAllComments() {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.CommentId, c.CommentContent, c.CommentDate, c.IsEdit, c.UserId, "
                + "u.DisplayName, u.Avatar, u.GoogleID "
                + "FROM Comments c "
                + "JOIN Users u ON c.UserId = u.UserId "
                + "ORDER BY c.CommentDate DESC";
        try (Connection conn = new DBContext().conn;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Comment comment = new Comment();
                comment.setCommentId(rs.getInt("CommentId"));
                comment.setCommentContent(rs.getString("CommentContent"));
                comment.setCommentDate(rs.getTimestamp("CommentDate"));
                comment.setIsEdit(rs.getBoolean("IsEdit"));
                comment.setUserId(rs.getInt("UserId"));

                User user = new User();
                user.setUserId(rs.getInt("UserId"));
                user.setDisplayName(rs.getString("DisplayName"));
                user.setAvatar(rs.getBytes("Avatar"));
                user.setGoogleID(rs.getString("GoogleID"));
                comment.setUser(user);
                comments.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    public boolean addComment(Comment comment) {
        String sql = "INSERT INTO Comments (UserId, MaterialId, CommentContent, CommentDate, IsEdit) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().conn;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, comment.getUserId());
            ps.setInt(2, comment.getMaterialId());
            ps.setString(3, comment.getCommentContent());
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            ps.setBoolean(5, false);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateComment(Comment comment) {
        String sql = "UPDATE Comments SET CommentContent = ?, IsEdit = ? WHERE CommentId = ? AND UserId = ?";
        try (Connection conn = new DBContext().conn;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, comment.getCommentContent());
            ps.setBoolean(2, true);
            ps.setInt(3, comment.getCommentId());
            ps.setInt(4, comment.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteComment(int commentId, int userId) {
        String sql = "DELETE FROM Comments WHERE CommentId = ? AND UserId = ?";
        try (Connection conn = new DBContext().conn;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Comment> getCommentsByMaterialId(int materialId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.CommentId, c.CommentContent, c.CommentDate, c.IsEdit, c.UserId, c.MaterialId, "
                + "u.DisplayName, u.Avatar, u.GoogleID "
                + "FROM Comments c "
                + "JOIN Users u ON c.UserId = u.UserId "
                + "WHERE c.MaterialId = ? "
                + "ORDER BY c.CommentDate DESC";
        try (Connection conn = new DBContext().conn;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, materialId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setCommentId(rs.getInt("CommentId"));
                    comment.setCommentContent(rs.getString("CommentContent"));
                    comment.setCommentDate(rs.getTimestamp("CommentDate"));
                    comment.setIsEdit(rs.getBoolean("IsEdit"));
                    comment.setUserId(rs.getInt("UserId"));
                    comment.setMaterialId(rs.getInt("MaterialId"));

                    User user = new User();
                    user.setUserId(rs.getInt("UserId"));
                    user.setDisplayName(rs.getString("DisplayName"));
                    user.setAvatar(rs.getBytes("Avatar"));
                    user.setGoogleID(rs.getString("GoogleID")); 
                    comment.setUser(user);
                    comments.add(comment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    public Comment getCommentById(int commentId) {
        String sql = "SELECT c.CommentId, c.CommentContent, c.CommentDate, c.IsEdit, c.UserId, "
                + "u.DisplayName, u.Avatar, u.GoogleID " 
                + "FROM Comments c "
                + "JOIN Users u ON c.UserId = u.UserId "
                + "WHERE c.CommentId = ?";
        try (Connection conn = new DBContext().conn;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Comment comment = new Comment();
                    comment.setCommentId(rs.getInt("CommentId"));
                    comment.setCommentContent(rs.getString("CommentContent"));
                    comment.setCommentDate(rs.getTimestamp("CommentDate"));
                    comment.setIsEdit(rs.getBoolean("IsEdit"));
                    comment.setUserId(rs.getInt("UserId"));

                    User user = new User();
                    user.setUserId(rs.getInt("UserId"));
                    user.setDisplayName(rs.getString("DisplayName"));
                    user.setAvatar(rs.getBytes("Avatar"));
                    user.setGoogleID(rs.getString("GoogleID"));
                    comment.setUser(user);
                    return comment;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}