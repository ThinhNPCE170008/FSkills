<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>My Bills</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous">
        <link rel="stylesheet" href="/FSkills/css/sidebar.css">
        <style>
            :root {
                --primary-color: #2c3e50;
                --secondary-color: #3498db;
                --success-color: #2ecc71;
                --background-color: #f8f9fa;
                --card-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                --border-radius: 8px;
                --transition: all 0.3s ease;
            }

            .main {
                min-height: 100vh;
                padding: 2rem 3vw;
                background-color: var(--background-color);
            }

            .h1 {
                font-size: 2.5rem;
                font-weight: 700;
                color: var(--primary-color);
                text-align: center;
                margin: 2rem 0 1.5rem;
            }

            .table-container {
                max-width: 1000px;
                margin: 0 auto;
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--card-shadow);
            }

            .table th, .table td {
                vertical-align: middle;
                padding: 0.75rem;
                color: var(--primary-color);
            }

            .table tbody tr:hover {
                background-color: #f5f5f5;
            }

            .btn-primary {
                background-color: var(--secondary-color);
                border-color: var(--secondary-color);
                padding: 0.5rem 1rem;
                font-weight: 600;
                transition: var(--transition);
            }

            .btn-primary:hover {
                background-color: #2980b9;
                transform: translateY(-2px);
            }

            .modal-content {
                border-radius: var(--border-radius);
            }

            .modal-table {
                margin-bottom: 0;
            }

            .summary-btn-container {
                text-align: center;
                margin-bottom: 1.5rem;
            }
        </style>
    </head>
    <body>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="/login"/>
        </c:if>
        <c:choose>
            <c:when test="${isAdmin}">
                <%@include file="../../layout/header.jsp" %>
                <%@include file="../../layout/sidebar_admin.jsp" %>
            </c:when>
            <c:otherwise>
                <%@include file="../../layout/header.jsp" %>
                <%@include file="../../layout/sidebar_user.jsp" %>
            </c:otherwise>
        </c:choose>

        <main class="main">
            <p class="h1">My Bills</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger text-center">${errorMessage}</div>
            </c:if>

            <c:choose>
                <c:when test="${empty receipts}">
                    <p class="text-center">No bills found.</p>
                </c:when>
                <c:otherwise>
                    <c:if test="${isAdmin}">
                    <div class="summary-btn-container">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#summaryModal">
                            View Total Summary
                        </button>
                    </div>
                    </c:if>
                    <div class="table-container">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <c:if test="${isAdmin}">
                                    <th>User ID</th>   
                                </c:if> 
                                <th>Receipt ID</th>
                                <th>Payment Date</th>
                                <th>Total Price</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <c:forEach var="receipt" items="${receipts}">
                                    <tr>
                                        <c:if test="${isAdmin}">
                                            <td><c:out value="${receipt.userID}"/></td>   
                                        </c:if>
                                        <td><c:out value="${receipt.receiptID}"/></td>
                                        <td><fmt:formatDate value="${receipt.paymentDate}" pattern="dd-MM-yyyy HH:mm:ss"/></td>
                                        <td><fmt:formatNumber value="${receipt.price}" type="number" groupingUsed="true"/> VND</td>
                                        <td>
                                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#receiptModal${receipt.receiptID}">
                                                View Details
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <c:if test="${isAdmin}">
                    <!-- Total Summary Modal -->
                    <div class="modal fade" id="summaryModal" tabindex="-1" aria-labelledby="summaryModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="summaryModalLabel">Total Billing Summary</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <table class="table modal-table">
                                        <tr>
                                            <th>Total Amount</th>
                                            <td>
                                                <c:set var="totalAmount" value="${0}"/>
                                                <c:forEach var="receipt" items="${receipts}">
                                                    <c:set var="totalAmount" value="${totalAmount + receipt.price}"/>
                                                </c:forEach>
                                                <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/> VND
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Platform Cut (15%)</th>
                                            <td>
                                                <c:set var="platformCut" value="${totalAmount * 0.15}"/>
                                                <fmt:formatNumber value="${platformCut}" type="number" groupingUsed="true"/> VND
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Net Amount</th>
                                            <td>
                                                <fmt:formatNumber value="${totalAmount - platformCut}" type="number" groupingUsed="true"/> VND
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    </c:if>
                    <!-- Receipt Detail Modals -->
                    <c:forEach var="receipt" items="${receipts}">
                        <div class="modal fade" id="receiptModal${receipt.receiptID}" tabindex="-1" aria-labelledby="receiptModalLabel${receipt.receiptID}" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="receiptModalLabel${receipt.receiptID}">Receipt #<c:out value="${receipt.receiptID}"/></h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <table class="table modal-table">
                                            <tr>
                                                <th>Payment Date</th>
                                                <td><fmt:formatDate value="${receipt.paymentDate}" pattern="dd-MM-yyyy HH:mm:ss"/></td>
                                            </tr>
                                            <tr>
                                                <th>Total Paid</th>
                                                <td><fmt:formatNumber value="${receipt.price}" type="number" groupingUsed="true"/> VND</td>
                                            </tr>
                                            <tr>
                                                <th>Voucher Used</th>
                                                <td><c:out value="${receipt.voucherCode eq '0' ? 'None' : receipt.voucherCode}"/></td>
                                            </tr>
                                            <tr>
                                                <th>Purchased Courses</th>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${empty receipt.course}">
                                                            No courses found.
                                                        </c:when>
                                                        <c:otherwise>
                                                            <ul class="list-unstyled">
                                                                <c:forEach var="course" items="${receipt.course}">
                                                                    <li><c:out value="${course.courseName}"/></li>
                                                                </c:forEach>
                                                            </ul>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </main>
        <script>
            // Script to ensure proper sidebar hover behavior
            document.addEventListener('DOMContentLoaded', function() {
                const sidebar = document.querySelector('.sidebar');
                const mainContent = document.querySelector('main');
                const header = document.querySelector('header');

                // Event handler functions defined outside to allow removal
                function handleSidebarMouseEnter() {
                    const windowWidth = window.innerWidth;
                    mainContent.style.transition = 'margin-left 0.2s ease, width 0.2s ease';

                    if (windowWidth <= 768) {
                        // Mobile layout
                        mainContent.style.marginLeft = '250px';
                        if (header) {
                            header.style.left = '250px';
                            header.style.width = 'calc(100% - 266px)';
                        }
                    } else {
                        // Desktop layout
                        mainContent.style.marginLeft = '250px';
                        if (header) {
                            header.style.left = '250px';
                            header.style.width = 'calc(100% - 266px)';
                        }
                    }
                }

                function handleSidebarMouseLeave() {
                    const windowWidth = window.innerWidth;
                    mainContent.style.transition = 'margin-left 0.2s ease, width 0.2s ease';

                    if (windowWidth <= 768) {
                        // Mobile layout
                        mainContent.style.marginLeft = '0';
                        if (header) {
                            header.style.left = '0';
                            header.style.width = 'calc(100% - 16px)';
                        }
                    } else {
                        // Desktop layout
                        mainContent.style.marginLeft = '80px';
                        if (header) {
                            header.style.left = '80px';
                            header.style.width = 'calc(100% - 96px)';
                        }
                    }
                }

                // Add event listeners
                sidebar.addEventListener('mouseenter', handleSidebarMouseEnter);
                sidebar.addEventListener('mouseleave', handleSidebarMouseLeave);

                // Set initial state based on window width
                handleSidebarMouseLeave();

                // Add resize event listener to handle window size changes
                window.addEventListener('resize', function() {
                    // Update layout based on current sidebar state
                    if (sidebar.matches(':hover')) {
                        handleSidebarMouseEnter();
                    } else {
                        handleSidebarMouseLeave();
                    }
                });
            });
        </script>

        <%@include file="../../layout/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    </body>
</html>