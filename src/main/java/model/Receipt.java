/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import dao.CourseDAO;
import java.util.ArrayList;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */

public class Receipt {
    private int receiptID;
    private int userID;
    private String paymentDetail; // Format: "UserID CourseID[-CourseID...] Price VoucherCode"
    private String paymentStatus;

    // Default constructor
    public Receipt() {
    }

    // Parameterized constructor
    public Receipt(int receiptID, int userID, String paymentDetail, String paymentStatus) {
        this.receiptID = receiptID;
        this.userID = userID;
        this.paymentDetail = paymentDetail;
        this.paymentStatus = paymentStatus;
    }

    // Getters and Setters
    public int getReceiptID() {
        return receiptID;
    }

    public void setReceiptID(int receiptID) {
        this.receiptID = receiptID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getPaymentDetail() {
        return paymentDetail;
    }

    public void setPaymentDetail(String paymentDetail) {
        this.paymentDetail = paymentDetail;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    // Helper methods to parse PaymentDetail
    public int getPaymentUserID() {
        if (paymentDetail != null && !paymentDetail.isEmpty()) {
            String[] parts = paymentDetail.split(" ");
            return Integer.parseInt(parts[0]);
        }
        return 0;
    }

    public ArrayList<Course> getCourseIDs() {
        if (paymentDetail != null && !paymentDetail.isEmpty()) {
            String[] parts = paymentDetail.split(" ");
            String[] courseID;
            ArrayList<Course> list = new ArrayList<Course>();
            CourseDAO cDAO = new CourseDAO();
            if (parts.length > 1) {
                courseID = parts[1].split("-");
                for (String c : courseID){
                    list.add(cDAO.getCourseByCourseID(Integer.parseInt(c)));
                }
                return list;
            }
        }
        return new ArrayList<Course>();
    }

    public double getPrice() {
        if (paymentDetail != null && !paymentDetail.isEmpty()) {
            String[] parts = paymentDetail.split(" ");
            if (parts.length > 2) {
                return Double.parseDouble(parts[2]);
            }
        }
        return 0.0;
    }

    public String getVoucherCode() {
        if (paymentDetail != null && !paymentDetail.isEmpty()) {
            String[] parts = paymentDetail.split(" ");
            if (parts.length > 3) {
                return parts[3];
            }
        }
        return "0";
    }

    @Override
    public String toString() {
        return "Receipt{" +
               "receiptID=" + receiptID +
               ", userID=" + userID +
               ", paymentDetail='" + paymentDetail + '\'' +
               ", paymentStatus='" + paymentStatus + '\'' +
               '}';
    }
}
