/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ReceiptDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Receipt;
import model.User;
import java.io.IOException;
import java.util.ArrayList;

/**
 * @author CE191059 Phuong Gia Lac
 */
@WebServlet(name = "BillListServlet", urlPatterns = {"/bills"})
public class BillListServlet extends HttpServlet {

    private ReceiptDAO receiptDAO;

    @Override
    public void init() throws ServletException {
        receiptDAO = new ReceiptDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        Boolean isAdmin = false;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        //set Attribute for Learner 
        if ("LEARNER".equals(role)) {
            try {
                ArrayList<Receipt> receipts = receiptDAO.getLearnerReceipt(user.getUserId());
                isAdmin = false;
                request.setAttribute("receipts", receipts);
                request.setAttribute("isAdmin", isAdmin);
            } catch (Exception e) {
                System.err.println("Error fetching receipts for userID: " + user.getUserId() + ", error: " + e.getMessage());
                request.setAttribute("errorMessage", "Failed to load bill list. Please try again or contact support.");
            }
        } else if("ADMIN".equals(role)){
            try {
                ArrayList<Receipt> receipts = receiptDAO.getReceipt();
                request.setAttribute("receipts", receipts);
                isAdmin = true;
                request.setAttribute("isAdmin", isAdmin);
            } catch (Exception e) {
                System.err.println("Error fetching receipts for userID: " + user.getUserId() + ", error: " + e.getMessage());
                request.setAttribute("errorMessage", "Failed to load bill list. Please try again or contact support.");
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/billList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Displays a list of user bills (receipts)";
    }
}
