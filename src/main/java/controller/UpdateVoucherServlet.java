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

        // Lấy tất cả các tham số từ request
        String voucherIDStr = request.getParameter("voucherID");
        String expiredDateStr = request.getParameter("expiredDate");
        String saleType = request.getParameter("saleType");
        String saleAmountStr = request.getParameter("saleAmount");
        String minPriceStr = request.getParameter("minPrice");
        String courseIDStr = request.getParameter("courseID");
        String amountStr = request.getParameter("amount");

        // Khởi tạo các biến để lưu giá trị đã parse/chuyển đổi
        int voucherID = 0;
        Date expiredDate = null;
        int saleAmount = 0;
        int minPrice = 0;
        int courseID = 0;
        int amount = 0;

        // Bắt đầu quá trình validation và parse dữ liệu
        // Voucher ID (chỉ đọc, nên giá trị từ request.getParameter là đủ, không cần truy vấn lại nếu chỉ để hiển thị)
        if (voucherIDStr == null || voucherIDStr.trim().isEmpty()) {
            errorMessages.put("voucherID", "Voucher ID can not be null.");
        } else {
            try {
                voucherID = Integer.parseInt(voucherIDStr.trim());
            } catch (NumberFormatException e) {
                errorMessages.put("voucherID", "Voucher ID must be an integer.");
            }
        }

        // Expired Date
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

        // Sale Type
        if (saleType == null || saleType.trim().isEmpty()) {
            errorMessages.put("saleType", "Please enter for this value.");
        } else if (!saleType.equals("PERCENT") && !saleType.equals("FIXED")) {
            errorMessages.put("saleType", "Not valid sale.");
        }

        // Sale Amount
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

        // Min Price
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

        // Course ID
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

        // Amount
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

        // --- ĐÂY LÀ PHẦN THAY ĐỔI QUAN TRỌNG NHẤT ---
        // Nếu có lỗi, truyền lại các giá trị mà người dùng đã nhập
        if (!errorMessages.isEmpty()) {
            globalMessage = "Voucher update failed. Please check for errors.";
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorMessages", errorMessages);

            // Tạo một đối tượng Voucher tạm thời từ các giá trị đã nhập
            Voucher voucherForDisplay = new Voucher();
            voucherForDisplay.setVoucherID(voucherID); // Dù lỗi, giữ lại ID để form vẫn là "Edit"
            voucherForDisplay.setExpiredDate(expiredDate);
            voucherForDisplay.setSaleType(saleType); // SỬ DỤNG saleType TỪ request.getParameter()
            voucherForDisplay.setSaleAmount(saleAmount);
            voucherForDisplay.setMinPrice(minPrice);
            voucherForDisplay.setCourseID(courseID);
            voucherForDisplay.setAmount(amount);

            request.setAttribute("voucher", voucherForDisplay); // Đặt đối tượng voucher này vào request

            // Không cần request.setAttribute("param", request.getParameterMap()); nữa
            // vì bạn đã chủ động tạo đối tượng voucherForDisplay từ các param.
            // Điều này làm cho EL `${voucher.saleType}` hoạt động chính xác hơn.
            
            request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
            return;
        }
        // --- KẾT THÚC PHẦN THAY ĐỔI QUAN TRỌNG NHẤT ---

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
                request.setAttribute("globalMessage", "Voucher updated successfully!"); // Thông báo thành công
                request.setAttribute("successMessage", true); // Thêm cờ này để JSP hiện màu xanh
                response.sendRedirect(request.getContextPath() + "/voucherList");
            } else {
                globalMessage = "Voucher update failed. Voucher not found or no changes made.";
                request.setAttribute("globalMessage", globalMessage);
                request.setAttribute("errorGlobalMessage", true); // Thêm cờ này để JSP hiện màu đỏ
                // Khi không thành công, chúng ta cũng cần hiển thị lại dữ liệu đã nhập
                request.setAttribute("voucher", updatedVoucher); // Dùng chính đối tượng vừa cố gắng update
                request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error updating voucher", ex);
            globalMessage = "Database error: " + ex.getMessage();
            request.setAttribute("globalMessage", globalMessage);
            request.setAttribute("errorGlobalMessage", true); // Thêm cờ này để JSP hiện màu đỏ
            
            // Khi có lỗi DB, cũng hiển thị lại dữ liệu đã nhập
            request.setAttribute("voucher", updatedVoucher); // Dùng chính đối tượng vừa cố gắng update
            request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
        }
    }
}