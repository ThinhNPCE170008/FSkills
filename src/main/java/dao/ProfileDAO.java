package dao;
import model.Profile;
import java.sql.*;

public class ProfileDAO {
    private Connection conn;

    public ProfileDAO(Connection conn) {
        this.conn = conn;
    }

    public Profile getProfile(int UserID) throws SQLException {
        String sql = "SELECT DisplayName, Email, PhoneNumber, Info, dateOfBirth, avatar, gender " +
                "FROM Users WHERE UserID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, UserID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Profile(
                        UserID,
                        rs.getString("DisplayName"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Info"),
                        rs.getTimestamp("dateOfBirth"),
                        rs.getString("avatar"),
                        rs.getBoolean("gender")
                );
            }
        }
        return null;
    }

    public boolean updateProfile(Profile profile) throws SQLException {
        String sql = "UPDATE Users SET DisplayName=?, Email=?, PhoneNumber=?, Info=?, " +
                "dateOfBirth=?, avatar=?, gender=? WHERE UserID=?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, profile.getDisplayName());
            stmt.setString(2, profile.getEmail());
            stmt.setString(3, profile.getPhoneNumber());
            stmt.setString(4, profile.getInfo());
            stmt.setTimestamp(5, profile.getDateOfBirth());
            stmt.setString(6, profile.getAvatar());
            stmt.setBoolean(7, profile.getGender());
            stmt.setInt(8, profile.getUserID());

            return stmt.executeUpdate() > 0;
        }
    }
}