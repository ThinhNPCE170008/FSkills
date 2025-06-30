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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Role;
import model.User;

@WebServlet(name = "EditVoucherServlet", urlPatterns = {"/editVoucher"})
public class EditVoucherServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(EditVoucherServlet.class.getName());

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

        String voucherIDStr = request.getParameter("voucherID");
        VoucherDAO voucherDAO = new VoucherDAO();
        Voucher voucher = null;
        String globalMessage = null;

        if (voucherIDStr != null && !voucherIDStr.trim().isEmpty()) {
            try {
                int voucherID = Integer.parseInt(voucherIDStr.trim()); 
                voucher = voucherDAO.getVoucherByID(voucherID); 
                if (voucher == null) {
                    globalMessage = "Not found the Voucher with ID: " + voucherIDStr;
                    request.setAttribute("errorMessage", true);
                }
            } catch (NumberFormatException e) {
                globalMessage = "ID Voucher must be an integer.";
                request.setAttribute("errorMessage", true);
            } catch (SQLException ex) {
                Logger.getLogger(EditVoucherServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            globalMessage = "Voucher ID has errors.";
            request.setAttribute("errorMessage", true);
        }

        request.setAttribute("voucher", voucher); 
        request.setAttribute("globalMessage", globalMessage);
        
        request.getRequestDispatcher("/WEB-INF/views/voucherDetails.jsp").forward(request, response);
    }
}