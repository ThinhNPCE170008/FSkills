/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
public class Cart {
    private int CartID;
    private int UserID;
    private int CourseID;
    private Timestamp BuyDate;

    public Cart() {
    }

    public Cart(int CartID, int UserID, int CourseID, Timestamp BuyDate) {
        this.CartID = CartID;
        this.CourseID = CourseID;
        this.UserID = UserID;
        this.BuyDate = BuyDate;
    }

    public int getCartID() {
        return CartID;
    }

    public void setCartID(int CartID) {
        this.CartID = CartID;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }
    
    public int getCourseID() {
        return CourseID;
    }

    public void setCourseID(int CourseID) {
        this.CourseID = CourseID;
    }

    public Timestamp getBuyDate() {
        return BuyDate;
    }

    public void setBuyDate(Timestamp BuyDate) {
        this.BuyDate = BuyDate;
    }
}
