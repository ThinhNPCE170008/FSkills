<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Checkout</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style>
            .course-img {
                width: 100px;
                height: auto;
            }
            .modal-img {
                width: 400px;
                height: 400px;
            }
            .table-container {
                max-width: 800px;
                margin: 20px auto;
            }
            .receipt-container {
                max-width: 400px;
                margin: 20px auto;
            }
            .main {
                padding: 20px;
            }
            .h1 {
                font-size: 2.5rem;
                font-weight: bold;
                text-align: center;
                margin-bottom: 20px;
            }
            #voucherMessage {
                color: red;
            }
        </style>
    </head>
    <body>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="/login"/>
        </c:if>
        <%@include file="../../layout/sidebar_user.jsp" %>
        <main class="main">
            <p class="h1">Checkout</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger text-center">${errorMessage}</div>
            </c:if>

            <c:choose>
                <c:when test="${empty selectedCourses}">
                    <p class="text-center">No courses selected for checkout.</p>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>Image</th>
                                    <th>Course Name</th>
                                    <th>Price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="course" items="${selectedCourses}">
                                    <tr>
                                        <td>
                                            <c:if test="${not empty course.imageDataURI}">
                                                <img class="course-img" src="${course.imageDataURI}" alt="Course image"/>
                                            </c:if>
                                        </td>
                                        <td class="align-middle">
                                            <a href="${pageContext.request.contextPath}/courseDetail?id=${course.courseID}">${course.courseName}</a>
                                        </td>
                                        <td class="align-middle">
                                            <c:choose>
                                                <c:when test="${course.isSale eq 0}">
                                                    <fmt:formatNumber value="${course.originalPrice}" type="number" groupingUsed="true"/> VND
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${course.salePrice}" type="number" groupingUsed="true"/> VND
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="receipt-container">
                        <form id="paymentForm" method="POST" action="${pageContext.request.contextPath}/PaymentServlet">
                            <input type="hidden" name="userID" value="${sessionScope.user.userId}">
                            <input type="hidden" name="courseIDs" value="${selectedCourseIDs}">
                            <input type="hidden" name="finalPrice" id="finalPrice" value="${totalPrice}">
                            <input type="hidden" name="voucherCode" id="voucherCodeHidden" value="0">
                            <table class="table">
                                <thead>
                                    <tr><th>Payment Summary</th></tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="d-flex justify-content-between ps-3 pe-3">
                                                <span class="text">Total:</span>
                                                <span><span id="totalDisplay"><fmt:formatNumber value="${totalPrice}" type="number" groupingUsed="true"/></span> VND</span>
                                            </div>
                                            <div class="mt-3">
                                                <label for="voucherCode" class="form-label">Voucher Code:</label>
                                                <div class="input-group">
                                                    <input type="text" id="voucherCode" class="form-control" placeholder="Enter voucher code">
                                                    <button type="button" class="btn btn-outline-primary" onclick="applyVoucher()">Apply Voucher</button>
                                                </div>
                                                <span id="voucherMessage"></span>
                                            </div>
                                            <div class="mt-3">
                                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#qrModal">Proceed to Payment</button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- QR Code Modal -->
            <div class="modal fade" id="qrModal" tabindex="-1" aria-labelledby="qrModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="qrModalLabel">Scan QR Code to Pay</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body text-center">
                            <c:set var="addInfo" value="${sessionScope.user.userId} ${selectedCourseIDs} ${totalPrice} 0"/>
                            <c:url var="encodedAddInfo" value="${addInfo}"/>
                            <img class="modal-img" id="qrCodeImg" src="https://img.vietqr.io/image/MB-0919470174-compact2.png?amount=${totalPrice}&addInfo=${encodedAddInfo}&accountName=Phuong%20Gia%20Lac" alt="QR Code"/>
                            <p>Scan the QR code to complete your payment.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <script>
            function applyVoucher() {
                const voucherCode = document.getElementById('voucherCode').value;
                const userID = ${user.userId};
                const courseIDs = '${selectedCourseIDs}';
                const totalPrice = parseFloat(document.getElementById('finalPrice').value);

                if (!userID) {
                    $('#voucherMessage').css('color', 'red').text('Error: Please log in to apply a voucher.');
                    return;
                }

                $.ajax({
                    url: '${pageContext.request.contextPath}/Checkout',
                    type: 'POST',
                    data: {
                        action: 'voucher',
                        voucherCode: voucherCode,
                        userID: userID,
                        courseIDs: courseIDs,
                        totalPrice: totalPrice
                    },
                    dataType: 'json',
                    success: function (response) {
                        if (response.valid) {
                            $('#voucherMessage').css('color', 'green').text('Voucher applied! Discount: ' + response.discount + '. New Price: ' + new Intl.NumberFormat('de-DE').format(response.newPrice) + ' VND');
                            $('#totalDisplay').text(new Intl.NumberFormat('de-DE').format(response.newPrice));
                            $('#finalPrice').val(response.newPrice);
                            $('#voucherCodeHidden').val(voucherCode);
                            // Update QR code URL with new price and voucher code
                            const addInfo = userID + ' ' + courseIDs + ' ' + response.newPrice + ' ' + encodeURIComponent(voucherCode);
                            const qrUrl = 'https://img.vietqr.io/image/MB-0919470174-compact2.png?amount=' + response.newPrice + '&addInfo=' + encodeURIComponent(addInfo) + '&accountName=Phuong%20Gia%20Lac';
                            $('#qrCodeImg').attr('src', qrUrl);
                        } else {
                            $('#voucherMessage').css('color', 'red').text('Error: ' + response.message);
                        }
                    },
                    error: function () {
                        $('#voucherMessage').css('color', 'red').text('Error checking voucher. Please try again.');
                    }
                });
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>