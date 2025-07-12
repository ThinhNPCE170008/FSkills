/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.CourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import model.Cart;
import model.Course;
import model.User;

/**
 *
 * @author CE191059 Phuong Gia Lac
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        CourseDAO courseDAO = new CourseDAO();
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            CartDAO cDAO = new CartDAO();
            ArrayList<Cart> cartList = cDAO.getLearnerCart(user.getUserId());
            HashMap<Integer, Course> courseMap = new HashMap<>();
            for (Cart c : cartList) {
                Course course = courseDAO.getCourseByCourseID(c.getCourseID());
                courseMap.put(c.getCartID(), course);
            }
            request.setAttribute("list", cartList);
            request.setAttribute("courseMap", courseMap);
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("CartAction");
        String remove = request.getParameter("remove-from-cart");
        CartDAO cDAO = new CartDAO();
        int courseID;
        if (action != null) {
            switch (action) {
                case "Add":
                    courseID = Integer.parseInt(request.getParameter("CourseID"));
                    if (cDAO.addToCart(user.getUserId(), courseID) != 0) {
                        response.sendRedirect(request.getContextPath() + "/courseDetail?id=" + courseID);
                    }
                    break;
            }
        }
        if (remove != null) {
            if (cDAO.removeFromCart(Integer.parseInt(remove)) != 0) {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
