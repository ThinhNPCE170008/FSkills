/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Test;
import util.DBContext;

/**
 *
 * @author AI Assistant
 */
public class TestDAO extends DBContext {

    /**
     * Get all tests created by a specific instructor
     * 
     * @param instructorId The ID of the instructor
     * @return List of tests created by the instructor
     */
    public List<Test> getAllTestsByInstructor(int instructorId) {
        List<Test> tests = new ArrayList<>();
        String sql = "SELECT * FROM Tests WHERE UserID = ? ORDER BY CreatedDate DESC";

        System.out.println("Getting all tests for instructor ID: " + instructorId);

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, instructorId);
            ResultSet rs = ps.executeQuery();

            int count = 0;
            while (rs.next()) {
                Test test = new Test();
                test.setTestId(rs.getInt("TestID"));
                test.setTestName(rs.getString("TestName"));
                test.setDescription(rs.getString("Description"));
                test.setDuration(rs.getInt("Duration"));
                test.setTotalQuestions(rs.getInt("TotalQuestions"));
                test.setCourseId(rs.getInt("CourseID"));
                test.setUserId(rs.getInt("UserID"));
                test.setCreatedDate(rs.getTimestamp("CreatedDate"));
                test.setUpdatedDate(rs.getTimestamp("UpdatedDate"));
                test.setIsActive(rs.getBoolean("IsActive"));

                tests.add(test);
                count++;
                System.out.println("Retrieved test: ID=" + test.getTestId() + ", Name=" + test.getTestName() + ", UserID=" + test.getUserId());
            }

            System.out.println("Total tests found for instructor ID " + instructorId + ": " + count);

            if (count == 0) {
                // If no tests were found, let's verify the instructor exists in the database
                System.out.println("No tests found for instructor ID " + instructorId + ". Verifying if this instructor exists...");
            }
        } catch (SQLException e) {
            System.out.println("Error getting tests by instructor: " + e.getMessage());
            e.printStackTrace();
        }

        return tests;
    }

    /**
     * Get a test by its ID
     * 
     * @param testId The ID of the test
     * @return The test object or null if not found
     */
    public Test getTestById(int testId) {
        String sql = "SELECT * FROM Tests WHERE TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Test test = new Test();
                test.setTestId(rs.getInt("TestID"));
                test.setTestName(rs.getString("TestName"));
                test.setDescription(rs.getString("Description"));
                test.setDuration(rs.getInt("Duration"));
                test.setTotalQuestions(rs.getInt("TotalQuestions"));
                test.setCourseId(rs.getInt("CourseID"));
                test.setUserId(rs.getInt("UserID"));
                test.setCreatedDate(rs.getTimestamp("CreatedDate"));
                test.setUpdatedDate(rs.getTimestamp("UpdatedDate"));
                test.setIsActive(rs.getBoolean("IsActive"));

                return test;
            }
        } catch (SQLException e) {
            System.out.println("Error getting test by ID: " + e.getMessage());
        }

        return null;
    }

    /**
     * Create a new test
     * 
     * @param test The test object to create
     * @return The generated test ID if successful, 0 if failed
     */
    public int createTest(Test test) {
        String sql = "INSERT INTO Tests (TestName, Description, Duration, TotalQuestions, CourseID, UserID, CreatedDate, IsActive) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            // Debug information
            System.out.println("Creating test: " + test.getTestName() + " for user ID: " + test.getUserId());

            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, test.getTestName());
            ps.setString(2, test.getDescription());
            ps.setInt(3, test.getDuration());
            ps.setInt(4, test.getTotalQuestions());
            ps.setInt(5, test.getCourseId());
            ps.setInt(6, test.getUserId());
            ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            ps.setBoolean(8, test.isIsActive());

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                System.out.println("Creating test failed, no rows affected.");
                return 0;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int testId = generatedKeys.getInt(1);
                    System.out.println("Test created successfully with ID: " + testId);
                    return testId;
                } else {
                    System.out.println("Creating test failed, no ID obtained.");
                    return 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error creating test: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Update an existing test
     * 
     * @param test The test object with updated values
     * @return true if successful, false if failed
     */
    public boolean updateTest(Test test) {
        String sql = "UPDATE Tests SET TestName = ?, Description = ?, Duration = ?, TotalQuestions = ?, "
                   + "CourseID = ?, UpdatedDate = ?, IsActive = ? WHERE TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, test.getTestName());
            ps.setString(2, test.getDescription());
            ps.setInt(3, test.getDuration());
            ps.setInt(4, test.getTotalQuestions());
            ps.setInt(5, test.getCourseId());
            ps.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            ps.setBoolean(7, test.isIsActive());
            ps.setInt(8, test.getTestId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating test: " + e.getMessage());
        }

        return false;
    }

    /**
     * Delete a test by its ID
     * 
     * @param testId The ID of the test to delete
     * @return true if successful, false if failed
     */
    public boolean deleteTest(int testId) {
        String sql = "DELETE FROM Tests WHERE TestID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting test: " + e.getMessage());
        }

        return false;
    }

    /**
     * Get all tests for a specific course
     * 
     * @param courseId The ID of the course
     * @return List of tests for the course
     */
    public List<Test> getTestsByCourse(int courseId) {
        List<Test> tests = new ArrayList<>();
        String sql = "SELECT * FROM Tests WHERE CourseID = ? ORDER BY CreatedDate DESC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Test test = new Test();
                test.setTestId(rs.getInt("TestID"));
                test.setTestName(rs.getString("TestName"));
                test.setDescription(rs.getString("Description"));
                test.setDuration(rs.getInt("Duration"));
                test.setTotalQuestions(rs.getInt("TotalQuestions"));
                test.setCourseId(rs.getInt("CourseID"));
                test.setUserId(rs.getInt("UserID"));
                test.setCreatedDate(rs.getTimestamp("CreatedDate"));
                test.setUpdatedDate(rs.getTimestamp("UpdatedDate"));
                test.setIsActive(rs.getBoolean("IsActive"));

                tests.add(test);
            }
        } catch (SQLException e) {
            System.out.println("Error getting tests by course: " + e.getMessage());
        }

        return tests;
    }
}
