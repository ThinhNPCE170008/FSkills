/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Announcement;
import model.Degree;
import model.User;
import util.DBContext;

/**
 *
 * @author huakh
 */
public class DegreeDAO extends DBContext {

    public DegreeDAO() {
        super();
    }

    public List<Degree> getAll() {
        List<Degree> list = new ArrayList<>();
        String sql = "SELECT ia.*,  u.username, u.DisplayName FROM [FLearn].[dbo].[InstructorApplications] AS ia "
                + "JOIN [FLearn].[dbo].[Users] AS u ON ia.UserID = u.UserID;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int ApplicationID = rs.getInt("ApplicationID");
                int ApplicationStatus = rs.getInt("ApplicationStatus");
                Timestamp ApplicationSubmitDate = rs.getTimestamp("ApplicationSubmitDate");
                Timestamp ApprovalDate = rs.getTimestamp("ApprovalDate");
                String CertificateImage = rs.getString("CertificateImage");
                String CertificateLink = rs.getString("CertificateLink");
                int userId = rs.getInt("UserID");
                String userName = rs.getString("UserName");
                String displayName = rs.getString("DisplayName");
                list.add(new Degree(ApplicationID, ApplicationStatus, ApplicationSubmitDate, ApprovalDate,
                        CertificateImage, CertificateLink, new User(userId, userName, displayName)));
            }
            return list;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public int insert(int userId, String Image, String link) {
        String sql = "INSERT INTO InstructorApplications(UserID,ApplicationStatus,ApplicationSubmitDate,"
                + "CertificateImage,CertificateLink) VALUES (?, 0, GETDATE(), ?, ?);";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, Image);
            ps.setString(3, link);
            int row = ps.executeUpdate();
            if (row > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public boolean update(String image, String link, String applicationId) {
        String sql = "UPDATE InstructorApplications SET ApplicationSubmitDate = GETDATE(),"
                + "CertificateImage = ?,CertificateLink = ? WHERE ApplicationID = ?;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, image);
            ps.setString(2, link);
            ps.setString(3, applicationId);
            int num = ps.executeUpdate();
            if (num > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public int delete(int id) {
        String sql = "DELETE FROM InstructorApplications WHERE ApplicationID  = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int num = ps.executeUpdate();
            if (num > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return 0;
    }
    
    public boolean approve(String status, String applicationId) {
        String sql = "UPDATE InstructorApplications SET ApprovalDate = GETDATE(),ApplicationStatus=? "
                + "WHERE ApplicationID = ?;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, applicationId);
            int num = ps.executeUpdate();
            if (num > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
}
