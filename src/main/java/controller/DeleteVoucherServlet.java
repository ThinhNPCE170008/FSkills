// Giữ nguyên code Servlet này
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DeleteVoucherServlet", urlPatterns = {"/deleteVoucher"})
public class DeleteVoucherServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DeleteVoucherServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String voucherIDStr = request.getParameter("voucherID");
        
        VoucherDAO voucherDAO = new VoucherDAO();
        String globalMessage = ""; 
        boolean success = false;

        try {
            if ("deleteExpired".equals(action)) {
                success = voucherDAO.deleteExpiredVouchers();
                if (success) {
                    globalMessage = "Successfully deleted all expired vouchers.";
                    request.setAttribute("successMessage", true);
                } else {
                    globalMessage = "No expired vouchers were found to delete.";
                    request.setAttribute("errorMessages", true);
                }
            } else if (voucherIDStr != null && !voucherIDStr.trim().isEmpty()) {
                try {
                    int voucherID = Integer.parseInt(voucherIDStr.trim());
                    success = voucherDAO.deleteVoucher(voucherID);
                    if (success) {
                        globalMessage = "Delete Voucher " + voucherID + " Succeed!";
                        request.setAttribute("successMessage", true);
                    } else {
                        globalMessage = "Delete Voucher " + voucherID + " Fail to found the Voucher.";
                        request.setAttribute("errorMessages", true);
                    }
                } catch (NumberFormatException e) {
                    globalMessage = "ID Voucher must be an integer.";
                    request.setAttribute("errorMessages", true);
                }
            } else {
                globalMessage = "Voucher ID has errors.";
                request.setAttribute("errorMessages", true);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error deleting voucher", ex);
            globalMessage = "Error: " + ex.getMessage();
            request.setAttribute("errorMessages", true);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error deleting voucher", ex);
            globalMessage = "Error.";
            request.setAttribute("errorMessages", true);
        }

        request.setAttribute("globalMessage", globalMessage);
        request.getRequestDispatcher("/voucherList").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}