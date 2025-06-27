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
public class StudyDAO extends DBContext{
    public StudyDAO(){
        
    }
    
    public boolean checkStudy(int UserID, int MaterialID){
        String sql = "Select * From Study Where UserID = ? AND MaterialID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, MaterialID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(2) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
    
    public int addLearnerStudyCompletion(int UserID, int MaterialID){
        String sql = "Insert Into Study (CompleteDate, UserID, MaterialID) Values (GETDATE(),?,?)";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, MaterialID);
            int result = ps.executeUpdate();
            return result;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
}
