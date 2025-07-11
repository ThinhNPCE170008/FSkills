/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBContext;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
public class StudyDAO extends DBContext {

    public StudyDAO() {

    }

    public boolean checkStudy(int UserID, int MaterialID) {
        String sql = "Select * From Study Where UserID = ? AND MaterialID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, MaterialID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(2) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean returnTotalStudy(int UserID, int ModuleID, int MatSize) {
        String sql = "SELECT COUNT(*) AS TotalCount\n"
                + "FROM Study s\n"
                + "JOIN Materials m ON s.MaterialID = m.MaterialID\n"
                + "WHERE s.UserID = ? AND m.ModuleID = ?;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, ModuleID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == MatSize;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public int returnStudyProgress(int UserID, int CourseID) {
        String sql
                = "SELECT \n"
                + "ROUND(\n"
                + "COUNT(DISTINCT s.MaterialID) * 100.0 / COUNT(DISTINCT mat.MaterialID),\n"
                + "2\n"
                + " ) AS StudyPercentage\n"
                + "FROM \n"
                + "Courses c\n"
                + "JOIN \n"
                + "Modules mo ON c.CourseID = mo.CourseID\n"
                + "JOIN \n"
                + "Materials mat ON mo.ModuleID = mat.ModuleID\n"
                + "LEFT JOIN \n"
                + "Study s ON mat.MaterialID = s.MaterialID AND s.UserID = ?\n"
                + "WHERE \n"
                + "c.CourseID = ?;";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, CourseID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
    
    public int addLearnerStudyCompletion(int UserID, int MaterialID, int CourseID) {
        String sql = "Insert Into Study (CompleteDate, UserID, MaterialID) Values (GETDATE(),?,?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, MaterialID);
            int result = ps.executeUpdate();
            if ((result != 0) && (returnStudyProgress(UserID, CourseID) == 100)){
                EnrollDAO eDAO = new EnrollDAO();
                eDAO.setCompleteDate(UserID, CourseID);
            }
            return result;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
}
