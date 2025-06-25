<%-- 
    Document   : globalAnn
    Created on : Jun 19, 2025, 1:52:43 PM
    Author     : DELL
--%>

<%-- globalAnn.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
        </style>
    </head>
    <body class="font-sans bg-gray-100">
        <h2>
            <a href="${pageContext.request.contextPath}/homePage_Guest.jsp" class="return-to-homepage">Return</a>
        </h2>
        <div class="container mx-auto p-8">
            <h1 class="text-4xl font-bold text-center text-gray-800 mb-10">Global Announcements</h1>

            <div class="mb-8 p-6 bg-white rounded-lg shadow-md flex flex-col md:flex-row items-center justify-between">
                <form action="${pageContext.request.contextPath}/guest/announcements" method="get" class="w-full md:w-auto flex-grow flex items-center space-x-4">
                    <div class="relative flex-grow">
                        <input type="text" name="search" placeholder="Search by title or content..." 
                               class="w-full pl-4 pr-10 py-2.5 border border-gray-300 rounded-full focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all duration-300 ease-in-out"
                               value="${param.search != null ? param.search : ''}">
                        <i class="fa-solid fa-magnifying-glass absolute right-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                    </div>
                    <button type="submit" class="px-6 py-2.5 bg-blue-600 text-white rounded-full hover:bg-blue-700 transition-colors">Search</button>
                </form>
                <div class="md:ml-4 mt-4 md:mt-0">
                    <a href="${pageContext.request.contextPath}/guest/announcements" class="px-6 py-2.5 bg-gray-200 text-gray-700 rounded-full hover:bg-gray-300 transition-colors">View All</a>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <c:forEach var="ann" items="${announcements}">
                    <div class="card-hover bg-white rounded-xl shadow-lg overflow-hidden flex flex-col">
                        <img src="${ann.announcementImage}" alt="Announcement Image" class="w-full h-48 object-cover">
                        <div class="p-6 flex-grow flex flex-col justify-between">
                            <div>
                                <h2 class="text-xl font-semibold text-gray-900 mb-3">${ann.title}</h2>
                                <p class="text-gray-700 mb-4 line-clamp-3">${ann.announcementText}</p>
                            </div>
                            <div class="flex items-center justify-between text-sm text-gray-500">
                                <span>Posted by: ${ann.userId.displayName}</span>
                                <span>Date: ${ann.createDate}</span>
                            </div>
                            <div class="mt-4 text-center">
                                <a href="${pageContext.request.contextPath}/guest/announcement-detail?id=${ann.annoucementID}" 
                                   class="inline-block px-5 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors">
                                    Read More
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty announcements}">
                    <p class="text-center text-gray-600 col-span-full">No announcements found.</p>
                </c:if>
            </div>
        </div>
    </body>
</html>