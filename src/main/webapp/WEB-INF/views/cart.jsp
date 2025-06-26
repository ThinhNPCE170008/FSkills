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
            #main-body{
                min-height: 70vh;
                width: 90vw;
            }
            .courseImg{
                max-height: 250px;
                max-width: 250px;
            }
        </style>
    </head>
    <body>
        <%@include file="../../layout/sidebar_user.jsp" %>
        <div id="main-body" class="mx-auto">
            <%            CourseDAO courseDAO = new CourseDAO();
                UserDAO userDAO = new UserDAO();
                ArrayList<Cart> list = (ArrayList) request.getAttribute("list");
                Course tempCourse = new Course();
                Cart temp = new Cart();
                double price;
            %>
            <p id="title" class="h1 mt-5">Cart</p>
            <%
                if (list == null || list.isEmpty()) {
            %>
            <p id="title" class="h1 mt-5 text-center">There's nothing in your cart</p>
            <%
            } else {
                int i = 0;
            %>
            <form method="POST" action="<%= request.getContextPath()%>/Cart">
                <div class="w-75 mx-auto text-center">
                    <table class="table .table-bordered table-hover mt-5">
                        <thead>
                            <tr>
                                <th><input id="checkall" class="form-check-input"" type="checkbox"></th>
                                <th>Image</th>
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
                                    tempCourse = courseDAO.getCourseByCourseID(c.getCourseID());
                                    price = tempCourse.getIsSale() == 0 ? tempCourse.getOriginalPrice() : tempCourse.getSalePrice();
                            %>
                            <tr>
                                <td class="align-middle">
                                    <input type="checkbox" name="checkbox" class="checkone form-check-input"" id="cb<%=i%>" value="<%=c.getCartID()%>">
                                </td>
                                <td>
                                    <%
                                        if (tempCourse.getCourseImageLocation() != null) {
                                    %>
                                    <img class="courseImg mx-auto" src="<%=tempCourse.getCourseImageLocation()%>" alt="alt"/>
                                    <%
                                        }
                                    %>
                                </td>
                                <td class="align-middle"><%=tempCourse.getCourseName()%></td>
                                <td class="align-middle"><%=tempCourse.getUser().getDisplayName()%></td>
                                <td class="align-middle"><%=String.format("%,.0f", price)%>VND</td>
                                <td class="align-middle"><button type="submit" name="remove-from-cart" value="<%=c.getCartID()%>" class="btn btn-sm btn-danger"><i class="fas fa-trash-alt"></i></button></td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                    <div class="d-flex justify-content-end w-100">
                        <table class="table text-center w-25">
                            <thead class="table-dark">
                                <tr>
                                    <th>Receipt</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="d-flex justify-content-between ps-3 pe-3">
                                            <span class="text ">Total:</span>
                                            <span><span id="total">0</span>VND</span>
                                        </div>
                                        <div><button type="submit" class="btn btn-primary text mt-3">To Checkout</button></div>
                                    </td>

                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
            <%}%>
        </div>
        <script>
            const coursePrice = [
            <% for (Cart c : list) {
                    Course course = courseDAO.getCourseByCourseID(c.getCourseID());
            %>
                "<%= course.getIsSale() == 0 ? course.getOriginalPrice() : course.getSalePrice()%>",
            <% }%>
            ];
            document.addEventListener('DOMContentLoaded', function () {
                const checkAll = document.getElementById('checkall');
                const checkboxes = document.querySelectorAll('.checkone');
                const totalDisplay = document.getElementById('total');

                function updateTotal() {
                    let total = 0;
                    let j = 0;
                    checkboxes.forEach(cb => {
                        if (cb.checked) {
                            total += parseFloat(coursePrice[j]);
                        }
                        j++;
                    });
                    totalDisplay.textContent = new Intl.NumberFormat('de-DE', {minimumFractionDigits: 0, maximumFractionDigits: 0, }).format(total.toFixed(0), );
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

        <%@include file="../../layout/footer.jsp" %>
    </body>
</html>
