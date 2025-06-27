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

@WebServlet(name = "AddVoucherServlet", urlPatterns = {"/addVoucher"})
public class AddVoucherServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AddVoucherServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setAttribute("voucher", new Voucher());
        request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, String> errorMessages = new HashMap<>();
        String globalMessage = "";

        String expiredDateStr = request.getParameter("expiredDate");
        String saleType = request.getParameter("saleType");
        String saleAmountStr = request.getParameter("saleAmount");
        String minPriceStr = request.getParameter("minPrice");
        String courseIDStr = request.getParameter("courseID");
        String amountStr = request.getParameter("amount");

        Timestamp expiredDate = null;

        if (expiredDateStr == null || expiredDateStr.trim().isEmpty()) {
            errorMessages.put("expiredDate", "Expiration date cannot be empty.");
        } else {
            try {
                LocalDateTime inputDateTime = LocalDateTime.parse(expiredDateStr);
                expiredDate = Timestamp.valueOf(inputDateTime);
                if (inputDateTime.isBefore(LocalDateTime.now())) {
                    errorMessages.put("expiredDate", "Expiration date must be in the future.");
                }
            } catch (DateTimeParseException e) {
                LOGGER.log(Level.WARNING, "Invalid Expiration Date format: " + expiredDateStr, e);
                errorMessages.put("expiredDate", "Invalid format. Use `YYYY-MM-DDTHH:MM` (e.g., 2025-06-23T14:30).");
            }
        }

        if (saleType == null || saleType.trim().isEmpty()) {
            errorMessages.put("saleType", "Sale type cannot be empty.");
        } else if (!saleType.equals("PERCENT") && !saleType.equals("FIXED")) {
            errorMessages.put("saleType", "Invalid sale type.");
        }

        int saleAmount = 0;
        if (saleAmountStr == null || saleAmountStr.trim().isEmpty()) {
            errorMessages.put("saleAmount", "Sale amount cannot be empty.");
        } else {
            try {
                saleAmount = Integer.parseInt(saleAmountStr.trim());
                if (saleAmount <= 0) {
                    errorMessages.put("saleAmount", "Sale amount must be greater than 0.");
                }
                if (saleType != null && saleType.equals("PERCENT") && (saleAmount > 100 || saleAmount < 0)) {
                    errorMessages.put("saleAmount", "Percentage sale amount must be between 0 and 100.");
                }
            } catch (NumberFormatException e) {
                errorMessages.put("saleAmount", "Invalid sale amount (must be an integer).");
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
            globalMessage = "Failed to add Voucher. Please check for errors.";
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorMessages", errorMessages);
            
            // Giữ lại các giá trị đã nhập
            Voucher voucherForDisplay = new Voucher();
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

        Voucher newVoucher = new Voucher();
        newVoucher.setExpiredDate(expiredDate);
        newVoucher.setSaleType(saleType.trim());
        newVoucher.setSaleAmount(saleAmount);
        newVoucher.setMinPrice(minPrice);
        newVoucher.setCourseID(courseID);
        newVoucher.setAmount(amount);

        VoucherDAO voucherDAO = new VoucherDAO();
        try {
            boolean success = voucherDAO.addVoucher(newVoucher);
            if (success) {
                request.setAttribute("globalMessage", "Voucher added successfully!");
                response.sendRedirect(request.getContextPath() + "/voucherList?message=" + java.net.URLEncoder.encode("Voucher added successfully!", "UTF-8"));
            } else {
                globalMessage = "Failed to add Voucher. An error occurred, possibly due to duplicate data or database issue.";
                request.setAttribute("globalMessage", globalMessage);
                request.setAttribute("voucher", newVoucher); 
                request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error adding voucher", ex);
            globalMessage = "Database error: " + ex.getMessage();
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("voucher", newVoucher); 
            request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
        }
    }
}