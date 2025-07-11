/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author DELL
 */
import java.sql.Timestamp;

public class Voucher {
    private int voucherID;
    private String voucherName;
    private String voucherCode;
    private Timestamp expiredDate;
    private String saleType;
    private int saleAmount;
    private int minPrice;
    private int amount;

    public Voucher() {
    }

    public Voucher(int voucherID, String voucherName, String voucherCode, Timestamp expiredDate, String saleType, int saleAmount, int minPrice, int amount) {
        this.voucherID = voucherID;
        this.voucherName = voucherName;
        this.voucherCode = voucherCode;
        this.expiredDate = expiredDate;
        this.saleType = saleType;
        this.saleAmount = saleAmount;
        this.minPrice = minPrice;
        this.amount = amount;
    }

    public int getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(int voucherID) {
        this.voucherID = voucherID;
    }
    
    public String getVoucherName() {
        return voucherName;
    }

    public void setVoucherName(String voucherName) {
        this.voucherName = voucherName;
    }
    
    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public Timestamp getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(Timestamp expiredDate) {
        this.expiredDate = expiredDate;
    }

    public String getSaleType() {
        return saleType;
    }

    public void setSaleType(String saleType) {
        this.saleType = saleType;
    }

    public int getSaleAmount() {
        return saleAmount;
    }

    public void setSaleAmount(int saleAmount) {
        this.saleAmount = saleAmount;
    }

    public int getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(int minPrice) {
        this.minPrice = minPrice;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    @Override
    public String toString() {
        return "Voucher{" +
                "voucherID=" + voucherID +
                ", voucherName='" + voucherName + '\'' +
                ", voucherCode='" + voucherCode + '\'' +
                ", expiredDate=" + expiredDate +
                ", saleType='" + saleType + '\'' +
                ", saleAmount=" + saleAmount +
                ", minPrice=" + minPrice +
                ", amount=" + amount +
                '}';
    }
}