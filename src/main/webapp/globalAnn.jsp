<%-- globalAnn.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Global Announcements</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <style>
            /* Các style custom của bạn */
            .card-hover {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .card-hover:hover {
                transform: translateY(-8px);
                box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            }
            .card-image-fixed {
                width: 100%;
                height: 200px; /* Chiều cao cố định */
                object-fit: cover; /* Cắt ảnh để vừa với khung mà không bị méo */
                /* Loại bỏ border nếu có */
                border: none;
            }
            .no-image-placeholder-card {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                height: 200px;
                background-color: #e2e8f0; /* bg-gray-200 */
                color: #4a5568; /* text-gray-700 */
                font-size: 1.2rem;
                text-align: center;
                border-bottom: 1px solid #cbd5e0; /* border-gray-300 */
            }
            /* Giữ chiều cao cố định cho card body để các card bằng nhau */
            .card-body-fixed-height {
                min-height: 220px; /* Điều chỉnh nếu cần để đủ chỗ cho tiêu đề, mô tả ngắn, và nút */
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }
            .line-clamp-3 {
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
        </style>
    </head>
    <body class="font-sans bg-gray-100">
        <div class="p-4">
            <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" 
               class="inline-flex items-center px-6 py-3 bg-gray-600 text-white rounded-full
               hover:bg-gray-700 transition-colors shadow-md text-lg">
                <i class="fa-solid fa-arrow-left mr-2"></i> Return
            </a>
        </div>
        <div class="container mx-auto p-8">
            <h1 class="text-4xl font-bold text-center text-gray-800 mb-10">Global Announcements</h1>

            <div class="mb-8 p-6 bg-white rounded-lg shadow-md flex flex-col md:flex-row items-center justify-between">
                <form action="${pageContext.request.contextPath}/announcements" method="get" class="w-full md:w-auto flex-grow flex items-center space-x-4">
                    <div class="relative flex-grow">
                        <input type="text" name="search" placeholder="Search by title or content..." 
                               class="w-full pl-4 pr-10 py-2.5 border border-gray-300 rounded-full focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all duration-300 ease-in-out"
                               value="${param.search != null ? param.search : ''}">
                        <i class="fa-solid fa-magnifying-glass absolute right-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                    </div>
                    <button type="submit" class="px-6 py-2.5 bg-blue-600 text-white rounded-full hover:bg-blue-700 transition-colors">Search</button>
                </form>
                <div class="md:ml-4 mt-4 md:mt-0">
                    <a href="${pageContext.request.contextPath}/announcements" class="px-6 py-2.5 bg-gray-200 text-gray-700 rounded-full hover:bg-gray-300 transition-colors">View All</a>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <c:if test="${empty announcements}">
                    <p class="text-center text-gray-600 col-span-full">No announcements found.</p>
                </c:if>
                <c:forEach var="ann" items="${announcements}">
                    <div class="card-hover bg-white rounded-xl shadow-lg overflow-hidden flex flex-col">
                        <c:if test="${ann.announcementImage != null}">
                            <img src="${ann.imageDataURI}" alt="${ann.title}" class="card-image-fixed">
                        </c:if>
                        <c:if test="${ann.announcementImage == null}">
                            <div class="no-image-placeholder-card">No Image</div>
                        </c:if>


                        <div class="p-6 flex-grow flex flex-col justify-between card-body-fixed-height">
                            <div>
                                <h2 class="text-xl font-semibold text-gray-900 mb-3">${ann.title}</h2>
                                <p class="text-gray-700 mb-4 line-clamp-3">${ann.announcementText}</p>
                            </div>
                            <div class="flex items-center justify-between text-sm text-gray-500 mt-auto">
                                <span>Posted by: ${ann.userId.displayName != null ? ann.userId.displayName : ann.userId.userName}</span>
                                <span>Date: <fmt:formatDate value="${ann.createDate}" pattern="dd/MM/yyyy"/></span>
                            </div>
                            <div class="mt-4 text-center">
                                <a href="${pageContext.request.contextPath}/announcement-detail?id=${ann.annoucementID}" 
                                   class="inline-block px-5 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors">
                                    Read More
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </body>
</html>