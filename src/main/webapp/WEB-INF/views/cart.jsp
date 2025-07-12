<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Cart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="icon" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico" type="image/x-icon">
        <style>
            #title {
                margin-left: 200px;
                font-weight: bold;
            }
            .text {
                font-size: 18px;
                font-weight: 700;
            }
            #main-body {
                min-height: 100vh;
                padding: 0 3vw;
            }
            .courseImg {
                max-height: 250px;
                max-width: 250px;
            }
            #content {
                width: 90%;
            }
        </style>
    </head>
    <body>
        <%@include file="../../layout/header_user.jsp" %>
        <%@include file="../../layout/sidebar_user.jsp" %>

        <main id="main-body" class="main">
            <p id="title" class="h1 mt-5">Cart</p>

            <c:choose>
                <c:when test="${empty list}">
                    <p id="title" class="h2 mt-5 text-center">There's nothing in your cart</p>
                </c:when>
                <c:otherwise>
                    <form method="POST" action="${pageContext.request.contextPath}/Cart">
                        <div id="content" class="mx-auto text-center">
                            <table class="table table-bordered table-hover mt-5">
                                <thead>
                                    <tr>
                                        <th><input id="checkall" class="form-check-input" type="checkbox"/></th>
                                        <th>Image</th>
                                        <th>Course Name</th>
                                        <th>Instructor</th>
                                        <th>Price</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cart" items="${list}" varStatus="loop">
                                        <c:set var="course" value="${courseMap[cart.cartID]}" />
                                        <c:set var="price" value="${course.isSale == 0 ? course.originalPrice : course.salePrice}" />
                                        <tr>
                                            <td class="align-middle">
                                                <input type="checkbox" name="checkbox" class="checkone form-check-input"
                                                       id="cb${loop.index}" value="${cart.cartID}" data-price="${price}"/>
                                            </td>
                                            <td>
                                                <c:if test="${not empty course.imageDataURI}">
                                                    <img class="courseImg mx-auto" src="${course.imageDataURI}" alt="Course image"/>
                                                </c:if>
                                            </td>
                                            <td class="align-middle"><a href="${pageContext.request.contextPath}/courseDetail?id=${course.courseID}">${course.courseName}</a></td>
                                            <td class="align-middle">${course.user.displayName}</td>
                                            <td class="align-middle"><fmt:formatNumber value="${price}" type="number" groupingUsed="true"/> VND</td>
                                            <td class="align-middle">
                                                <button type="submit" name="remove-from-cart" value="${cart.cartID}" class="btn btn-sm btn-danger">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-end w-100">
                                <table class="table text-center w-25">
                                    <thead class="table-dark">
                                        <tr><th>Receipt</th></tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div class="d-flex justify-content-between ps-3 pe-3">
                                                    <span class="text">Total:</span>
                                                    <span><span id="total">0</span> VND</span>
                                                </div>
                                                <div><button type="submit" class="btn btn-primary text mt-3">To Checkout</button></div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </main>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const checkAll = document.getElementById('checkall');
                const checkboxes = document.querySelectorAll('.checkone');
                const totalDisplay = document.getElementById('total');

                function updateTotal() {
                    let total = 0;
                    checkboxes.forEach(cb => {
                        if (cb.checked) {
                            total += parseFloat(cb.dataset.price);
                        }
                    });
                    totalDisplay.textContent = new Intl.NumberFormat('de-DE').format(total);
                }

                checkAll.addEventListener('change', function () {
                    checkboxes.forEach(cb => cb.checked = this.checked);
                    updateTotal();
                });

                checkboxes.forEach(cb => {
                    cb.addEventListener('change', () => {
                        checkAll.checked = [...checkboxes].every(cb => cb.checked);
                        updateTotal();
                    });
                });

                updateTotal();
            });
        </script>

        <%@include file="../../layout/footer.jsp" %>
    </body>
</html>
