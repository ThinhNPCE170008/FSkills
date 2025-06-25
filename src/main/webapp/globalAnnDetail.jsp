<%-- 
    Document   : globalAnnDetail
    Created on : Jun 19, 2025, 2:35:10 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${announcement.title}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon_io/favicon.ico">
        <style>
            /* CSS của bạn */
            body { font-family: Arial, sans-serif; margin: 20px; background-color: #f0f2f5; }
            .container { max-width: 900px; margin: auto; background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,.1); }
            .back-link { margin-bottom: 20px; display: block; text-decoration: none; color: #007bff; }
            .announcement-header { border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px; }
            .announcement-header h1 { margin: 0; color: #333; font-size: 1.8em; }
            .announcement-meta { font-size: 0.9em; color: #777; margin-top: 5px; }
            .announcement-actions-top { text-align: right; font-size: 0.9em; color: #777; margin-top: -30px; margin-bottom: 20px; }
            .announcement-content-detail { line-height: 1.6; color: #444; }
            .announcement-content-detail img { max-width: 100%; height: auto; display: block; margin: 15px 0; border-radius: 4px; }
            .announcement-footer { border-top: 1px solid #eee; padding-top: 15px; margin-top: 30px; text-align: right; }
            .announcement-type-detail { background-color: #dc3545; color: white; padding: 3px 8px; border-radius: 4px; font-size: 0.8em; margin-right: 10px; display: inline-block; }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="${pageContext.request.contextPath}/guest/announcements" class="back-link">&larr; Return to the Announcement List</a>

            <c:if test="${empty announcement}">
                <p>No Announcements here.</p>
            </c:if>

            <c:if test="${not empty announcement}">
                <div class="announcement-header">
                    <span class="announcement-type-detail">Announcements</span>
                    <h1>${announcement.title}</h1>
                    <div class="announcement-meta">
                        ${announcement.userId.displayName != null ? announcement.userId.displayName : announcement.userId.userName} - <fmt:formatDate value="${announcement.createDate}" pattern="dd/MM/yy"/> - 0 <img src="${pageContext.request.contextPath}/img/comment_icon.png" alt="comments" width="16" height="16"> - <fmt:formatNumber value="4000" type="number" pattern="#,###"/> <img src="${pageContext.request.contextPath}/img/eye_icon.png" alt="views" width="16" height="16">
                    </div>
                </div>

                <c:if test="${announcement.announcementImage != null && announcement.announcementImage != ''}">
                    <img src="${pageContext.request.contextPath}/${announcement.announcementImage}" alt="Announcement picture">
                </c:if>

                <div class="announcement-content-detail">
                    <p class="text-break"><c:out value="${announcement.announcementText}" escapeXml="false"/></p>
                </div>

                <div class="announcement-footer">
                    <span style="display: inline-block; margin-right: 10px;"><span role="img" aria-label="like">👍</span></span>
                    <span style="display: inline-block;">Khôi dã like Announcement này</span>
                </div>
            </c:if>
        </div>
    </body>
</html>