/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.VoucherDAO;
import model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "UpdateVoucherServlet", urlPatterns = {"/updateVoucher"})
public class UpdateVoucherServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateVoucherServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, String> errorMessages = new HashMap<>();
        String globalMessage = "";

        String voucherIDStr = request.getParameter("voucherID");
        String expiredDateStr = request.getParameter("expiredDate");
        String saleType = request.getParameter("saleType");
        String saleAmountStr = request.getParameter("saleAmount");
        String minPriceStr = request.getParameter("minPrice");
        String courseIDStr = request.getParameter("courseID");
        String amountStr = request.getParameter("amount");

        int voucherID = 0;
        if (voucherIDStr == null || voucherIDStr.trim().isEmpty()) {
            errorMessages.put("voucherID", "Voucher ID can not be null.");
        } else {
            try {
                voucherID = Integer.parseInt(voucherIDStr.trim());
            } catch (NumberFormatException e) {
                errorMessages.put("voucherID", "Voucher ID must be an integer.");
            }
        }

        Date expiredDate = null;
        if (expiredDateStr == null || expiredDateStr.trim().isEmpty()) {
            errorMessages.put("expiredDate", "Please enter this value.");
        } else {
            try {
                LocalDate date = LocalDate.parse(expiredDateStr);
                expiredDate = Date.valueOf(date);
                if (expiredDate.before(new Date(System.currentTimeMillis()))) {
                    errorMessages.put("expiredDate", "The expired day must be in the future.");
                }
            } catch (DateTimeParseException e) {
                errorMessages.put("expiredDate", "Use YYYY-MM-DD.");
            }
        }

        if (saleType == null || saleType.trim().isEmpty()) {
            errorMessages.put("saleType", "Please enter for this value.");
        } else if (!saleType.equals("PERCENT") && !saleType.equals("FIXED")) {
            errorMessages.put("saleType", "Not valid sale.");
        }

        int saleAmount = 0;
        if (saleAmountStr == null || saleAmountStr.trim().isEmpty()) {
            errorMessages.put("saleAmount", "Not null here.");
        } else {
            try {
                saleAmount = Integer.parseInt(saleAmountStr.trim());
                if (saleAmount <= 0) {
                    errorMessages.put("saleAmount", "Must be >0.");
                }
                if (saleType != null && saleType.equals("PERCENT") && (saleAmount > 100 || saleAmount < 0)) {
                    errorMessages.put("saleAmount", "Please input 0-100.");
                }
            } catch (NumberFormatException e) {
                errorMessages.put("saleAmount", "Must be an integer.");
            }
        }

        int minPrice = 0;
        if (minPriceStr == null || minPriceStr.trim().isEmpty()) {
            errorMessages.put("minPrice", "Minimum price cannot be empty.");
        } else {
            try {
                minPrice = Integer.parseInt(minPriceStr.trim());
                if (minPrice < 0) {
                    errorMessages.put("minPrice", "Minimum price must be non-negative.");
                }
            } catch (NumberFormatException e) {
                errorMessages.put("minPrice", "Invalid minimum price (must be an integer).");
            }
        }

        int courseID = 0;
        if (courseIDStr == null || courseIDStr.trim().isEmpty()) {
            errorMessages.put("courseID", "Course ID cannot be empty.");
        } else {
            try {
                courseID = Integer.parseInt(courseIDStr.trim());
                if (courseID < 0) {
                    errorMessages.put("courseID", "Course ID must be non-negative.");
                }
            } catch (NumberFormatException e) {
                errorMessages.put("courseID", "Invalid Course ID (must be an integer).");
            }
        }

        int amount = 0;
        if (amountStr == null || amountStr.trim().isEmpty()) {
            errorMessages.put("amount", "Amount cannot be empty.");
        } else {
            try {
                amount = Integer.parseInt(amountStr.trim());
                if (amount <= 0) {
                    errorMessages.put("amount", "Amount must be greater than 0.");
                }
            } catch (NumberFormatException e) {
                errorMessages.put("amount", "Invalid amount (must be an integer).");
            }
        }

        if (!errorMessages.isEmpty()) {
            globalMessage = "Voucher update failed. Please check for errors.";
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorMessages", errorMessages);
            request.setAttribute("param", request.getParameterMap());

            VoucherDAO voucherDAO = new VoucherDAO();
            try {
                request.setAttribute("voucher", voucherDAO.getVoucherByID(voucherID));
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Database error retrieving voucher for error display", ex);
                errorMessages.put("global", "Database error reloading voucher information.");
            }
            request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
            return;
        }

        Voucher updatedVoucher = new Voucher();
        updatedVoucher.setVoucherID(voucherID);
        updatedVoucher.setExpiredDate(expiredDate);
        updatedVoucher.setSaleType(saleType.trim());
        updatedVoucher.setSaleAmount(saleAmount);
        updatedVoucher.setMinPrice(minPrice);
        updatedVoucher.setCourseID(courseID);
        updatedVoucher.setAmount(amount);

        VoucherDAO voucherDAO = new VoucherDAO();
        try {
            boolean success = voucherDAO.updateVoucher(updatedVoucher);
            if (success) {
                request.setAttribute("globalMessage", "Voucher updated successfully!");
                response.sendRedirect(request.getContextPath() + "/voucherList");
            } else {
                globalMessage = "Voucher update failed. Voucher not found or no changes made.";
                request.setAttribute("globalMessage", globalMessage);
                request.setAttribute("errorMessages", errorMessages);
                request.setAttribute("param", request.getParameterMap());
                request.setAttribute("voucher", voucherDAO.getVoucherByID(voucherID));
                request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error updating voucher", ex);
            globalMessage = "Database error: " + ex.getMessage();
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorMessages", errorMessages);
            request.setAttribute("param", request.getParameterMap());
            try {
                request.setAttribute("voucher", voucherDAO.getVoucherByID(voucherID));
            } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error re-fetching voucher", e); }
            request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
        }
    }
}