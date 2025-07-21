package controller;

import dao.CartDAO;
import dao.CourseDAO;
import dao.EnrollDAO;
import dao.ReceiptDAO;
import dao.UserDAO;
import dao.VoucherDAO;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.Course;
import model.Voucher;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import model.Receipt;

/**
 * @author CE191059 Phuong Gia Lac
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO;
    private CourseDAO courseDAO;
    private VoucherDAO voucherDAO;
    private ReceiptDAO receiptDAO;
    private EnrollDAO enrollDAO;
    private String payCon;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        courseDAO = new CourseDAO();
        voucherDAO = new VoucherDAO();
        receiptDAO = new ReceiptDAO();
        enrollDAO = new EnrollDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (null == role) {
            response.sendRedirect(request.getContextPath() + "/homePage_Guest.jsp");
        } else {
            switch (role) {
                case "INSTRUCTOR":
                    response.sendRedirect(request.getContextPath() + "/instructor");
                    break;
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/homePage_Guest.jsp");
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (null == role) {
            response.sendRedirect(request.getContextPath() + "/homePage_Guest.jsp");
        } else {
            switch (role) {
                case "LEARNER":
                    String action = request.getParameter("action");
                    if ("voucher".equals(action)) {
                        handleVoucherValidation(request, response);
                        return;
                    } else if ("submit-payment".equals(action)) {
                        try {
                            handlePayment(request, response);
                            return;
                        } catch (SQLException ex) {
                            Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    handleCheckout(request, response);
                    break;
                case "INSTRUCTOR":
                    response.sendRedirect(request.getContextPath() + "/instructor");
                    break;
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/homePage_Guest.jsp");
                    break;
            }
        }
    }

    private void handleCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        // Get selected cart IDs from the form
        String[] selectedCartIDs = request.getParameterValues("checkbox");
        if ((selectedCartIDs == null || selectedCartIDs.length == 0)) {
            selectedCartIDs = new String[1];
            selectedCartIDs[0] = (String) request.getParameter("buynowid");
            if (selectedCartIDs[0] != null) {
                if (!cartDAO.isInCart(user.getUserId(), Integer.parseInt(selectedCartIDs[0]))) {
                    cartDAO.addToCart(user.getUserId(), Integer.parseInt(selectedCartIDs[0]));
                    selectedCartIDs[0] = String.valueOf(cartDAO.getRecentCart(user.getUserId()).getCartID());
                } else {
                    selectedCartIDs[0] = String.valueOf(cartDAO.getCartByCourseID(user.getUserId(), Integer.parseInt(selectedCartIDs[0])).getCartID());
                }
            }
        }
        List<Course> selectedCourses = new ArrayList<>();
        List<Integer> courseIDs = new ArrayList<>();
        HashMap<Integer, User> courseUser = new HashMap<>();
        int totalPrice = 0;

        if (selectedCartIDs == null || selectedCartIDs.length == 0) {
            request.setAttribute("errorMessage", "Please select at least one course to checkout.");
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
            return;
        }

        try {
            for (String cartID : selectedCartIDs) {
                Cart cart = cartDAO.getCartByID(Integer.parseInt(cartID));
                if (cart != null) {
                    Course course = courseDAO.getCourseByCourseID(cart.getCourseID());
                    if (course != null) {
                        selectedCourses.add(course);
                        courseIDs.add(course.getCourseID());
                        courseUser.put(course.getCourseID() ,course.getUser());
                        System.out.println(course.getUser());
                        totalPrice += (course.getIsSale() == 1) ? course.getSalePrice() : course.getOriginalPrice();
                    }
                }
            }
        } catch (Exception e) {
            throw new ServletException("Error fetching course details", e);
        }

        // Store data in request attributes
        request.setAttribute("user", user);
        request.setAttribute("selectedCourses", selectedCourses);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("selectedCourseIDs", String.join("-", courseIDs.stream().map(String::valueOf).toArray(String[]::new)));
        request.setAttribute("courseUser", courseUser);
        payCon = user.getUserId() + " " + String.join("-", courseIDs.stream().map(String::valueOf).toArray(String[]::new)) + " " + totalPrice + " 0";
        request.setAttribute("paymentContent", payCon);

        // Forward to checkout JSP
        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    private void handleVoucherValidation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JsonObjectBuilder jsonBuilder = Json.createObjectBuilder();

        String voucherCode = request.getParameter("voucherCode");
        int userID = Integer.parseInt(request.getParameter("userID"));
        String courseIDs = request.getParameter("courseIDs");
        int totalPrice = Integer.parseInt(request.getParameter("totalPrice"));

        try {
            // Search for voucher by code
            Voucher voucher = voucherDAO.getVoucherByCode(voucherCode);

            if (voucher == null) {
                jsonBuilder.add("valid", false)
                        .add("message", "Invalid voucher code");
            } else {
                // Validate voucher conditions
                if (voucher.getAmount() <= 0) {
                    jsonBuilder.add("valid", false)
                            .add("message", "Voucher is out of stock");
                } else if (voucher.getExpiredDate().before(new Timestamp(System.currentTimeMillis()))) {
                    jsonBuilder.add("valid", false)
                            .add("message", "Voucher has expired");
                } else if (totalPrice < voucher.getMinPrice()) {
                    jsonBuilder.add("valid", false)
                            .add("message", "Total price must be at least " + voucher.getMinPrice() + " VND to use this voucher");
                } else {
                    // Calculate new price based on saleType
                    double newPrice = totalPrice;
                    String saleType = voucher.getSaleType().toLowerCase();
                    double discount = voucher.getSaleAmount();

                    if ("percent".equals(saleType)) {
                        newPrice = totalPrice * (1 - discount / 100.0);
                    } else if ("fixed".equals(saleType)) {
                        newPrice = totalPrice - discount;
                    }

                    payCon = userID + " " + courseIDs + " " + (int) newPrice + " " + voucherCode;
                    // Ensure price doesn't go below 0
                    newPrice = Math.max(0, newPrice);

                    jsonBuilder.add("valid", true)
                            .add("discount", discount + ("percent".equals(saleType) ? "%" : " VND"))
                            .add("newPrice", newPrice);
                }
            }
        } catch (SQLException e) {
            jsonBuilder.add("valid", false)
                    .add("message", "Database error: " + e.getMessage());
        } catch (Exception e) {
            jsonBuilder.add("valid", false)
                    .add("message", "Error validating voucher: " + e.getMessage());
        }

        JsonObject json = jsonBuilder.build();
        out.print(json.toString());
        out.flush();
    }

    private void handlePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String paymentInfo = (String) request.getParameter("submitData");
        if (payCon.equals(paymentInfo)) {
            Receipt receipt = new Receipt(user.getUserId(), paymentInfo, 1, new Timestamp(System.currentTimeMillis()));
            System.out.println(receipt);
            if (receiptDAO.saveReceipt(receipt)) {
                for (Course c : receipt.getCourse()) {
                    cartDAO.setCartBuyDate(cartDAO.getCartByCourseID(user.getUserId(), c.getCourseID()).getCartID());
                    enrollDAO.addLearnerEnrollment(user.getUserId(), c.getCourseID());

                }
                voucherDAO.useVoucher(receipt.getVoucherCode());
                request.setAttribute("user", user);
                request.setAttribute("selectedCourses", receipt.getCourse());
                request.setAttribute("finalPrice", receipt.getPrice());
                request.setAttribute("voucherCode", receipt.getVoucherCode());
                request.setAttribute("paymentDate", receipt.getPaymentDate());
                request.getRequestDispatcher("/WEB-INF/views/paymentSuccess.jsp").forward(request, response);
            } else {
                System.err.println("Failed to save receipt for userID: " + user.getUserId() + ", paymentDetail: " + receipt.getPaymentDetail());

            }
        } else {
                System.err.println("Pay Content error for userID: " + user.getUserId() + ", paymentDetail: " + paymentInfo + ", ExpectedDetail: " + payCon);

        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
