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
public class EnrollDAO extends DBContext{
    public EnrollDAO(){
        
    }
    
    public boolean checkEnrollment(int UserID, int CourseID){
        String sql = "Select * From Enroll Where UserID = ? AND CourseID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, CourseID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
    
    public int addLearnerEnrollment(int UserID, int CourseID){
        String sql = "Insert Into Enroll (UserID, CourseID) Values (?,?)";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, CourseID);
            int result = ps.executeUpdate();
            return result;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
    
    public int setCompleteDate(int UserID, int CourseID){
        String sql
                = "Update Enroll\n"
                + "Set CompleteDate = GETDATE()\n"
                + "Where UserID = ? CourseID = ?";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, CourseID);
            int result = ps.executeUpdate();
            return result;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
}
