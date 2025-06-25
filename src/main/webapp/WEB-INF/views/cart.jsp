<%@page import="dao.UserDAO"%>
<%@page import="model.Course"%>
<%@page import="model.Cart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.CourseDAO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <style>
            #title{
                margin-left: 200px;
                font-weight: bold;
            }
            .text{
                font-size: 18px;
                font-weight: 700;
            }
        </style>
    </head>
    <body>
        <%@include file="../../layout/sidebar_user.jsp" %>
        <%
            CourseDAO courseDAO = new CourseDAO();
            UserDAO userDAO = new UserDAO();
            ArrayList<Cart> list = (ArrayList) request.getAttribute("list");
            Course tempCourse = new Course();
            Cart temp = new Cart();
        %>
        <p id="title" class="h1 mt-5">Cart</p>
        <%
            if (list == null || list.isEmpty()) {
        %>
        <p id="title" class="h1 mt-5">There's no course in cart</p>
        <%
        } else {
            int i = 0;
        %>
        <form method="POST" action="<%= request.getContextPath()%>/Cart">
            <div class="w-75 mx-auto text-center">
                <table class="table .table-bordered">
                    <thead>
                        <tr>
                            <th><input id="checkall" class="form-check-input"" type="checkbox"></th>
                            <th>Course Name</th>
                            <th>Instructor</th>
                            <th>Price</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Cart c : list) {
                                i++;
                                System.out.println(c.getCourseID());
                                tempCourse = courseDAO.getCourseByCourseID(c.getCourseID());
                                System.out.println(tempCourse);
                        %>
                        <tr>
                            <td>
                                <input type="checkbox" name="checkbox" class="checkone form-check-input"" id="cb<%=i%>" value="<%=c.getCartID()%>">
                            </td>
                            <td><%=tempCourse.getCourseName()%></td>
                            <td><%=tempCourse.getUser().getDisplayName()%></td>
                            <td><%=tempCourse.getIsSale() == 0 ? tempCourse.getOriginalPrice() : tempCourse.getSalePrice()%></td>
                            <td><button type="submit" name="remove-from-cart" value="<%=c.getCartID()%>" class="btn btn-sm btn-danger"><i class="fas fa-trash-alt"></i></button></td>
                        </tr>
                        <%}%>
                    </tbody>
                </table>
                <div class="d-flex justify-content-end w-100">
                    <div class="text-center w-25">
                        <h3 class="text mt-3">Total: $<span id="total">0</span></h3>
                        <button type="submit" class="btn btn-primary text mt-3">To Checkout</button>
                    </div>
                </div>
            </div>
        </form>
        <%}%>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const checkAll = document.getElementById('checkall');
                const checkboxes = document.querySelectorAll('.checkone');
                const totalDisplay = document.getElementById('total');

                function updateTotal() {
                    let total = 0;
                    <%
                        int j = 0;
                    %>
                    checkboxes.forEach(cb => {
                        <%
                            temp = list.get(j);
                            tempCourse = courseDAO.getCourseByCourseID(temp.getCourseID());
                        %>
                        if (cb.checked) {
                            total += parseFloat('<%=tempCourse.getIsSale() == 0 ? tempCourse.getOriginalPrice() : tempCourse.getSalePrice()%>');
                        }
                        <%
                            j++;
                        %>
                    });
                    totalDisplay.textContent = total.toFixed(0);
                }

                checkAll.addEventListener('change', function () {
                    checkboxes.forEach(cb => cb.checked = this.checked);
                    updateTotal();
                });

                checkboxes.forEach(cb => {
                    cb.addEventListener('change', function () {
                        if (!this.checked)
                            checkAll.checked = false;
                        updateTotal();
                    });
                });

                updateTotal();
            });
        </script>
    </body>
</html>
