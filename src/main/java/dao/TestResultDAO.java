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
        String sql = "SELECT TOP 1 * FROM TestResult " +
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
        String sql = "SELECT * FROM TestResult " +
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
        String sql = "SELECT * FROM TestResult WHERE TestResultID = ?";

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
        return testResult;
    }
} 