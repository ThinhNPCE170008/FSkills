<%-- globalAnnDetail.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${announcement.title}</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <style>
            /* CSS của bạn */
            body { font-family: Arial, sans-serif; background-color: #f0f2f5; }
            .container-detail { max-width: 900px; margin: 20px auto; background-color: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,.08); }
            
            /* Lỗi 2: Ảnh không hiển thị (placeholder) và Lỗi 4: Ảnh bị tràn */
            .announcement-image-detail {
                max-width: 100%; /* Giới hạn chiều rộng tối đa là 100% của phần tử cha */
                height: auto; /* Chiều cao tự động để duy trì tỷ lệ khung hình */
                display: block; /* Để margin auto hoạt động */
                margin: 20px auto; /* Căn giữa ảnh và thêm khoảng cách trên dưới */
                border-radius: 8px; /* Bo góc nhẹ */
                box-shadow: 0 2px 8px rgba(0,0,0,0.1); /* Thêm bóng */
                /* Loại bỏ border nếu có */
                border: none;
            }
            .no-image-detail-placeholder {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 300px; /* Chiều cao tối thiểu cho placeholder */
                background-color: #e2e8f0; /* bg-gray-200 */
                color: #4a5568; /* text-gray-700 */
                font-size: 1.5rem;
                text-align: center;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                margin: 20px auto;
            }

            /* Các style khác giữ lại hoặc điều chỉnh cho phù hợp Tailwind */
            .announcement-header { border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px; }
            .announcement-header h1 { margin: 0; color: #333; font-size: 2.2em; font-weight: bold; }
            .announcement-meta { font-size: 0.9em; color: #777; margin-top: 5px; display: flex; align-items: center; flex-wrap: wrap; }
            .announcement-meta span { margin-right: 15px; } /* Khoảng cách giữa các phần tử meta */
            .announcement-meta .icon-text { display: inline-flex; align-items: center; margin-right: 15px; }
            .announcement-meta .icon-text i { margin-right: 5px; } /* Khoảng cách giữa icon và text */

            .announcement-content-detail { line-height: 1.8; color: #333; } /* Tăng line-height cho dễ đọc */
            .announcement-footer { border-top: 1px solid #eee; padding-top: 15px; margin-top: 30px; text-align: right; }
            .announcement-type-detail { background-color: #ef4444; /* red-500 */ color: white; padding: 4px 10px; border-radius: 9999px; /* full-rounded */ font-size: 0.85em; margin-right: 10px; display: inline-block; font-weight: bold;}
            
        </style>
    </head>
    <body>
        <div class="container-detail">
            <%-- Lỗi 2: "Return to announcement list" thành button (đã sửa ở lần trước) --%>
            <a href="${pageContext.request.contextPath}/guest/announcements" 
               class="inline-flex items-center px-6 py-3 bg-blue-600 text-white rounded-full 
                      hover:bg-blue-700 transition-colors shadow-md mb-6 text-lg">
                <i class="fa-solid fa-arrow-left-long mr-2"></i> Return
            </a>

            <c:if test="${empty announcement}">
                <p class="text-center text-gray-600 text-xl py-10">No announcement found with the given ID.</p>
            </c:if>

            <c:if test="${not empty announcement}">
                <div class="announcement-header">
                    <span class="announcement-type-detail">Announcement</span>
                    <h1 class="text-3xl">${announcement.title}</h1>
                    <div class="announcement-meta">
                        <span>Posted by: ${announcement.userId.displayName != null ? announcement.userId.displayName : announcement.userId.userName}</span>
                        <span>- <fmt:formatDate value="${announcement.createDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                        
                        <%-- Sửa lỗi 3: Icon bị vỡ và Lỗi 6: Dùng Font Awesome thay img --%>
                        <span class="icon-text">
                            <i class="fa-regular fa-comment text-base"></i> 0 comments
                        </span>
                        <span class="icon-text">
                            <i class="fa-regular fa-eye text-base"></i> <fmt:formatNumber value="4000" type="number" pattern="#,###"/> views
                        </span>
                    </div>
                </div>

               <c:if test="${announcement.announcementImage != null && announcement.announcementImage != '' && announcement.announcementImage != 'No Image'}">
                   <img src="${pageContext.request.contextPath}/${announcement.announcementImage}" alt="${announcement.title}" class="announcement-image-detail">
               </c:if>
                

                <div class="announcement-content-detail">
                    <%-- Sử dụng c:out với escapeXml="false" nếu nội dung có thể chứa HTML (từ trình soạn thảo WYSIWYG) --%>
                    <p class="text-gray-800"><c:out value="${announcement.announcementText}" escapeXml="false"/></p>
                </div>

                <div class="announcement-footer">
                    <span class="text-gray-600">
                        <span role="img" aria-label="like" class="text-2xl mr-2">👍</span>Khôi đã like Announcement này
                    </span>
                </div>
            </c:if>
        </div>
    </body>
</html>