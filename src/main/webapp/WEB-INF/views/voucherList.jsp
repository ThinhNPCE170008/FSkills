<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Quản Trị F-SKILL - Quản lý Voucher</title>

    <link rel="icon" type="image/png" href="https://placehold.co/32x32/0284c7/ffffff?text=FS">

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        inter: ['Inter', 'sans-serif'],
                    },
                    colors: {
                        primary: {
                            DEFAULT: '#0284c7',
                            light: '#03a9f4',
                            dark: '#075985',
                        },
                        secondary: '#475569',
                    }
                }
            }
        }
    </script>

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f2f5;
        }

        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #555;
            border-radius: 10px;
        }

        .sidebar-container {
            width: 250px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            transition: transform 0.3s ease;
            overflow-y: auto;
        }
        .sidebar-container.collapsed {
            transform: translateX(-100%);
        }
        .sidebar-toggle {
            position: fixed;
            top: 1rem;
            left: 1rem;
            z-index: 1001;
            background: #0284c7;
            color: white;
            padding: 8px;
            border-radius: 50%;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        .sidebar-toggle:hover {
            background-color: #075985;
            transform: scale(1.1);
        }
        @media (max-width: 768px) {
            .sidebar-container {
                transform: translateX(-100%);
            }
            .sidebar-container.active {
                transform: translateX(0);
            }
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.875rem;
            color: #1f2937;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
            vertical-align: middle;
        }

        th {
            background-color: #f9fafb;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #6b7280;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .actions-cell form {
            display: inline-block;
            margin-right: 0.5rem;
        }

        .action-btn {
            background-color: transparent;
            border: none;
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 0.375rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.2s ease;
        }
        .action-btn svg {
            width: 1.25rem;
            height: 1.25rem;
        }

        .action-btn-edit { color: #f59e0b; }
        .action-btn-edit:hover { background-color: #fef3c7; }

        .action-btn-delete { color: #ef4444; }
        .action-btn-delete:hover { background-color: #fee2e2; }

        .no-results td {
            text-align: center;
            color: #6b7280;
            padding: 2.5rem;
            font-size: 1rem;
        }
    </style>
</head>
<body class="flex flex-col h-screen font-inter bg-[#f0f2f5] text-gray-800">
    <button class="sidebar-toggle hidden md:hidden">
        <i class="bi bi-list text-lg"></i>
    </button>

    <jsp:include page="/layout/header_admin.jsp" />

    <div class="flex flex-grow">
        <jsp:include page="/layout/sidebar_admin.jsp" />
        <%--
        Cho này neu sai thi lay dong code duoi nayyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
        <jsp:include page="/layout/sidebar_admin.jsp"/>
        --%>

        <main class="flex-grow p-6 bg-[#DFEBF6] rounded-tl-lg overflow-y-auto">
            <div class="bg-white p-6 rounded shadow-sm max-w-6xl mx-auto">
                <div class="page-header flex justify-between items-center mb-6 pb-4 border-b border-gray-200">
                    <h2 class="text-2xl font-bold text-gray-800 m-0">List of Vouchers</h2>
                    <div class="header-actions flex gap-3">
                        <a href="${pageContext.request.contextPath}/admin" class="text-gray-600 font-medium py-2 px-3 rounded-md hover:bg-gray-100 transition duration-200">
                            Return to Dashboard
                        </a>
                    </div>
                </div>

                <c:if test="${not empty globalMessage}">
                    <p class="global-message bg-red-100 text-red-800 p-3 rounded-lg mb-4 text-center">
                        ${globalMessage}
                    </p>
                </c:if>

                <div class="search-add-section flex justify-between items-center mb-6 flex-wrap gap-4 pt-4">
                    <div class="search-bar flex items-center gap-3 flex-grow">
                        <form action="voucherList" method="get" class="flex-grow flex gap-3">
                            <input type="text" name="searchTerm" placeholder="Search Voucher..." value="${param.searchTerm}"
                                   class="flex-grow p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary transition duration-200">
                            <button type="submit" class="btn btn-primary bg-primary text-white py-3 px-5 rounded-lg hover:bg-primary-dark transition duration-200">
                                <i class="fas fa-search mr-2"></i>Search
                            </button>
                            <button type="button" class="btn btn-secondary bg-gray-200 text-gray-700 py-3 px-5 rounded-lg hover:bg-gray-300 transition duration-200" onclick="window.location.href = 'voucherList'">
                                Show All
                            </button>
                        </form>
                    </div>
                    <div>
                        <a href="addVoucher" class="add-button bg-green-600 text-white py-3 px-5 rounded-lg hover:bg-green-700 transition duration-200 flex items-center gap-2">
                            <i class="fas fa-plus-circle"></i> Add new voucher
                        </a>
                    </div>
                </div>

                <div class="table-wrapper overflow-x-auto bg-white rounded-lg shadow-sm">
                    <c:choose>
                        <c:when test="${not empty voucherList}">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Expiration Date</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Sale Type</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Sale Amount</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Minimum Price</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Course ID</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Amount</th>
                                        <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach var="voucher" items="${voucherList}">
                                        <tr class="hover:bg-gray-50">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${voucher.voucherID}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                                <fmt:formatDate value="${voucher.expiredDate}" pattern="HH:mm dd/MM/yyyy"/>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${voucher.saleType}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${voucher.saleAmount}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${voucher.minPrice}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${voucher.courseID}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${voucher.amount}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium text-center actions-cell">
                                                <a href="editVoucher?voucherID=${voucher.voucherID}" class="action-btn action-btn-edit" title="Edit Voucher">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <form action="deleteVoucher" method="post" class="inline-block mx-1" onsubmit="return confirm('Are you sure you want to delete voucher ID ${voucher.voucherID}? This action cannot be undone.');">
                                                    <input type="hidden" name="voucherID" value="${voucher.voucherID}">
                                                    <button type="submit" class="action-btn action-btn-delete" title="Delete Voucher">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <%-- Chỉ hiển thị thông báo "There are no vouchers to display." nếu voucherList trống VÀ không có globalMessage (ví dụ: từ tìm kiếm cụ thể) --%>
                            <c:if test="${empty globalMessage}">
                                <p class="no-results px-6 py-10 text-gray-500 text-center text-base">
                                    There are no vouchers to display.
                                </p>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script>
        const notificationBell = document.getElementById('notification-bell');
        const notificationPopup = document.getElementById('notification-popup');

        notificationBell.addEventListener('click', (event) => {
            event.stopPropagation();
            notificationPopup.classList.toggle('hidden');
        });

        document.addEventListener('click', (event) => {
            if (!notificationBell.contains(event.target) && !notificationPopup.contains(event.target)) {
                notificationPopup.classList.add('hidden');
            }
        });

        document.querySelector('.sidebar-toggle').addEventListener('click', () => {
            document.querySelector('.sidebar-container').classList.toggle('active');
        });
    </script>
</body>
</html>