package controller;

import dao.CartDAO;
import dao.CourseDAO;
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
import java.util.List;
import model.User;

/**
 * @author CE191059 Phuong Gia Lac
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/Checkout"})
public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO;
    private CourseDAO courseDAO;
    private VoucherDAO voucherDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        courseDAO = new CourseDAO();
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CheckoutServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CheckoutServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        if ("voucher".equals(action)) {
            handleVoucherValidation(request, response);
            return;
        }
        handleCheckout(request, response);
    }

    private void handleCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        // Get selected cart IDs from the form
        String[] selectedCartIDs = request.getParameterValues("checkbox");
        List<Course> selectedCourses = new ArrayList<>();
        List<Integer> courseIDs = new ArrayList<>();
        double totalPrice = 0.0;

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
        double totalPrice = Double.parseDouble(request.getParameter("totalPrice"));

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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
