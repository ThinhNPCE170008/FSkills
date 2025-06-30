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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Role;
import model.User;

@WebServlet(name = "AddVoucherServlet", urlPatterns = {"/addVoucher"})
public class AddVoucherServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AddVoucherServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        Role role = user.getRole();
        if (role != Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setAttribute("voucher", new Voucher());
        request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        Role role = user.getRole();
        if (role != Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        List<String> errorMessages = new ArrayList();
        String globalMessage = "";
        String voucherName = request.getParameter("voucherName");
        String voucherCode = request.getParameter("voucherCode");
        String expiredDateStr = request.getParameter("expiredDate");
        String saleType = request.getParameter("saleType");
        String saleAmountStr = request.getParameter("saleAmount");
        String minPriceStr = request.getParameter("minPrice");
        String amountStr = request.getParameter("amount");

        Timestamp expiredDate = null;

        if (voucherName == null || voucherName.trim().isEmpty()) {
            errorMessages.add("Voucher name cannot be empty.");
        }

        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            errorMessages.add("Voucher code cannot be empty.");
        }

        if (expiredDateStr == null || expiredDateStr.trim().isEmpty()) {
            errorMessages.add("Expiration date cannot be empty.");
        } else {
            try {
                LocalDateTime inputDateTime = LocalDateTime.parse(expiredDateStr);
                expiredDate = Timestamp.valueOf(inputDateTime);
                if (inputDateTime.isBefore(LocalDateTime.now())) {
                    errorMessages.add("Expiration date must be in the future.");
                }
            } catch (DateTimeParseException e) {
                LOGGER.log(Level.WARNING, "Invalid Expiration Date format: " + expiredDateStr, e);
                errorMessages.add("Invalid format. Use `YYYY-MM-DDTHH:MM` (e.g., 2025-06-23T14:30).");
            }
        }

        if (saleType == null || saleType.trim().isEmpty()) {
            errorMessages.add("Sale type cannot be empty.");
        } else if (!saleType.equals("PERCENT") && !saleType.equals("FIXED")) {
            errorMessages.add("Invalid sale type.");
        }

        int saleAmount = 0;
        if (saleAmountStr == null || saleAmountStr.trim().isEmpty()) {
            errorMessages.add("Sale amount cannot be empty.");
        } else {
            try {
                saleAmount = Integer.parseInt(saleAmountStr.trim());
                if (saleAmount <= 0) {
                    errorMessages.add("Sale amount must be greater than 0.");
                }
                if (saleType != null && saleType.equals("PERCENT") && (saleAmount > 100 || saleAmount < 0)) {
                    errorMessages.add("Percentage sale amount must be between 0 and 100.");
                }
            } catch (NumberFormatException e) {
                errorMessages.add("Invalid sale amount (must be an integer).");
            }
        }

        int minPrice = 0;
        if (minPriceStr == null || minPriceStr.trim().isEmpty()) {
            errorMessages.add("Minimum price cannot be empty.");
        } else {
            try {
                minPrice = Integer.parseInt(minPriceStr.trim());
                if (minPrice < 0) {
                    errorMessages.add("Minimum price must be non-negative.");
                }
            } catch (NumberFormatException e) {
                errorMessages.add("Invalid minimum price (must be an integer).");
            }
        }

        int amount = 0;
        if (amountStr == null || amountStr.trim().isEmpty()) {
            errorMessages.add("Amount cannot be empty.");
        } else {
            try {
                amount = Integer.parseInt(amountStr.trim());
                if (amount <= 0) {
                    errorMessages.add("Amount must be greater than 0.");
                }
            } catch (NumberFormatException e) {
                errorMessages.add("Invalid amount (must be an integer).");
            }
        }

        if (!errorMessages.isEmpty()) {
            globalMessage = "Failed to add Voucher. Please check for errors.";
            request.setAttribute("err", globalMessage);
            request.setAttribute("err", errorMessages);

            // Giữ lại các giá trị đã nhập
            Voucher voucherForDisplay = new Voucher();
            voucherForDisplay.setVoucherName(voucherName);
            voucherForDisplay.setVoucherCode(voucherCode);
            voucherForDisplay.setExpiredDate(expiredDate);
            voucherForDisplay.setSaleType(saleType);
            voucherForDisplay.setSaleAmount(saleAmount);
            voucherForDisplay.setMinPrice(minPrice);
            voucherForDisplay.setAmount(amount);

            request.setAttribute("voucher", voucherForDisplay);

            request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
            return;
        }

        Voucher newVoucher = new Voucher();
        newVoucher.setVoucherName(voucherName.trim());
        newVoucher.setVoucherCode(voucherCode.trim());
        newVoucher.setExpiredDate(expiredDate);
        newVoucher.setSaleType(saleType.trim());
        newVoucher.setSaleAmount(saleAmount);
        newVoucher.setMinPrice(minPrice);
        newVoucher.setAmount(amount);

        VoucherDAO voucherDAO = new VoucherDAO();
        try {
            boolean success = voucherDAO.addVoucher(newVoucher);
            if (success) {
                request.setAttribute("success", "Voucher added successfully!");
                request.getRequestDispatcher("voucherList").forward(request, response);
            } else {
                globalMessage = "Failed to add Voucher. An error occurred, possibly due to duplicate data or database issue.";
                request.setAttribute("err", globalMessage);
                request.setAttribute("voucher", newVoucher);
                request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error adding voucher", ex);
            globalMessage = "Database error: " + ex.getMessage();
            request.setAttribute("err", globalMessage);
            request.setAttribute("voucher", newVoucher);
            request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
        }
    }
}
