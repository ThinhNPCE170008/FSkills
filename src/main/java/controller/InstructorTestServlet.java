package controller;

import dao.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.*;
import model.Module;

/**
 * InstructorTestServlet - CRUD operations for Tests and Questions
 * @author Generated for Test Management functionality
 */
@WebServlet(name = "InstructorTestServlet", urlPatterns = {"/instructor/tests"})
public class InstructorTestServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet InstructorTestServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InstructorTestServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contextPath = request.getContextPath();
        HttpSession session = request.getSession();

        TestDAO testDAO = new TestDAO();
        QuestionDAO questionDAO = new QuestionDAO();
        ModuleDAO moduleDAO = new ModuleDAO();
        UserDAO userDAO = new UserDAO();

        User acc = (User) session.getAttribute("user");
        if (acc == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        if (acc.getRole() != Role.INSTRUCTOR) {
            response.sendRedirect(contextPath + "/homePage_Guest.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    CourseDAO courseDAO = new CourseDAO();
                    List<Course> courses = courseDAO.getCourseByUserID(acc.getUserId());
                    request.setAttribute("courses", courses);

                    // Handle filtering
                    String filterCourseIdStr = request.getParameter("filterCourseId");
                    String filterModuleIdStr = request.getParameter("filterModuleId");

                    List<Test> testList;

                    if (filterModuleIdStr != null && !filterModuleIdStr.isEmpty()) {
                        // Filter by specific module
                        int moduleId = Integer.parseInt(filterModuleIdStr);
                        testList = testDAO.getTestsByModuleID(moduleId);

                        // Also load modules for the selected course to repopulate dropdown
                        if (filterCourseIdStr != null && !filterCourseIdStr.isEmpty()) {
                            int courseId = Integer.parseInt(filterCourseIdStr);
                            List<Module> filterModules = moduleDAO.getAllModuleByCourseID(courseId);
                            request.setAttribute("filterModules", filterModules);
                        }
                    } else if (filterCourseIdStr != null && !filterCourseIdStr.isEmpty()) {
                        // Filter by course (all modules in course)
                        int courseId = Integer.parseInt(filterCourseIdStr);
                        List<Module> modulesByCourse = moduleDAO.getAllModuleByCourseID(courseId);
                        testList = new ArrayList<>();
                        for (Module module : modulesByCourse) {
                            testList.addAll(testDAO.getTestsByModuleID(module.getModuleID()));
                        }

                        // Load modules for dropdown
                        request.setAttribute("filterModules", modulesByCourse);
                    } else {
                        // No filter - get all tests for instructor
                        testList = testDAO.getTestsByInstructorID(acc.getUserId());
                    }

                    // Add question counts to each test
                    for (Test test : testList) {
                        int questionCount = questionDAO.getQuestionCountForTest(test.getTestID());
                        test.setQuestionCount(questionCount);
                    }

                    request.setAttribute("listTest", testList);
                    request.getRequestDispatcher("/WEB-INF/views/instructorListTests.jsp").forward(request, response);
                    break;

                case "listByModule":
                    String moduleIdStr = request.getParameter("moduleId");
                    if (moduleIdStr == null || moduleIdStr.isEmpty()) {
                        response.sendRedirect(contextPath + "/instructor/tests?action=list");
                        return;
                    }

                    int moduleId = Integer.parseInt(moduleIdStr);
                    Module module = moduleDAO.getModuleByID(moduleId);
                    List<Test> moduleTests = testDAO.getTestsByModuleID(moduleId);

                    // Add question counts to each test
                    for (Test test : moduleTests) {
                        int questionCount = questionDAO.getQuestionCountForTest(test.getTestID());
                        test.setQuestionCount(questionCount);
                    }

                    request.setAttribute("module", module);
                    request.setAttribute("listTest", moduleTests);
                    request.getRequestDispatcher("/WEB-INF/views/instructorListTests.jsp").forward(request, response);
                    break;

                case "create":
                    List<Course> coursesByUser =  new CourseDAO().getCourseByUserID(acc.getUserId());
                    request.setAttribute("courses", coursesByUser);

                    List<Test> allTestsByInstructor = testDAO.getTestsByInstructorID(acc.getUserId());
                    request.setAttribute("allTestsByInstructor", allTestsByInstructor);

                    request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
                    break;

                case "update":
                    String testIdUpdate = request.getParameter("testId");
                    if (testIdUpdate == null || testIdUpdate.isEmpty()) {
                        response.sendRedirect(contextPath + "/instructor/tests?action=list");
                        return;
                    }

                    int testId = Integer.parseInt(testIdUpdate);

                    // Check if test belongs to instructor
                    if (!testDAO.isTestOwnedByInstructor(testId, acc.getUserId())) {
                        response.sendRedirect(contextPath + "/instructor/tests?action=list");
                        return;
                    }

                    Test testToUpdate = testDAO.getTestByID(testId);
                    List<Question> questions = questionDAO.getQuestionsByTestID(testId);

                    request.setAttribute("test", testToUpdate);
                    request.setAttribute("questions", questions);
                    request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
                    break;

                case "view":
                    String testIdView = request.getParameter("testId");
                    if (testIdView == null || testIdView.isEmpty()) {
                        response.sendRedirect(contextPath + "/instructor/tests?action=list");
                        return;
                    }

                    int viewTestId = Integer.parseInt(testIdView);

                    // Check if test belongs to instructor
                    if (!testDAO.isTestOwnedByInstructor(viewTestId, acc.getUserId())) {
                        response.sendRedirect(contextPath + "/instructor/tests?action=list");
                        return;
                    }

                    Test testToView = testDAO.getTestByID(viewTestId);
                    List<Question> viewQuestions = questionDAO.getQuestionsByTestID(viewTestId);
                    int totalPoints = questionDAO.getTotalPointsForTest(viewTestId);
                    int questionCount = questionDAO.getQuestionCountForTest(viewTestId);

                    request.setAttribute("test", testToView);
                    request.setAttribute("questions", viewQuestions);
                    request.setAttribute("totalPoints", totalPoints);
                    request.setAttribute("questionCount", questionCount);
                    request.getRequestDispatcher("/WEB-INF/views/instructorViewTest.jsp").forward(request, response);
                    break;

                case "getModules":
                    // API endpoint to get modules by course ID
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    String courseIdStr = request.getParameter("courseId");
                    if (courseIdStr == null || courseIdStr.isEmpty()) {
                        response.getWriter().write("[]");
                        return;
                    }

                    try {
                        int courseId = Integer.parseInt(courseIdStr);
                        List<Module> modules = moduleDAO.getAllModuleByCourseID(courseId);

                        StringBuilder json = new StringBuilder();
                        json.append("[");
                        for (int i = 0; i < modules.size(); i++) {
                            Module m = modules.get(i);
                            json.append("{");
                            json.append("\"moduleID\":").append(m.getModuleID()).append(",");
                            json.append("\"moduleName\":\"").append(m.getModuleName().replace("\"", "\\\"")).append("\"");
                            json.append("}");
                            if (i < modules.size() - 1) {
                                json.append(",");
                            }
                        }
                        json.append("]");

                        response.getWriter().write(json.toString());
                    } catch (NumberFormatException e) {
                        response.getWriter().write("[]");
                    }
                    break;

                case "checkTestOrder":
                    // API endpoint to check if test order already exists in module
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    String checkModuleIdStr = request.getParameter("moduleId");
                    String checkTestOrderStr = request.getParameter("testOrder");
                    String existingTestIdStr = request.getParameter("testId"); // For update operations

                    try {
                        if (checkTestOrderStr == null || checkTestOrderStr.isEmpty()) {
                            response.getWriter().write("{\"exists\": false}");
                            return;
                        }

                        int checkModuleId = -1;
                        int checkTestOrder = Integer.parseInt(checkTestOrderStr);
                        int existingTestId = existingTestIdStr != null && !existingTestIdStr.isEmpty()
                                ? Integer.parseInt(existingTestIdStr) : -1;

                        // If moduleId is provided, use it directly
                        if (checkModuleIdStr != null && !checkModuleIdStr.isEmpty()) {
                            checkModuleId = Integer.parseInt(checkModuleIdStr);
                        }
                        // If testId is provided but moduleId is not, get moduleId from test
                        else if (existingTestId > 0) {
                            Test existingTest = testDAO.getTestByID(existingTestId);
                            if (existingTest != null) {
                                checkModuleId = existingTest.getModuleID();
                            }
                        }

                        if (checkModuleId <= 0) {
                            response.getWriter().write("{\"exists\": false}");
                            return;
                        }

                        boolean exists = testDAO.checkTestOrderExists(checkModuleId, checkTestOrder, existingTestId);
                        response.getWriter().write("{\"exists\": " + exists + "}");
                    } catch (NumberFormatException e) {
                        response.getWriter().write("{\"exists\": false}");
                    }
                    break;

                case "studentResults":
                    handleStudentResults(request, response, acc);
                    break;

                case "studentResultDetail":
                    handleStudentResultDetail(request, response, acc);
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in InstructorTestServlet doGet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        TestDAO testDAO = new TestDAO();
        QuestionDAO questionDAO = new QuestionDAO();
        UserDAO userDAO = new UserDAO();

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("user");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (acc.getRole() != Role.INSTRUCTOR) {
            response.sendRedirect(request.getContextPath() + "/homePage_Guest.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    handleCreateTest(request, response, testDAO, questionDAO, acc, session);
                    break;

                case "update":
                    handleUpdateTest(request, response, testDAO, questionDAO, acc, session);
                    break;

                case "delete":
                    handleDeleteTest(request, response, testDAO, acc, session);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in InstructorTestServlet doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("err", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/instructorListTests.jsp").forward(request, response);
        }
    }

    private void handleCreateTest(HttpServletRequest request, HttpServletResponse response,
                                  TestDAO testDAO, QuestionDAO questionDAO, User acc, HttpSession session)
            throws ServletException, IOException {

        String moduleIdStr = request.getParameter("moduleId");
        String testName = request.getParameter("testName");
        String testOrderStr = request.getParameter("testOrder");
        String passPercentageStr = request.getParameter("passPercentage");
        String requiredCorrectAnswersStr = request.getParameter("requiredCorrectAnswers");
        String isRandomizeStr = request.getParameter("isRandomize");
        String showAnswerStr = request.getParameter("showAnswer");

        // Validation
        if (moduleIdStr == null || moduleIdStr.isEmpty()) {
            request.setAttribute("err", "Module ID is required.");
            request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
            return;
        }

        if (testName == null || testName.trim().isEmpty()) {
            request.setAttribute("err", "Test name is required.");
            request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
            return;
        }

        try {
            int moduleId = Integer.parseInt(moduleIdStr);
            int testOrder = Integer.parseInt(testOrderStr);
            //int passPercentage = Integer.parseInt(passPercentageStr);
            int requiredCorrectAnswers = Integer.parseInt(requiredCorrectAnswersStr);
            boolean isRandomize = "1".equals(isRandomizeStr);
            boolean showAnswer = "1".equals(showAnswerStr);

            // if (passPercentage < 0 || passPercentage > 100) {
            //     request.setAttribute("err", "Pass percentage must be between 0 and 100.");
            //     request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
            //     return;
            // }
            String questionCountStr = request.getParameter("questionCount");
            if (questionCountStr == null || questionCountStr.isEmpty()) {
                request.setAttribute("err", "Question count is required.");
                request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
                return;
            }
            int questionCount = Integer.parseInt(questionCountStr);
            if (questionCount < 1) {
                request.setAttribute("err", "Question count must be at least 1.");
                request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
                return;
            }

            if (requiredCorrectAnswers < 1) {
                request.setAttribute("err", "Required correct answers must be at least 1.");
                request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
                return;
            }
            int passPercentage = (requiredCorrectAnswers * 100) / questionCount;
            // Check if test order already exists
            if (testDAO.checkTestNameExists(moduleId, testName)) {
                request.setAttribute("err", "Test name '" + testName + "' already exists in this module. Please choose a different name.");
                request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
                return;
            }

            if (testDAO.checkTestOrderExists(moduleId, testOrder, -1)) {
                request.setAttribute("err", "Test order " + testOrder + " already exists in this module. Please choose a different order.");
                request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
                return;
            }

            // Create test
            Test test = new Test();
            test.setModuleID(moduleId);
            test.setTestName(testName.trim());
            test.setTestOrder(testOrder);
            test.setPassPercentage(passPercentage);
            test.setRandomize(isRandomize);
            test.setShowAnswer(showAnswer);

            int testId = testDAO.insertTest(test);

            if (testId > 0) {
                List<Question> questions = parseQuestions(request, testId);
                if (!questions.isEmpty()) {
                    questionDAO.insertQuestions(questions);
                }

                session.setAttribute("success", "Test created successfully!");
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
            } else {
                request.setAttribute("err", "Failed to create test.");
                request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("err", "Invalid number format.");
            request.getRequestDispatcher("/WEB-INF/views/instructorCreateTest.jsp").forward(request, response);
        }
    }

    private void handleUpdateTest(HttpServletRequest request, HttpServletResponse response,
                                  TestDAO testDAO, QuestionDAO questionDAO, User acc, HttpSession session)
            throws ServletException, IOException {

        String testIdStr = request.getParameter("testId");
        String testName = request.getParameter("testName");
        String testOrderStr = request.getParameter("testOrder");
        String requiredCorrectAnswersStr = request.getParameter("requiredCorrectAnswers");
        String isRandomizeStr = request.getParameter("isRandomize");
        String showAnswerStr = request.getParameter("showAnswer");
        String questionCountStr = request.getParameter("questionCount");
        if (questionCountStr == null || questionCountStr.isEmpty()) {
            request.setAttribute("err", "Question count is required.");
            request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
            return;
        }
        int questionCount = Integer.parseInt(questionCountStr);
        if (questionCount < 1) {
            request.setAttribute("err", "Question count must be at least 1.");
            request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
            return;
        }

        try {
            int testId = Integer.parseInt(testIdStr);

            // Check ownership
            if (!testDAO.isTestOwnedByInstructor(testId, acc.getUserId())) {
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
                return;
            }

            Test existingTest = testDAO.getTestByID(testId);
            if (existingTest == null) {
                request.setAttribute("err", "Test not found.");
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
                return;
            }

            if (testName == null || testName.trim().isEmpty()) {
                request.setAttribute("err", "Test name is required.");
                request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
                return;
            }

            int testOrder = Integer.parseInt(testOrderStr);
            int requiredCorrectAnswers = Integer.parseInt(requiredCorrectAnswersStr);
            boolean isRandomize = "1".equals(isRandomizeStr);
            boolean showAnswer = "1".equals(showAnswerStr);

//            if (passPercentage < 0 || passPercentage > 100) {
//                request.setAttribute("err", "Pass percentage must be between 0 and 100.");
//                request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
//                return;
//            }

            if (requiredCorrectAnswers < 1) {
                request.setAttribute("err", "Required correct answers must be at least 1.");
                request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
                return;
            }
            int passPercentage = (requiredCorrectAnswers * 100) / questionCount;
            // Check if test order already exists (excluding current test)
            if (testDAO.checkTestOrderExists(existingTest.getModuleID(), testOrder, testId)) {
                request.setAttribute("err", "Test order " + testOrder + " already exists in this module. Please choose a different order.");
                request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
                return;
            }

            // Update test
            existingTest.setTestName(testName.trim());
            existingTest.setTestOrder(testOrder);
            existingTest.setPassPercentage(passPercentage);
            existingTest.setRandomize(isRandomize);
            existingTest.setShowAnswer(showAnswer);

            int updateResult = testDAO.updateTest(existingTest);

            if (updateResult > 0) {
                // Delete existing questions and insert new ones
                questionDAO.deleteQuestionsByTestID(testId);

                List<Question> questions = parseQuestions(request, testId);
                if (!questions.isEmpty()) {
                    questionDAO.insertQuestions(questions);
                }

                session.setAttribute("success", "Test updated successfully!");
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
            } else {
                request.setAttribute("err", "Failed to update test.");
                request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("err", "Invalid number format.");
            request.getRequestDispatcher("/WEB-INF/views/instructorUpdateTest.jsp").forward(request, response);
        }
    }

    private void handleDeleteTest(HttpServletRequest request, HttpServletResponse response,
                                  TestDAO testDAO, User acc, HttpSession session)
            throws ServletException, IOException {

        String testIdStr = request.getParameter("testId");

        try {
            int testId = Integer.parseInt(testIdStr);

            // Check ownership
            if (!testDAO.isTestOwnedByInstructor(testId, acc.getUserId())) {
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
                return;
            }

            Test test = testDAO.getTestByID(testId);
            if (test == null) {
                request.setAttribute("err", "Test not found.");
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
                return;
            }

            int moduleId = test.getModuleID();
            int deleteResult = testDAO.deleteTest(testId);

            if (deleteResult > 0) {
                session.setAttribute("success", "Test deleted successfully!");
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
            } else {
                session.setAttribute("err", "Failed to delete test.");
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("err", "Invalid test ID.");
            response.sendRedirect(request.getContextPath() + "/instructor/tests?action=list");
        }
    }

    private List<Question> parseQuestions(HttpServletRequest request, int testId) {
        List<Question> questions = new ArrayList<>();

        // Get question count
        String questionCountStr = request.getParameter("questionCount");
        if (questionCountStr == null || questionCountStr.isEmpty()) {
            return questions;
        }

        try {
            int questionCount = Integer.parseInt(questionCountStr);

            for (int i = 1; i <= questionCount; i++) {
                String question = request.getParameter("question_" + i);
                String option1 = request.getParameter("option1_" + i);
                String option2 = request.getParameter("option2_" + i);
                String option3 = request.getParameter("option3_" + i);
                String option4 = request.getParameter("option4_" + i);
                String rightOption = request.getParameter("rightOption_" + i);
                String writingAnswer = request.getParameter("writingAnswer_" + i);
                String pointStr = request.getParameter("point_" + i);
                String questionType = request.getParameter("questionType_" + i);

                // Skip empty questions
                if (question == null || question.trim().isEmpty()) {
                    continue;
                }

                int point = 1; // default
                try {
                    if (pointStr != null && !pointStr.isEmpty()) {
                        point = Integer.parseInt(pointStr);
                    }
                } catch (NumberFormatException e) {
                    point = 1;
                }

                if (questionType == null || questionType.isEmpty()) {
                    questionType = "CHOICE";
                }

                // Handle MULTIPLE choice answers
                if ("MULTIPLE".equals(questionType)) {
                    String[] selectedOptions = request.getParameterValues("multipleChoice_" + i);
                    rightOption = (selectedOptions != null) ? String.join(",", selectedOptions) : "";
                } else if ("WRITING".equals(questionType) && writingAnswer != null && !writingAnswer.trim().isEmpty()) {
                    rightOption = writingAnswer.trim();
                }

                Question q = new Question();
                q.setTestID(testId);
                q.setPoint(point);
                q.setQuestionOrder(i);
                q.setQuestionType(questionType);
                q.setQuestion(question.trim());
                q.setOption1(option1 != null ? option1.trim() : "");
                q.setOption2(option2 != null ? option2.trim() : "");
                q.setOption3(option3 != null ? option3.trim() : "");
                q.setOption4(option4 != null ? option4.trim() : "");
                q.setRightOption(rightOption != null ? rightOption.trim() : "A");

                questions.add(q);
            }
        } catch (NumberFormatException e) {
            System.out.println("Error parsing question count: " + e.getMessage());
        }

        return questions;
    }

    /**
     * Handle student results list view
     */
    private void handleStudentResults(HttpServletRequest request, HttpServletResponse response, User instructor)
            throws ServletException, IOException {
        TestResultDAO testResultDAO = new TestResultDAO();
        CourseDAO courseDAO = new CourseDAO();

        // Get course filter parameter
        String courseIdStr = request.getParameter("courseId");
        Integer courseId = null;
        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            try {
                courseId = Integer.parseInt(courseIdStr);
            } catch (NumberFormatException e) {
                courseId = null;
            }
        }

        // Get student results for instructor
        List<TestResult> studentResults = testResultDAO.getStudentResultsForInstructor(instructor.getUserId(), courseId);

        // Get instructor's courses for filter dropdown
        List<Course> instructorCourses = courseDAO.getCourseByUserID(instructor.getUserId());

        request.setAttribute("studentResults", studentResults);
        request.setAttribute("instructorCourses", instructorCourses);
        request.setAttribute("selectedCourseId", courseId);

        request.getRequestDispatcher("/WEB-INF/views/instructorLearnerResults.jsp").forward(request, response);
    }

    /**
     * Handle student result detail view
     */
// ... toàn bộ phần đầu file giữ nguyên như bạn đã gửi ...

    private void handleStudentResultDetail(HttpServletRequest request, HttpServletResponse response, User instructor)
            throws ServletException, IOException {
        String testResultIdStr = request.getParameter("testResultId");
        if (testResultIdStr == null || testResultIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/instructor/tests?action=studentResults");
            return;
        }

        try {
            int testResultId = Integer.parseInt(testResultIdStr);
            TestResultDAO testResultDAO = new TestResultDAO();
            UserAnswerDAO userAnswerDAO = new UserAnswerDAO();
            QuestionDAO questionDAO = new QuestionDAO();

            // Lấy chi tiết kết quả bài làm của học viên
            TestResult studentResult = testResultDAO.getStudentResultDetail(testResultId, instructor.getUserId());
            if (studentResult == null) {
                request.setAttribute("err", "Result not found or access denied.");
                response.sendRedirect(request.getContextPath() + "/instructor/tests?action=studentResults");
                return;
            }

            // Lấy danh sách câu trả lời kèm theo question đầy đủ thông tin
            List<UserAnswer> userAnswers = userAnswerDAO.getUserAnswersWithQuestions(testResultId);
            for (UserAnswer ua : userAnswers) {
                Question fullQ = questionDAO.getQuestionByID(ua.getQuestion().getQuestionID());
                ua.setQuestion(fullQ);
            }

            request.setAttribute("studentResult", studentResult);
            request.setAttribute("userAnswers", userAnswers);

            request.getRequestDispatcher("/WEB-INF/views/instructorLearnerResultsDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/instructor/tests?action=studentResults");
        }
    }


    /**
     * Returns a short description of the servlet.
     */
    @Override
    public String getServletInfo() {
        return "InstructorTestServlet for Test and Question CRUD operations";
    }
}