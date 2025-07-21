<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Results - F-SKILL</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <style>
        #main-body {
            background-color: white;
            padding: 0;
            min-height: 100vh;
            box-sizing: border-box;
            padding-bottom: 50px;
        }

        .results-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .results-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .results-table th {
            border: none;
            padding: 1rem;
            font-weight: 600;
        }

        .results-table td {
            border: none;
            padding: 1rem;
            vertical-align: middle;
        }

        .results-table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .results-table tbody tr:hover {
            background-color: #e3f2fd;
            transition: background-color 0.3s ease;
        }

        .status-passed {
            background-color: #218334;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .status-failed {
            background-color: #B93636;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .btn-view {
            background-color: transparent;
            border: 1px solid #6c757d;
            color: #6c757d;
            padding: 6px 12px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .btn-view:hover {
            background-color: #6c757d;
            color: white;
        }

        .filter-card {
            background: linear-gradient(145deg, #ffffff, #f8f9fa);
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <%@include file="../../layout/header.jsp" %>
    <%@include file="../../layout/sidebar_user.jsp"%>

    <main id="main-body" class="main d-flex">
        <div class="mt-5 flex-fill" style="margin-top: 60px !important;">
            <div class="container-fluid px-4 py-4">
                <!-- Back to Test Management Button -->
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/instructor/tests?action=list" 
                       class="btn btn-outline-primary">
                        <i class="bi bi-arrow-left me-2"></i>Back to Test Management
                    </a>
                </div>

                <!-- Page Header -->
                <div class="page-header text-center">
                    <h1 class="display-6 mb-3">
                        <i class="bi bi-people-fill me-3"></i>
                        Student Test Results
                    </h1>
                    <p class="lead mb-0">View and manage test results from your students</p>
                </div>

                <!-- Course Filter -->
                <div class="card filter-card">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="bi bi-funnel text-primary me-2"></i>
                            Filter Results
                        </h5>
                        <form method="GET" action="${pageContext.request.contextPath}/instructor/tests">
                            <input type="hidden" name="action" value="studentResults">
                            <div class="row align-items-end">
                                <div class="col-md-8">
                                    <label class="form-label">Course</label>
                                    <select class="form-select" name="courseId">
                                        <option value="">All Courses</option>
                                        <c:forEach var="course" items="${instructorCourses}">
                                            <option value="${course.courseID}" 
                                                ${selectedCourseId == course.courseID ? 'selected' : ''}>
                                                ${course.courseName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-search me-2"></i>Filter
                                    </button>
                                    <a href="${pageContext.request.contextPath}/instructor/tests?action=studentResults" 
                                       class="btn btn-outline-secondary ms-2">
                                        <i class="bi bi-x-circle me-1"></i>Clear
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Results Table -->
                <div class="card">
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty studentResults}">
                                <div class="text-center py-5">
                                    <i class="bi bi-clipboard-x display-1 text-muted"></i>
                                    <h4 class="mt-3">No Results Found</h4>
                                    <p class="text-muted">No student test results available for the selected criteria.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover results-table mb-0">
                                        <thead>
                                            <tr>
                                                <th>No.</th>
                                                <th>Full Name</th>
                                                <th>Email</th>
                                                <th>Test Status</th>
                                                <th>Test Type</th>
                                                <th>Test Name</th>
                                                <th>Start Time</th>
                                                <th>End Time</th>
                                                <th>Score (%)</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="result" items="${studentResults}" varStatus="status">
                                                <tr>
                                                    <td class="fw-bold">${status.index + 1}</td>
                                                    <td>${result.fullName}</td>
                                                    <td>${result.email}</td>
                                                    <td>
                                                        <span class="${result.passed ? 'status-passed' : 'status-failed'}">
                                                            <i class="bi ${result.passed ? 'bi-check-circle' : 'bi-x-circle'} me-1"></i>
                                                            ${result.passed ? 'Passed' : 'Failed'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info">${result.testType}</span>
                                                    </td>
                                                    <td>${result.testName}</td>
                                                    <td>
                                                        <fmt:formatDate value="${result.dateTaken}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${result.dateTaken}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>
                                                    <td class="fw-bold">${result.result}%</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/instructor/tests?action=studentResultDetail&testResultId=${result.testResultID}" 
                                                           class="btn btn-view btn-sm" title="View Details">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </div>
    </main>

    <%@include file="../../layout/footer.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

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
</body>
</html>
