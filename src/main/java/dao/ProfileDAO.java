package dao;

import model.Profile;
import util.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProfileDAO {
    private DBContext dbContext;

    public ProfileDAO(DBContext dbContext) {
        this.dbContext = dbContext;
    }

    public Profile getProfile(int userId) throws SQLException {
        String sql = "SELECT DisplayName, Email, PhoneNumber, Info, dateOfBirth, avatar, gender FROM Users WHERE UserID = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Gián tiếp truy cập kết nối từ dbContext
            stmt = prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return new Profile(
                        userId,
                        rs.getString("DisplayName"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Info"),
                        rs.getTimestamp("dateOfBirth"),
                        rs.getString("avatar"),
                        rs.getBoolean("gender")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error while fetching profile: " + e.getMessage());
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        return null;
    }

    public boolean updateProfile(Profile profile) throws SQLException {
        String sql = "UPDATE Users SET DisplayName=?, Email=?, PhoneNumber=?, Info=?, dateOfBirth=?, avatar=?, gender=? WHERE UserID=?";
        PreparedStatement stmt = null;

        try {
            // Gián tiếp truy cập kết nối từ dbContext
            stmt = prepareStatement(sql);
            stmt.setString(1, profile.getDisplayName());
            stmt.setString(2, profile.getEmail());
            stmt.setString(3, profile.getPhoneNumber());
            stmt.setString(4, profile.getInfo());
            stmt.setTimestamp(5, profile.getDateOfBirth());
            stmt.setString(6, profile.getAvatar());
            stmt.setBoolean(7, profile.getGender());
            stmt.setInt(8, profile.getUserId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error while updating profile: " + e.getMessage());
            throw e;
        } finally {
            if (stmt != null) stmt.close();
        }
    }

    /**
     * Tạo PreparedStatement từ câu lệnh SQL và sử dụng kết nối từ dbContext.
     */
    private PreparedStatement prepareStatement(String sql) throws SQLException {
        if (dbContext.conn == null) {
            throw new SQLException("Database connection is null");
        }
        return dbContext.conn.prepareStatement(sql);
    }
}