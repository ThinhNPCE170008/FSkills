package dao;

import model.TestResult;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * TestResultDAO class for CRUD operations on TestResult table
 * @author Generated for learner test functionality
 */
public class TestResultDAO extends DBContext {

    public TestResultDAO() {
        super();
    }

    /**
     * Get latest test result for a user and test
     */
    public TestResult getLatestTestResult(int testID, int userID) {
        String sql = "SELECT TOP 1 *,CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = t.TestID AND q.QuestionType = 'WRITING') " +
                " THEN CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = t.TestID AND q.QuestionType = 'CHOICE') " +
                " THEN 'Mixed' ELSE 'WRITING' END ELSE 'MultiChoice' END as TestType FROM TestResult t " +
                    "WHERE TestID = ? AND UserID = ? " +
                    "ORDER BY Attempt DESC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ps.setInt(2, userID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return createTestResultFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error in getLatestTestResult: " + e.getMessage());
        }
        return null;
    }

    /**
     * Get all test results for a user and test
     */
    public List<TestResult> getTestResults(int testID, int userID) {
        List<TestResult> list = new ArrayList<>();
        String sql = "SELECT *, CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = t.TestID AND q.QuestionType = 'WRITING') \n" +
                "        THEN CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = t.TestID AND q.QuestionType = 'CHOICE')\n" +
                "        THEN 'Mixed' ELSE 'WRITING' END ELSE 'MultiChoice' END as TestType FROM TestResult t " +
                    "WHERE TestID = ? AND UserID = ? " +
                    "ORDER BY Attempt DESC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ps.setInt(2, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(createTestResultFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in getTestResults: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get next attempt number for a user and test
     */
    public int getNextAttempt(int testID, int userID) {
        String sql = "SELECT ISNULL(MAX(Attempt), 0) + 1 as NextAttempt " +
                    "FROM TestResult WHERE TestID = ? AND UserID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testID);
            ps.setInt(2, userID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("NextAttempt");
            }
        } catch (SQLException e) {
            System.out.println("Error in getNextAttempt: " + e.getMessage());
        }
        return 1;
    }

    /**
     * Insert new test result
     */
    public int insertTestResult(TestResult testResult) {
        String sql = "INSERT INTO TestResult (TestID, UserID, Attempt, Result, IsPassed, DateTaken) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, testResult.getTestID());
            ps.setInt(2, testResult.getUserID());
            ps.setInt(3, testResult.getAttempt());
            ps.setInt(4, testResult.getResult());
            ps.setBoolean(5, testResult.isPassed());
            ps.setTimestamp(6, testResult.getDateTaken());

            int insert = ps.executeUpdate();
            if (insert > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in insertTestResult: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Get test result by ID
     */
    public TestResult getTestResultByID(int testResultID) {
        String sql = "SELECT *, CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = t.TestID AND q.QuestionType = 'WRITING') \n" +
                "THEN CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = t.TestID AND q.QuestionType = 'CHOICE')\n" +
                " THEN 'Mixed' ELSE 'WRITING' END ELSE 'MultiChoice' END as TestType FROM TestResult t WHERE TestResultID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testResultID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return createTestResultFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error in getTestResultByID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Get student results for instructor with optional course filter
     */
    public List<TestResult> getStudentResultsForInstructor(int instructorID, Integer courseID) {
        List<TestResult> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DISTINCT tr.*, u.DisplayName, u.email, t.testName, ");
        sql.append("CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = t.TestID AND q.QuestionType = 'WRITING') ");
        sql.append("THEN CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = t.TestID AND q.QuestionType = 'CHOICE') ");
        sql.append("THEN 'Mixed' ELSE 'WRITING' END ELSE 'MultiChoice' END as TestType ");
        sql.append("FROM TestResult tr ");
        sql.append("INNER JOIN Users u ON tr.UserID = u.UserID ");
        sql.append("INNER JOIN Tests t ON tr.TestID = t.TestID ");
        sql.append("INNER JOIN Modules m ON t.ModuleID = m.ModuleID ");
        sql.append("INNER JOIN Courses c ON m.CourseID = c.CourseID ");
        sql.append("WHERE c.UserID = ? ");
        
        if (courseID != null) {
            sql.append("AND c.CourseID = ? ");
        }
        
        sql.append("ORDER BY tr.DateTaken DESC");

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            ps.setInt(1, instructorID);
            if (courseID != null) {
                ps.setInt(2, courseID);
            }
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TestResult testResult = createTestResultFromResultSet(rs);
                
                // Add additional fields from join
                testResult.setFullName(rs.getString("DisplayName"));
                testResult.setEmail(rs.getString("email"));
                testResult.setTestName(rs.getString("testName"));
                testResult.setTestType(rs.getString("TestType"));
                
                list.add(testResult);
            }
        } catch (SQLException e) {
            System.out.println("Error in getStudentResultsForInstructor: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get student result detail with questions and answers
     */
    public TestResult getStudentResultDetail(int testResultID, int instructorID) {
        String sql = "SELECT tr.*, CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = tr.TestID AND q.QuestionType = 'WRITING') \n" +
                "THEN CASE WHEN EXISTS (SELECT 1 FROM Questions q WHERE q.TestID = tr.TestID AND q.QuestionType = 'CHOICE')\n" +
                " THEN 'Mixed' ELSE 'WRITING' END ELSE 'MultiChoice' END as TestType, u.DisplayName, u.email, t.testName " +
                    "FROM TestResult tr " +
                    "INNER JOIN Users u ON tr.UserID = u.UserID " +
                    "INNER JOIN Tests t ON tr.TestID = t.TestID " +
                    "INNER JOIN Modules m ON t.ModuleID = m.ModuleID " +
                    "INNER JOIN Courses c ON m.CourseID = c.CourseID " +
                    "WHERE tr.TestResultID = ? AND c.UserID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, testResultID);
            ps.setInt(2, instructorID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                TestResult testResult = createTestResultFromResultSet(rs);
                testResult.setFullName(rs.getString("DisplayName"));
                testResult.setEmail(rs.getString("email"));
                testResult.setTestName(rs.getString("testName"));
                return testResult;
            }
        } catch (SQLException e) {
            System.out.println("Error in getStudentResultDetail: " + e.getMessage());
        }
        return null;
    }

    /**
     * Helper method to create TestResult object from ResultSet
     */
    private TestResult createTestResultFromResultSet(ResultSet rs) throws SQLException {
        TestResult testResult = new TestResult();
        testResult.setTestResultID(rs.getInt("TestResultID"));
        testResult.setTestID(rs.getInt("TestID"));
        testResult.setUserID(rs.getInt("UserID"));
        testResult.setAttempt(rs.getInt("Attempt"));
        testResult.setResult(rs.getInt("Result"));
        testResult.setPassed(rs.getBoolean("IsPassed"));
        testResult.setDateTaken(rs.getTimestamp("DateTaken"));
        testResult.setTestType(rs.getString("TestType"));
        return testResult;
    }
} 