package model;

/**
 * UserAnswer model class representing the UserAnswer table
 * @author Generated for learner test functionality
 */
public class UserAnswer {
    private int testResultID;
    private int questionID;
    private int userID;
    private String answer;
    private boolean isCorrected;
    
    // For relationships
    private TestResult testResult;
    private Question question;
    private User user;

    public UserAnswer() {
    }

    public UserAnswer(int testResultID, int questionID, int userID, String answer, boolean isCorrected) {
        this.testResultID = testResultID;
        this.questionID = questionID;
        this.userID = userID;
        this.answer = answer;
        this.isCorrected = isCorrected;
    }

    // Getters and Setters
    public int getTestResultID() {
        return testResultID;
    }

    public void setTestResultID(int testResultID) {
        this.testResultID = testResultID;
    }

    public int getQuestionID() {
        return questionID;
    }

    public void setQuestionID(int questionID) {
        this.questionID = questionID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public boolean isCorrected() {
        return isCorrected;
    }

    public void setCorrected(boolean corrected) {
        isCorrected = corrected;
    }

    public TestResult getTestResult() {
        return testResult;
    }

    public void setTestResult(TestResult testResult) {
        this.testResult = testResult;
    }

    public Question getQuestion() {
        return question;
    }

    public void setQuestion(Question question) {
        this.question = question;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "UserAnswer{" +
                "testResultID=" + testResultID +
                ", questionID=" + questionID +
                ", userID=" + userID +
                ", answer='" + answer + '\'' +
                ", isCorrected=" + isCorrected +
                '}';
    }
} 