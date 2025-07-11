<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Cart</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" integrity="sha384-XGjxtQfXaH2tnPFa9x+ruJTuLE3Aa6LhHSWRr1XeTyhezb4abCG4ccI5AkVDxqC+" crossorigin="anonymous">
        <link rel="icon" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <style>
            :root {
                --primary-color: #2c3e50;
                --secondary-color: #3498db;
                --success-color: #2ecc71;
                --danger-color: #e74c3c;
                --background-color: #f8f9fa;
                --card-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                --border-radius: 8px;
                --transition: all 0.3s ease;
            }

            #main-body {
                min-height: 100vh;
                padding: 2rem 3vw;
                background-color: var(--background-color) !important;
            }

            #title {
                font-size: 2.5rem;
                font-weight: 700;
                color: var(--primary-color);
                margin: 2rem 0 1.5rem 200px;
                text-align: left;
            }

            #content {
                max-width: 1200px;
                margin: 0 auto;
            }

            .table-container {
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--card-shadow);
                overflow: hidden;
                margin-bottom: 2rem;
            }

            .table {
                margin-bottom: 0;
                width: 100%;
            }

            .table th {
                background: var(--primary-color);
                color: white;
                font-weight: 600;
                padding: 1rem;
                text-align: center;
                vertical-align: middle;
            }

            .table td {
                vertical-align: middle;
                padding: 1rem;
                color: var(--primary-color);
            }

            .table tbody tr {
                transition: var(--transition);
            }

            .table tbody tr:hover {
                background-color: #f5f5f5;
            }

            .courseImg {
                max-height: 150px;
                max-width: 150px;
                object-fit: cover;
                border-radius: 4px;
                display: block;
                margin: 0 auto;
            }

            .text {
                font-size: 1.1rem;
                font-weight: 600;
                color: var(--primary-color);
            }

            .form-check-input {
                cursor: pointer;
                width: 1.25rem;
                height: 1.25rem;
                transition: var(--transition);
            }

            .form-check-input:checked {
                background-color: var(--success-color);
                border-color: var(--success-color);
                transform: scale(1.1);
            }

            .btn-danger {
                background-color: var(--danger-color) !important;
                border-color: var(--danger-color) !important;
                transition: var(--transition);
            }

            .btn-danger:hover {
                background-color: #c0392b !important;
                transform: translateY(-2px);
            }

            .btn-primary {
                background-color: var(--secondary-color) !important;
                border-color: var(--secondary-color) !important;
                padding: 0.75rem 1.5rem;
                font-weight: 600;
                transition: var(--transition);
            }

            .btn-primary:hover {
                background-color: #2980b9 !important;
                transform: translateY(-2px);
            }

            .receipt-container {
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--card-shadow);
                width: 100%;
                max-width: 350px;
                margin-left: auto;
            }

            .receipt-container .table {
                margin: 0;
            }

            .receipt-container .table th {
                background: var(--secondary-color);
                color: white;
            }

            .receipt-container .table td {
                padding: 1.5rem;
            }

            .empty-cart {
                font-size: 1.5rem;
                font-weight: 600;
                color: #6c757d;
                text-align: center;
                margin-top: 3rem;
            }

            a[href] {
                color: var(--secondary-color);
                text-decoration: none;
                transition: var(--transition);
            }

            a[href]:hover {
                color: #2980b9;
                text-decoration: underline;
            }

            /* Override potential Tailwind conflicts */
            html body #main-body #content .table-container .table {
                display: table !important;
                visibility: visible !important;
                opacity: 1 !important;
                width: 100% !important;
                height: auto !important;
                max-height: none !important;
                transition: none !important;
            }

            html body #main-body #content .receipt-container .table {
                display: table !important;
                visibility: visible !important;
                opacity: 1 !important;
                width: 100% !important;
                height: auto !important;
                max-height: none !important;
                transition: none !important;
            }

            @media (max-width: 992px) {
                #title {
                    margin-left: 0;
                    text-align: center;
                }

                .table-container {
                    overflow-x: auto;
                }

                .receipt-container {
                    max-width: 100%;
                    margin: 2rem auto;
                }

                .courseImg {
                    max-height: 100px;
                    max-width: 100px;
                }
            }

            @media (max-width: 576px) {
                .table th, .table td {
                    font-size: 0.9rem;
                    padding: 0.5rem;
                }

                .btn-primary, .btn-danger {
                    padding: 0.5rem 1rem;
                    font-size: 0.9rem;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="../../layout/header_user.jsp" %>
        <%@include file="../../layout/sidebar_user.jsp" %>

        <main id="main-body" class="main">
            <p id="title" class="h1">Cart</p>

            <c:choose>
                <c:when test="${empty list}">
                    <p class="empty-cart">There's nothing in your cart</p>
                </c:when>
                <c:otherwise>
                    <form method="POST" action="${pageContext.request.contextPath}/cart">
                        <div id="content" class="mx-auto">
                            <div class="table-container">
                                <table class="table table-bordered table-hover">
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
                                                        <img class="courseImg" src="${course.imageDataURI}" alt="Course image"/>
                                                    </c:if>
                                                </td>
                                                <td class="align-middle">
                                                    <a href="${pageContext.request.contextPath}/courseDetail?id=${course.courseID}">${course.courseName}</a>
                                                </td>
                                                <td class="align-middle">${course.user.displayName}</td>
                                                <td class="align-middle">
                                                    <fmt:formatNumber value="${price}" type="number" groupingUsed="true"/> VND
                                                </td>
                                                <td class="align-middle">
                                                    <button type="submit" name="remove-from-cart" value="${cart.cartID}" class="btn btn-sm btn-danger">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="receipt-container">
                                <table class="table">
                                    <thead>
                                        <tr><th>Receipt</th></tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div class="d-flex justify-content-between ps-3 pe-3">
                                                    <span class="text">Total:</span>
                                                    <span><span id="total">0</span> VND</span>
                                                </div>
                                                <div>
                                                    <button type="submit" class="btn btn-primary text mt-3">To Checkout</button>
                                                </div>
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
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    </body>
</html>