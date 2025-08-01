package controller;

import dao.*;
import model.*;
import model.Module;
import util.RoleRedirect;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * LearnerTestServlet handles all test-related functionality for learners
 *
 * @author Generated for learner test functionality
 */
@WebServlet("/learner/tests")
public class LearnerTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contextPath = request.getContextPath();
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        // Check if user is logged in and is a learner
        if (user == null || user.getRole() != Role.LEARNER) {
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
                    handleListTests(request, response, user);
                    break;
                case "detail":
                    handleTestDetail(request, response, user);
                    break;
                case "take":
                    handleTakeTest(request, response, user);
                    break;
                case "result":
                    handleTestResult(request, response, user);
                    break;
                case "getModules":
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    String courseIdStr = request.getParameter("courseId");
                    if (courseIdStr == null || courseIdStr.isEmpty()) {
                        response.getWriter().write("[]");
                        return;
                    }

                    try {
                        int courseId = Integer.parseInt(courseIdStr);
                        List<Module> modules = new ModuleDAO().getAllModuleByCourseID(courseId);

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
                default:
                    handleListTests(request, response, user);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("err", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contextPath = request.getContextPath();
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in and is a learner
        if (user == null || user.getRole() != Role.LEARNER) {
            response.sendRedirect(contextPath + "/homePage_Guest.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "submit":
                    handleSubmitTest(request, response, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/learner/tests");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("err", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Handle test list view
     */
    private void handleListTests(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        TestDAO testDAO = new TestDAO();
        CourseDAO courseDAO = new CourseDAO();
        ModuleDAO moduleDAO = new ModuleDAO();
        TestResultDAO testResultDAO = new TestResultDAO();

        // Get filter parameters
        String courseIdStr = request.getParameter("courseId");
        String moduleIdStr = request.getParameter("moduleId");
        Integer courseId = null;
        Integer moduleId = null;

        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            courseId = Integer.parseInt(courseIdStr);
        }
        if (moduleIdStr != null && !moduleIdStr.isEmpty()) {
            moduleId = Integer.parseInt(moduleIdStr);
        }

        // Get tests for learner with filters
        List<Test> tests;
        if (courseId != null || moduleId != null) {
            tests = testDAO.getFilteredTestsForLearner(user.getUserId(), courseId, moduleId);
        } else {
            tests = testDAO.getTestsForLearner(user.getUserId());
        }

        // Get enrolled courses for filter dropdown
        List<Course> enrolledCourses = testDAO.getCourseByEnrollID(user.getUserId());

        // Get modules for selected course
        List<Module> modules = new ArrayList<>();
        if (courseId != null) {
            modules = moduleDAO.getAllModuleByCourseID(courseId);
        }

        // Add latest test results to each test for Take/Retake button logic and status badges
        for (Test test : tests) {
            TestResult latestResult = testResultDAO.getLatestTestResult(test.getTestID(), user.getUserId());
            test.setLatestResult(latestResult); // Store latest result in test object
        }

        request.setAttribute("tests", tests);
        request.setAttribute("enrolledCourses", enrolledCourses);
        request.setAttribute("modules", modules);
        request.setAttribute("selectedCourseId", courseId);
        request.setAttribute("selectedModuleId", moduleId);

        request.getRequestDispatcher("/WEB-INF/views/learnerListTest.jsp").forward(request, response);
    }

    /**
     * Handle test detail view
     */
    private void handleTestDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String testIdStr = request.getParameter("testId");
        if (testIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/learner/tests");
            return;
        }

        int testId = Integer.parseInt(testIdStr);
        TestDAO testDAO = new TestDAO();
        TestResultDAO testResultDAO = new TestResultDAO();
        QuestionDAO questionDAO = new QuestionDAO();

        // Check if learner is enrolled in this test's course
        if (!testDAO.isLearnerEnrolledInTest(testId, user.getUserId())) {
            request.setAttribute("err", "You are not enrolled in this test's course.");
            handleListTests(request, response, user);
            return;
        }

        // Get test details
        Test test = testDAO.getTestByID(testId);
        if (test == null) {
            request.setAttribute("err", "Test not found.");
            handleListTests(request, response, user);
            return;
        }

        // Get question count
        int questionCount = questionDAO.getQuestionCountForTest(testId);
        test.setQuestionCount(questionCount);

        // Get latest test result
        TestResult latestResult = testResultDAO.getLatestTestResult(testId, user.getUserId());

        // Get test history for learner
        List<TestResult> testHistory = testResultDAO.getTestResults(testId, user.getUserId());

        request.setAttribute("test", test);
        request.setAttribute("latestResult", latestResult);
        request.setAttribute("testHistory", testHistory);

        request.getRequestDispatcher("/WEB-INF/views/learnerTestDetail.jsp").forward(request, response);
    }

    /**
     * Handle take test view
     */
    private void handleTakeTest(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String testIdStr = request.getParameter("testId");
        if (testIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/learner/tests");
            return;
        }

        int testId = Integer.parseInt(testIdStr);
        TestDAO testDAO = new TestDAO();
        QuestionDAO questionDAO = new QuestionDAO();

        // Check if learner is enrolled in this test's course
        if (!testDAO.isLearnerEnrolledInTest(testId, user.getUserId())) {
            request.setAttribute("err", "You are not enrolled in this test's course.");
            handleListTests(request, response, user);
            return;
        }

        // Get test details
        Test test = testDAO.getTestByID(testId);
        if (test == null) {
            request.setAttribute("err", "Test not found.");
            handleListTests(request, response, user);
            return;
        }

        // Get questions (randomized if test setting is enabled)
        List<Question> questions = questionDAO.getQuestionsForTest(testId, test.isRandomize());

        request.setAttribute("test", test);
        request.setAttribute("questions", questions);

        request.getRequestDispatcher("/WEB-INF/views/learnerTakeTest.jsp").forward(request, response);
    }

    /**
     * Handle test submission
     */
    private void handleSubmitTest(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String testIdStr = request.getParameter("testId");
        if (testIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/learner/tests");
            return;
        }

        int testId = Integer.parseInt(testIdStr);
        TestDAO testDAO = new TestDAO();
        QuestionDAO questionDAO = new QuestionDAO();
        TestResultDAO testResultDAO = new TestResultDAO();
        UserAnswerDAO userAnswerDAO = new UserAnswerDAO();
        if (!testDAO.isLearnerEnrolledInTest(testId, user.getUserId())) {
            request.setAttribute("err", "You are not enrolled in this test's course.");
            handleListTests(request, response, user);
            return;
        }

        // Get test and questions
        Test test = testDAO.getTestByID(testId);
        List<Question> questions = questionDAO.getQuestionsByTestID(testId);

        // Calculate score
        int totalPoints = 0;
        int earnedPoints = 0;
        List<UserAnswer> userAnswers = new ArrayList<>();

        for (Question question : questions) {
            totalPoints += question.getPoint();

            String userAnswer = "";

// MULTIPLE: dùng getParameterValues để lấy tất cả đáp án học viên chọn
            if ("MULTIPLE".equals(question.getQuestionType())) {
                String[] selected = request.getParameterValues("answer_" + question.getQuestionID());
                if (selected != null) {
                    userAnswer = String.join(",", selected);  // sẽ ra "1,3" hoặc "2,4", v.v.
                }
            } else {
                userAnswer = request.getParameter("answer_" + question.getQuestionID());
            }

            if (userAnswer == null) {
                userAnswer = "";
            }

            String answerToStore = ""; // This will be the letter format to store in database
            boolean isCorrect = false;

            if (question.getQuestionType().equals("CHOICE")) {
                // Map user answer (1,2,3,4) to option letters (A,B,C,D)
                switch (userAnswer) {
                    case "1":
                        answerToStore = "A";
                        break;
                    case "2":
                        answerToStore = "B";
                        break;
                    case "3":
                        answerToStore = "C";
                        break;
                    case "4":
                        answerToStore = "D";
                        break;
                    default:
                        answerToStore = ""; // No answer selected
                }
                isCorrect = answerToStore.equals(question.getRightOption());

            } else if (question.getQuestionType().equals("MULTIPLE")) {
                // Handle multiple choice answers (userAnswer could be "1,3" for A,C)
                if (!userAnswer.trim().isEmpty()) {
                    String[] userSelections = userAnswer.split(",");
                    StringBuilder selectedOptions = new StringBuilder();
                    for (String selection : userSelections) {
                        String letter = "";
                        switch (selection.trim()) {
                            case "1":
                                letter = "A";
                                break;
                            case "2":
                                letter = "B";
                                break;
                            case "3":
                                letter = "C";
                                break;
                            case "4":
                                letter = "D";
                                break;
                        }
                        if (!letter.isEmpty()) {
                            if (selectedOptions.length() > 0) {
                                selectedOptions.append(",");
                            }
                            selectedOptions.append(letter);
                        }
                    }
                    answerToStore = selectedOptions.toString();
                } else {
                    answerToStore = ""; // No answers selected
                }

                // Compare selected options with correct options
                if (!answerToStore.isEmpty() && !question.getRightOption().isEmpty()) {
                    String[] correctOptions = question.getRightOption().split(",");
                    String[] selectedOptionsArray = answerToStore.split(",");
                    Arrays.sort(correctOptions);
                    Arrays.sort(selectedOptionsArray);
                    isCorrect = Arrays.equals(correctOptions, selectedOptionsArray);
                }

            } else if (question.getQuestionType().equals("WRITING")) {
                answerToStore = userAnswer; // Store the text as-is for writing questions
                // For writing questions, manual grading is typically required
                // This logic might need to be adjusted based on your requirements
                isCorrect = false; // Writing questions should be manually graded
            }

            if (isCorrect) {
                earnedPoints += question.getPoint();
            }

            UserAnswer ua = new UserAnswer();
            ua.setQuestionID(question.getQuestionID());
            ua.setUserID(user.getUserId());
            ua.setAnswer(answerToStore); // Store the converted letter format
            ua.setCorrected(isCorrect);
            userAnswers.add(ua);
        }

        // Calculate percentage and pass status
        int percentage = totalPoints > 0 ? (earnedPoints * 100) / totalPoints : 0;
        boolean isPassed = percentage >= test.getPassPercentage();

        // Get next attempt number
        int attempt = testResultDAO.getNextAttempt(testId, user.getUserId());

        // Create test result
        TestResult testResult = new TestResult();
        testResult.setTestID(testId);
        testResult.setUserID(user.getUserId());
        testResult.setAttempt(attempt);
        testResult.setResult(percentage);
        testResult.setPassed(isPassed);
        testResult.setDateTaken(new java.sql.Timestamp(System.currentTimeMillis()));

        // Save test result
        int testResultId = testResultDAO.insertTestResult(testResult);
        if (testResultId > 0) {
            // Set test result ID for user answers
            for (UserAnswer ua : userAnswers) {
                ua.setTestResultID(testResultId);
            }

            // Save user answers
            userAnswerDAO.insertUserAnswers(userAnswers);
        }

        // Redirect to test result
        response.sendRedirect(request.getContextPath() + "/learner/tests?action=result&testResultId=" + testResultId);
    }

    /**
     * Handle test result view
     */
    private void handleTestResult(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String testResultIdStr = request.getParameter("testResultId");
        if (testResultIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/learner/tests");
            return;
        }

        int testResultId = Integer.parseInt(testResultIdStr);
        TestResultDAO testResultDAO = new TestResultDAO();
        TestDAO testDAO = new TestDAO();
        UserAnswerDAO userAnswerDAO = new UserAnswerDAO();

        // Get test result
        TestResult testResult = testResultDAO.getTestResultByID(testResultId);
        if (testResult == null || testResult.getUserID() != user.getUserId()) {
            request.setAttribute("err", "Test result not found or access denied.");
            handleListTests(request, response, user);
            return;
        }

        // Get test details
        Test test = testDAO.getTestByID(testResult.getTestID());

        // Get user answers with question details
        List<UserAnswer> userAnswers = userAnswerDAO.getUserAnswersWithQuestions(testResultId);

        // Calculate statistics for display
        int totalQuestions = userAnswers.size();
        int correctAnswers = 0;
        for (UserAnswer ua : userAnswers) {
            if (ua.isCorrected()) {
                correctAnswers++;
            }
        }

        request.setAttribute("testResult", testResult);
        request.setAttribute("test", test);
        request.setAttribute("userAnswers", userAnswers);
        request.setAttribute("totalQuestions", totalQuestions);
        request.setAttribute("correctAnswers", correctAnswers);

        request.getRequestDispatcher("/WEB-INF/views/learnerTestResult.jsp").forward(request, response);
    }
}
