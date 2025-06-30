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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Role;
import model.User;

@WebServlet(name = "VoucherServlet", urlPatterns = {"/voucherList"})
public class VoucherServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(VoucherServlet.class.getName());

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

        VoucherDAO voucherDAO = new VoucherDAO();
        List<Voucher> voucherList = null;
        String searchTerm = request.getParameter("searchTerm");

        Object globalMsgObj = request.getAttribute("globalMessage");
        String globalMessage = (globalMsgObj instanceof String) ? (String) globalMsgObj : null;

        try {
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                voucherList = voucherDAO.searchVouchers(searchTerm);

                if (voucherList.isEmpty()) {
                    globalMessage = "Cannot find any vouchers with name: '" + searchTerm + "'.";
                }
            } else {
                voucherList = voucherDAO.getAllVouchers();
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error.", ex);
            globalMessage = "Error.";
            voucherList = new java.util.ArrayList<>();
        }

        request.setAttribute("voucherList", voucherList);
        request.setAttribute("globalMessage", globalMessage);

        request.getRequestDispatcher("/WEB-INF/views/voucherList.jsp").forward(request, response);
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
        doGet(request, response);
    }
}
