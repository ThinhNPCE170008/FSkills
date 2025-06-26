/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author DELL
 */
import model.Voucher;
import util.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VoucherDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(VoucherDAO.class.getName());

    public List<Voucher> getAllVouchers() throws SQLException {
        List<Voucher> vouchers = new ArrayList<>();
        // Updated SQL query: added VoucherName, VoucherCode, removed CourseID
        String sql = "SELECT VoucherID, VoucherName, VoucherCode, ExpiredDate, SaleType, SaleAmount, MinPrice, Amount FROM Vouchers";
        try ( PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                vouchers.add(setVoucher(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAllVouchers: " + e.getMessage(), e);
            throw e;
        }
        return vouchers;
    }

    public Voucher getVoucherByID(int voucherID) throws SQLException {
        String sql = "SELECT VoucherID, VoucherName, VoucherCode, ExpiredDate, SaleType, SaleAmount, MinPrice, Amount FROM Vouchers WHERE VoucherID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherID);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return setVoucher(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getVoucherByID for ID " + voucherID + ": " + e.getMessage(), e);
            throw e;
        }
        return null;
    }

    public List<Voucher> searchVouchers(String searchTerm) throws SQLException {
        List<Voucher> vouchers = new ArrayList<>();

        String sql = "SELECT VoucherID, VoucherName, VoucherCode, ExpiredDate, SaleType, SaleAmount, MinPrice, Amount FROM Vouchers WHERE VoucherName LIKE ?";

        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            String trimmedSearchTerm = searchTerm.trim();
            String likeTerm = "%" + trimmedSearchTerm + "%"; //tìm gan dúng

            ps.setString(1, likeTerm);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vouchers.add(setVoucher(rs));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in searchVouchers for term '" + searchTerm + "': " + ex.getMessage(), ex);
            throw ex;
        }

        return vouchers;
    }

    public boolean addVoucher(Voucher voucher) throws SQLException {
        // Updated SQL INSERT statement: added VoucherName, VoucherCode, removed CourseID
        String sql = "INSERT INTO Vouchers (VoucherName, VoucherCode, ExpiredDate, SaleType, SaleAmount, MinPrice, Amount) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, voucher.getVoucherName());
            ps.setString(2, voucher.getVoucherCode());
            ps.setTimestamp(3, voucher.getExpiredDate());
            ps.setString(4, voucher.getSaleType());
            ps.setInt(5, voucher.getSaleAmount());
            ps.setInt(6, voucher.getMinPrice());
            ps.setInt(7, voucher.getAmount());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in addVoucher: " + e.getMessage(), e);
            throw e;
        }
    }

    public boolean updateVoucher(Voucher voucher) throws SQLException {
        String sql = "UPDATE Vouchers SET VoucherName = ?, VoucherCode = ?, ExpiredDate = ?, SaleType = ?, SaleAmount = ?, MinPrice = ?, Amount = ? WHERE VoucherID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, voucher.getVoucherName());
            ps.setString(2, voucher.getVoucherCode());
            ps.setTimestamp(3, voucher.getExpiredDate());
            ps.setString(4, voucher.getSaleType());
            ps.setInt(5, voucher.getSaleAmount());
            ps.setInt(6, voucher.getMinPrice());
            ps.setInt(7, voucher.getAmount());
            ps.setInt(8, voucher.getVoucherID());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateVoucher for ID " + voucher.getVoucherID() + ": " + e.getMessage(), e);
            throw e;
        }
    }

    public boolean deleteVoucher(int voucherID) throws SQLException {
        String sql = "DELETE FROM Vouchers WHERE VoucherID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in deleteVoucher for ID " + voucherID + ": " + e.getMessage(), e);
            throw e;
        }
    }

    private Voucher setVoucher(ResultSet rs) throws SQLException {
        Voucher voucher = new Voucher();
        voucher.setVoucherID(rs.getInt("VoucherID"));
        voucher.setVoucherName(rs.getString("VoucherName"));
        voucher.setVoucherCode(rs.getString("VoucherCode"));
        voucher.setExpiredDate(rs.getTimestamp("ExpiredDate"));
        voucher.setSaleType(rs.getString("SaleType"));
        voucher.setSaleAmount(rs.getInt("SaleAmount"));
        voucher.setMinPrice(rs.getInt("MinPrice"));
        voucher.setAmount(rs.getInt("Amount"));
        return voucher;
    }
}
