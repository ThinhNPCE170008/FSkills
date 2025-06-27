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
import java.sql.Timestamp;
import java.time.LocalDateTime;
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
        Timestamp expiredDate = null;
        int saleAmount = 0;
        int minPrice = 0;
        int courseID = 0;
        int amount = 0;

        if (voucherIDStr == null || voucherIDStr.trim().isEmpty()) {
            errorMessages.put("voucherID", "Voucher ID can not be null.");
        } else {
            try {
                voucherID = Integer.parseInt(voucherIDStr.trim());
            } catch (NumberFormatException e) {
                errorMessages.put("voucherID", "Voucher ID must be an integer.");
            }
        }

        if (expiredDateStr == null || expiredDateStr.trim().isEmpty()) {
            errorMessages.put("expiredDate", "Please enter this value.");
        } else {
            try {
                LocalDateTime inputDateTime = LocalDateTime.parse(expiredDateStr);
                expiredDate = Timestamp.valueOf(inputDateTime); 
                if (inputDateTime.isBefore(LocalDateTime.now())) {
                    errorMessages.put("expiredDate", "The expired day must be in the future.");
                }
            } catch (DateTimeParseException e) {
                LOGGER.log(Level.WARNING, "Invalid Expiration Date format: " + expiredDateStr, e);
                errorMessages.put("expiredDate", "Invalid format. Use YYYY-MM-DDTHH:MM (e.g., 2025-06-23T14:30).");
            }
        }

        if (saleType == null || saleType.trim().isEmpty()) {
            errorMessages.put("saleType", "Please enter for this value.");
        } else if (!saleType.equals("PERCENT") && !saleType.equals("FIXED")) {
            errorMessages.put("saleType", "Not valid sale.");
        }

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

        // truyền lại các giá trị đã nhập
        if (!errorMessages.isEmpty()) {
            globalMessage = "Voucher update failed. Please check for errors.";
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorMessages", errorMessages);

            Voucher voucherForDisplay = new Voucher();
            voucherForDisplay.setVoucherID(voucherID);
            voucherForDisplay.setExpiredDate(expiredDate);
            voucherForDisplay.setSaleType(saleType);
            voucherForDisplay.setSaleAmount(saleAmount);
            voucherForDisplay.setMinPrice(minPrice);
            voucherForDisplay.setCourseID(courseID);
            voucherForDisplay.setAmount(amount);

            request.setAttribute("voucher", voucherForDisplay);

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
                request.setAttribute("successMessage", true);
                response.sendRedirect(request.getContextPath() + "/voucherList");
            } else {
                globalMessage = "Voucher update failed. Voucher not found or no changes made.";
                request.setAttribute("globalMessage", globalMessage);
                request.setAttribute("errorGlobalMessage", true);
                request.setAttribute("voucher", updatedVoucher);
                request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error updating voucher", ex);
            globalMessage = "Database error: " + ex.getMessage();
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorGlobalMessage", true);

            request.setAttribute("voucher", updatedVoucher);
            request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String voucherIDParam = request.getParameter("voucherID");
        VoucherDAO voucherDAO = new VoucherDAO();
        Voucher voucher = null;
        String globalMessage = "";

        if (voucherIDParam != null && !voucherIDParam.isEmpty()) {
            try {
                int voucherID = Integer.parseInt(voucherIDParam);
                voucher = voucherDAO.getVoucherByID(voucherID);
                if (voucher == null) {
                    globalMessage = "Voucher with ID " + voucherID + " not found.";
                }
            } catch (NumberFormatException e) {
                globalMessage = "Invalid Voucher ID format.";
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Database error retrieving voucher.", ex);
                globalMessage = "Database error: " + ex.getMessage();
            }
        }

        request.setAttribute("voucher", voucher);
        request.setAttribute("globalMessage", globalMessage);
        request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
    }
}