/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBContext;
import model.Cart;
import java.util.ArrayList;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
public class CartDAO extends DBContext{
    public CartDAO(){
    }
    
    public ArrayList<Cart> getLearnerCart(int UserID){
        ArrayList<Cart> cartList = new ArrayList<Cart>();
        String sql = "Select * From Cart Where UserID = ? AND BuyDate IS NULL";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, UserID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                cartList.add(new Cart(rs.getInt("CartID"), rs.getInt("UserID"), rs.getInt("CourseID"), null));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return cartList;
    }
    
    public int addToCart( int UserID, int CourseID){
        String sql 
                = "Insert Into Cart (UserID, CourseID)\n"
                + "Values (?,?)";
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
    
    public int removeFromCart(int CartID){
        String sql 
                = "Delete From Cart\n"
                + "Where CartID = ?";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, CartID);
            int result = ps.executeUpdate();
            return result;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
    
    public int setCartBuyDate(int CartID){
        String sql 
                = "Update Cart\n"
                + "Set BuyDate = GETDATE()\n"
                + "Where CartID = ?";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, CartID);
            int result = ps.executeUpdate();
            return result;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }
}
