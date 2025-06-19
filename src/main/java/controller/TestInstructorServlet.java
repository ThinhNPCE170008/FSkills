/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.TestDAO;
import java.io.IOException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import model.Test;
import model.User;

/**
 *
 * @author AI Assistant
 */
@WebServlet(name = "TestInstructorServlet", urlPatterns = {"/instructor/tests"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class TestInstructorServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in and is an instructor or admin
        if (user == null || (user.getRole() != model.Role.INSTRUCTOR && user.getRole() != model.Role.ADMIN)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        TestDAO testDAO = new TestDAO();

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                // Get all tests for this instructor
                System.out.println("TestInstructorServlet: Getting all tests for instructor ID: " + user.getUserId());
                List<Test> tests = testDAO.getAllTestsByInstructor(user.getUserId());
                System.out.println("TestInstructorServlet: Retrieved " + tests.size() + " tests for instructor ID: " + user.getUserId());

                // Log each test for debugging
                for (Test test : tests) {
                    System.out.println("TestInstructorServlet: Test ID=" + test.getTestId() + ", Name=" + test.getTestName());
                }

                request.setAttribute("tests", tests);
                request.getRequestDispatcher("/WEB-INF/views/testInstructor.jsp").forward(request, response);
                break;

            case "edit":
                // Get test by ID for editing
                String testIdParam = request.getParameter("id");
                if (testIdParam != null && !testIdParam.isEmpty()) {
                    try {
                        int testId = Integer.parseInt(testIdParam);
                        Test test = testDAO.getTestById(testId);

                        // Check if test exists and belongs to this instructor
                        if (test != null && test.getUserId() == user.getUserId()) {
                            request.setAttribute("test", test);
                            request.setAttribute("action", "edit");
                            request.getRequestDispatcher("/WEB-INF/views/testInstructor.jsp").forward(request, response);
                        } else {
                            // Test not found or doesn't belong to this instructor
                            request.setAttribute("errorMessage", "Test not found or you don't have permission to edit it.");
                            response.sendRedirect(request.getContextPath() + "/instructor/tests");
                        }
                    } catch (NumberFormatException e) {
                        response.sendRedirect(request.getContextPath() + "/instructor/tests");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/instructor/tests");
                }
                break;

            case "create":
                // Show create test form
                request.setAttribute("action", "create");
                request.getRequestDispatcher("/WEB-INF/views/testInstructor.jsp").forward(request, response);
                break;

            case "upload":
                // Show upload document form
                request.setAttribute("action", "upload");
                request.getRequestDispatcher("/WEB-INF/views/testInstructor.jsp").forward(request, response);
                break;

            case "generate":
                // Show generate from text form
                request.setAttribute("action", "generate");
                request.getRequestDispatcher("/WEB-INF/views/testInstructor.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/instructor/tests");
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in and is an instructor or admin
        if (user == null || (user.getRole() != model.Role.INSTRUCTOR && user.getRole() != model.Role.ADMIN)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        TestDAO testDAO = new TestDAO();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/instructor/tests");
            return;
        }

        switch (action) {
            case "create":
                // Create a new test
                try {
                    String testName = request.getParameter("testName");
                    String description = request.getParameter("description");
                    int duration = Integer.parseInt(request.getParameter("duration"));
                    int totalQuestions = Integer.parseInt(request.getParameter("totalQuestions"));
                    int courseId = Integer.parseInt(request.getParameter("courseId"));
                    boolean isActive = request.getParameter("isActive") != null;

                    Test test = new Test();
                    test.setTestName(testName);
                    test.setDescription(description);
                    test.setDuration(duration);
                    test.setTotalQuestions(totalQuestions);
                    test.setCourseId(courseId);
                    test.setUserId(user.getUserId());
                    test.setCreatedDate(new Timestamp(System.currentTimeMillis()));
                    test.setIsActive(isActive);

                    int testId = testDAO.createTest(test);
                    System.out.println("TestInstructorServlet: Created test with ID: " + testId);

                    if (testId > 0) {
                        // Store success message in session instead of request
                        session.setAttribute("successMessage", "Test created successfully!");
                        // Redirect to the list view with a parameter to highlight the new test
                        response.sendRedirect(request.getContextPath() + "/instructor/tests?newTest=" + testId);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Failed to create test.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid input. Please check your form data.");
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/instructor/tests");
                break;

            case "update":
                // Update an existing test
                try {
                    int testId = Integer.parseInt(request.getParameter("testId"));
                    String testName = request.getParameter("testName");
                    String description = request.getParameter("description");
                    int duration = Integer.parseInt(request.getParameter("duration"));
                    int totalQuestions = Integer.parseInt(request.getParameter("totalQuestions"));
                    int courseId = Integer.parseInt(request.getParameter("courseId"));
                    boolean isActive = request.getParameter("isActive") != null;

                    // Get the existing test to verify ownership
                    Test existingTest = testDAO.getTestById(testId);

                    if (existingTest != null && existingTest.getUserId() == user.getUserId()) {
                        Test test = new Test();
                        test.setTestId(testId);
                        test.setTestName(testName);
                        test.setDescription(description);
                        test.setDuration(duration);
                        test.setTotalQuestions(totalQuestions);
                        test.setCourseId(courseId);
                        test.setUserId(user.getUserId());
                        test.setCreatedDate(existingTest.getCreatedDate());
                        test.setUpdatedDate(new Timestamp(System.currentTimeMillis()));
                        test.setIsActive(isActive);

                        boolean result = testDAO.updateTest(test);

                        if (result) {
                            request.setAttribute("successMessage", "Test updated successfully!");
                        } else {
                            request.setAttribute("errorMessage", "Failed to update test.");
                        }
                    } else {
                        request.setAttribute("errorMessage", "Test not found or you don't have permission to edit it.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid input. Please check your form data.");
                }

                response.sendRedirect(request.getContextPath() + "/instructor/tests");
                break;

            case "delete":
                // Delete a test
                try {
                    int testId = Integer.parseInt(request.getParameter("testId"));

                    // Get the existing test to verify ownership
                    Test existingTest = testDAO.getTestById(testId);

                    if (existingTest != null && existingTest.getUserId() == user.getUserId()) {
                        boolean result = testDAO.deleteTest(testId);

                        if (result) {
                            request.setAttribute("successMessage", "Test deleted successfully!");
                        } else {
                            request.setAttribute("errorMessage", "Failed to delete test.");
                        }
                    } else {
                        request.setAttribute("errorMessage", "Test not found or you don't have permission to delete it.");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid test ID.");
                }

                response.sendRedirect(request.getContextPath() + "/instructor/tests");
                break;

            case "uploadDocument":
                // Handle document upload
                try {
                    String testName = request.getParameter("testName");
                    String description = request.getParameter("description");
                    int courseId = Integer.parseInt(request.getParameter("courseId"));
                    boolean isActive = request.getParameter("isActive") != null;

                    // Get the uploaded file
                    Part filePart = request.getPart("documentFile");
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));

                    // Generate a unique file name to prevent overwriting
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

                    // Create directory if it doesn't exist
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "target" + File.separator + "test_document";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    // Save the file
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    try (InputStream input = filePart.getInputStream();
                         FileOutputStream output = new FileOutputStream(filePath)) {
                        byte[] buffer = new byte[1024];
                        int length;
                        while ((length = input.read(buffer)) > 0) {
                            output.write(buffer, 0, length);
                        }
                    }

                    // Create test record
                    Test test = new Test();
                    test.setTestName(testName);
                    test.setDescription(description);
                    test.setDuration(0); // No time limit for document tests
                    test.setTotalQuestions(0); // No questions for document tests
                    test.setCourseId(courseId);
                    test.setUserId(user.getUserId());
                    test.setCreatedDate(new Timestamp(System.currentTimeMillis()));
                    test.setIsActive(isActive);

                    int testId = testDAO.createTest(test);
                    System.out.println("TestInstructorServlet: Created document test with ID: " + testId);

                    if (testId > 0) {
                        // Store success message in session instead of request
                        session.setAttribute("successMessage", "Document uploaded successfully!");
                        // Redirect to the list view with a parameter to highlight the new test
                        response.sendRedirect(request.getContextPath() + "/instructor/tests?newTest=" + testId);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Failed to upload document.");
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Error uploading document: " + e.getMessage());
                    System.out.println("TestInstructorServlet: Error uploading document: " + e.getMessage());
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/instructor/tests");
                break;

            case "createMultipleChoice":
                // Handle multiple choice test creation
                try {
                    String testName = request.getParameter("testName");
                    String description = request.getParameter("description");
                    int duration = Integer.parseInt(request.getParameter("duration"));
                    int courseId = Integer.parseInt(request.getParameter("courseId"));
                    boolean isActive = request.getParameter("isActive") != null;
                    int questionCount = Integer.parseInt(request.getParameter("mcQuestionCount"));

                    // Create test record
                    Test test = new Test();
                    test.setTestName(testName);
                    test.setDescription(description);
                    test.setDuration(duration);
                    test.setTotalQuestions(questionCount);
                    test.setCourseId(courseId);
                    test.setUserId(user.getUserId());
                    test.setCreatedDate(new Timestamp(System.currentTimeMillis()));
                    test.setIsActive(isActive);

                    int testId = testDAO.createTest(test);
                    System.out.println("TestInstructorServlet: Created multiple choice test with ID: " + testId);

                    if (testId > 0) {
                        // Create directory if it doesn't exist
                        String testDataPath = getServletContext().getRealPath("") + File.separator + "target" + File.separator + "test";
                        File testDataDir = new File(testDataPath);
                        if (!testDataDir.exists()) {
                            testDataDir.mkdirs();
                        }

                        // Save test data to file
                        String testDataFile = testDataPath + File.separator + "test_" + testId + ".txt";
                        try (PrintWriter writer = new PrintWriter(new FileOutputStream(testDataFile))) {
                            writer.println("TEST_TYPE: MULTIPLE_CHOICE");
                            writer.println("TEST_NAME: " + testName);
                            writer.println("DESCRIPTION: " + description);
                            writer.println("DURATION: " + duration);
                            writer.println("QUESTION_COUNT: " + questionCount);
                            writer.println("COURSE_ID: " + courseId);
                            writer.println("USER_ID: " + user.getUserId());
                            writer.println("CREATED_DATE: " + new Timestamp(System.currentTimeMillis()));
                            writer.println("IS_ACTIVE: " + isActive);
                            writer.println("QUESTIONS:");

                            for (int i = 1; i <= questionCount; i++) {
                                String question = request.getParameter("mcQuestion" + i);
                                writer.println("Q" + i + ": " + question);

                                // Get all options for this question
                                Map<String, String> options = new HashMap<>();
                                char optionLetter = 'A';
                                while (request.getParameter("mcOption" + i + optionLetter) != null) {
                                    String option = request.getParameter("mcOption" + i + optionLetter);
                                    options.put(String.valueOf(optionLetter), option);
                                    optionLetter++;
                                }

                                // Write options
                                for (Map.Entry<String, String> entry : options.entrySet()) {
                                    writer.println("Q" + i + "_OPTION_" + entry.getKey() + ": " + entry.getValue());
                                }

                                // Get correct options
                                String[] correctOptions = request.getParameterValues("correctOption" + i);
                                if (correctOptions != null) {
                                    writer.print("Q" + i + "_CORRECT: ");
                                    for (int j = 0; j < correctOptions.length; j++) {
                                        writer.print(correctOptions[j]);
                                        if (j < correctOptions.length - 1) {
                                            writer.print(",");
                                        }
                                    }
                                    writer.println();
                                }
                            }
                            System.out.println("TestInstructorServlet: Saved multiple choice test data to file: " + testDataFile);
                        }

                        // Store success message in session instead of request
                        session.setAttribute("successMessage", "Multiple choice test created successfully!");
                        // Redirect to the list view with a parameter to highlight the new test
                        response.sendRedirect(request.getContextPath() + "/instructor/tests?newTest=" + testId);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Failed to create multiple choice test.");
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Error creating multiple choice test: " + e.getMessage());
                    System.out.println("TestInstructorServlet: Error creating multiple choice test: " + e.getMessage());
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/instructor/tests");
                break;

            case "createWriting":
                // Handle writing test creation
                try {
                    String testName = request.getParameter("testName");
                    String description = request.getParameter("description");
                    int duration = Integer.parseInt(request.getParameter("duration"));
                    int courseId = Integer.parseInt(request.getParameter("courseId"));
                    boolean isActive = request.getParameter("isActive") != null;
                    int questionCount = Integer.parseInt(request.getParameter("writingQuestionCount"));

                    // Create test record
                    Test test = new Test();
                    test.setTestName(testName);
                    test.setDescription(description);
                    test.setDuration(duration);
                    test.setTotalQuestions(questionCount);
                    test.setCourseId(courseId);
                    test.setUserId(user.getUserId());
                    test.setCreatedDate(new Timestamp(System.currentTimeMillis()));
                    test.setIsActive(isActive);

                    int testId = testDAO.createTest(test);
                    System.out.println("TestInstructorServlet: Created writing test with ID: " + testId);

                    if (testId > 0) {
                        // Create directory if it doesn't exist
                        String testDataPath = getServletContext().getRealPath("") + File.separator + "target" + File.separator + "test";
                        File testDataDir = new File(testDataPath);
                        if (!testDataDir.exists()) {
                            testDataDir.mkdirs();
                        }

                        // Save test data to file
                        String testDataFile = testDataPath + File.separator + "test_" + testId + ".txt";
                        try (PrintWriter writer = new PrintWriter(new FileOutputStream(testDataFile))) {
                            writer.println("TEST_TYPE: WRITING");
                            writer.println("TEST_NAME: " + testName);
                            writer.println("DESCRIPTION: " + description);
                            writer.println("DURATION: " + duration);
                            writer.println("QUESTION_COUNT: " + questionCount);
                            writer.println("COURSE_ID: " + courseId);
                            writer.println("USER_ID: " + user.getUserId());
                            writer.println("CREATED_DATE: " + new Timestamp(System.currentTimeMillis()));
                            writer.println("IS_ACTIVE: " + isActive);
                            writer.println("QUESTIONS:");

                            for (int i = 1; i <= questionCount; i++) {
                                String question = request.getParameter("writingQuestion" + i);
                                String answer = request.getParameter("writingAnswer" + i);
                                writer.println("Q" + i + ": " + question);
                                writer.println("Q" + i + "_ANSWER: " + answer);
                            }
                            System.out.println("TestInstructorServlet: Saved writing test data to file: " + testDataFile);
                        }

                        // Store success message in session instead of request
                        session.setAttribute("successMessage", "Writing test created successfully!");
                        // Redirect to the list view with a parameter to highlight the new test
                        response.sendRedirect(request.getContextPath() + "/instructor/tests?newTest=" + testId);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Failed to create writing test.");
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Error creating writing test: " + e.getMessage());
                    System.out.println("TestInstructorServlet: Error creating writing test: " + e.getMessage());
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/instructor/tests");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/instructor/tests");
                break;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for managing tests by instructors";
    }
}
