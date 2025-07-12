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
        String sql = "SELECT DisplayName, Email, PhoneNumber, Info, dateOfBirth, avatar, gender, IsVerified FROM Users WHERE UserID = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
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
                        rs.getBytes("avatar"),
                        rs.getBoolean("gender"),
                        rs.getBoolean("IsVerified")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error while fetching profile: " + e.getMessage());
            throw e;
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
        }
        return null;
    }

    public boolean updateProfile(Profile profile) throws SQLException {
        String sql = "UPDATE Users SET DisplayName=?, PhoneNumber=?, Info=?, dateOfBirth=?, gender=? WHERE UserID=?";
        PreparedStatement stmt = null;

        try {
            stmt = prepareStatement(sql);
            stmt.setString(1, profile.getDisplayName());
            stmt.setString(2, profile.getPhoneNumber());
            stmt.setString(3, profile.getInfo());
            stmt.setTimestamp(4, profile.getDateOfBirth());
            stmt.setBoolean(5, profile.getGender());
            stmt.setInt(6, profile.getUserId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error while updating profile: " + e.getMessage());
            throw e;
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
    }

    public boolean updateProfileWithImage(Profile profile, java.io.InputStream avatarStream) throws SQLException {
        String sql = "UPDATE Users SET DisplayName=?, PhoneNumber=?, Info=?, dateOfBirth=?, avatar=?, gender=? WHERE UserID=?";
        PreparedStatement stmt = null;

        try {
            stmt = prepareStatement(sql);
            stmt.setString(1, profile.getDisplayName());
            stmt.setString(2, profile.getPhoneNumber());
            stmt.setString(3, profile.getInfo());
            stmt.setTimestamp(4, profile.getDateOfBirth());
            if (avatarStream != null) {
                stmt.setBinaryStream(5, avatarStream, avatarStream.available());
            } else {
                stmt.setNull(5, java.sql.Types.VARBINARY);
            }
            stmt.setBoolean(6, profile.getGender());
            stmt.setInt(7, profile.getUserId());

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error while updating profile with image: " + e.getMessage());
            throw new SQLException(e);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
    }

    public boolean updateEmail(int userId, String email) throws SQLException {
        String sql = "UPDATE Users SET Email=?, IsVerified=? WHERE UserID=?";
        PreparedStatement stmt = null;

        try {
            stmt = prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setBoolean(2, false); // Set isVerified to false for new email
            stmt.setInt(3, userId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error while updating email: " + e.getMessage());
            throw e;
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
    }

    private PreparedStatement prepareStatement(String sql) throws SQLException {
        if (dbContext.conn == null) {
            throw new SQLException("Database connection is null");
        }
        return dbContext.conn.prepareStatement(sql);
    }
}
