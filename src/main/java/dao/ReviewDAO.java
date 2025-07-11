/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Review;
import model.User;
import util.DBContext;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
public class ReviewDAO extends DBContext{
    public ReviewDAO(){
    }
    
    public ArrayList<Review> getReviewList(int CourseID){
        ArrayList<Review> list = new ArrayList<Review>();
        String sql = "Select * From Reviews Where CourseID = ?";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, CourseID);
            ResultSet rs = ps.executeQuery();
            UserDAO uDAO = new UserDAO();
            while (rs.next()){
                list.add(new Review(rs.getInt("ReviewID"), rs.getInt("UserID"), rs.getInt("CourseID"), rs.getFloat("Rate"), rs.getString("ReviewDescription"), uDAO.getByUserID(rs.getInt("UserID"))));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }
    
    public boolean isReviewed(int UserID, int CourseID) {
        String sql = "Select * From Reviews Where UserID = ? AND CourseID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ps.setInt(2, CourseID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
    
    public int submitReview(Review re){
        String sql 
                = "Insert Into Reviews (UserID, CourseID, Rate, ReviewDescription)\n"
                + "Values (?,?,?,?)";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, re.getUserID());
            ps.setInt(2, re.getCourseID());
            ps.setFloat(3, re.getRate());
            ps.setString(4, re.getReviewDescription());
            int result = ps.executeUpdate();
            return result;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
}
