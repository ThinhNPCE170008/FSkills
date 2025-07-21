<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Details - ${course.courseName}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .status-default { background-color: #e5e7eb; color: #374151; }
        .status-approved { background-color: #d1fae5; color: #065f46; }
        .status-rejected { background-color: #fee2e2; color: #b91c1c; }
        .status-processing { background-color: #bfdbfe; color: #1e40af; }
        .status-hidden { background-color: #f3f4f6; color: #6b7280; }
        .material-table {
            min-width: 1000px;
        }
        @media (max-width: 768px) {
            .table-container {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen">
<!-- Flex container for sidebar and main content -->
<div class="flex">
    <!-- Header Section (Sidebar) -->
    <jsp:include page="/layout/sidebar_admin.jsp"/>

    <!-- Main Content Area -->
    <div class="flex-1 p-4 md:p-6 lg:p-8">
        <main class="bg-white rounded-2xl shadow-lg p-6 md:p-8 lg:p-10">
            <!-- Back Button & Page Title -->
            <div class="flex justify-between items-center mb-6 pb-4 border-b border-gray-200">
                <h1 class="text-3xl md:text-4xl font-extrabold text-gray-900">Course Details</h1>
                <a href="<c:url value='/admin/ManageCourse'/>" class="text-indigo-600 hover:text-indigo-800 flex items-center gap-2 text-lg font-medium transition-colors duration-200">
                    <i class="fas fa-arrow-left"></i> Back to Courses
                </a>
            </div>

            <!-- Messages -->
            <c:if test="${not empty message}">
                <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-r-lg shadow-sm" role="alert">
                        ${message}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-r-lg shadow-sm" role="alert">
                        ${error}
                </div>
            </c:if>

            <!-- Course Header Section -->
            <section class="mb-8 p-6 bg-blue-50 rounded-xl shadow-inner border border-blue-100">
                <div class="flex flex-col lg:flex-row items-start lg:items-center gap-6">
                    <div class="flex-shrink-0 w-full lg:w-1/3">
                        <c:choose>
                            <c:when test="${not empty course.courseImageLocation and not empty course.getImageDataURI()}">
                                <img src="${course.getImageDataURI()}" alt="Course Image" class="rounded-lg shadow-xl w-full h-64 object-cover border border-gray-200"/>
                            </c:when>
                            <c:otherwise>
                                <img src="https://placehold.co/600x400/E0F2FE/2563EB?text=Course+Image" alt="Placeholder Image" class="rounded-lg shadow-xl w-full h-64 object-cover border border-gray-200"/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="flex-1 space-y-3">
                        <div class="flex justify-between items-start">
                            <h2 class="text-3xl font-bold text-gray-900">${course.courseName}</h2>
                            <span class="status-badge status-${course.approveStatus == 0 ? 'default' :
                                  course.approveStatus == 1 ? 'approved' :
                                  course.approveStatus == 2 ? 'rejected' :
                                  course.approveStatus == 3 ? 'processing' : 'hidden'}">
                                ${course.approveStatus == 0 ? 'Default' :
                                        course.approveStatus == 1 ? 'Approved' :
                                                course.approveStatus == 2 ? 'Rejected' :
                                                        course.approveStatus == 3 ? 'Processing' : 'Hidden'}
                            </span>
                        </div>

                        <p class="text-lg text-gray-700">
                            <span class="font-semibold text-gray-800">Instructor:</span> ${course.user.displayName}
                        </p>

                        <p class="text-gray-600 leading-relaxed">${course.courseSummary}</p>

                        <div class="flex flex-wrap items-center gap-4 text-sm mt-4">
                            <span class="px-3 py-1 rounded-full bg-indigo-100 text-indigo-800 font-medium shadow-sm">
                                ${course.category.name}
                            </span>

                            <span class="text-gray-600 flex items-center">
                                <i class="fas fa-users mr-2 text-gray-500"></i> ${course.totalEnrolled} Enrolled Students
                            </span>
                        </div>

                        <div class="flex items-baseline gap-2 mt-4">
                            <c:choose>
                                <c:when test="${course.isSale == 1}">
                                    <span class="text-3xl font-extrabold text-green-700">$${course.salePrice}</span>
                                    <span class="text-xl text-gray-500 line-through">$${course.originalPrice}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-3xl font-extrabold text-green-700">$${course.originalPrice}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Detailed Course Information -->
            <section class="mb-8 p-6 bg-gray-50 rounded-xl shadow-inner border border-gray-100">
                <h3 class="text-2xl font-bold text-gray-800 mb-4">Course Overview</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-y-4 gap-x-6 text-gray-700">
                    <p><span class="font-medium text-gray-600">Course ID:</span> ${course.courseID}</p>
                    <p><span class="font-medium text-gray-600">Highlight:</span> ${course.courseHighlight}</p>
                    <p><span class="font-medium text-gray-600">On Sale:</span> ${course.isSale == 1 ? 'Yes' : 'No'}</p>
                    <p><span class="font-medium text-gray-600">Public Date:</span>
                        <fmt:formatDate value="${course.publicDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </p>
                    <p><span class="font-medium text-gray-600">Last Update:</span>
                        <fmt:formatDate value="${course.courseLastUpdate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </p>
                    <p><span class="font-medium text-gray-600">Approval Status:</span>
                        ${course.approveStatus == 0 ? 'Default' :
                                course.approveStatus == 1 ? 'Approved' :
                                        course.approveStatus == 2 ? 'Rejected' :
                                                course.approveStatus == 3 ? 'Processing' : 'Hidden'}
                    </p>
                </div>

                <!-- Admin Actions -->
                <div class="flex flex-wrap gap-4 mt-6 pt-6 border-t border-gray-200">
                    <c:if test="${course.approveStatus != 1}">
                        <form action="ManageCourse" method="post" class="inline">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="courseID" value="${course.courseID}">
                            <input type="hidden" name="status" value="1">
                            <button type="submit" class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-md flex items-center gap-2">
                                <i class="fas fa-check"></i> Approve
                            </button>
                        </form>
                    </c:if>

                    <c:if test="${course.approveStatus != 2}">
                        <form action="ManageCourse" method="post" class="inline">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="courseID" value="${course.courseID}">
                            <input type="hidden" name="status" value="2">
                            <button type="submit" class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-md flex items-center gap-2">
                                <i class="fas fa-times"></i> Reject
                            </button>
                        </form>
                    </c:if>

                    
                    
                </div>
            </section>

            <!-- Modules List -->
            <section class="mb-8">
                <h3 class="text-2xl font-bold text-gray-900 mb-6">Course Content</h3>
                <div class="space-y-4">
                    <c:forEach var="module" items="${course.modules}" varStatus="loop">
                        <details class="bg-white rounded-xl shadow-md overflow-hidden group border border-gray-200">
                            <summary class="flex justify-between items-center p-5 cursor-pointer bg-gray-100 hover:bg-gray-200 transition-colors duration-200">
                                <h4 class="text-lg font-semibold text-gray-800 flex items-center gap-3">
                                    <i class="fas fa-chevron-right text-gray-500 group-open:rotate-90 transition-transform duration-200"></i>
                                    Module ${loop.index + 1}: ${module.moduleName}
                                </h4>
                                <div class="flex items-center gap-4">
                                    <span class="text-sm text-gray-600 hidden md:inline">
                                        Last Update: <fmt:formatDate value="${module.moduleLastUpdate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </span>
                                    <form action="ManageCourse" method="post" class="inline-block"
                                          onsubmit="return confirm('Are you sure you want to delete this module? This will also delete all its materials.');">
                                        <input type="hidden" name="action" value="deleteModule"/>
                                        <input type="hidden" name="courseID" value="${course.courseID}"/>
                                        <input type="hidden" name="moduleID" value="${module.moduleID}"/>
                                        <button type="submit" class="text-red-600 hover:text-red-800 text-sm font-medium p-2 rounded-full hover:bg-red-100 transition-colors duration-200" title="Delete Module">
                                            <i class="fas fa-trash-alt"></i> <span class="hidden sm:inline">Delete Module</span>
                                        </button>
                                    </form>
                                </div>
                            </summary>
                            <div class="p-5 border-t border-gray-200 bg-white">
                                <p class="text-sm text-gray-600 mb-4">Module ID: ${module.moduleID}</p>

                                <!-- Materials List -->
                                <h5 class="text-md font-semibold text-gray-800 mb-3">Materials for this Module</h5>
                                <div class="table-container">
                                    <table class="min-w-full bg-white rounded-lg shadow-sm border border-gray-200 material-table">
                                        <thead>
                                        <tr class="bg-gray-100 text-gray-700 uppercase text-xs tracking-wider">
                                            <th class="px-4 py-3 text-left rounded-tl-lg">ID</th>
                                            <th class="px-4 py-3 text-left">Name</th>
                                            <th class="px-4 py-3 text-left">Type</th>
                                            <th class="px-4 py-3 text-left">Order</th>
                                            <th class="px-4 py-3 text-left">Time</th>
                                            <th class="px-4 py-3 text-left">Description</th>
                                            <th class="px-4 py-3 text-left">File/Link</th>
                                            <th class="px-4 py-3 text-left rounded-tr-lg">Actions</th>
                                        </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                        <c:forEach var="material" items="${module.materials}">
                                            <tr class="hover:bg-gray-50 transition-colors duration-150">
                                                <td class="px-4 py-3 text-gray-800">${material.materialId}</td>
                                                <td class="px-4 py-3 font-medium text-gray-900">${material.materialName}</td>
                                                <td class="px-4 py-3 text-gray-600">
                                                    <c:choose>
                                                        <c:when test="${material.type == 'VIDEO'}">Video</c:when>
                                                        <c:when test="${material.type == 'PDF'}">PDF Document</c:when>
                                                        <c:when test="${material.type == 'QUIZ'}">Quiz</c:when>
                                                        <c:when test="${material.type == 'LINK'}">External Link</c:when>
                                                        <c:otherwise>${material.type}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-4 py-3 text-gray-600">${material.materialOrder}</td>
                                                <td class="px-4 py-3 text-gray-600">
                                                    <c:choose>
                                                        <c:when test="${not empty material.time}">
                                                            <c:choose>
                                                                <c:when test="${material.time.length() <= 3 and material.time.trim().length() > 0}">
                                                                    ${material.time} minutes
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${material.time}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            -
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-4 py-3 text-gray-600 max-w-xs truncate">${material.materialDescription}</td>
                                                <td class="px-4 py-3 text-gray-600">
                                                    <c:if test="${not empty material.fileName}">
                                                        <div class="flex items-center gap-1">
                                                            <i class="fas fa-file-alt text-blue-500"></i>
                                                            <span>${material.fileName}</span>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty material.materialUrl}">
                                                        <div class="mt-1">
                                                            <a href="${material.materialUrl}" target="_blank" class="text-blue-600 hover:underline flex items-center gap-1">
                                                                <i class="fas fa-external-link-alt"></i> External Link
                                                            </a>
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td class="px-4 py-3 text-center">
                                                    <c:if test="${not empty material.pdfDataURI}">
                                                        <button onclick="showPdfPreview('${material.pdfDataURI}')"
                                                                class="text-blue-500 hover:text-blue-700 p-1 rounded hover:bg-blue-50 mr-2"
                                                                title="Preview PDF">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                    </c:if>
                                                    <form action="ManageCourse" method="post" class="inline-block"
                                                          onsubmit="return confirm('Are you sure you want to delete this material?');">
                                                        <input type="hidden" name="action" value="deleteMaterialAdmin"/>
                                                        <input type="hidden" name="courseID" value="${course.courseID}"/>
                                                        <input type="hidden" name="moduleID" value="${module.moduleID}"/>
                                                        <input type="hidden" name="materialID" value="${material.materialId}"/>
                                                        <button type="submit" class="text-red-500 hover:text-red-700 p-1 rounded hover:bg-red-100 transition-colors duration-200" title="Delete Material">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty module.materials}">
                                            <tr>
                                                <td colspan="8" class="px-4 py-3 text-center text-gray-500">
                                                    <div class="flex flex-col items-center justify-center py-4">
                                                        <i class="fas fa-folder-open text-gray-400 text-3xl mb-2"></i>
                                                        <p>No materials found for this module</p>
                                                        <a href="#" class="text-indigo-600 hover:text-indigo-800 mt-2 text-sm font-medium">
                                                            <i class="fas fa-plus mr-1"></i> Add Material
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </details>
                    </c:forEach>
                    <c:if test="${empty course.modules}">
                        <div class="bg-white rounded-xl shadow-md p-6 text-center text-gray-500 border border-gray-200">
                            <div class="flex flex-col items-center justify-center py-4">
                                <i class="fas fa-folder-open text-gray-400 text-4xl mb-3"></i>
                                <p class="text-lg mb-2">No modules found for this course</p>
                                <a href="#" class="text-indigo-600 hover:text-indigo-800 mt-2 text-sm font-medium">
                                    <i class="fas fa-plus mr-1"></i> Add Module
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </section>
        </main>
    </div>
</div>

<script>
    function showPdfPreview(dataUri) {
        const win = window.open();
        win.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>PDF Preview</title>
            <style>
                body { margin: 0; }
                iframe { width: 100%; height: 100vh; border: none; }
            </style>
        </head>
        <body>
            <iframe src="${dataUri}"></iframe>
        </body>
        </html>
    `);
    }
</script>
</body>
</html>
