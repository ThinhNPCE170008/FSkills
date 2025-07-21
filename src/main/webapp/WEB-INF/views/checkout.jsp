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
                                    <th></th>
                                    <th>Course Name</th>
                                    <th>Category</th>
                                    <th>Instructor Name</th>
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
                                            ${course.category.name}
                                        </td>
                                        <td class="align-middle">
                                            <a href="${pageContext.request.contextPath}/userDetail?id=${courseUser[course.courseID].userId}">${courseUser[course.courseID].displayName}</a>
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
                            <c:set var="addInfo" value="${paymentContent}"/>
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
            <form method="post" action="${pageContext.request.contextPath}/checkout" id="submit-form">
            </form>
        </main>

        <script>
            let isSuccess = false;
            let price = ${totalPrice};
            let content = "${addInfo}";
            document.addEventListener("DOMContentLoaded", () => {
                setInterval(() => {
                    checkPaid(window.price, window.content || '');
                }, 1000);
            });

            function applyVoucher() {
                const voucherCode = document.getElementById('voucherCode').value;
                const userID = ${user.userId};
                const courseIDs = '${selectedCourseIDs}';
                const totalPrice = parseFloat(document.getElementById('finalPrice').value);

                console.log('Applying voucher:', {voucherCode, userID, courseIDs, totalPrice});

                if (!userID) {
                    $('#voucherMessage').css('color', 'red').text('Error: Please log in to apply a voucher.');
                    console.error('No userID found');
                    return;
                }

                $('#voucherMessage').text('');

                $.ajax({
                    url: '${pageContext.request.contextPath}/checkout',
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
                        console.log('AJAX Response:', response);

                        if (!response || typeof response.valid === 'undefined') {
                            $('#voucherMessage').css('color', 'red').text('Error: Invalid response from server.');
                            console.error('Invalid response structure:', response);
                            return;
                        }

                        if (response.valid) {
                            if (isNaN(response.newPrice) || response.newPrice === null) {
                                $('#voucherMessage').css('color', 'red').text('Error: Invalid price returned from server.');
                                console.error('Invalid newPrice:', response.newPrice);
                                return;
                            }

                            const newPrice = parseInt(response.newPrice);
                            $('#voucherMessage').css('color', 'green').text(
                                    'Voucher applied! Discount: ' + (response.discount || '0') + '. New Price: ' +
                                    new Intl.NumberFormat('de-DE').format(newPrice) + ' VND'
                                    );
                            $('#totalDisplay').text(new Intl.NumberFormat('de-DE').format(newPrice));
                            $('#finalPrice').val(newPrice);
                            $('#voucherCodeHidden').val(voucherCode);

                            const addInfo = userID + ' ' + courseIDs + ' ' + newPrice + ' ' + encodeURIComponent(voucherCode);
                            window.price = newPrice;
                            window.content = userID + ' ' + courseIDs + ' ' + newPrice + ' ' + voucherCode;
                            window.contentBefore = window.content;

                            const qrUrl = 'https://img.vietqr.io/image/MB-0919470174-compact2.png?amount=' +
                                    newPrice + '&addInfo=' + encodeURIComponent(addInfo) +
                                    '&accountName=Phuong%20Gia%20Lac';
                            console.log('QR URL:', qrUrl);

                            $('#qrCodeImg').off('error').on('error', function () {
                                $('#voucherMessage').css('color', 'red').text('Error: Failed to load QR code.');
                                console.error('QR code failed to load:', qrUrl);
                            });
                            $('#qrCodeImg').attr('src', qrUrl);
                        } else {
                            $('#voucherMessage').css('color', 'red').text('Error: ' + (response.message || 'Unknown error'));
                            console.log('Voucher invalid, message:', response.message);
                        }
                    },
                    error: function (xhr, status, error) {
                        $('#voucherMessage').css('color', 'red').text('Error checking voucher. Please try again.');
                        console.error('AJAX error:', status, error, xhr.responseText);
                    }
                });
            }

            async function checkPaid(price, content) {
                if (isSuccess) {
                    return;
                } else {
                    try {
                        const response = await fetch(
                                "https://script.google.com/macros/s/AKfycbxKPwVyhF7P1WVYoa7kKjl_wFHTCZ0uCf9a521GovWVgKFObLmhhXTeWgthZjYNHLPu/exec"
                                );
                        const data = await response.json();
                        const lastPaid = data.data[data.data.length - 1];
                        const lastPrice = lastPaid["Giá trị"];
                        const lastContent = lastPaid["Mô tả"];

                        // Fixed syntax for console.log with object literal
                        console.log('Comparing:', {
                            lastPrice: lastPrice,
                            price: price,
                            lastContent: lastContent,
                            windowContent: window.content
                        });

                        const submitData = document.createElement("input");
                        const submitAction = document.createElement("input");
                        console.log('Comparing values:', {lastPrice, price, lastContent, windowContent: window.content});

                        if (lastPrice >= price && lastContent.includes(window.content)) {
                            isSuccess = true;
                            submitData.type = "hidden";
                            submitData.name = "submitData";
                            submitData.value = window.content;
                            submitAction.type = "hidden";
                            submitAction.name = "action";
                            submitAction.value = "submit-payment";
                            document.getElementById("submit-form").appendChild(submitData);
                            document.getElementById("submit-form").appendChild(submitAction);
                            document.getElementById("submit-form").submit();
                        } else {
                            console.log("Không thành công");
                        }
                    } catch (e) {
                        console.error("Lỗi", e);
                    }
                }
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>