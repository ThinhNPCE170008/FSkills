package model;

import java.sql.Timestamp;

/**
 * TestResult model class representing the TestResult table
 * @author Generated for learner test functionality
 */
public class TestResult {
    private int testResultID;
    private int testID;
    private int userID;
    private int attempt;
    private int result;
    private boolean isPassed;
    private Timestamp dateTaken;
    
    // For relationships
    private Test test;
    private User user;

    public TestResult() {
    }

    public TestResult(int testID, int userID, int attempt, int result, boolean isPassed) {
        this.testID = testID;
        this.userID = userID;
        this.attempt = attempt;
        this.result = result;
        this.isPassed = isPassed;
        this.dateTaken = new Timestamp(System.currentTimeMillis());
    }

    public TestResult(int testResultID, int testID, int userID, int attempt, int result, boolean isPassed) {
        this.testResultID = testResultID;
        this.testID = testID;
        this.userID = userID;
        this.attempt = attempt;
        this.result = result;
        this.isPassed = isPassed;
        this.dateTaken = new Timestamp(System.currentTimeMillis());
    }

    public TestResult(int testResultID, int testID, int userID, int attempt, int result, boolean isPassed, Timestamp dateTaken) {
        this.testResultID = testResultID;
        this.testID = testID;
        this.userID = userID;
        this.attempt = attempt;
        this.result = result;
        this.isPassed = isPassed;
        this.dateTaken = dateTaken;
    }

    // Getters and Setters
    public int getTestResultID() {
        return testResultID;
    }

    public void setTestResultID(int testResultID) {
        this.testResultID = testResultID;
    }

    public int getTestID() {
        return testID;
    }

    public void setTestID(int testID) {
        this.testID = testID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getAttempt() {
        return attempt;
    }

    public void setAttempt(int attempt) {
        this.attempt = attempt;
    }

    public int getResult() {
        return result;
    }

    public void setResult(int result) {
        this.result = result;
    }

    public boolean isPassed() {
        return isPassed;
    }

    public void setPassed(boolean passed) {
        isPassed = passed;
    }

    public Timestamp getDateTaken() {
        return dateTaken;
    }

    public void setDateTaken(Timestamp dateTaken) {
        this.dateTaken = dateTaken;
    }

    public Test getTest() {
        return test;
    }

    public void setTest(Test test) {
        this.test = test;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "TestResult{" +
                "testResultID=" + testResultID +
                ", testID=" + testID +
                ", userID=" + userID +
                ", attempt=" + attempt +
                ", result=" + result +
                ", isPassed=" + isPassed +
                ", dateTaken=" + dateTaken +
                '}';
    }
} 